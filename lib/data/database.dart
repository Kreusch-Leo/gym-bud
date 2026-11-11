import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

import '../core/effort.dart';
import '../core/muscle_group.dart';
import '../core/tracking_mode.dart';
import 'backup.dart';

part 'database.g.dart';

class MuscleListConverter extends TypeConverter<List<MuscleGroup>, String> {
  const MuscleListConverter();

  @override
  List<MuscleGroup> fromSql(String fromDb) => [
    for (final name in jsonDecode(fromDb) as List)
      ?MuscleGroup.tryParse(name as String),
  ];

  @override
  String toSql(List<MuscleGroup> value) =>
      jsonEncode([for (final g in value) g.name]);
}

/// Equipamento granular: "Halteres até 10kg" e "Halteres até 30kg" são itens distintos.
@DataClassName('Equipment')
class Equipments extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().unique()();
}

class Exercises extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().unique()();
  TextColumn get primaryMuscle => textEnum<MuscleGroup>()();
  TextColumn get secondaryMuscles => text()
      .map(const MuscleListConverter())
      .withDefault(const Constant('[]'))();

  /// Caminho de um GIF/imagem copiado para a pasta do app.
  TextColumn get mediaPath => text().nullable()();

  /// Modo padrão do exercício; cada treino pode trocar o seu (ver [WorkoutExercises.mode]).
  TextColumn get trackingMode =>
      textEnum<TrackingMode>().withDefault(Constant(TrackingMode.reps.name))();
}

/// Lista estrita: o exercício só é viável se TODOS os equipamentos estiverem no local.
class ExerciseEquipments extends Table {
  IntColumn get exerciseId =>
      integer().references(Exercises, #id, onDelete: KeyAction.cascade)();
  IntColumn get equipmentId =>
      integer().references(Equipments, #id, onDelete: KeyAction.cascade)();

  @override
  Set<Column> get primaryKey => {exerciseId, equipmentId};
}

class Gyms extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().unique()();
  RealColumn get latitude => real().nullable()();
  RealColumn get longitude => real().nullable()();
  RealColumn get radiusM => real().withDefault(const Constant(100))();
}

class GymEquipments extends Table {
  IntColumn get gymId =>
      integer().references(Gyms, #id, onDelete: KeyAction.cascade)();
  IntColumn get equipmentId =>
      integer().references(Equipments, #id, onDelete: KeyAction.cascade)();

  @override
  Set<Column> get primaryKey => {gymId, equipmentId};
}

/// Um treino. `endedAt == null` significa treino ativo (no máximo um).
class Workouts extends Table {
  IntColumn get id => integer().autoIncrement()();
  DateTimeColumn get startedAt => dateTime()();
  DateTimeColumn get endedAt => dateTime().nullable()();
  IntColumn get gymId =>
      integer().nullable().references(Gyms, #id, onDelete: KeyAction.setNull)();

  /// Descanso manual, em segundos; `null` = descanso inteligente (`smartRestSec`).
  IntColumn get restCustomSec => integer().nullable()();

  /// Fim do descanso em andamento; persistido para sobreviver ao app em segundo plano.
  DateTimeColumn get restEndsAt => dateTime().nullable()();

  /// Fim da contagem do exercício por tempo em andamento; `null` = parada.
  DateTimeColumn get timerEndsAt => dateTime().nullable()();

  /// Percepção de esforço informada na conclusão; `null` = não informada.
  TextColumn get effort => textEnum<Effort>().nullable()();
}

class WorkoutExercises extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get workoutId =>
      integer().references(Workouts, #id, onDelete: KeyAction.cascade)();
  IntColumn get exerciseId =>
      integer().references(Exercises, #id, onDelete: KeyAction.cascade)();
  IntColumn get position => integer()();
  IntColumn get targetSets => integer().withDefault(const Constant(3))();

  /// Metas da próxima série: o modo decide se vale [targetReps] ou [targetSeconds].
  TextColumn get mode =>
      textEnum<TrackingMode>().withDefault(Constant(TrackingMode.reps.name))();
  IntColumn get targetReps => integer().withDefault(const Constant(12))();
  IntColumn get targetSeconds => integer().withDefault(const Constant(30))();
  RealColumn get targetWeightKg => real().withDefault(const Constant(0))();
  BoolColumn get done => boolean().withDefault(const Constant(false))();
}

class WorkoutSets extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get workoutExerciseId => integer().references(
    WorkoutExercises,
    #id,
    onDelete: KeyAction.cascade,
  )();
  RealColumn get weightKg => real()();

  /// Série por repetições preenche [reps]; série por tempo, [durationSec].
  IntColumn get reps => integer().nullable()();
  IntColumn get durationSec => integer().nullable()();
  DateTimeColumn get doneAt => dateTime()();
}

class BodyMetrics extends Table {
  IntColumn get id => integer().autoIncrement()();
  DateTimeColumn get date => dateTime()();
  RealColumn get weightKg => real().nullable()();
  RealColumn get heightCm => real().nullable()();
  RealColumn get bodyFatPct => real().nullable()();
  RealColumn get chestCm => real().nullable()();
  RealColumn get waistCm => real().nullable()();
  RealColumn get hipCm => real().nullable()();
  RealColumn get armCm => real().nullable()();
  RealColumn get thighCm => real().nullable()();
}

@DriftDatabase(
  tables: [
    Equipments,
    Exercises,
    ExerciseEquipments,
    Gyms,
    GymEquipments,
    Workouts,
    WorkoutExercises,
    WorkoutSets,
    BodyMetrics,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase({QueryExecutor? executor, this.loadSeed})
    : super(executor ?? driftDatabase(name: 'gym_bud'));

  /// JSON (formato de `backup.dart`) carregado uma única vez, na criação do banco.
  final Future<String> Function()? loadSeed;

  @override
  int get schemaVersion => 3;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) async {
      await m.createAll();
      final seed = await loadSeed?.call();
      if (seed != null) await importBackup(this, seed);
    },
    onUpgrade: (m, from, to) async {
      if (from < 2) {
        await m.addColumn(exercises, exercises.trackingMode);
        await m.addColumn(workoutExercises, workoutExercises.mode);
        await m.addColumn(workoutExercises, workoutExercises.targetReps);
        await m.addColumn(workoutExercises, workoutExercises.targetSeconds);
        await m.addColumn(workoutExercises, workoutExercises.targetWeightKg);
        // Recria as tabelas: saem os dois tempos de descanso fixos e `reps` vira opcional.
        await m.alterTable(
          TableMigration(
            workouts,
            newColumns: [
              workouts.restCustomSec,
              workouts.timerEndsAt,
              workouts.effort,
            ],
          ),
        );
        await m.alterTable(
          TableMigration(workoutSets, newColumns: [workoutSets.durationSec]),
        );
      } else if (from < 3) {
        // Quem vem da v1 já ganhou a coluna ao recriar a tabela acima.
        await m.addColumn(workouts, workouts.effort);
      }
    },
    beforeOpen: (details) async {
      await customStatement('PRAGMA foreign_keys = ON');
    },
  );
}
