import 'dart:convert';
import 'dart:io';

import 'package:drift/drift.dart';

import '../core/effort.dart';
import '../core/muscle_group.dart';
import '../core/tracking_mode.dart';
import 'database.dart';

/// Formato JSON único para seed inicial, backup e adição de treinos/exercícios:
///
/// ```json
/// {
///   "equipment": ["Barra Olímpica 20kg"],
///   "exercises": [{"name": "...", "primary": "peito", "secondary": ["triceps"],
///                  "equipment": ["Barra Olímpica 20kg"], "media": null, "mode": "reps"}],
///   "gyms": [{"name": "...", "lat": 0, "lng": 0, "radius": 100, "equipment": []}],
///   "workouts": [{"startedAt": "ISO-8601", "endedAt": "ISO-8601", "gym": "...", "effort": "right",
///                 "exercises": [{"exercise": "...", "sets": [{"weight": 20, "reps": 10, "at": "ISO-8601"},
///                                                            {"weight": 0, "seconds": 30, "at": "ISO-8601"}]}]}],
///   "metrics": [{"date": "ISO-8601", "weightKg": 80, "heightCm": 180, ...}]
/// }
/// ```
/// Todas as chaves são opcionais. A importação só adiciona: nada existente é
/// sobrescrito (exercícios, equipamentos e locais casam por nome; treinos e
/// métricas, por data).
class ImportResult {
  int equipment = 0, exercises = 0, gyms = 0, workouts = 0, metrics = 0;

  @override
  String toString() =>
      '$exercises exercícios, $equipment equipamentos, $gyms locais, '
      '$workouts treinos e $metrics medições adicionados';
}

List<T> _list<T>(Object? value) =>
    value == null ? const [] : (value as List).cast<T>();

double? _num(Object? value) => (value as num?)?.toDouble();

/// Lança [FormatException] se o JSON não seguir o formato; nesse caso nada é gravado.
Future<ImportResult> importBackup(AppDatabase db, String source) async {
  final result = ImportResult();
  try {
    final json = jsonDecode(source) as Map<String, dynamic>;
    await db.transaction(() async {
      final equipmentIds = {
        for (final e in await db.select(db.equipments).get()) e.name: e.id,
      };
      Future<int> equipmentId(String name) async =>
          equipmentIds[name] ??= await () async {
            result.equipment++;
            return db
                .into(db.equipments)
                .insert(EquipmentsCompanion.insert(name: name));
          }();

      for (final name in _list<String>(json['equipment'])) {
        await equipmentId(name);
      }

      final exerciseIds = {
        for (final e in await db.select(db.exercises).get()) e.name: e.id,
      };
      for (final e in _list<Map<String, dynamic>>(json['exercises'])) {
        final name = e['name'] as String;
        if (exerciseIds.containsKey(name)) continue;
        final primary = MuscleGroup.tryParse(e['primary'] as String);
        if (primary == null) {
          throw FormatException('Grupo muscular inválido em "$name"');
        }
        final media = e['media'] as String?;
        final id = await db
            .into(db.exercises)
            .insert(
              ExercisesCompanion.insert(
                name: name,
                primaryMuscle: primary,
                secondaryMuscles: Value([
                  for (final g in _list<String>(e['secondary']))
                    ?MuscleGroup.tryParse(g),
                ]),
                mediaPath: Value(
                  media != null && File(media).existsSync() ? media : null,
                ),
                trackingMode: Value.absentIfNull(
                  TrackingMode.tryParse(e['mode'] as String?),
                ),
              ),
            );
        exerciseIds[name] = id;
        result.exercises++;
        for (final equipment in _list<String>(e['equipment']).toSet()) {
          await db
              .into(db.exerciseEquipments)
              .insert(
                ExerciseEquipmentsCompanion.insert(
                  exerciseId: id,
                  equipmentId: await equipmentId(equipment),
                ),
              );
        }
      }

      final gymIds = {
        for (final g in await db.select(db.gyms).get()) g.name: g.id,
      };
      for (final g in _list<Map<String, dynamic>>(json['gyms'])) {
        final name = g['name'] as String;
        if (gymIds.containsKey(name)) continue;
        final id = await db
            .into(db.gyms)
            .insert(
              GymsCompanion.insert(
                name: name,
                latitude: Value(_num(g['lat'])),
                longitude: Value(_num(g['lng'])),
                radiusM: Value(_num(g['radius']) ?? 100),
              ),
            );
        gymIds[name] = id;
        result.gyms++;
        for (final equipment in _list<String>(g['equipment']).toSet()) {
          await db
              .into(db.gymEquipments)
              .insert(
                GymEquipmentsCompanion.insert(
                  gymId: id,
                  equipmentId: await equipmentId(equipment),
                ),
              );
        }
      }

      final workoutStarts = {
        for (final w in await db.select(db.workouts).get()) w.startedAt,
      };
      for (final w in _list<Map<String, dynamic>>(json['workouts'])) {
        final startedAt = DateTime.parse(w['startedAt'] as String).toLocal();
        if (!workoutStarts.add(startedAt)) continue;
        final workoutId = await db
            .into(db.workouts)
            .insert(
              WorkoutsCompanion.insert(
                startedAt: startedAt,
                // Treino importado é sempre histórico, nunca "ativo".
                endedAt: Value(
                  DateTime.parse((w['endedAt'] ?? w['startedAt']) as String)
                      .toLocal(),
                ),
                gymId: Value(gymIds[w['gym']]),
                effort: Value(Effort.tryParse(w['effort'] as String?)),
              ),
            );
        result.workouts++;
        var position = 0;
        for (final e in _list<Map<String, dynamic>>(w['exercises'])) {
          final exerciseId = exerciseIds[e['exercise']];
          if (exerciseId == null) {
            throw FormatException(
              'Treino referencia exercício desconhecido: "${e['exercise']}"',
            );
          }
          final linkId = await db
              .into(db.workoutExercises)
              .insert(
                WorkoutExercisesCompanion.insert(
                  workoutId: workoutId,
                  exerciseId: exerciseId,
                  position: position++,
                  done: const Value(true),
                ),
              );
          for (final s in _list<Map<String, dynamic>>(e['sets'])) {
            await db
                .into(db.workoutSets)
                .insert(
                  WorkoutSetsCompanion.insert(
                    workoutExerciseId: linkId,
                    weightKg: _num(s['weight'])!,
                    reps: Value((s['reps'] as num?)?.toInt()),
                    durationSec: Value((s['seconds'] as num?)?.toInt()),
                    doneAt: s['at'] == null
                        ? startedAt
                        : DateTime.parse(s['at'] as String).toLocal(),
                  ),
                );
          }
        }
      }

      final metricDates = {
        for (final m in await db.select(db.bodyMetrics).get()) m.date,
      };
      for (final m in _list<Map<String, dynamic>>(json['metrics'])) {
        final date = DateTime.parse(m['date'] as String).toLocal();
        if (!metricDates.add(date)) continue;
        await db
            .into(db.bodyMetrics)
            .insert(
              BodyMetricsCompanion.insert(
                date: date,
                weightKg: Value(_num(m['weightKg'])),
                heightCm: Value(_num(m['heightCm'])),
                bodyFatPct: Value(_num(m['bodyFatPct'])),
                chestCm: Value(_num(m['chestCm'])),
                waistCm: Value(_num(m['waistCm'])),
                hipCm: Value(_num(m['hipCm'])),
                armCm: Value(_num(m['armCm'])),
                thighCm: Value(_num(m['thighCm'])),
              ),
            );
        result.metrics++;
      }
    });
  } on TypeError catch (e) {
    throw FormatException('Arquivo fora do formato esperado ($e)');
  }
  return result;
}

/// Backup completo (o treino ativo, se houver, fica de fora).
Future<String> exportBackup(AppDatabase db) async {
  final equipment = {
    for (final e in await db.select(db.equipments).get()) e.id: e.name,
  };
  final exercises = {
    for (final e in await db.select(db.exercises).get()) e.id: e,
  };
  final gyms = {for (final g in await db.select(db.gyms).get()) g.id: g};
  final exerciseLinks = await db.select(db.exerciseEquipments).get();
  final gymLinks = await db.select(db.gymEquipments).get();
  final workouts = await (db.select(
    db.workouts,
  )..where((t) => t.endedAt.isNotNull())).get();
  final workoutExercises = await (db.select(
    db.workoutExercises,
  )..orderBy([(t) => OrderingTerm.asc(t.position)])).get();
  final sets = await (db.select(
    db.workoutSets,
  )..orderBy([(t) => OrderingTerm.asc(t.id)])).get();
  final metrics = await db.select(db.bodyMetrics).get();

  String iso(DateTime d) => d.toUtc().toIso8601String();

  return const JsonEncoder.withIndent('  ').convert({
    'equipment': equipment.values.toList(),
    'exercises': [
      for (final e in exercises.values)
        {
          'name': e.name,
          'primary': e.primaryMuscle.name,
          'secondary': [for (final g in e.secondaryMuscles) g.name],
          'equipment': [
            for (final l in exerciseLinks)
              if (l.exerciseId == e.id) equipment[l.equipmentId],
          ],
          'media': e.mediaPath,
          'mode': e.trackingMode.name,
        },
    ],
    'gyms': [
      for (final g in gyms.values)
        {
          'name': g.name,
          'lat': g.latitude,
          'lng': g.longitude,
          'radius': g.radiusM,
          'equipment': [
            for (final l in gymLinks)
              if (l.gymId == g.id) equipment[l.equipmentId],
          ],
        },
    ],
    'workouts': [
      for (final w in workouts)
        {
          'startedAt': iso(w.startedAt),
          'endedAt': iso(w.endedAt!),
          'gym': gyms[w.gymId]?.name,
          'effort': w.effort?.name,
          'exercises': [
            for (final we in workoutExercises)
              if (we.workoutId == w.id)
                {
                  'exercise': exercises[we.exerciseId]!.name,
                  'sets': [
                    for (final s in sets)
                      if (s.workoutExerciseId == we.id)
                        {
                          'weight': s.weightKg,
                          'reps': ?s.reps,
                          'seconds': ?s.durationSec,
                          'at': iso(s.doneAt),
                        },
                  ],
                },
          ],
        },
    ],
    'metrics': [
      for (final m in metrics)
        {
          'date': iso(m.date),
          'weightKg': m.weightKg,
          'heightCm': m.heightCm,
          'bodyFatPct': m.bodyFatPct,
          'chestCm': m.chestCm,
          'waistCm': m.waistCm,
          'hipCm': m.hipCm,
          'armCm': m.armCm,
          'thighCm': m.thighCm,
        },
    ],
  });
}
