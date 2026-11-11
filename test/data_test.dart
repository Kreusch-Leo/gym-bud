import 'dart:convert';
import 'dart:io';

import 'package:drift/drift.dart' show Value;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gym_bud/core/tracking_mode.dart';
import 'package:gym_bud/data/backup.dart';
import 'package:gym_bud/data/database.dart';
import 'package:gym_bud/data/repositories.dart';

AppDatabase open({bool seed = true}) => AppDatabase(
  executor: NativeDatabase.memory(),
  loadSeed: seed
      ? () => File('assets/seed/exercises.json').readAsString()
      : null,
);

void main() {
  test('seed inicial carrega o catálogo na criação do banco', () async {
    final db = open();
    addTearDown(db.close);
    final exercises = await CatalogRepository(db).watchExercises().first;
    final equipment = await CatalogRepository(db).watchEquipment().first;
    expect(exercises, hasLength(52));
    expect(equipment, hasLength(28));
    // Equipamento granular e lista estrita por exercício.
    expect(
      equipment.map((e) => e.name),
      containsAll(['Halteres até 10kg', 'Leg Press 45']),
    );
    expect(exercises.where((e) => e.equipmentIds.isEmpty), isNotEmpty);
    expect(exercises.where((e) => e.equipmentIds.length > 1), isNotEmpty);
  });

  test(
    'treino: registrar séries, finalizar e consolidar no histórico',
    () async {
      final db = open();
      addTearDown(db.close);
      final repo = WorkoutRepository(db);
      final exercises = await CatalogRepository(db).watchExercises().first;
      final ids = [exercises[0].exercise.id, exercises[1].exercise.id];

      final id = await repo.start(exerciseIds: ids);
      expect(
        await repo.start(),
        id,
        reason: 'não abre um segundo treino ativo',
      );
      var active = (await repo.watchActive().first)!;
      expect(active.entries.map((e) => e.exercise.id), ids);

      final first = active.entries[0].link.id;
      await repo.setTargets(first, weightKg: 40, reps: 10);
      expect(
        await repo.completeSet(first),
        isNotNull,
        reason: 'série concluída inicia o descanso',
      );
      await repo.setRestEndsAt(id, null);
      await repo.setTargets(first, weightKg: 42.5, reps: 8);
      await repo.completeSet(first);
      expect((await repo.lastSetOf(ids[0]))!.weightKg, 42.5);

      expect(await repo.finish(id), isTrue);
      expect(await repo.watchActive().first, isNull);
      final history = await repo.watchHistory().first;
      expect(history, hasLength(1));
      expect(
        history.single.entries,
        hasLength(1),
        reason: 'exercício sem série não é salvo',
      );
      expect(history.single.totalSets, 2);
      expect(history.single.totalLoadKg, 40 * 10 + 42.5 * 8);
    },
  );

  test('execução: modos, descanso e conclusão do treino', () async {
    final db = open();
    addTearDown(db.close);
    final repo = WorkoutRepository(db);
    final exercises = await CatalogRepository(db).watchExercises().first;
    final plank = exercises
        .singleWhere((e) => e.exercise.name == 'Prancha')
        .exercise;
    final other = exercises
        .firstWhere((e) => e.exercise.id != plank.id)
        .exercise;

    final id = await repo.start(exerciseIds: [plank.id, other.id]);
    var active = (await repo.watchActive().first)!;
    final [timed, byReps] = active.entries.map((e) => e.link).toList();
    expect(
      timed.mode,
      TrackingMode.time,
      reason: 'modo padrão vem do exercício',
    );
    expect(byReps.mode, TrackingMode.reps);
    await repo.setTargets(timed.id, sets: 2, seconds: 40);
    await repo.setTargets(byReps.id, sets: 1, reps: 16, weightKg: 20);

    // Série por tempo, com outra série do mesmo exercício a seguir: descanso curto.
    await repo.setTimerEndsAt(id, DateTime.now());
    var rest = (await repo.completeSet(timed.id))!;
    active = (await repo.watchActive().first)!;
    expect(active.workout.timerEndsAt, isNull);
    expect(rest.difference(active.workout.restEndsAt!).inSeconds, 0);
    rest = active.workout.restEndsAt!;
    expect(active.entries[0].sets.single.durationSec, 40);
    expect(active.entries[0].sets.single.reps, isNull);
    expect(active.entries[0].link.done, isFalse);
    expect(rest.difference(active.entries[0].sets.single.doneAt).inSeconds, 30);

    // Durante o descanso não há série a concluir.
    expect(await repo.completeSet(timed.id), rest);
    expect((await repo.watchActive().first)!.totalSets, 1);

    // Última série do exercício: conclui e o descanso é o de troca de exercício.
    await repo.setRestEndsAt(id, null);
    rest = (await repo.completeSet(timed.id))!;
    active = (await repo.watchActive().first)!;
    expect(active.entries[0].link.done, isTrue);
    expect(rest.difference(active.entries[0].sets.last.doneAt).inSeconds, 60);

    // Descanso personalizado vale para o próximo descanso; aqui o modo é trocado em tempo real.
    await repo.setRestEndsAt(id, null);
    await repo.setRestCustom(id, 20);
    await repo.setTargets(byReps.id, sets: 2);
    rest = (await repo.completeSet(byReps.id))!;
    active = (await repo.watchActive().first)!;
    expect(active.entries[1].sets.single.reps, 16);
    expect(rest.difference(active.entries[1].sets.single.doneAt).inSeconds, 20);
    await repo.setRestEndsAt(id, null);
    await repo.setTargets(byReps.id, mode: TrackingMode.time);

    // Última série do treino: não há descanso.
    expect(await repo.completeSet(byReps.id), isNull);
    active = (await repo.watchActive().first)!;
    expect(active.entries[1].sets.last.durationSec, 30);
    expect(active.entries.every((e) => e.link.done), isTrue);
    await repo.finish(id);

    // O próximo treino herda o descanso e parte da última série de cada exercício.
    await repo.start(exerciseIds: [other.id]);
    active = (await repo.watchActive().first)!;
    expect(active.workout.restCustomSec, 20);
    expect(active.entries.single.link.mode, TrackingMode.time);
    expect(active.entries.single.link.targetWeightKg, 20);
  });

  test('descanso inteligente', () {
    int rest(TrackingMode mode, double kg, bool same) =>
        smartRestSec(mode: mode, weightKg: kg, sameExercise: same);
    expect(rest(TrackingMode.time, 0, true), 30);
    expect(rest(TrackingMode.reps, 0, true), 45);
    expect(rest(TrackingMode.reps, 20, true), 75);
    expect(rest(TrackingMode.reps, 20, false), 105);
  });

  test('migração da v1 preserva treinos e séries', () async {
    final db = AppDatabase(
      executor: NativeDatabase.memory(
        setup: (raw) => raw.execute('''
          CREATE TABLE equipments (id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT, name TEXT NOT NULL UNIQUE);
          CREATE TABLE exercises (id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT, name TEXT NOT NULL UNIQUE,
            primary_muscle TEXT NOT NULL, secondary_muscles TEXT NOT NULL DEFAULT '[]', media_path TEXT NULL);
          CREATE TABLE gyms (id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT, name TEXT NOT NULL UNIQUE,
            latitude REAL NULL, longitude REAL NULL, radius_m REAL NOT NULL DEFAULT 100.0);
          CREATE TABLE workouts (id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT, started_at INTEGER NOT NULL,
            ended_at INTEGER NULL, gym_id INTEGER NULL REFERENCES gyms (id) ON DELETE SET NULL,
            rest_set_sec INTEGER NOT NULL DEFAULT 60, rest_exercise_sec INTEGER NOT NULL DEFAULT 120,
            rest_ends_at INTEGER NULL);
          CREATE TABLE workout_exercises (id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
            workout_id INTEGER NOT NULL REFERENCES workouts (id) ON DELETE CASCADE,
            exercise_id INTEGER NOT NULL REFERENCES exercises (id) ON DELETE CASCADE,
            position INTEGER NOT NULL, target_sets INTEGER NOT NULL DEFAULT 3,
            done INTEGER NOT NULL DEFAULT 0 CHECK (done IN (0, 1)));
          CREATE TABLE workout_sets (id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
            workout_exercise_id INTEGER NOT NULL REFERENCES workout_exercises (id) ON DELETE CASCADE,
            weight_kg REAL NOT NULL, reps INTEGER NOT NULL, done_at INTEGER NOT NULL);
          INSERT INTO exercises (name, primary_muscle) VALUES ('Supino', 'peito');
          INSERT INTO workouts (started_at, ended_at) VALUES (1000, 2000);
          INSERT INTO workout_exercises (workout_id, exercise_id, position, done) VALUES (1, 1, 0, 1);
          INSERT INTO workout_sets (workout_exercise_id, weight_kg, reps, done_at) VALUES (1, 40, 10, 1500);
          PRAGMA user_version = 1;
        '''),
      ),
    );
    addTearDown(db.close);
    final repo = WorkoutRepository(db);
    final entry = (await repo.watchHistory().first).single.entries.single;
    expect(entry.exercise.trackingMode, TrackingMode.reps);
    expect(entry.link.mode, TrackingMode.reps);
    expect(
      (
        entry.sets.single.weightKg,
        entry.sets.single.reps,
        entry.sets.single.durationSec,
      ),
      (40, 10, null),
    );

    // As tabelas recriadas aceitam o que a v2 grava.
    final id = await repo.start(exerciseIds: [entry.exercise.id]);
    final link = (await repo.watchActive().first)!.entries.single.link;
    expect((link.targetWeightKg, link.targetReps), (40, 10));
    await repo.setTargets(link.id, mode: TrackingMode.time);
    await repo.completeSet(link.id);
    await repo.setRestCustom(id, 25);
    expect(
      (await repo.watchActive().first)!.entries.single.sets.single.reps,
      isNull,
    );
  });

  test('treino sem nenhuma série é descartado ao finalizar', () async {
    final db = open();
    addTearDown(db.close);
    final repo = WorkoutRepository(db);
    final id = await repo.start();
    expect(await repo.finish(id), isFalse);
    expect(await repo.watchHistory().first, isEmpty);
    expect(await repo.watchActive().first, isNull);
  });

  test('backup: exportar e importar em um banco vazio preserva tudo; reimportar não duplica', () async {
    final source = open();
    addTearDown(source.close);
    final exercises = await CatalogRepository(source).watchExercises().first;
    final equipment = await CatalogRepository(source).watchEquipment().first;
    await GymRepository(source).saveGym(
      name: 'Academia Centro',
      latitude: -27.59,
      longitude: -48.55,
      radiusM: 100,
      equipmentIds: {equipment[0].id, equipment[1].id},
    );
    final workouts = WorkoutRepository(source);
    final id = await workouts.start(exerciseIds: [exercises.first.exercise.id]);
    final active = (await workouts.watchActive().first)!;
    final link = active.entries.single.link.id;
    await workouts.setTargets(link, weightKg: 60, reps: 5);
    await workouts.completeSet(link);
    await workouts.setRestEndsAt(id, null);
    await workouts.setTargets(
      link,
      mode: TrackingMode.time,
      weightKg: 0,
      seconds: 45,
    );
    await workouts.completeSet(link);
    await workouts.finish(id);
    await MetricsRepository(source).add(
      BodyMetricsCompanion.insert(
        date: DateTime(2026, 11, 1),
        weightKg: const Value(80),
        heightCm: const Value(180),
      ),
    );

    final json = await exportBackup(source);
    expect(jsonDecode(json), isA<Map<String, dynamic>>());

    final target = open(seed: false);
    addTearDown(target.close);
    final result = await importBackup(target, json);
    expect(result.exercises, 52);
    expect(result.equipment, 28);
    expect(result.gyms, 1);
    expect(result.workouts, 1);
    expect(result.metrics, 1);

    final gym = (await GymRepository(target).watchGyms().first).single;
    expect(gym.gym.name, 'Academia Centro');
    expect(gym.gym.latitude, -27.59);
    expect(gym.equipmentIds, hasLength(2));
    final restored = (await WorkoutRepository(
      target,
    ).watchHistory().first).single;
    expect(
      restored.entries.single.exercise.name,
      exercises.first.exercise.name,
    );
    final [byReps, byTime] = restored.entries.single.sets;
    expect((byReps.weightKg, byReps.reps, byReps.durationSec), (60, 5, null));
    expect((byTime.weightKg, byTime.reps, byTime.durationSec), (0, null, 45));
    expect(
      (await CatalogRepository(target).watchExercises().first)
          .singleWhere((e) => e.exercise.name == 'Prancha')
          .exercise
          .trackingMode,
      TrackingMode.time,
    );
    expect(await exportBackup(target), json, reason: 'ida e volta sem perdas');

    final again = await importBackup(target, json);
    expect([
      again.exercises,
      again.equipment,
      again.gyms,
      again.workouts,
      again.metrics,
    ], everyElement(0));
  });

  test('importação rejeita arquivo fora do formato', () async {
    final db = open(seed: false);
    addTearDown(db.close);
    expect(() => importBackup(db, 'não é json'), throwsFormatException);
    expect(() => importBackup(db, '[1, 2]'), throwsFormatException);
    expect(
      () => importBackup(
        db,
        '{"exercises": [{"name": "X", "primary": "inexistente"}]}',
      ),
      throwsFormatException,
    );
    expect(await CatalogRepository(db).watchExercises().first, isEmpty);
  });

  test('IMC', () {
    expect(bmi(80, 180), closeTo(24.69, 0.01));
    expect(bmi(null, 180), isNull);
    expect(bmi(80, null), isNull);
  });
}
