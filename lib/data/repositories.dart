import 'package:drift/drift.dart';

import '../core/effort.dart';
import '../core/muscle_group.dart';
import '../core/tracking_mode.dart';
import 'database.dart';

class ExerciseInfo {
  ExerciseInfo(this.exercise, this.equipmentIds);

  final Exercise exercise;
  final Set<int> equipmentIds;
}

class GymInfo {
  GymInfo(this.gym, this.equipmentIds);

  final Gym gym;
  final Set<int> equipmentIds;
}

class WorkoutEntry {
  WorkoutEntry(this.link, this.exercise, this.sets);

  final WorkoutExercise link;
  final Exercise exercise;
  final List<WorkoutSet> sets;
}

class WorkoutDetail {
  WorkoutDetail(this.workout, this.entries);

  final Workout workout;
  final List<WorkoutEntry> entries;

  int get totalSets => entries.fold(0, (sum, e) => sum + e.sets.length);

  /// Séries previstas: a meta de cada exercício.
  int get targetSets => entries.fold(0, (sum, e) => sum + e.link.targetSets);

  /// Tempo de treino: até o fim, ou até agora se ainda está ativo.
  Duration get elapsed =>
      (workout.endedAt ?? DateTime.now()).difference(workout.startedAt);

  /// Duração prevista do que ainda falta: execução das séries mais os descansos.
  Duration get estimatedRemaining {
    var total = Duration.zero;
    for (final e in entries) {
      final link = e.link;
      total += estimateSets(
        sets: link.targetSets - e.sets.length,
        mode: link.mode,
        reps: link.targetReps,
        seconds: link.targetSeconds,
        weightKg: link.targetWeightKg,
        restCustomSec: workout.restCustomSec,
      );
    }
    return total;
  }

  /// Volume de carga: soma de carga × repetições (séries por tempo não contam).
  double get totalLoadKg => entries.fold(
    0,
    (sum, e) =>
        sum + e.sets.fold(0.0, (s, x) => s + x.weightKg * (x.reps ?? 0)),
  );

  Set<MuscleGroup> get groups => {
    for (final e in entries)
      if (e.sets.isNotEmpty) e.exercise.primaryMuscle,
  };
}

/// Exercícios e equipamentos.
class CatalogRepository {
  CatalogRepository(this.db);

  final AppDatabase db;

  Stream<List<Equipment>> watchEquipment() => (db.select(
    db.equipments,
  )..orderBy([(t) => OrderingTerm.asc(t.name)])).watch();

  /// Devolve o id do equipamento com esse nome, criando se não existir.
  Future<int> ensureEquipment(String name) async {
    final existing = await (db.select(
      db.equipments,
    )..where((t) => t.name.equals(name))).getSingleOrNull();
    return existing?.id ??
        await db
            .into(db.equipments)
            .insert(EquipmentsCompanion.insert(name: name));
  }

  Future<void> deleteEquipment(int id) =>
      (db.delete(db.equipments)..where((t) => t.id.equals(id))).go();

  Stream<List<ExerciseInfo>> watchExercises() {
    final query = db.select(db.exercises).join([
      leftOuterJoin(
        db.exerciseEquipments,
        db.exerciseEquipments.exerciseId.equalsExp(db.exercises.id),
      ),
    ])..orderBy([OrderingTerm.asc(db.exercises.name)]);
    return query.watch().map((rows) {
      final byId = <int, ExerciseInfo>{};
      for (final row in rows) {
        final exercise = row.readTable(db.exercises);
        final info = byId.putIfAbsent(
          exercise.id,
          () => ExerciseInfo(exercise, {}),
        );
        final link = row.readTableOrNull(db.exerciseEquipments);
        if (link != null) info.equipmentIds.add(link.equipmentId);
      }
      return byId.values.toList();
    });
  }

  /// Cria (id nulo) ou atualiza um exercício e substitui sua lista de equipamentos.
  Future<int> saveExercise({
    int? id,
    required String name,
    required MuscleGroup primary,
    required List<MuscleGroup> secondary,
    required Set<int> equipmentIds,
    String? mediaPath,
    TrackingMode trackingMode = TrackingMode.reps,
  }) => db.transaction(() async {
    final row = ExercisesCompanion(
      name: Value(name),
      primaryMuscle: Value(primary),
      secondaryMuscles: Value(secondary),
      mediaPath: Value(mediaPath),
      trackingMode: Value(trackingMode),
    );
    final exerciseId = id ?? await db.into(db.exercises).insert(row);
    if (id != null) {
      await (db.update(db.exercises)..where((t) => t.id.equals(id))).write(row);
      await (db.delete(
        db.exerciseEquipments,
      )..where((t) => t.exerciseId.equals(id))).go();
    }
    await db.batch((b) {
      b.insertAll(db.exerciseEquipments, [
        for (final e in equipmentIds)
          ExerciseEquipmentsCompanion.insert(
            exerciseId: exerciseId,
            equipmentId: e,
          ),
      ]);
    });
    return exerciseId;
  });

  Future<void> deleteExercise(int id) =>
      (db.delete(db.exercises)..where((t) => t.id.equals(id))).go();
}

class GymRepository {
  GymRepository(this.db);

  final AppDatabase db;

  Stream<List<GymInfo>> watchGyms() {
    final query = db.select(db.gyms).join([
      leftOuterJoin(
        db.gymEquipments,
        db.gymEquipments.gymId.equalsExp(db.gyms.id),
      ),
    ])..orderBy([OrderingTerm.asc(db.gyms.name)]);
    return query.watch().map((rows) {
      final byId = <int, GymInfo>{};
      for (final row in rows) {
        final gym = row.readTable(db.gyms);
        final info = byId.putIfAbsent(gym.id, () => GymInfo(gym, {}));
        final link = row.readTableOrNull(db.gymEquipments);
        if (link != null) info.equipmentIds.add(link.equipmentId);
      }
      return byId.values.toList();
    });
  }

  Future<int> saveGym({
    int? id,
    required String name,
    required double? latitude,
    required double? longitude,
    required double radiusM,
    required Set<int> equipmentIds,
  }) => db.transaction(() async {
    final row = GymsCompanion(
      name: Value(name),
      latitude: Value(latitude),
      longitude: Value(longitude),
      radiusM: Value(radiusM),
    );
    final gymId = id ?? await db.into(db.gyms).insert(row);
    if (id != null) {
      await (db.update(db.gyms)..where((t) => t.id.equals(id))).write(row);
      await (db.delete(
        db.gymEquipments,
      )..where((t) => t.gymId.equals(id))).go();
    }
    await db.batch((b) {
      b.insertAll(db.gymEquipments, [
        for (final e in equipmentIds)
          GymEquipmentsCompanion.insert(gymId: gymId, equipmentId: e),
      ]);
    });
    return gymId;
  });

  Future<void> deleteGym(int id) =>
      (db.delete(db.gyms)..where((t) => t.id.equals(id))).go();
}

/// Treino ativo e histórico.
class WorkoutRepository {
  WorkoutRepository(this.db);

  final AppDatabase db;

  JoinedSelectStatement<HasResultSet, dynamic> _detailQuery() =>
      db.select(db.workouts).join([
        leftOuterJoin(
          db.workoutExercises,
          db.workoutExercises.workoutId.equalsExp(db.workouts.id),
        ),
        leftOuterJoin(
          db.exercises,
          db.exercises.id.equalsExp(db.workoutExercises.exerciseId),
        ),
        leftOuterJoin(
          db.workoutSets,
          db.workoutSets.workoutExerciseId.equalsExp(db.workoutExercises.id),
        ),
      ])..orderBy([
        OrderingTerm.desc(db.workouts.startedAt),
        OrderingTerm.asc(db.workoutExercises.position),
        OrderingTerm.asc(db.workoutSets.id),
      ]);

  List<WorkoutDetail> _group(List<TypedResult> rows) {
    final workouts = <int, WorkoutDetail>{};
    final entries = <int, WorkoutEntry>{};
    for (final row in rows) {
      final workout = row.readTable(db.workouts);
      final detail = workouts.putIfAbsent(
        workout.id,
        () => WorkoutDetail(workout, []),
      );
      final link = row.readTableOrNull(db.workoutExercises);
      if (link == null) continue;
      final entry = entries.putIfAbsent(link.id, () {
        final e = WorkoutEntry(link, row.readTable(db.exercises), []);
        detail.entries.add(e);
        return e;
      });
      final set = row.readTableOrNull(db.workoutSets);
      if (set != null) entry.sets.add(set);
    }
    return workouts.values.toList();
  }

  Stream<WorkoutDetail?> watchActive() =>
      (_detailQuery()..where(db.workouts.endedAt.isNull())).watch().map(
        (rows) => _group(rows).firstOrNull,
      );

  /// Treinos concluídos, do mais recente ao mais antigo.
  Stream<List<WorkoutDetail>> watchHistory() =>
      (_detailQuery()..where(db.workouts.endedAt.isNotNull())).watch().map(
        _group,
      );

  /// Tudo que teve início a partir de [since], incluindo o treino ativo — é o
  /// "treino real" que alimenta o planejador.
  Stream<List<WorkoutDetail>> watchSince(DateTime since) =>
      (_detailQuery()..where(db.workouts.startedAt.isBiggerOrEqualValue(since)))
          .watch()
          .map(_group);

  /// Inicia um treino; se já houver um ativo, devolve o id dele sem criar outro.
  Future<int> start({int? gymId, List<int> exerciseIds = const []}) =>
      db.transaction(() async {
        final active = await (db.select(
          db.workouts,
        )..where((t) => t.endedAt.isNull())).getSingleOrNull();
        if (active != null) return active.id;
        // Reaproveita a configuração de descanso do último treino.
        final last =
            await (db.select(db.workouts)
                  ..orderBy([(t) => OrderingTerm.desc(t.startedAt)])
                  ..limit(1))
                .getSingleOrNull();
        final id = await db
            .into(db.workouts)
            .insert(
              WorkoutsCompanion.insert(
                startedAt: DateTime.now(),
                gymId: Value(gymId),
                restCustomSec: Value(last?.restCustomSec),
              ),
            );
        for (final (i, exerciseId) in exerciseIds.indexed) {
          await _insertExercise(id, exerciseId, i);
        }
        return id;
      });

  /// As metas partem da última série feita deste exercício; sem histórico, do modo
  /// padrão do exercício e dos padrões das colunas.
  Future<void> _insertExercise(
    int workoutId,
    int exerciseId,
    int position,
  ) async {
    final exercise = await (db.select(
      db.exercises,
    )..where((t) => t.id.equals(exerciseId))).getSingle();
    final last = await lastSetOf(exerciseId);
    await db
        .into(db.workoutExercises)
        .insert(
          WorkoutExercisesCompanion.insert(
            workoutId: workoutId,
            exerciseId: exerciseId,
            position: position,
            mode: Value(switch (last) {
              null => exercise.trackingMode,
              WorkoutSet(durationSec: _?) => TrackingMode.time,
              _ => TrackingMode.reps,
            }),
            targetReps: Value.absentIfNull(last?.reps),
            targetSeconds: Value.absentIfNull(last?.durationSec),
            targetWeightKg: Value.absentIfNull(last?.weightKg),
          ),
        );
  }

  Future<void> addExercise(int workoutId, int exerciseId) =>
      db.transaction(() async {
        final position = db.workoutExercises.position.max();
        final last =
            await (db.selectOnly(db.workoutExercises)
                  ..addColumns([position])
                  ..where(db.workoutExercises.workoutId.equals(workoutId)))
                .map((row) => row.read(position))
                .getSingle();
        await _insertExercise(workoutId, exerciseId, (last ?? -1) + 1);
      });

  Future<void> removeExercise(int workoutExerciseId) => (db.delete(
    db.workoutExercises,
  )..where((t) => t.id.equals(workoutExerciseId))).go();

  /// Ajusta as metas do exercício no treino; o que não for passado fica como está.
  Future<void> setTargets(
    int workoutExerciseId, {
    TrackingMode? mode,
    int? sets,
    int? reps,
    int? seconds,
    double? weightKg,
  }) =>
      (db.update(
        db.workoutExercises,
      )..where((t) => t.id.equals(workoutExerciseId))).write(
        WorkoutExercisesCompanion(
          mode: Value.absentIfNull(mode),
          targetSets: Value.absentIfNull(sets),
          targetReps: Value.absentIfNull(reps),
          targetSeconds: Value.absentIfNull(seconds),
          targetWeightKg: Value.absentIfNull(weightKg),
        ),
      );

  /// Registra uma série com as metas atuais do exercício e inicia o descanso. O
  /// exercício fica concluído ao atingir `targetSets`.
  ///
  /// Devolve o fim do descanso, ou `null` se não sobrou exercício pendente (o treino
  /// acabou). Durante um descanso não há série a concluir: a chamada é ignorada e
  /// devolve o descanso em andamento.
  Future<DateTime?> completeSet(int workoutExerciseId) =>
      db.transaction(() async {
        final link = await (db.select(
          db.workoutExercises,
        )..where((t) => t.id.equals(workoutExerciseId))).getSingle();
        final workout = await (db.select(
          db.workouts,
        )..where((t) => t.id.equals(link.workoutId))).getSingle();
        if (workout.restEndsAt != null) return workout.restEndsAt;

        final now = DateTime.now();
        final timed = link.mode == TrackingMode.time;
        await db
            .into(db.workoutSets)
            .insert(
              WorkoutSetsCompanion.insert(
                workoutExerciseId: workoutExerciseId,
                weightKg: link.targetWeightKg,
                reps: Value(timed ? null : link.targetReps),
                durationSec: Value(timed ? link.targetSeconds : null),
                doneAt: now,
              ),
            );
        final sets = await (db.select(
          db.workoutSets,
        )..where((t) => t.workoutExerciseId.equals(workoutExerciseId))).get();
        final exerciseDone = sets.length >= link.targetSets;
        if (exerciseDone) {
          await (db.update(db.workoutExercises)
                ..where((t) => t.id.equals(workoutExerciseId)))
              .write(const WorkoutExercisesCompanion(done: Value(true)));
        }
        final pending =
            await (db.select(db.workoutExercises)..where(
                  (t) => t.workoutId.equals(workout.id) & t.done.equals(false),
                ))
                .get();
        final restEndsAt = pending.isEmpty
            ? null
            : now.add(
                Duration(
                  seconds:
                      workout.restCustomSec ??
                      smartRestSec(
                        mode: link.mode,
                        weightKg: link.targetWeightKg,
                        sameExercise: !exerciseDone,
                      ),
                ),
              );
        await (db.update(
          db.workouts,
        )..where((t) => t.id.equals(workout.id))).write(
          WorkoutsCompanion(
            restEndsAt: Value(restEndsAt),
            timerEndsAt: const Value(null),
          ),
        );
        return restEndsAt;
      });

  Future<void> deleteSet(int setId) =>
      (db.delete(db.workoutSets)..where((t) => t.id.equals(setId))).go();

  /// Última série registrada do exercício: é de onde saem as metas iniciais.
  Future<WorkoutSet?> lastSetOf(int exerciseId) {
    final query =
        db.select(db.workoutSets).join([
            innerJoin(
              db.workoutExercises,
              db.workoutExercises.id.equalsExp(
                db.workoutSets.workoutExerciseId,
              ),
            ),
          ])
          ..where(db.workoutExercises.exerciseId.equals(exerciseId))
          ..orderBy([OrderingTerm.desc(db.workoutSets.id)])
          ..limit(1);
    return query.map((row) => row.readTable(db.workoutSets)).getSingleOrNull();
  }

  Future<void> setRestEndsAt(int workoutId, DateTime? endsAt) =>
      (db.update(db.workouts)..where((t) => t.id.equals(workoutId))).write(
        WorkoutsCompanion(restEndsAt: Value(endsAt)),
      );

  Future<void> setTimerEndsAt(int workoutId, DateTime? endsAt) =>
      (db.update(db.workouts)..where((t) => t.id.equals(workoutId))).write(
        WorkoutsCompanion(timerEndsAt: Value(endsAt)),
      );

  Future<void> setEffort(int workoutId, Effort? effort) =>
      (db.update(db.workouts)..where((t) => t.id.equals(workoutId))).write(
        WorkoutsCompanion(effort: Value(effort)),
      );

  /// Recomeça o treino ativo do zero: mesmos exercícios e metas, sem séries e com o
  /// relógio zerado.
  Future<void> restart(int workoutId) => db.transaction(() async {
    final links = db.selectOnly(db.workoutExercises)
      ..addColumns([db.workoutExercises.id])
      ..where(db.workoutExercises.workoutId.equals(workoutId));
    await (db.delete(
      db.workoutSets,
    )..where((t) => t.workoutExerciseId.isInQuery(links))).go();
    await (db.update(db.workoutExercises)
          ..where((t) => t.workoutId.equals(workoutId)))
        .write(const WorkoutExercisesCompanion(done: Value(false)));
    await (db.update(db.workouts)..where((t) => t.id.equals(workoutId))).write(
      WorkoutsCompanion(
        startedAt: Value(DateTime.now()),
        restEndsAt: const Value(null),
        timerEndsAt: const Value(null),
      ),
    );
  });

  /// `null` volta ao descanso inteligente.
  Future<void> setRestCustom(int workoutId, int? seconds) =>
      (db.update(db.workouts)..where((t) => t.id.equals(workoutId))).write(
        WorkoutsCompanion(restCustomSec: Value(seconds)),
      );

  /// Consolida o treino no histórico. Exercícios sem séries são removidos; um treino
  /// sem nenhuma série é descartado. Devolve `true` se o treino foi salvo.
  Future<bool> finish(int workoutId) => db.transaction(() async {
    final withSets = db.selectOnly(db.workoutSets)
      ..addColumns([db.workoutSets.workoutExerciseId]);
    await (db.delete(db.workoutExercises)..where(
          (t) => t.workoutId.equals(workoutId) & t.id.isNotInQuery(withSets),
        ))
        .go();
    final remaining = await (db.select(
      db.workoutExercises,
    )..where((t) => t.workoutId.equals(workoutId))).get();
    if (remaining.isEmpty) {
      await delete(workoutId);
      return false;
    }
    await (db.update(db.workouts)..where((t) => t.id.equals(workoutId))).write(
      WorkoutsCompanion(
        endedAt: Value(DateTime.now()),
        restEndsAt: const Value(null),
        timerEndsAt: const Value(null),
      ),
    );
    return true;
  });

  Future<void> delete(int workoutId) =>
      (db.delete(db.workouts)..where((t) => t.id.equals(workoutId))).go();
}

class MetricsRepository {
  MetricsRepository(this.db);

  final AppDatabase db;

  /// Em ordem cronológica.
  Stream<List<BodyMetric>> watchAll() => (db.select(
    db.bodyMetrics,
  )..orderBy([(t) => OrderingTerm.asc(t.date)])).watch();

  Future<void> add(BodyMetricsCompanion entry) =>
      db.into(db.bodyMetrics).insert(entry);

  Future<void> delete(int id) =>
      (db.delete(db.bodyMetrics)..where((t) => t.id.equals(id))).go();
}

/// IMC = peso (kg) / altura (m)².
double? bmi(double? weightKg, double? heightCm) {
  if (weightKg == null || heightCm == null || heightCm <= 0) return null;
  final m = heightCm / 100;
  return weightKg / (m * m);
}

String bmiCategory(double bmi) => switch (bmi) {
  < 18.5 => 'abaixo do peso',
  < 25 => 'peso normal',
  < 30 => 'sobrepeso',
  _ => 'obesidade',
};

/// Ritmo assumido para estimar a duração de uma série por repetições.
const secondsPerRep = 3;

/// Séries por exercício quando ainda não há meta (padrão de `WorkoutExercises`).
const defaultTargetSets = 3;

/// Duração prevista de [sets] séries: a execução mais o descanso depois de cada uma.
/// Os padrões são os das colunas de `WorkoutExercises` (exercício ainda sem metas).
Duration estimateSets({
  required int sets,
  required TrackingMode mode,
  int reps = 12,
  int seconds = 30,
  double weightKg = 0,
  int? restCustomSec,
}) {
  if (sets <= 0) return Duration.zero;
  final work = mode == TrackingMode.time ? seconds : reps * secondsPerRep;
  final rest =
      restCustomSec ??
      smartRestSec(mode: mode, weightKg: weightKg, sameExercise: true);
  return Duration(seconds: sets * (work + rest));
}

/// Peso assumido na estimativa de calorias enquanto não há medição.
const defaultBodyWeightKg = 70.0;

/// Estimativa de gasto calórico: MET × peso (kg) × horas, com MET 5 (treino de força
/// / calistenia em ritmo moderado). É uma aproximação, não uma medição.
double estimateKcal(Duration duration, double? bodyWeightKg) =>
    5 * (bodyWeightKg ?? defaultBodyWeightKg) * duration.inSeconds / 3600;

/// Descanso inteligente, em segundos: mais longo com carga e ao trocar de exercício.
int smartRestSec({
  required TrackingMode mode,
  required double weightKg,
  required bool sameExercise,
}) {
  final base = switch (mode) {
    TrackingMode.time => 30,
    TrackingMode.reps => weightKg > 0 ? 75 : 45,
  };
  return sameExercise ? base : base + 30;
}
