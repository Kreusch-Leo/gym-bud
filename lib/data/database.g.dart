// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $EquipmentsTable extends Equipments
    with TableInfo<$EquipmentsTable, Equipment> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $EquipmentsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  @override
  List<GeneratedColumn> get $columns => [id, name];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'equipments';
  @override
  VerificationContext validateIntegrity(
    Insertable<Equipment> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Equipment map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Equipment(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
    );
  }

  @override
  $EquipmentsTable createAlias(String alias) {
    return $EquipmentsTable(attachedDatabase, alias);
  }
}

class Equipment extends DataClass implements Insertable<Equipment> {
  final int id;
  final String name;
  const Equipment({required this.id, required this.name});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    return map;
  }

  EquipmentsCompanion toCompanion(bool nullToAbsent) {
    return EquipmentsCompanion(id: Value(id), name: Value(name));
  }

  factory Equipment.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Equipment(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
    };
  }

  Equipment copyWith({int? id, String? name}) =>
      Equipment(id: id ?? this.id, name: name ?? this.name);
  Equipment copyWithCompanion(EquipmentsCompanion data) {
    return Equipment(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Equipment(')
          ..write('id: $id, ')
          ..write('name: $name')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Equipment && other.id == this.id && other.name == this.name);
}

class EquipmentsCompanion extends UpdateCompanion<Equipment> {
  final Value<int> id;
  final Value<String> name;
  const EquipmentsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
  });
  EquipmentsCompanion.insert({
    this.id = const Value.absent(),
    required String name,
  }) : name = Value(name);
  static Insertable<Equipment> custom({
    Expression<int>? id,
    Expression<String>? name,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
    });
  }

  EquipmentsCompanion copyWith({Value<int>? id, Value<String>? name}) {
    return EquipmentsCompanion(id: id ?? this.id, name: name ?? this.name);
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('EquipmentsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name')
          ..write(')'))
        .toString();
  }
}

class $ExercisesTable extends Exercises
    with TableInfo<$ExercisesTable, Exercise> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ExercisesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  @override
  late final GeneratedColumnWithTypeConverter<MuscleGroup, String>
  primaryMuscle = GeneratedColumn<String>(
    'primary_muscle',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  ).withConverter<MuscleGroup>($ExercisesTable.$converterprimaryMuscle);
  @override
  late final GeneratedColumnWithTypeConverter<List<MuscleGroup>, String>
  secondaryMuscles =
      GeneratedColumn<String>(
        'secondary_muscles',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultValue: const Constant('[]'),
      ).withConverter<List<MuscleGroup>>(
        $ExercisesTable.$convertersecondaryMuscles,
      );
  static const VerificationMeta _mediaPathMeta = const VerificationMeta(
    'mediaPath',
  );
  @override
  late final GeneratedColumn<String> mediaPath = GeneratedColumn<String>(
    'media_path',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  late final GeneratedColumnWithTypeConverter<TrackingMode, String>
  trackingMode = GeneratedColumn<String>(
    'tracking_mode',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: Constant(TrackingMode.reps.name),
  ).withConverter<TrackingMode>($ExercisesTable.$convertertrackingMode);
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    primaryMuscle,
    secondaryMuscles,
    mediaPath,
    trackingMode,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'exercises';
  @override
  VerificationContext validateIntegrity(
    Insertable<Exercise> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('media_path')) {
      context.handle(
        _mediaPathMeta,
        mediaPath.isAcceptableOrUnknown(data['media_path']!, _mediaPathMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Exercise map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Exercise(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      primaryMuscle: $ExercisesTable.$converterprimaryMuscle.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}primary_muscle'],
        )!,
      ),
      secondaryMuscles: $ExercisesTable.$convertersecondaryMuscles.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}secondary_muscles'],
        )!,
      ),
      mediaPath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}media_path'],
      ),
      trackingMode: $ExercisesTable.$convertertrackingMode.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}tracking_mode'],
        )!,
      ),
    );
  }

  @override
  $ExercisesTable createAlias(String alias) {
    return $ExercisesTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<MuscleGroup, String, String>
  $converterprimaryMuscle = const EnumNameConverter<MuscleGroup>(
    MuscleGroup.values,
  );
  static TypeConverter<List<MuscleGroup>, String> $convertersecondaryMuscles =
      const MuscleListConverter();
  static JsonTypeConverter2<TrackingMode, String, String>
  $convertertrackingMode = const EnumNameConverter<TrackingMode>(
    TrackingMode.values,
  );
}

class Exercise extends DataClass implements Insertable<Exercise> {
  final int id;
  final String name;
  final MuscleGroup primaryMuscle;
  final List<MuscleGroup> secondaryMuscles;

  /// Caminho de um GIF/imagem copiado para a pasta do app.
  final String? mediaPath;

  /// Modo padrão do exercício; cada treino pode trocar o seu (ver [WorkoutExercises.mode]).
  final TrackingMode trackingMode;
  const Exercise({
    required this.id,
    required this.name,
    required this.primaryMuscle,
    required this.secondaryMuscles,
    this.mediaPath,
    required this.trackingMode,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    {
      map['primary_muscle'] = Variable<String>(
        $ExercisesTable.$converterprimaryMuscle.toSql(primaryMuscle),
      );
    }
    {
      map['secondary_muscles'] = Variable<String>(
        $ExercisesTable.$convertersecondaryMuscles.toSql(secondaryMuscles),
      );
    }
    if (!nullToAbsent || mediaPath != null) {
      map['media_path'] = Variable<String>(mediaPath);
    }
    {
      map['tracking_mode'] = Variable<String>(
        $ExercisesTable.$convertertrackingMode.toSql(trackingMode),
      );
    }
    return map;
  }

  ExercisesCompanion toCompanion(bool nullToAbsent) {
    return ExercisesCompanion(
      id: Value(id),
      name: Value(name),
      primaryMuscle: Value(primaryMuscle),
      secondaryMuscles: Value(secondaryMuscles),
      mediaPath: mediaPath == null && nullToAbsent
          ? const Value.absent()
          : Value(mediaPath),
      trackingMode: Value(trackingMode),
    );
  }

  factory Exercise.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Exercise(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      primaryMuscle: $ExercisesTable.$converterprimaryMuscle.fromJson(
        serializer.fromJson<String>(json['primaryMuscle']),
      ),
      secondaryMuscles: serializer.fromJson<List<MuscleGroup>>(
        json['secondaryMuscles'],
      ),
      mediaPath: serializer.fromJson<String?>(json['mediaPath']),
      trackingMode: $ExercisesTable.$convertertrackingMode.fromJson(
        serializer.fromJson<String>(json['trackingMode']),
      ),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'primaryMuscle': serializer.toJson<String>(
        $ExercisesTable.$converterprimaryMuscle.toJson(primaryMuscle),
      ),
      'secondaryMuscles': serializer.toJson<List<MuscleGroup>>(
        secondaryMuscles,
      ),
      'mediaPath': serializer.toJson<String?>(mediaPath),
      'trackingMode': serializer.toJson<String>(
        $ExercisesTable.$convertertrackingMode.toJson(trackingMode),
      ),
    };
  }

  Exercise copyWith({
    int? id,
    String? name,
    MuscleGroup? primaryMuscle,
    List<MuscleGroup>? secondaryMuscles,
    Value<String?> mediaPath = const Value.absent(),
    TrackingMode? trackingMode,
  }) => Exercise(
    id: id ?? this.id,
    name: name ?? this.name,
    primaryMuscle: primaryMuscle ?? this.primaryMuscle,
    secondaryMuscles: secondaryMuscles ?? this.secondaryMuscles,
    mediaPath: mediaPath.present ? mediaPath.value : this.mediaPath,
    trackingMode: trackingMode ?? this.trackingMode,
  );
  Exercise copyWithCompanion(ExercisesCompanion data) {
    return Exercise(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      primaryMuscle: data.primaryMuscle.present
          ? data.primaryMuscle.value
          : this.primaryMuscle,
      secondaryMuscles: data.secondaryMuscles.present
          ? data.secondaryMuscles.value
          : this.secondaryMuscles,
      mediaPath: data.mediaPath.present ? data.mediaPath.value : this.mediaPath,
      trackingMode: data.trackingMode.present
          ? data.trackingMode.value
          : this.trackingMode,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Exercise(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('primaryMuscle: $primaryMuscle, ')
          ..write('secondaryMuscles: $secondaryMuscles, ')
          ..write('mediaPath: $mediaPath, ')
          ..write('trackingMode: $trackingMode')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    primaryMuscle,
    secondaryMuscles,
    mediaPath,
    trackingMode,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Exercise &&
          other.id == this.id &&
          other.name == this.name &&
          other.primaryMuscle == this.primaryMuscle &&
          other.secondaryMuscles == this.secondaryMuscles &&
          other.mediaPath == this.mediaPath &&
          other.trackingMode == this.trackingMode);
}

class ExercisesCompanion extends UpdateCompanion<Exercise> {
  final Value<int> id;
  final Value<String> name;
  final Value<MuscleGroup> primaryMuscle;
  final Value<List<MuscleGroup>> secondaryMuscles;
  final Value<String?> mediaPath;
  final Value<TrackingMode> trackingMode;
  const ExercisesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.primaryMuscle = const Value.absent(),
    this.secondaryMuscles = const Value.absent(),
    this.mediaPath = const Value.absent(),
    this.trackingMode = const Value.absent(),
  });
  ExercisesCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required MuscleGroup primaryMuscle,
    this.secondaryMuscles = const Value.absent(),
    this.mediaPath = const Value.absent(),
    this.trackingMode = const Value.absent(),
  }) : name = Value(name),
       primaryMuscle = Value(primaryMuscle);
  static Insertable<Exercise> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? primaryMuscle,
    Expression<String>? secondaryMuscles,
    Expression<String>? mediaPath,
    Expression<String>? trackingMode,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (primaryMuscle != null) 'primary_muscle': primaryMuscle,
      if (secondaryMuscles != null) 'secondary_muscles': secondaryMuscles,
      if (mediaPath != null) 'media_path': mediaPath,
      if (trackingMode != null) 'tracking_mode': trackingMode,
    });
  }

  ExercisesCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<MuscleGroup>? primaryMuscle,
    Value<List<MuscleGroup>>? secondaryMuscles,
    Value<String?>? mediaPath,
    Value<TrackingMode>? trackingMode,
  }) {
    return ExercisesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      primaryMuscle: primaryMuscle ?? this.primaryMuscle,
      secondaryMuscles: secondaryMuscles ?? this.secondaryMuscles,
      mediaPath: mediaPath ?? this.mediaPath,
      trackingMode: trackingMode ?? this.trackingMode,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (primaryMuscle.present) {
      map['primary_muscle'] = Variable<String>(
        $ExercisesTable.$converterprimaryMuscle.toSql(primaryMuscle.value),
      );
    }
    if (secondaryMuscles.present) {
      map['secondary_muscles'] = Variable<String>(
        $ExercisesTable.$convertersecondaryMuscles.toSql(
          secondaryMuscles.value,
        ),
      );
    }
    if (mediaPath.present) {
      map['media_path'] = Variable<String>(mediaPath.value);
    }
    if (trackingMode.present) {
      map['tracking_mode'] = Variable<String>(
        $ExercisesTable.$convertertrackingMode.toSql(trackingMode.value),
      );
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ExercisesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('primaryMuscle: $primaryMuscle, ')
          ..write('secondaryMuscles: $secondaryMuscles, ')
          ..write('mediaPath: $mediaPath, ')
          ..write('trackingMode: $trackingMode')
          ..write(')'))
        .toString();
  }
}

class $ExerciseEquipmentsTable extends ExerciseEquipments
    with TableInfo<$ExerciseEquipmentsTable, ExerciseEquipment> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ExerciseEquipmentsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _exerciseIdMeta = const VerificationMeta(
    'exerciseId',
  );
  @override
  late final GeneratedColumn<int> exerciseId = GeneratedColumn<int>(
    'exercise_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES exercises (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _equipmentIdMeta = const VerificationMeta(
    'equipmentId',
  );
  @override
  late final GeneratedColumn<int> equipmentId = GeneratedColumn<int>(
    'equipment_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES equipments (id) ON DELETE CASCADE',
    ),
  );
  @override
  List<GeneratedColumn> get $columns => [exerciseId, equipmentId];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'exercise_equipments';
  @override
  VerificationContext validateIntegrity(
    Insertable<ExerciseEquipment> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('exercise_id')) {
      context.handle(
        _exerciseIdMeta,
        exerciseId.isAcceptableOrUnknown(data['exercise_id']!, _exerciseIdMeta),
      );
    } else if (isInserting) {
      context.missing(_exerciseIdMeta);
    }
    if (data.containsKey('equipment_id')) {
      context.handle(
        _equipmentIdMeta,
        equipmentId.isAcceptableOrUnknown(
          data['equipment_id']!,
          _equipmentIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_equipmentIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {exerciseId, equipmentId};
  @override
  ExerciseEquipment map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ExerciseEquipment(
      exerciseId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}exercise_id'],
      )!,
      equipmentId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}equipment_id'],
      )!,
    );
  }

  @override
  $ExerciseEquipmentsTable createAlias(String alias) {
    return $ExerciseEquipmentsTable(attachedDatabase, alias);
  }
}

class ExerciseEquipment extends DataClass
    implements Insertable<ExerciseEquipment> {
  final int exerciseId;
  final int equipmentId;
  const ExerciseEquipment({
    required this.exerciseId,
    required this.equipmentId,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['exercise_id'] = Variable<int>(exerciseId);
    map['equipment_id'] = Variable<int>(equipmentId);
    return map;
  }

  ExerciseEquipmentsCompanion toCompanion(bool nullToAbsent) {
    return ExerciseEquipmentsCompanion(
      exerciseId: Value(exerciseId),
      equipmentId: Value(equipmentId),
    );
  }

  factory ExerciseEquipment.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ExerciseEquipment(
      exerciseId: serializer.fromJson<int>(json['exerciseId']),
      equipmentId: serializer.fromJson<int>(json['equipmentId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'exerciseId': serializer.toJson<int>(exerciseId),
      'equipmentId': serializer.toJson<int>(equipmentId),
    };
  }

  ExerciseEquipment copyWith({int? exerciseId, int? equipmentId}) =>
      ExerciseEquipment(
        exerciseId: exerciseId ?? this.exerciseId,
        equipmentId: equipmentId ?? this.equipmentId,
      );
  ExerciseEquipment copyWithCompanion(ExerciseEquipmentsCompanion data) {
    return ExerciseEquipment(
      exerciseId: data.exerciseId.present
          ? data.exerciseId.value
          : this.exerciseId,
      equipmentId: data.equipmentId.present
          ? data.equipmentId.value
          : this.equipmentId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ExerciseEquipment(')
          ..write('exerciseId: $exerciseId, ')
          ..write('equipmentId: $equipmentId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(exerciseId, equipmentId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ExerciseEquipment &&
          other.exerciseId == this.exerciseId &&
          other.equipmentId == this.equipmentId);
}

class ExerciseEquipmentsCompanion extends UpdateCompanion<ExerciseEquipment> {
  final Value<int> exerciseId;
  final Value<int> equipmentId;
  final Value<int> rowid;
  const ExerciseEquipmentsCompanion({
    this.exerciseId = const Value.absent(),
    this.equipmentId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ExerciseEquipmentsCompanion.insert({
    required int exerciseId,
    required int equipmentId,
    this.rowid = const Value.absent(),
  }) : exerciseId = Value(exerciseId),
       equipmentId = Value(equipmentId);
  static Insertable<ExerciseEquipment> custom({
    Expression<int>? exerciseId,
    Expression<int>? equipmentId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (exerciseId != null) 'exercise_id': exerciseId,
      if (equipmentId != null) 'equipment_id': equipmentId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ExerciseEquipmentsCompanion copyWith({
    Value<int>? exerciseId,
    Value<int>? equipmentId,
    Value<int>? rowid,
  }) {
    return ExerciseEquipmentsCompanion(
      exerciseId: exerciseId ?? this.exerciseId,
      equipmentId: equipmentId ?? this.equipmentId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (exerciseId.present) {
      map['exercise_id'] = Variable<int>(exerciseId.value);
    }
    if (equipmentId.present) {
      map['equipment_id'] = Variable<int>(equipmentId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ExerciseEquipmentsCompanion(')
          ..write('exerciseId: $exerciseId, ')
          ..write('equipmentId: $equipmentId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $GymsTable extends Gyms with TableInfo<$GymsTable, Gym> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $GymsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _latitudeMeta = const VerificationMeta(
    'latitude',
  );
  @override
  late final GeneratedColumn<double> latitude = GeneratedColumn<double>(
    'latitude',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _longitudeMeta = const VerificationMeta(
    'longitude',
  );
  @override
  late final GeneratedColumn<double> longitude = GeneratedColumn<double>(
    'longitude',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _radiusMMeta = const VerificationMeta(
    'radiusM',
  );
  @override
  late final GeneratedColumn<double> radiusM = GeneratedColumn<double>(
    'radius_m',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(100),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    latitude,
    longitude,
    radiusM,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'gyms';
  @override
  VerificationContext validateIntegrity(
    Insertable<Gym> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('latitude')) {
      context.handle(
        _latitudeMeta,
        latitude.isAcceptableOrUnknown(data['latitude']!, _latitudeMeta),
      );
    }
    if (data.containsKey('longitude')) {
      context.handle(
        _longitudeMeta,
        longitude.isAcceptableOrUnknown(data['longitude']!, _longitudeMeta),
      );
    }
    if (data.containsKey('radius_m')) {
      context.handle(
        _radiusMMeta,
        radiusM.isAcceptableOrUnknown(data['radius_m']!, _radiusMMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Gym map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Gym(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      latitude: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}latitude'],
      ),
      longitude: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}longitude'],
      ),
      radiusM: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}radius_m'],
      )!,
    );
  }

  @override
  $GymsTable createAlias(String alias) {
    return $GymsTable(attachedDatabase, alias);
  }
}

class Gym extends DataClass implements Insertable<Gym> {
  final int id;
  final String name;
  final double? latitude;
  final double? longitude;
  final double radiusM;
  const Gym({
    required this.id,
    required this.name,
    this.latitude,
    this.longitude,
    required this.radiusM,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || latitude != null) {
      map['latitude'] = Variable<double>(latitude);
    }
    if (!nullToAbsent || longitude != null) {
      map['longitude'] = Variable<double>(longitude);
    }
    map['radius_m'] = Variable<double>(radiusM);
    return map;
  }

  GymsCompanion toCompanion(bool nullToAbsent) {
    return GymsCompanion(
      id: Value(id),
      name: Value(name),
      latitude: latitude == null && nullToAbsent
          ? const Value.absent()
          : Value(latitude),
      longitude: longitude == null && nullToAbsent
          ? const Value.absent()
          : Value(longitude),
      radiusM: Value(radiusM),
    );
  }

  factory Gym.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Gym(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      latitude: serializer.fromJson<double?>(json['latitude']),
      longitude: serializer.fromJson<double?>(json['longitude']),
      radiusM: serializer.fromJson<double>(json['radiusM']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'latitude': serializer.toJson<double?>(latitude),
      'longitude': serializer.toJson<double?>(longitude),
      'radiusM': serializer.toJson<double>(radiusM),
    };
  }

  Gym copyWith({
    int? id,
    String? name,
    Value<double?> latitude = const Value.absent(),
    Value<double?> longitude = const Value.absent(),
    double? radiusM,
  }) => Gym(
    id: id ?? this.id,
    name: name ?? this.name,
    latitude: latitude.present ? latitude.value : this.latitude,
    longitude: longitude.present ? longitude.value : this.longitude,
    radiusM: radiusM ?? this.radiusM,
  );
  Gym copyWithCompanion(GymsCompanion data) {
    return Gym(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      latitude: data.latitude.present ? data.latitude.value : this.latitude,
      longitude: data.longitude.present ? data.longitude.value : this.longitude,
      radiusM: data.radiusM.present ? data.radiusM.value : this.radiusM,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Gym(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('latitude: $latitude, ')
          ..write('longitude: $longitude, ')
          ..write('radiusM: $radiusM')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, latitude, longitude, radiusM);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Gym &&
          other.id == this.id &&
          other.name == this.name &&
          other.latitude == this.latitude &&
          other.longitude == this.longitude &&
          other.radiusM == this.radiusM);
}

class GymsCompanion extends UpdateCompanion<Gym> {
  final Value<int> id;
  final Value<String> name;
  final Value<double?> latitude;
  final Value<double?> longitude;
  final Value<double> radiusM;
  const GymsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.latitude = const Value.absent(),
    this.longitude = const Value.absent(),
    this.radiusM = const Value.absent(),
  });
  GymsCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    this.latitude = const Value.absent(),
    this.longitude = const Value.absent(),
    this.radiusM = const Value.absent(),
  }) : name = Value(name);
  static Insertable<Gym> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<double>? latitude,
    Expression<double>? longitude,
    Expression<double>? radiusM,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (latitude != null) 'latitude': latitude,
      if (longitude != null) 'longitude': longitude,
      if (radiusM != null) 'radius_m': radiusM,
    });
  }

  GymsCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<double?>? latitude,
    Value<double?>? longitude,
    Value<double>? radiusM,
  }) {
    return GymsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      radiusM: radiusM ?? this.radiusM,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (latitude.present) {
      map['latitude'] = Variable<double>(latitude.value);
    }
    if (longitude.present) {
      map['longitude'] = Variable<double>(longitude.value);
    }
    if (radiusM.present) {
      map['radius_m'] = Variable<double>(radiusM.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('GymsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('latitude: $latitude, ')
          ..write('longitude: $longitude, ')
          ..write('radiusM: $radiusM')
          ..write(')'))
        .toString();
  }
}

class $GymEquipmentsTable extends GymEquipments
    with TableInfo<$GymEquipmentsTable, GymEquipment> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $GymEquipmentsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _gymIdMeta = const VerificationMeta('gymId');
  @override
  late final GeneratedColumn<int> gymId = GeneratedColumn<int>(
    'gym_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES gyms (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _equipmentIdMeta = const VerificationMeta(
    'equipmentId',
  );
  @override
  late final GeneratedColumn<int> equipmentId = GeneratedColumn<int>(
    'equipment_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES equipments (id) ON DELETE CASCADE',
    ),
  );
  @override
  List<GeneratedColumn> get $columns => [gymId, equipmentId];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'gym_equipments';
  @override
  VerificationContext validateIntegrity(
    Insertable<GymEquipment> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('gym_id')) {
      context.handle(
        _gymIdMeta,
        gymId.isAcceptableOrUnknown(data['gym_id']!, _gymIdMeta),
      );
    } else if (isInserting) {
      context.missing(_gymIdMeta);
    }
    if (data.containsKey('equipment_id')) {
      context.handle(
        _equipmentIdMeta,
        equipmentId.isAcceptableOrUnknown(
          data['equipment_id']!,
          _equipmentIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_equipmentIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {gymId, equipmentId};
  @override
  GymEquipment map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return GymEquipment(
      gymId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}gym_id'],
      )!,
      equipmentId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}equipment_id'],
      )!,
    );
  }

  @override
  $GymEquipmentsTable createAlias(String alias) {
    return $GymEquipmentsTable(attachedDatabase, alias);
  }
}

class GymEquipment extends DataClass implements Insertable<GymEquipment> {
  final int gymId;
  final int equipmentId;
  const GymEquipment({required this.gymId, required this.equipmentId});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['gym_id'] = Variable<int>(gymId);
    map['equipment_id'] = Variable<int>(equipmentId);
    return map;
  }

  GymEquipmentsCompanion toCompanion(bool nullToAbsent) {
    return GymEquipmentsCompanion(
      gymId: Value(gymId),
      equipmentId: Value(equipmentId),
    );
  }

  factory GymEquipment.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return GymEquipment(
      gymId: serializer.fromJson<int>(json['gymId']),
      equipmentId: serializer.fromJson<int>(json['equipmentId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'gymId': serializer.toJson<int>(gymId),
      'equipmentId': serializer.toJson<int>(equipmentId),
    };
  }

  GymEquipment copyWith({int? gymId, int? equipmentId}) => GymEquipment(
    gymId: gymId ?? this.gymId,
    equipmentId: equipmentId ?? this.equipmentId,
  );
  GymEquipment copyWithCompanion(GymEquipmentsCompanion data) {
    return GymEquipment(
      gymId: data.gymId.present ? data.gymId.value : this.gymId,
      equipmentId: data.equipmentId.present
          ? data.equipmentId.value
          : this.equipmentId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('GymEquipment(')
          ..write('gymId: $gymId, ')
          ..write('equipmentId: $equipmentId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(gymId, equipmentId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is GymEquipment &&
          other.gymId == this.gymId &&
          other.equipmentId == this.equipmentId);
}

class GymEquipmentsCompanion extends UpdateCompanion<GymEquipment> {
  final Value<int> gymId;
  final Value<int> equipmentId;
  final Value<int> rowid;
  const GymEquipmentsCompanion({
    this.gymId = const Value.absent(),
    this.equipmentId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  GymEquipmentsCompanion.insert({
    required int gymId,
    required int equipmentId,
    this.rowid = const Value.absent(),
  }) : gymId = Value(gymId),
       equipmentId = Value(equipmentId);
  static Insertable<GymEquipment> custom({
    Expression<int>? gymId,
    Expression<int>? equipmentId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (gymId != null) 'gym_id': gymId,
      if (equipmentId != null) 'equipment_id': equipmentId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  GymEquipmentsCompanion copyWith({
    Value<int>? gymId,
    Value<int>? equipmentId,
    Value<int>? rowid,
  }) {
    return GymEquipmentsCompanion(
      gymId: gymId ?? this.gymId,
      equipmentId: equipmentId ?? this.equipmentId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (gymId.present) {
      map['gym_id'] = Variable<int>(gymId.value);
    }
    if (equipmentId.present) {
      map['equipment_id'] = Variable<int>(equipmentId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('GymEquipmentsCompanion(')
          ..write('gymId: $gymId, ')
          ..write('equipmentId: $equipmentId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $WorkoutsTable extends Workouts with TableInfo<$WorkoutsTable, Workout> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $WorkoutsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _startedAtMeta = const VerificationMeta(
    'startedAt',
  );
  @override
  late final GeneratedColumn<DateTime> startedAt = GeneratedColumn<DateTime>(
    'started_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _endedAtMeta = const VerificationMeta(
    'endedAt',
  );
  @override
  late final GeneratedColumn<DateTime> endedAt = GeneratedColumn<DateTime>(
    'ended_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _gymIdMeta = const VerificationMeta('gymId');
  @override
  late final GeneratedColumn<int> gymId = GeneratedColumn<int>(
    'gym_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES gyms (id) ON DELETE SET NULL',
    ),
  );
  static const VerificationMeta _restCustomSecMeta = const VerificationMeta(
    'restCustomSec',
  );
  @override
  late final GeneratedColumn<int> restCustomSec = GeneratedColumn<int>(
    'rest_custom_sec',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _restEndsAtMeta = const VerificationMeta(
    'restEndsAt',
  );
  @override
  late final GeneratedColumn<DateTime> restEndsAt = GeneratedColumn<DateTime>(
    'rest_ends_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _timerEndsAtMeta = const VerificationMeta(
    'timerEndsAt',
  );
  @override
  late final GeneratedColumn<DateTime> timerEndsAt = GeneratedColumn<DateTime>(
    'timer_ends_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  late final GeneratedColumnWithTypeConverter<Effort?, String> effort =
      GeneratedColumn<String>(
        'effort',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      ).withConverter<Effort?>($WorkoutsTable.$convertereffortn);
  @override
  List<GeneratedColumn> get $columns => [
    id,
    startedAt,
    endedAt,
    gymId,
    restCustomSec,
    restEndsAt,
    timerEndsAt,
    effort,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'workouts';
  @override
  VerificationContext validateIntegrity(
    Insertable<Workout> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('started_at')) {
      context.handle(
        _startedAtMeta,
        startedAt.isAcceptableOrUnknown(data['started_at']!, _startedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_startedAtMeta);
    }
    if (data.containsKey('ended_at')) {
      context.handle(
        _endedAtMeta,
        endedAt.isAcceptableOrUnknown(data['ended_at']!, _endedAtMeta),
      );
    }
    if (data.containsKey('gym_id')) {
      context.handle(
        _gymIdMeta,
        gymId.isAcceptableOrUnknown(data['gym_id']!, _gymIdMeta),
      );
    }
    if (data.containsKey('rest_custom_sec')) {
      context.handle(
        _restCustomSecMeta,
        restCustomSec.isAcceptableOrUnknown(
          data['rest_custom_sec']!,
          _restCustomSecMeta,
        ),
      );
    }
    if (data.containsKey('rest_ends_at')) {
      context.handle(
        _restEndsAtMeta,
        restEndsAt.isAcceptableOrUnknown(
          data['rest_ends_at']!,
          _restEndsAtMeta,
        ),
      );
    }
    if (data.containsKey('timer_ends_at')) {
      context.handle(
        _timerEndsAtMeta,
        timerEndsAt.isAcceptableOrUnknown(
          data['timer_ends_at']!,
          _timerEndsAtMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Workout map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Workout(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      startedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}started_at'],
      )!,
      endedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}ended_at'],
      ),
      gymId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}gym_id'],
      ),
      restCustomSec: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}rest_custom_sec'],
      ),
      restEndsAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}rest_ends_at'],
      ),
      timerEndsAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}timer_ends_at'],
      ),
      effort: $WorkoutsTable.$convertereffortn.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}effort'],
        ),
      ),
    );
  }

  @override
  $WorkoutsTable createAlias(String alias) {
    return $WorkoutsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<Effort, String, String> $convertereffort =
      const EnumNameConverter<Effort>(Effort.values);
  static JsonTypeConverter2<Effort?, String?, String?> $convertereffortn =
      JsonTypeConverter2.asNullable($convertereffort);
}

class Workout extends DataClass implements Insertable<Workout> {
  final int id;
  final DateTime startedAt;
  final DateTime? endedAt;
  final int? gymId;

  /// Descanso manual, em segundos; `null` = descanso inteligente (`smartRestSec`).
  final int? restCustomSec;

  /// Fim do descanso em andamento; persistido para sobreviver ao app em segundo plano.
  final DateTime? restEndsAt;

  /// Fim da contagem do exercício por tempo em andamento; `null` = parada.
  final DateTime? timerEndsAt;

  /// Percepção de esforço informada na conclusão; `null` = não informada.
  final Effort? effort;
  const Workout({
    required this.id,
    required this.startedAt,
    this.endedAt,
    this.gymId,
    this.restCustomSec,
    this.restEndsAt,
    this.timerEndsAt,
    this.effort,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['started_at'] = Variable<DateTime>(startedAt);
    if (!nullToAbsent || endedAt != null) {
      map['ended_at'] = Variable<DateTime>(endedAt);
    }
    if (!nullToAbsent || gymId != null) {
      map['gym_id'] = Variable<int>(gymId);
    }
    if (!nullToAbsent || restCustomSec != null) {
      map['rest_custom_sec'] = Variable<int>(restCustomSec);
    }
    if (!nullToAbsent || restEndsAt != null) {
      map['rest_ends_at'] = Variable<DateTime>(restEndsAt);
    }
    if (!nullToAbsent || timerEndsAt != null) {
      map['timer_ends_at'] = Variable<DateTime>(timerEndsAt);
    }
    if (!nullToAbsent || effort != null) {
      map['effort'] = Variable<String>(
        $WorkoutsTable.$convertereffortn.toSql(effort),
      );
    }
    return map;
  }

  WorkoutsCompanion toCompanion(bool nullToAbsent) {
    return WorkoutsCompanion(
      id: Value(id),
      startedAt: Value(startedAt),
      endedAt: endedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(endedAt),
      gymId: gymId == null && nullToAbsent
          ? const Value.absent()
          : Value(gymId),
      restCustomSec: restCustomSec == null && nullToAbsent
          ? const Value.absent()
          : Value(restCustomSec),
      restEndsAt: restEndsAt == null && nullToAbsent
          ? const Value.absent()
          : Value(restEndsAt),
      timerEndsAt: timerEndsAt == null && nullToAbsent
          ? const Value.absent()
          : Value(timerEndsAt),
      effort: effort == null && nullToAbsent
          ? const Value.absent()
          : Value(effort),
    );
  }

  factory Workout.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Workout(
      id: serializer.fromJson<int>(json['id']),
      startedAt: serializer.fromJson<DateTime>(json['startedAt']),
      endedAt: serializer.fromJson<DateTime?>(json['endedAt']),
      gymId: serializer.fromJson<int?>(json['gymId']),
      restCustomSec: serializer.fromJson<int?>(json['restCustomSec']),
      restEndsAt: serializer.fromJson<DateTime?>(json['restEndsAt']),
      timerEndsAt: serializer.fromJson<DateTime?>(json['timerEndsAt']),
      effort: $WorkoutsTable.$convertereffortn.fromJson(
        serializer.fromJson<String?>(json['effort']),
      ),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'startedAt': serializer.toJson<DateTime>(startedAt),
      'endedAt': serializer.toJson<DateTime?>(endedAt),
      'gymId': serializer.toJson<int?>(gymId),
      'restCustomSec': serializer.toJson<int?>(restCustomSec),
      'restEndsAt': serializer.toJson<DateTime?>(restEndsAt),
      'timerEndsAt': serializer.toJson<DateTime?>(timerEndsAt),
      'effort': serializer.toJson<String?>(
        $WorkoutsTable.$convertereffortn.toJson(effort),
      ),
    };
  }

  Workout copyWith({
    int? id,
    DateTime? startedAt,
    Value<DateTime?> endedAt = const Value.absent(),
    Value<int?> gymId = const Value.absent(),
    Value<int?> restCustomSec = const Value.absent(),
    Value<DateTime?> restEndsAt = const Value.absent(),
    Value<DateTime?> timerEndsAt = const Value.absent(),
    Value<Effort?> effort = const Value.absent(),
  }) => Workout(
    id: id ?? this.id,
    startedAt: startedAt ?? this.startedAt,
    endedAt: endedAt.present ? endedAt.value : this.endedAt,
    gymId: gymId.present ? gymId.value : this.gymId,
    restCustomSec: restCustomSec.present
        ? restCustomSec.value
        : this.restCustomSec,
    restEndsAt: restEndsAt.present ? restEndsAt.value : this.restEndsAt,
    timerEndsAt: timerEndsAt.present ? timerEndsAt.value : this.timerEndsAt,
    effort: effort.present ? effort.value : this.effort,
  );
  Workout copyWithCompanion(WorkoutsCompanion data) {
    return Workout(
      id: data.id.present ? data.id.value : this.id,
      startedAt: data.startedAt.present ? data.startedAt.value : this.startedAt,
      endedAt: data.endedAt.present ? data.endedAt.value : this.endedAt,
      gymId: data.gymId.present ? data.gymId.value : this.gymId,
      restCustomSec: data.restCustomSec.present
          ? data.restCustomSec.value
          : this.restCustomSec,
      restEndsAt: data.restEndsAt.present
          ? data.restEndsAt.value
          : this.restEndsAt,
      timerEndsAt: data.timerEndsAt.present
          ? data.timerEndsAt.value
          : this.timerEndsAt,
      effort: data.effort.present ? data.effort.value : this.effort,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Workout(')
          ..write('id: $id, ')
          ..write('startedAt: $startedAt, ')
          ..write('endedAt: $endedAt, ')
          ..write('gymId: $gymId, ')
          ..write('restCustomSec: $restCustomSec, ')
          ..write('restEndsAt: $restEndsAt, ')
          ..write('timerEndsAt: $timerEndsAt, ')
          ..write('effort: $effort')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    startedAt,
    endedAt,
    gymId,
    restCustomSec,
    restEndsAt,
    timerEndsAt,
    effort,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Workout &&
          other.id == this.id &&
          other.startedAt == this.startedAt &&
          other.endedAt == this.endedAt &&
          other.gymId == this.gymId &&
          other.restCustomSec == this.restCustomSec &&
          other.restEndsAt == this.restEndsAt &&
          other.timerEndsAt == this.timerEndsAt &&
          other.effort == this.effort);
}

class WorkoutsCompanion extends UpdateCompanion<Workout> {
  final Value<int> id;
  final Value<DateTime> startedAt;
  final Value<DateTime?> endedAt;
  final Value<int?> gymId;
  final Value<int?> restCustomSec;
  final Value<DateTime?> restEndsAt;
  final Value<DateTime?> timerEndsAt;
  final Value<Effort?> effort;
  const WorkoutsCompanion({
    this.id = const Value.absent(),
    this.startedAt = const Value.absent(),
    this.endedAt = const Value.absent(),
    this.gymId = const Value.absent(),
    this.restCustomSec = const Value.absent(),
    this.restEndsAt = const Value.absent(),
    this.timerEndsAt = const Value.absent(),
    this.effort = const Value.absent(),
  });
  WorkoutsCompanion.insert({
    this.id = const Value.absent(),
    required DateTime startedAt,
    this.endedAt = const Value.absent(),
    this.gymId = const Value.absent(),
    this.restCustomSec = const Value.absent(),
    this.restEndsAt = const Value.absent(),
    this.timerEndsAt = const Value.absent(),
    this.effort = const Value.absent(),
  }) : startedAt = Value(startedAt);
  static Insertable<Workout> custom({
    Expression<int>? id,
    Expression<DateTime>? startedAt,
    Expression<DateTime>? endedAt,
    Expression<int>? gymId,
    Expression<int>? restCustomSec,
    Expression<DateTime>? restEndsAt,
    Expression<DateTime>? timerEndsAt,
    Expression<String>? effort,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (startedAt != null) 'started_at': startedAt,
      if (endedAt != null) 'ended_at': endedAt,
      if (gymId != null) 'gym_id': gymId,
      if (restCustomSec != null) 'rest_custom_sec': restCustomSec,
      if (restEndsAt != null) 'rest_ends_at': restEndsAt,
      if (timerEndsAt != null) 'timer_ends_at': timerEndsAt,
      if (effort != null) 'effort': effort,
    });
  }

  WorkoutsCompanion copyWith({
    Value<int>? id,
    Value<DateTime>? startedAt,
    Value<DateTime?>? endedAt,
    Value<int?>? gymId,
    Value<int?>? restCustomSec,
    Value<DateTime?>? restEndsAt,
    Value<DateTime?>? timerEndsAt,
    Value<Effort?>? effort,
  }) {
    return WorkoutsCompanion(
      id: id ?? this.id,
      startedAt: startedAt ?? this.startedAt,
      endedAt: endedAt ?? this.endedAt,
      gymId: gymId ?? this.gymId,
      restCustomSec: restCustomSec ?? this.restCustomSec,
      restEndsAt: restEndsAt ?? this.restEndsAt,
      timerEndsAt: timerEndsAt ?? this.timerEndsAt,
      effort: effort ?? this.effort,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (startedAt.present) {
      map['started_at'] = Variable<DateTime>(startedAt.value);
    }
    if (endedAt.present) {
      map['ended_at'] = Variable<DateTime>(endedAt.value);
    }
    if (gymId.present) {
      map['gym_id'] = Variable<int>(gymId.value);
    }
    if (restCustomSec.present) {
      map['rest_custom_sec'] = Variable<int>(restCustomSec.value);
    }
    if (restEndsAt.present) {
      map['rest_ends_at'] = Variable<DateTime>(restEndsAt.value);
    }
    if (timerEndsAt.present) {
      map['timer_ends_at'] = Variable<DateTime>(timerEndsAt.value);
    }
    if (effort.present) {
      map['effort'] = Variable<String>(
        $WorkoutsTable.$convertereffortn.toSql(effort.value),
      );
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('WorkoutsCompanion(')
          ..write('id: $id, ')
          ..write('startedAt: $startedAt, ')
          ..write('endedAt: $endedAt, ')
          ..write('gymId: $gymId, ')
          ..write('restCustomSec: $restCustomSec, ')
          ..write('restEndsAt: $restEndsAt, ')
          ..write('timerEndsAt: $timerEndsAt, ')
          ..write('effort: $effort')
          ..write(')'))
        .toString();
  }
}

class $WorkoutExercisesTable extends WorkoutExercises
    with TableInfo<$WorkoutExercisesTable, WorkoutExercise> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $WorkoutExercisesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _workoutIdMeta = const VerificationMeta(
    'workoutId',
  );
  @override
  late final GeneratedColumn<int> workoutId = GeneratedColumn<int>(
    'workout_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES workouts (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _exerciseIdMeta = const VerificationMeta(
    'exerciseId',
  );
  @override
  late final GeneratedColumn<int> exerciseId = GeneratedColumn<int>(
    'exercise_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES exercises (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _positionMeta = const VerificationMeta(
    'position',
  );
  @override
  late final GeneratedColumn<int> position = GeneratedColumn<int>(
    'position',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _targetSetsMeta = const VerificationMeta(
    'targetSets',
  );
  @override
  late final GeneratedColumn<int> targetSets = GeneratedColumn<int>(
    'target_sets',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(3),
  );
  @override
  late final GeneratedColumnWithTypeConverter<TrackingMode, String> mode =
      GeneratedColumn<String>(
        'mode',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultValue: Constant(TrackingMode.reps.name),
      ).withConverter<TrackingMode>($WorkoutExercisesTable.$convertermode);
  static const VerificationMeta _targetRepsMeta = const VerificationMeta(
    'targetReps',
  );
  @override
  late final GeneratedColumn<int> targetReps = GeneratedColumn<int>(
    'target_reps',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(12),
  );
  static const VerificationMeta _targetSecondsMeta = const VerificationMeta(
    'targetSeconds',
  );
  @override
  late final GeneratedColumn<int> targetSeconds = GeneratedColumn<int>(
    'target_seconds',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(30),
  );
  static const VerificationMeta _targetWeightKgMeta = const VerificationMeta(
    'targetWeightKg',
  );
  @override
  late final GeneratedColumn<double> targetWeightKg = GeneratedColumn<double>(
    'target_weight_kg',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _doneMeta = const VerificationMeta('done');
  @override
  late final GeneratedColumn<bool> done = GeneratedColumn<bool>(
    'done',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("done" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    workoutId,
    exerciseId,
    position,
    targetSets,
    mode,
    targetReps,
    targetSeconds,
    targetWeightKg,
    done,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'workout_exercises';
  @override
  VerificationContext validateIntegrity(
    Insertable<WorkoutExercise> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('workout_id')) {
      context.handle(
        _workoutIdMeta,
        workoutId.isAcceptableOrUnknown(data['workout_id']!, _workoutIdMeta),
      );
    } else if (isInserting) {
      context.missing(_workoutIdMeta);
    }
    if (data.containsKey('exercise_id')) {
      context.handle(
        _exerciseIdMeta,
        exerciseId.isAcceptableOrUnknown(data['exercise_id']!, _exerciseIdMeta),
      );
    } else if (isInserting) {
      context.missing(_exerciseIdMeta);
    }
    if (data.containsKey('position')) {
      context.handle(
        _positionMeta,
        position.isAcceptableOrUnknown(data['position']!, _positionMeta),
      );
    } else if (isInserting) {
      context.missing(_positionMeta);
    }
    if (data.containsKey('target_sets')) {
      context.handle(
        _targetSetsMeta,
        targetSets.isAcceptableOrUnknown(data['target_sets']!, _targetSetsMeta),
      );
    }
    if (data.containsKey('target_reps')) {
      context.handle(
        _targetRepsMeta,
        targetReps.isAcceptableOrUnknown(data['target_reps']!, _targetRepsMeta),
      );
    }
    if (data.containsKey('target_seconds')) {
      context.handle(
        _targetSecondsMeta,
        targetSeconds.isAcceptableOrUnknown(
          data['target_seconds']!,
          _targetSecondsMeta,
        ),
      );
    }
    if (data.containsKey('target_weight_kg')) {
      context.handle(
        _targetWeightKgMeta,
        targetWeightKg.isAcceptableOrUnknown(
          data['target_weight_kg']!,
          _targetWeightKgMeta,
        ),
      );
    }
    if (data.containsKey('done')) {
      context.handle(
        _doneMeta,
        done.isAcceptableOrUnknown(data['done']!, _doneMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  WorkoutExercise map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return WorkoutExercise(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      workoutId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}workout_id'],
      )!,
      exerciseId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}exercise_id'],
      )!,
      position: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}position'],
      )!,
      targetSets: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}target_sets'],
      )!,
      mode: $WorkoutExercisesTable.$convertermode.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}mode'],
        )!,
      ),
      targetReps: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}target_reps'],
      )!,
      targetSeconds: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}target_seconds'],
      )!,
      targetWeightKg: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}target_weight_kg'],
      )!,
      done: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}done'],
      )!,
    );
  }

  @override
  $WorkoutExercisesTable createAlias(String alias) {
    return $WorkoutExercisesTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<TrackingMode, String, String> $convertermode =
      const EnumNameConverter<TrackingMode>(TrackingMode.values);
}

class WorkoutExercise extends DataClass implements Insertable<WorkoutExercise> {
  final int id;
  final int workoutId;
  final int exerciseId;
  final int position;
  final int targetSets;

  /// Metas da próxima série: o modo decide se vale [targetReps] ou [targetSeconds].
  final TrackingMode mode;
  final int targetReps;
  final int targetSeconds;
  final double targetWeightKg;
  final bool done;
  const WorkoutExercise({
    required this.id,
    required this.workoutId,
    required this.exerciseId,
    required this.position,
    required this.targetSets,
    required this.mode,
    required this.targetReps,
    required this.targetSeconds,
    required this.targetWeightKg,
    required this.done,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['workout_id'] = Variable<int>(workoutId);
    map['exercise_id'] = Variable<int>(exerciseId);
    map['position'] = Variable<int>(position);
    map['target_sets'] = Variable<int>(targetSets);
    {
      map['mode'] = Variable<String>(
        $WorkoutExercisesTable.$convertermode.toSql(mode),
      );
    }
    map['target_reps'] = Variable<int>(targetReps);
    map['target_seconds'] = Variable<int>(targetSeconds);
    map['target_weight_kg'] = Variable<double>(targetWeightKg);
    map['done'] = Variable<bool>(done);
    return map;
  }

  WorkoutExercisesCompanion toCompanion(bool nullToAbsent) {
    return WorkoutExercisesCompanion(
      id: Value(id),
      workoutId: Value(workoutId),
      exerciseId: Value(exerciseId),
      position: Value(position),
      targetSets: Value(targetSets),
      mode: Value(mode),
      targetReps: Value(targetReps),
      targetSeconds: Value(targetSeconds),
      targetWeightKg: Value(targetWeightKg),
      done: Value(done),
    );
  }

  factory WorkoutExercise.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return WorkoutExercise(
      id: serializer.fromJson<int>(json['id']),
      workoutId: serializer.fromJson<int>(json['workoutId']),
      exerciseId: serializer.fromJson<int>(json['exerciseId']),
      position: serializer.fromJson<int>(json['position']),
      targetSets: serializer.fromJson<int>(json['targetSets']),
      mode: $WorkoutExercisesTable.$convertermode.fromJson(
        serializer.fromJson<String>(json['mode']),
      ),
      targetReps: serializer.fromJson<int>(json['targetReps']),
      targetSeconds: serializer.fromJson<int>(json['targetSeconds']),
      targetWeightKg: serializer.fromJson<double>(json['targetWeightKg']),
      done: serializer.fromJson<bool>(json['done']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'workoutId': serializer.toJson<int>(workoutId),
      'exerciseId': serializer.toJson<int>(exerciseId),
      'position': serializer.toJson<int>(position),
      'targetSets': serializer.toJson<int>(targetSets),
      'mode': serializer.toJson<String>(
        $WorkoutExercisesTable.$convertermode.toJson(mode),
      ),
      'targetReps': serializer.toJson<int>(targetReps),
      'targetSeconds': serializer.toJson<int>(targetSeconds),
      'targetWeightKg': serializer.toJson<double>(targetWeightKg),
      'done': serializer.toJson<bool>(done),
    };
  }

  WorkoutExercise copyWith({
    int? id,
    int? workoutId,
    int? exerciseId,
    int? position,
    int? targetSets,
    TrackingMode? mode,
    int? targetReps,
    int? targetSeconds,
    double? targetWeightKg,
    bool? done,
  }) => WorkoutExercise(
    id: id ?? this.id,
    workoutId: workoutId ?? this.workoutId,
    exerciseId: exerciseId ?? this.exerciseId,
    position: position ?? this.position,
    targetSets: targetSets ?? this.targetSets,
    mode: mode ?? this.mode,
    targetReps: targetReps ?? this.targetReps,
    targetSeconds: targetSeconds ?? this.targetSeconds,
    targetWeightKg: targetWeightKg ?? this.targetWeightKg,
    done: done ?? this.done,
  );
  WorkoutExercise copyWithCompanion(WorkoutExercisesCompanion data) {
    return WorkoutExercise(
      id: data.id.present ? data.id.value : this.id,
      workoutId: data.workoutId.present ? data.workoutId.value : this.workoutId,
      exerciseId: data.exerciseId.present
          ? data.exerciseId.value
          : this.exerciseId,
      position: data.position.present ? data.position.value : this.position,
      targetSets: data.targetSets.present
          ? data.targetSets.value
          : this.targetSets,
      mode: data.mode.present ? data.mode.value : this.mode,
      targetReps: data.targetReps.present
          ? data.targetReps.value
          : this.targetReps,
      targetSeconds: data.targetSeconds.present
          ? data.targetSeconds.value
          : this.targetSeconds,
      targetWeightKg: data.targetWeightKg.present
          ? data.targetWeightKg.value
          : this.targetWeightKg,
      done: data.done.present ? data.done.value : this.done,
    );
  }

  @override
  String toString() {
    return (StringBuffer('WorkoutExercise(')
          ..write('id: $id, ')
          ..write('workoutId: $workoutId, ')
          ..write('exerciseId: $exerciseId, ')
          ..write('position: $position, ')
          ..write('targetSets: $targetSets, ')
          ..write('mode: $mode, ')
          ..write('targetReps: $targetReps, ')
          ..write('targetSeconds: $targetSeconds, ')
          ..write('targetWeightKg: $targetWeightKg, ')
          ..write('done: $done')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    workoutId,
    exerciseId,
    position,
    targetSets,
    mode,
    targetReps,
    targetSeconds,
    targetWeightKg,
    done,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is WorkoutExercise &&
          other.id == this.id &&
          other.workoutId == this.workoutId &&
          other.exerciseId == this.exerciseId &&
          other.position == this.position &&
          other.targetSets == this.targetSets &&
          other.mode == this.mode &&
          other.targetReps == this.targetReps &&
          other.targetSeconds == this.targetSeconds &&
          other.targetWeightKg == this.targetWeightKg &&
          other.done == this.done);
}

class WorkoutExercisesCompanion extends UpdateCompanion<WorkoutExercise> {
  final Value<int> id;
  final Value<int> workoutId;
  final Value<int> exerciseId;
  final Value<int> position;
  final Value<int> targetSets;
  final Value<TrackingMode> mode;
  final Value<int> targetReps;
  final Value<int> targetSeconds;
  final Value<double> targetWeightKg;
  final Value<bool> done;
  const WorkoutExercisesCompanion({
    this.id = const Value.absent(),
    this.workoutId = const Value.absent(),
    this.exerciseId = const Value.absent(),
    this.position = const Value.absent(),
    this.targetSets = const Value.absent(),
    this.mode = const Value.absent(),
    this.targetReps = const Value.absent(),
    this.targetSeconds = const Value.absent(),
    this.targetWeightKg = const Value.absent(),
    this.done = const Value.absent(),
  });
  WorkoutExercisesCompanion.insert({
    this.id = const Value.absent(),
    required int workoutId,
    required int exerciseId,
    required int position,
    this.targetSets = const Value.absent(),
    this.mode = const Value.absent(),
    this.targetReps = const Value.absent(),
    this.targetSeconds = const Value.absent(),
    this.targetWeightKg = const Value.absent(),
    this.done = const Value.absent(),
  }) : workoutId = Value(workoutId),
       exerciseId = Value(exerciseId),
       position = Value(position);
  static Insertable<WorkoutExercise> custom({
    Expression<int>? id,
    Expression<int>? workoutId,
    Expression<int>? exerciseId,
    Expression<int>? position,
    Expression<int>? targetSets,
    Expression<String>? mode,
    Expression<int>? targetReps,
    Expression<int>? targetSeconds,
    Expression<double>? targetWeightKg,
    Expression<bool>? done,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (workoutId != null) 'workout_id': workoutId,
      if (exerciseId != null) 'exercise_id': exerciseId,
      if (position != null) 'position': position,
      if (targetSets != null) 'target_sets': targetSets,
      if (mode != null) 'mode': mode,
      if (targetReps != null) 'target_reps': targetReps,
      if (targetSeconds != null) 'target_seconds': targetSeconds,
      if (targetWeightKg != null) 'target_weight_kg': targetWeightKg,
      if (done != null) 'done': done,
    });
  }

  WorkoutExercisesCompanion copyWith({
    Value<int>? id,
    Value<int>? workoutId,
    Value<int>? exerciseId,
    Value<int>? position,
    Value<int>? targetSets,
    Value<TrackingMode>? mode,
    Value<int>? targetReps,
    Value<int>? targetSeconds,
    Value<double>? targetWeightKg,
    Value<bool>? done,
  }) {
    return WorkoutExercisesCompanion(
      id: id ?? this.id,
      workoutId: workoutId ?? this.workoutId,
      exerciseId: exerciseId ?? this.exerciseId,
      position: position ?? this.position,
      targetSets: targetSets ?? this.targetSets,
      mode: mode ?? this.mode,
      targetReps: targetReps ?? this.targetReps,
      targetSeconds: targetSeconds ?? this.targetSeconds,
      targetWeightKg: targetWeightKg ?? this.targetWeightKg,
      done: done ?? this.done,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (workoutId.present) {
      map['workout_id'] = Variable<int>(workoutId.value);
    }
    if (exerciseId.present) {
      map['exercise_id'] = Variable<int>(exerciseId.value);
    }
    if (position.present) {
      map['position'] = Variable<int>(position.value);
    }
    if (targetSets.present) {
      map['target_sets'] = Variable<int>(targetSets.value);
    }
    if (mode.present) {
      map['mode'] = Variable<String>(
        $WorkoutExercisesTable.$convertermode.toSql(mode.value),
      );
    }
    if (targetReps.present) {
      map['target_reps'] = Variable<int>(targetReps.value);
    }
    if (targetSeconds.present) {
      map['target_seconds'] = Variable<int>(targetSeconds.value);
    }
    if (targetWeightKg.present) {
      map['target_weight_kg'] = Variable<double>(targetWeightKg.value);
    }
    if (done.present) {
      map['done'] = Variable<bool>(done.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('WorkoutExercisesCompanion(')
          ..write('id: $id, ')
          ..write('workoutId: $workoutId, ')
          ..write('exerciseId: $exerciseId, ')
          ..write('position: $position, ')
          ..write('targetSets: $targetSets, ')
          ..write('mode: $mode, ')
          ..write('targetReps: $targetReps, ')
          ..write('targetSeconds: $targetSeconds, ')
          ..write('targetWeightKg: $targetWeightKg, ')
          ..write('done: $done')
          ..write(')'))
        .toString();
  }
}

class $WorkoutSetsTable extends WorkoutSets
    with TableInfo<$WorkoutSetsTable, WorkoutSet> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $WorkoutSetsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _workoutExerciseIdMeta = const VerificationMeta(
    'workoutExerciseId',
  );
  @override
  late final GeneratedColumn<int> workoutExerciseId = GeneratedColumn<int>(
    'workout_exercise_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES workout_exercises (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _weightKgMeta = const VerificationMeta(
    'weightKg',
  );
  @override
  late final GeneratedColumn<double> weightKg = GeneratedColumn<double>(
    'weight_kg',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _repsMeta = const VerificationMeta('reps');
  @override
  late final GeneratedColumn<int> reps = GeneratedColumn<int>(
    'reps',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _durationSecMeta = const VerificationMeta(
    'durationSec',
  );
  @override
  late final GeneratedColumn<int> durationSec = GeneratedColumn<int>(
    'duration_sec',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _doneAtMeta = const VerificationMeta('doneAt');
  @override
  late final GeneratedColumn<DateTime> doneAt = GeneratedColumn<DateTime>(
    'done_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    workoutExerciseId,
    weightKg,
    reps,
    durationSec,
    doneAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'workout_sets';
  @override
  VerificationContext validateIntegrity(
    Insertable<WorkoutSet> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('workout_exercise_id')) {
      context.handle(
        _workoutExerciseIdMeta,
        workoutExerciseId.isAcceptableOrUnknown(
          data['workout_exercise_id']!,
          _workoutExerciseIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_workoutExerciseIdMeta);
    }
    if (data.containsKey('weight_kg')) {
      context.handle(
        _weightKgMeta,
        weightKg.isAcceptableOrUnknown(data['weight_kg']!, _weightKgMeta),
      );
    } else if (isInserting) {
      context.missing(_weightKgMeta);
    }
    if (data.containsKey('reps')) {
      context.handle(
        _repsMeta,
        reps.isAcceptableOrUnknown(data['reps']!, _repsMeta),
      );
    }
    if (data.containsKey('duration_sec')) {
      context.handle(
        _durationSecMeta,
        durationSec.isAcceptableOrUnknown(
          data['duration_sec']!,
          _durationSecMeta,
        ),
      );
    }
    if (data.containsKey('done_at')) {
      context.handle(
        _doneAtMeta,
        doneAt.isAcceptableOrUnknown(data['done_at']!, _doneAtMeta),
      );
    } else if (isInserting) {
      context.missing(_doneAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  WorkoutSet map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return WorkoutSet(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      workoutExerciseId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}workout_exercise_id'],
      )!,
      weightKg: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}weight_kg'],
      )!,
      reps: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}reps'],
      ),
      durationSec: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}duration_sec'],
      ),
      doneAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}done_at'],
      )!,
    );
  }

  @override
  $WorkoutSetsTable createAlias(String alias) {
    return $WorkoutSetsTable(attachedDatabase, alias);
  }
}

class WorkoutSet extends DataClass implements Insertable<WorkoutSet> {
  final int id;
  final int workoutExerciseId;
  final double weightKg;

  /// Série por repetições preenche [reps]; série por tempo, [durationSec].
  final int? reps;
  final int? durationSec;
  final DateTime doneAt;
  const WorkoutSet({
    required this.id,
    required this.workoutExerciseId,
    required this.weightKg,
    this.reps,
    this.durationSec,
    required this.doneAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['workout_exercise_id'] = Variable<int>(workoutExerciseId);
    map['weight_kg'] = Variable<double>(weightKg);
    if (!nullToAbsent || reps != null) {
      map['reps'] = Variable<int>(reps);
    }
    if (!nullToAbsent || durationSec != null) {
      map['duration_sec'] = Variable<int>(durationSec);
    }
    map['done_at'] = Variable<DateTime>(doneAt);
    return map;
  }

  WorkoutSetsCompanion toCompanion(bool nullToAbsent) {
    return WorkoutSetsCompanion(
      id: Value(id),
      workoutExerciseId: Value(workoutExerciseId),
      weightKg: Value(weightKg),
      reps: reps == null && nullToAbsent ? const Value.absent() : Value(reps),
      durationSec: durationSec == null && nullToAbsent
          ? const Value.absent()
          : Value(durationSec),
      doneAt: Value(doneAt),
    );
  }

  factory WorkoutSet.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return WorkoutSet(
      id: serializer.fromJson<int>(json['id']),
      workoutExerciseId: serializer.fromJson<int>(json['workoutExerciseId']),
      weightKg: serializer.fromJson<double>(json['weightKg']),
      reps: serializer.fromJson<int?>(json['reps']),
      durationSec: serializer.fromJson<int?>(json['durationSec']),
      doneAt: serializer.fromJson<DateTime>(json['doneAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'workoutExerciseId': serializer.toJson<int>(workoutExerciseId),
      'weightKg': serializer.toJson<double>(weightKg),
      'reps': serializer.toJson<int?>(reps),
      'durationSec': serializer.toJson<int?>(durationSec),
      'doneAt': serializer.toJson<DateTime>(doneAt),
    };
  }

  WorkoutSet copyWith({
    int? id,
    int? workoutExerciseId,
    double? weightKg,
    Value<int?> reps = const Value.absent(),
    Value<int?> durationSec = const Value.absent(),
    DateTime? doneAt,
  }) => WorkoutSet(
    id: id ?? this.id,
    workoutExerciseId: workoutExerciseId ?? this.workoutExerciseId,
    weightKg: weightKg ?? this.weightKg,
    reps: reps.present ? reps.value : this.reps,
    durationSec: durationSec.present ? durationSec.value : this.durationSec,
    doneAt: doneAt ?? this.doneAt,
  );
  WorkoutSet copyWithCompanion(WorkoutSetsCompanion data) {
    return WorkoutSet(
      id: data.id.present ? data.id.value : this.id,
      workoutExerciseId: data.workoutExerciseId.present
          ? data.workoutExerciseId.value
          : this.workoutExerciseId,
      weightKg: data.weightKg.present ? data.weightKg.value : this.weightKg,
      reps: data.reps.present ? data.reps.value : this.reps,
      durationSec: data.durationSec.present
          ? data.durationSec.value
          : this.durationSec,
      doneAt: data.doneAt.present ? data.doneAt.value : this.doneAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('WorkoutSet(')
          ..write('id: $id, ')
          ..write('workoutExerciseId: $workoutExerciseId, ')
          ..write('weightKg: $weightKg, ')
          ..write('reps: $reps, ')
          ..write('durationSec: $durationSec, ')
          ..write('doneAt: $doneAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, workoutExerciseId, weightKg, reps, durationSec, doneAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is WorkoutSet &&
          other.id == this.id &&
          other.workoutExerciseId == this.workoutExerciseId &&
          other.weightKg == this.weightKg &&
          other.reps == this.reps &&
          other.durationSec == this.durationSec &&
          other.doneAt == this.doneAt);
}

class WorkoutSetsCompanion extends UpdateCompanion<WorkoutSet> {
  final Value<int> id;
  final Value<int> workoutExerciseId;
  final Value<double> weightKg;
  final Value<int?> reps;
  final Value<int?> durationSec;
  final Value<DateTime> doneAt;
  const WorkoutSetsCompanion({
    this.id = const Value.absent(),
    this.workoutExerciseId = const Value.absent(),
    this.weightKg = const Value.absent(),
    this.reps = const Value.absent(),
    this.durationSec = const Value.absent(),
    this.doneAt = const Value.absent(),
  });
  WorkoutSetsCompanion.insert({
    this.id = const Value.absent(),
    required int workoutExerciseId,
    required double weightKg,
    this.reps = const Value.absent(),
    this.durationSec = const Value.absent(),
    required DateTime doneAt,
  }) : workoutExerciseId = Value(workoutExerciseId),
       weightKg = Value(weightKg),
       doneAt = Value(doneAt);
  static Insertable<WorkoutSet> custom({
    Expression<int>? id,
    Expression<int>? workoutExerciseId,
    Expression<double>? weightKg,
    Expression<int>? reps,
    Expression<int>? durationSec,
    Expression<DateTime>? doneAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (workoutExerciseId != null) 'workout_exercise_id': workoutExerciseId,
      if (weightKg != null) 'weight_kg': weightKg,
      if (reps != null) 'reps': reps,
      if (durationSec != null) 'duration_sec': durationSec,
      if (doneAt != null) 'done_at': doneAt,
    });
  }

  WorkoutSetsCompanion copyWith({
    Value<int>? id,
    Value<int>? workoutExerciseId,
    Value<double>? weightKg,
    Value<int?>? reps,
    Value<int?>? durationSec,
    Value<DateTime>? doneAt,
  }) {
    return WorkoutSetsCompanion(
      id: id ?? this.id,
      workoutExerciseId: workoutExerciseId ?? this.workoutExerciseId,
      weightKg: weightKg ?? this.weightKg,
      reps: reps ?? this.reps,
      durationSec: durationSec ?? this.durationSec,
      doneAt: doneAt ?? this.doneAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (workoutExerciseId.present) {
      map['workout_exercise_id'] = Variable<int>(workoutExerciseId.value);
    }
    if (weightKg.present) {
      map['weight_kg'] = Variable<double>(weightKg.value);
    }
    if (reps.present) {
      map['reps'] = Variable<int>(reps.value);
    }
    if (durationSec.present) {
      map['duration_sec'] = Variable<int>(durationSec.value);
    }
    if (doneAt.present) {
      map['done_at'] = Variable<DateTime>(doneAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('WorkoutSetsCompanion(')
          ..write('id: $id, ')
          ..write('workoutExerciseId: $workoutExerciseId, ')
          ..write('weightKg: $weightKg, ')
          ..write('reps: $reps, ')
          ..write('durationSec: $durationSec, ')
          ..write('doneAt: $doneAt')
          ..write(')'))
        .toString();
  }
}

class $BodyMetricsTable extends BodyMetrics
    with TableInfo<$BodyMetricsTable, BodyMetric> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BodyMetricsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
    'date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _weightKgMeta = const VerificationMeta(
    'weightKg',
  );
  @override
  late final GeneratedColumn<double> weightKg = GeneratedColumn<double>(
    'weight_kg',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _heightCmMeta = const VerificationMeta(
    'heightCm',
  );
  @override
  late final GeneratedColumn<double> heightCm = GeneratedColumn<double>(
    'height_cm',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _bodyFatPctMeta = const VerificationMeta(
    'bodyFatPct',
  );
  @override
  late final GeneratedColumn<double> bodyFatPct = GeneratedColumn<double>(
    'body_fat_pct',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _chestCmMeta = const VerificationMeta(
    'chestCm',
  );
  @override
  late final GeneratedColumn<double> chestCm = GeneratedColumn<double>(
    'chest_cm',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _waistCmMeta = const VerificationMeta(
    'waistCm',
  );
  @override
  late final GeneratedColumn<double> waistCm = GeneratedColumn<double>(
    'waist_cm',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _hipCmMeta = const VerificationMeta('hipCm');
  @override
  late final GeneratedColumn<double> hipCm = GeneratedColumn<double>(
    'hip_cm',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _armCmMeta = const VerificationMeta('armCm');
  @override
  late final GeneratedColumn<double> armCm = GeneratedColumn<double>(
    'arm_cm',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _thighCmMeta = const VerificationMeta(
    'thighCm',
  );
  @override
  late final GeneratedColumn<double> thighCm = GeneratedColumn<double>(
    'thigh_cm',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    date,
    weightKg,
    heightCm,
    bodyFatPct,
    chestCm,
    waistCm,
    hipCm,
    armCm,
    thighCm,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'body_metrics';
  @override
  VerificationContext validateIntegrity(
    Insertable<BodyMetric> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('weight_kg')) {
      context.handle(
        _weightKgMeta,
        weightKg.isAcceptableOrUnknown(data['weight_kg']!, _weightKgMeta),
      );
    }
    if (data.containsKey('height_cm')) {
      context.handle(
        _heightCmMeta,
        heightCm.isAcceptableOrUnknown(data['height_cm']!, _heightCmMeta),
      );
    }
    if (data.containsKey('body_fat_pct')) {
      context.handle(
        _bodyFatPctMeta,
        bodyFatPct.isAcceptableOrUnknown(
          data['body_fat_pct']!,
          _bodyFatPctMeta,
        ),
      );
    }
    if (data.containsKey('chest_cm')) {
      context.handle(
        _chestCmMeta,
        chestCm.isAcceptableOrUnknown(data['chest_cm']!, _chestCmMeta),
      );
    }
    if (data.containsKey('waist_cm')) {
      context.handle(
        _waistCmMeta,
        waistCm.isAcceptableOrUnknown(data['waist_cm']!, _waistCmMeta),
      );
    }
    if (data.containsKey('hip_cm')) {
      context.handle(
        _hipCmMeta,
        hipCm.isAcceptableOrUnknown(data['hip_cm']!, _hipCmMeta),
      );
    }
    if (data.containsKey('arm_cm')) {
      context.handle(
        _armCmMeta,
        armCm.isAcceptableOrUnknown(data['arm_cm']!, _armCmMeta),
      );
    }
    if (data.containsKey('thigh_cm')) {
      context.handle(
        _thighCmMeta,
        thighCm.isAcceptableOrUnknown(data['thigh_cm']!, _thighCmMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  BodyMetric map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return BodyMetric(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      date: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}date'],
      )!,
      weightKg: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}weight_kg'],
      ),
      heightCm: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}height_cm'],
      ),
      bodyFatPct: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}body_fat_pct'],
      ),
      chestCm: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}chest_cm'],
      ),
      waistCm: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}waist_cm'],
      ),
      hipCm: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}hip_cm'],
      ),
      armCm: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}arm_cm'],
      ),
      thighCm: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}thigh_cm'],
      ),
    );
  }

  @override
  $BodyMetricsTable createAlias(String alias) {
    return $BodyMetricsTable(attachedDatabase, alias);
  }
}

class BodyMetric extends DataClass implements Insertable<BodyMetric> {
  final int id;
  final DateTime date;
  final double? weightKg;
  final double? heightCm;
  final double? bodyFatPct;
  final double? chestCm;
  final double? waistCm;
  final double? hipCm;
  final double? armCm;
  final double? thighCm;
  const BodyMetric({
    required this.id,
    required this.date,
    this.weightKg,
    this.heightCm,
    this.bodyFatPct,
    this.chestCm,
    this.waistCm,
    this.hipCm,
    this.armCm,
    this.thighCm,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['date'] = Variable<DateTime>(date);
    if (!nullToAbsent || weightKg != null) {
      map['weight_kg'] = Variable<double>(weightKg);
    }
    if (!nullToAbsent || heightCm != null) {
      map['height_cm'] = Variable<double>(heightCm);
    }
    if (!nullToAbsent || bodyFatPct != null) {
      map['body_fat_pct'] = Variable<double>(bodyFatPct);
    }
    if (!nullToAbsent || chestCm != null) {
      map['chest_cm'] = Variable<double>(chestCm);
    }
    if (!nullToAbsent || waistCm != null) {
      map['waist_cm'] = Variable<double>(waistCm);
    }
    if (!nullToAbsent || hipCm != null) {
      map['hip_cm'] = Variable<double>(hipCm);
    }
    if (!nullToAbsent || armCm != null) {
      map['arm_cm'] = Variable<double>(armCm);
    }
    if (!nullToAbsent || thighCm != null) {
      map['thigh_cm'] = Variable<double>(thighCm);
    }
    return map;
  }

  BodyMetricsCompanion toCompanion(bool nullToAbsent) {
    return BodyMetricsCompanion(
      id: Value(id),
      date: Value(date),
      weightKg: weightKg == null && nullToAbsent
          ? const Value.absent()
          : Value(weightKg),
      heightCm: heightCm == null && nullToAbsent
          ? const Value.absent()
          : Value(heightCm),
      bodyFatPct: bodyFatPct == null && nullToAbsent
          ? const Value.absent()
          : Value(bodyFatPct),
      chestCm: chestCm == null && nullToAbsent
          ? const Value.absent()
          : Value(chestCm),
      waistCm: waistCm == null && nullToAbsent
          ? const Value.absent()
          : Value(waistCm),
      hipCm: hipCm == null && nullToAbsent
          ? const Value.absent()
          : Value(hipCm),
      armCm: armCm == null && nullToAbsent
          ? const Value.absent()
          : Value(armCm),
      thighCm: thighCm == null && nullToAbsent
          ? const Value.absent()
          : Value(thighCm),
    );
  }

  factory BodyMetric.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return BodyMetric(
      id: serializer.fromJson<int>(json['id']),
      date: serializer.fromJson<DateTime>(json['date']),
      weightKg: serializer.fromJson<double?>(json['weightKg']),
      heightCm: serializer.fromJson<double?>(json['heightCm']),
      bodyFatPct: serializer.fromJson<double?>(json['bodyFatPct']),
      chestCm: serializer.fromJson<double?>(json['chestCm']),
      waistCm: serializer.fromJson<double?>(json['waistCm']),
      hipCm: serializer.fromJson<double?>(json['hipCm']),
      armCm: serializer.fromJson<double?>(json['armCm']),
      thighCm: serializer.fromJson<double?>(json['thighCm']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'date': serializer.toJson<DateTime>(date),
      'weightKg': serializer.toJson<double?>(weightKg),
      'heightCm': serializer.toJson<double?>(heightCm),
      'bodyFatPct': serializer.toJson<double?>(bodyFatPct),
      'chestCm': serializer.toJson<double?>(chestCm),
      'waistCm': serializer.toJson<double?>(waistCm),
      'hipCm': serializer.toJson<double?>(hipCm),
      'armCm': serializer.toJson<double?>(armCm),
      'thighCm': serializer.toJson<double?>(thighCm),
    };
  }

  BodyMetric copyWith({
    int? id,
    DateTime? date,
    Value<double?> weightKg = const Value.absent(),
    Value<double?> heightCm = const Value.absent(),
    Value<double?> bodyFatPct = const Value.absent(),
    Value<double?> chestCm = const Value.absent(),
    Value<double?> waistCm = const Value.absent(),
    Value<double?> hipCm = const Value.absent(),
    Value<double?> armCm = const Value.absent(),
    Value<double?> thighCm = const Value.absent(),
  }) => BodyMetric(
    id: id ?? this.id,
    date: date ?? this.date,
    weightKg: weightKg.present ? weightKg.value : this.weightKg,
    heightCm: heightCm.present ? heightCm.value : this.heightCm,
    bodyFatPct: bodyFatPct.present ? bodyFatPct.value : this.bodyFatPct,
    chestCm: chestCm.present ? chestCm.value : this.chestCm,
    waistCm: waistCm.present ? waistCm.value : this.waistCm,
    hipCm: hipCm.present ? hipCm.value : this.hipCm,
    armCm: armCm.present ? armCm.value : this.armCm,
    thighCm: thighCm.present ? thighCm.value : this.thighCm,
  );
  BodyMetric copyWithCompanion(BodyMetricsCompanion data) {
    return BodyMetric(
      id: data.id.present ? data.id.value : this.id,
      date: data.date.present ? data.date.value : this.date,
      weightKg: data.weightKg.present ? data.weightKg.value : this.weightKg,
      heightCm: data.heightCm.present ? data.heightCm.value : this.heightCm,
      bodyFatPct: data.bodyFatPct.present
          ? data.bodyFatPct.value
          : this.bodyFatPct,
      chestCm: data.chestCm.present ? data.chestCm.value : this.chestCm,
      waistCm: data.waistCm.present ? data.waistCm.value : this.waistCm,
      hipCm: data.hipCm.present ? data.hipCm.value : this.hipCm,
      armCm: data.armCm.present ? data.armCm.value : this.armCm,
      thighCm: data.thighCm.present ? data.thighCm.value : this.thighCm,
    );
  }

  @override
  String toString() {
    return (StringBuffer('BodyMetric(')
          ..write('id: $id, ')
          ..write('date: $date, ')
          ..write('weightKg: $weightKg, ')
          ..write('heightCm: $heightCm, ')
          ..write('bodyFatPct: $bodyFatPct, ')
          ..write('chestCm: $chestCm, ')
          ..write('waistCm: $waistCm, ')
          ..write('hipCm: $hipCm, ')
          ..write('armCm: $armCm, ')
          ..write('thighCm: $thighCm')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    date,
    weightKg,
    heightCm,
    bodyFatPct,
    chestCm,
    waistCm,
    hipCm,
    armCm,
    thighCm,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is BodyMetric &&
          other.id == this.id &&
          other.date == this.date &&
          other.weightKg == this.weightKg &&
          other.heightCm == this.heightCm &&
          other.bodyFatPct == this.bodyFatPct &&
          other.chestCm == this.chestCm &&
          other.waistCm == this.waistCm &&
          other.hipCm == this.hipCm &&
          other.armCm == this.armCm &&
          other.thighCm == this.thighCm);
}

class BodyMetricsCompanion extends UpdateCompanion<BodyMetric> {
  final Value<int> id;
  final Value<DateTime> date;
  final Value<double?> weightKg;
  final Value<double?> heightCm;
  final Value<double?> bodyFatPct;
  final Value<double?> chestCm;
  final Value<double?> waistCm;
  final Value<double?> hipCm;
  final Value<double?> armCm;
  final Value<double?> thighCm;
  const BodyMetricsCompanion({
    this.id = const Value.absent(),
    this.date = const Value.absent(),
    this.weightKg = const Value.absent(),
    this.heightCm = const Value.absent(),
    this.bodyFatPct = const Value.absent(),
    this.chestCm = const Value.absent(),
    this.waistCm = const Value.absent(),
    this.hipCm = const Value.absent(),
    this.armCm = const Value.absent(),
    this.thighCm = const Value.absent(),
  });
  BodyMetricsCompanion.insert({
    this.id = const Value.absent(),
    required DateTime date,
    this.weightKg = const Value.absent(),
    this.heightCm = const Value.absent(),
    this.bodyFatPct = const Value.absent(),
    this.chestCm = const Value.absent(),
    this.waistCm = const Value.absent(),
    this.hipCm = const Value.absent(),
    this.armCm = const Value.absent(),
    this.thighCm = const Value.absent(),
  }) : date = Value(date);
  static Insertable<BodyMetric> custom({
    Expression<int>? id,
    Expression<DateTime>? date,
    Expression<double>? weightKg,
    Expression<double>? heightCm,
    Expression<double>? bodyFatPct,
    Expression<double>? chestCm,
    Expression<double>? waistCm,
    Expression<double>? hipCm,
    Expression<double>? armCm,
    Expression<double>? thighCm,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (date != null) 'date': date,
      if (weightKg != null) 'weight_kg': weightKg,
      if (heightCm != null) 'height_cm': heightCm,
      if (bodyFatPct != null) 'body_fat_pct': bodyFatPct,
      if (chestCm != null) 'chest_cm': chestCm,
      if (waistCm != null) 'waist_cm': waistCm,
      if (hipCm != null) 'hip_cm': hipCm,
      if (armCm != null) 'arm_cm': armCm,
      if (thighCm != null) 'thigh_cm': thighCm,
    });
  }

  BodyMetricsCompanion copyWith({
    Value<int>? id,
    Value<DateTime>? date,
    Value<double?>? weightKg,
    Value<double?>? heightCm,
    Value<double?>? bodyFatPct,
    Value<double?>? chestCm,
    Value<double?>? waistCm,
    Value<double?>? hipCm,
    Value<double?>? armCm,
    Value<double?>? thighCm,
  }) {
    return BodyMetricsCompanion(
      id: id ?? this.id,
      date: date ?? this.date,
      weightKg: weightKg ?? this.weightKg,
      heightCm: heightCm ?? this.heightCm,
      bodyFatPct: bodyFatPct ?? this.bodyFatPct,
      chestCm: chestCm ?? this.chestCm,
      waistCm: waistCm ?? this.waistCm,
      hipCm: hipCm ?? this.hipCm,
      armCm: armCm ?? this.armCm,
      thighCm: thighCm ?? this.thighCm,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (weightKg.present) {
      map['weight_kg'] = Variable<double>(weightKg.value);
    }
    if (heightCm.present) {
      map['height_cm'] = Variable<double>(heightCm.value);
    }
    if (bodyFatPct.present) {
      map['body_fat_pct'] = Variable<double>(bodyFatPct.value);
    }
    if (chestCm.present) {
      map['chest_cm'] = Variable<double>(chestCm.value);
    }
    if (waistCm.present) {
      map['waist_cm'] = Variable<double>(waistCm.value);
    }
    if (hipCm.present) {
      map['hip_cm'] = Variable<double>(hipCm.value);
    }
    if (armCm.present) {
      map['arm_cm'] = Variable<double>(armCm.value);
    }
    if (thighCm.present) {
      map['thigh_cm'] = Variable<double>(thighCm.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BodyMetricsCompanion(')
          ..write('id: $id, ')
          ..write('date: $date, ')
          ..write('weightKg: $weightKg, ')
          ..write('heightCm: $heightCm, ')
          ..write('bodyFatPct: $bodyFatPct, ')
          ..write('chestCm: $chestCm, ')
          ..write('waistCm: $waistCm, ')
          ..write('hipCm: $hipCm, ')
          ..write('armCm: $armCm, ')
          ..write('thighCm: $thighCm')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $EquipmentsTable equipments = $EquipmentsTable(this);
  late final $ExercisesTable exercises = $ExercisesTable(this);
  late final $ExerciseEquipmentsTable exerciseEquipments =
      $ExerciseEquipmentsTable(this);
  late final $GymsTable gyms = $GymsTable(this);
  late final $GymEquipmentsTable gymEquipments = $GymEquipmentsTable(this);
  late final $WorkoutsTable workouts = $WorkoutsTable(this);
  late final $WorkoutExercisesTable workoutExercises = $WorkoutExercisesTable(
    this,
  );
  late final $WorkoutSetsTable workoutSets = $WorkoutSetsTable(this);
  late final $BodyMetricsTable bodyMetrics = $BodyMetricsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    equipments,
    exercises,
    exerciseEquipments,
    gyms,
    gymEquipments,
    workouts,
    workoutExercises,
    workoutSets,
    bodyMetrics,
  ];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules([
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'exercises',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('exercise_equipments', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'equipments',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('exercise_equipments', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'gyms',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('gym_equipments', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'equipments',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('gym_equipments', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'gyms',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('workouts', kind: UpdateKind.update)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'workouts',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('workout_exercises', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'exercises',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('workout_exercises', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'workout_exercises',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('workout_sets', kind: UpdateKind.delete)],
    ),
  ]);
}

typedef $$EquipmentsTableCreateCompanionBuilder = EquipmentsCompanion Function({
  Value<int> id,
  required String name,
});
typedef $$EquipmentsTableUpdateCompanionBuilder = EquipmentsCompanion Function({
  Value<int> id,
  Value<String> name,
});

final class $$EquipmentsTableReferences
    extends BaseReferences<_$AppDatabase, $EquipmentsTable, Equipment> {
  $$EquipmentsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$ExerciseEquipmentsTable, List<ExerciseEquipment>>
  _exerciseEquipmentsRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.exerciseEquipments,
        aliasName: 'equipments__id__exercise_equipments__equipment_id',
      );

  $$ExerciseEquipmentsTableProcessedTableManager get exerciseEquipmentsRefs {
    final manager = $$ExerciseEquipmentsTableTableManager(
      $_db,
      $_db.exerciseEquipments,
    ).filter((f) => f.equipmentId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _exerciseEquipmentsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$GymEquipmentsTable, List<GymEquipment>>
  _gymEquipmentsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.gymEquipments,
    aliasName: 'equipments__id__gym_equipments__equipment_id',
  );

  $$GymEquipmentsTableProcessedTableManager get gymEquipmentsRefs {
    final manager = $$GymEquipmentsTableTableManager(
      $_db,
      $_db.gymEquipments,
    ).filter((f) => f.equipmentId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_gymEquipmentsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$EquipmentsTableFilterComposer
    extends Composer<_$AppDatabase, $EquipmentsTable> {
  $$EquipmentsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> exerciseEquipmentsRefs(
    Expression<bool> Function($$ExerciseEquipmentsTableFilterComposer f) f,
  ) {
    final $$ExerciseEquipmentsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.exerciseEquipments,
      getReferencedColumn: (t) => t.equipmentId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ExerciseEquipmentsTableFilterComposer(
            $db: $db,
            $table: $db.exerciseEquipments,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> gymEquipmentsRefs(
    Expression<bool> Function($$GymEquipmentsTableFilterComposer f) f,
  ) {
    final $$GymEquipmentsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.gymEquipments,
      getReferencedColumn: (t) => t.equipmentId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GymEquipmentsTableFilterComposer(
            $db: $db,
            $table: $db.gymEquipments,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$EquipmentsTableOrderingComposer
    extends Composer<_$AppDatabase, $EquipmentsTable> {
  $$EquipmentsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$EquipmentsTableAnnotationComposer
    extends Composer<_$AppDatabase, $EquipmentsTable> {
  $$EquipmentsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  Expression<T> exerciseEquipmentsRefs<T extends Object>(
    Expression<T> Function($$ExerciseEquipmentsTableAnnotationComposer a) f,
  ) {
    final $$ExerciseEquipmentsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.exerciseEquipments,
          getReferencedColumn: (t) => t.equipmentId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$ExerciseEquipmentsTableAnnotationComposer(
                $db: $db,
                $table: $db.exerciseEquipments,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<T> gymEquipmentsRefs<T extends Object>(
    Expression<T> Function($$GymEquipmentsTableAnnotationComposer a) f,
  ) {
    final $$GymEquipmentsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.gymEquipments,
      getReferencedColumn: (t) => t.equipmentId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GymEquipmentsTableAnnotationComposer(
            $db: $db,
            $table: $db.gymEquipments,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$EquipmentsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $EquipmentsTable,
          Equipment,
          $$EquipmentsTableFilterComposer,
          $$EquipmentsTableOrderingComposer,
          $$EquipmentsTableAnnotationComposer,
          $$EquipmentsTableCreateCompanionBuilder,
          $$EquipmentsTableUpdateCompanionBuilder,
          (Equipment, $$EquipmentsTableReferences),
          Equipment,
          PrefetchHooks Function({
            bool exerciseEquipmentsRefs,
            bool gymEquipmentsRefs,
          })
        > {
  $$EquipmentsTableTableManager(_$AppDatabase db, $EquipmentsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$EquipmentsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$EquipmentsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$EquipmentsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> name = const Value.absent(),
          }) => EquipmentsCompanion(id: id, name: name),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String name,
          }) => EquipmentsCompanion.insert(id: id, name: name),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$EquipmentsTable, Equipment>(table),
                  $$EquipmentsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({exerciseEquipmentsRefs = false, gymEquipmentsRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (exerciseEquipmentsRefs) db.exerciseEquipments,
                    if (gymEquipmentsRefs) db.gymEquipments,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (exerciseEquipmentsRefs)
                        await $_getPrefetchedDataByColumns<
                          Equipment,
                          $EquipmentsTable,
                          ExerciseEquipment,
                          $ExerciseEquipmentsTable
                        >(
                          currentTable: table,
                          referencedTable: $$EquipmentsTableReferences
                              ._exerciseEquipmentsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$EquipmentsTableReferences(
                                db,
                                table,
                                p0,
                              ).exerciseEquipmentsRefs,
                          currentColumn: 'id',
                          referencedColumn: 'equipment_id',
                          typedResults: items,
                        ),
                      if (gymEquipmentsRefs)
                        await $_getPrefetchedDataByColumns<
                          Equipment,
                          $EquipmentsTable,
                          GymEquipment,
                          $GymEquipmentsTable
                        >(
                          currentTable: table,
                          referencedTable: $$EquipmentsTableReferences
                              ._gymEquipmentsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$EquipmentsTableReferences(
                                db,
                                table,
                                p0,
                              ).gymEquipmentsRefs,
                          currentColumn: 'id',
                          referencedColumn: 'equipment_id',
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$EquipmentsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $EquipmentsTable,
      Equipment,
      $$EquipmentsTableFilterComposer,
      $$EquipmentsTableOrderingComposer,
      $$EquipmentsTableAnnotationComposer,
      $$EquipmentsTableCreateCompanionBuilder,
      $$EquipmentsTableUpdateCompanionBuilder,
      (Equipment, $$EquipmentsTableReferences),
      Equipment,
      PrefetchHooks Function({
        bool exerciseEquipmentsRefs,
        bool gymEquipmentsRefs,
      })
    >;
typedef $$ExercisesTableCreateCompanionBuilder = ExercisesCompanion Function({
  Value<int> id,
  required String name,
  required MuscleGroup primaryMuscle,
  Value<List<MuscleGroup>> secondaryMuscles,
  Value<String?> mediaPath,
  Value<TrackingMode> trackingMode,
});
typedef $$ExercisesTableUpdateCompanionBuilder = ExercisesCompanion Function({
  Value<int> id,
  Value<String> name,
  Value<MuscleGroup> primaryMuscle,
  Value<List<MuscleGroup>> secondaryMuscles,
  Value<String?> mediaPath,
  Value<TrackingMode> trackingMode,
});

final class $$ExercisesTableReferences
    extends BaseReferences<_$AppDatabase, $ExercisesTable, Exercise> {
  $$ExercisesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$ExerciseEquipmentsTable, List<ExerciseEquipment>>
  _exerciseEquipmentsRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.exerciseEquipments,
        aliasName: 'exercises__id__exercise_equipments__exercise_id',
      );

  $$ExerciseEquipmentsTableProcessedTableManager get exerciseEquipmentsRefs {
    final manager = $$ExerciseEquipmentsTableTableManager(
      $_db,
      $_db.exerciseEquipments,
    ).filter((f) => f.exerciseId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _exerciseEquipmentsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$WorkoutExercisesTable, List<WorkoutExercise>>
  _workoutExercisesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.workoutExercises,
    aliasName: 'exercises__id__workout_exercises__exercise_id',
  );

  $$WorkoutExercisesTableProcessedTableManager get workoutExercisesRefs {
    final manager = $$WorkoutExercisesTableTableManager(
      $_db,
      $_db.workoutExercises,
    ).filter((f) => f.exerciseId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _workoutExercisesRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$ExercisesTableFilterComposer
    extends Composer<_$AppDatabase, $ExercisesTable> {
  $$ExercisesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<MuscleGroup, MuscleGroup, String>
  get primaryMuscle => $composableBuilder(
    column: $table.primaryMuscle,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnWithTypeConverterFilters<List<MuscleGroup>, List<MuscleGroup>, String>
  get secondaryMuscles => $composableBuilder(
    column: $table.secondaryMuscles,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<String> get mediaPath => $composableBuilder(
    column: $table.mediaPath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<TrackingMode, TrackingMode, String>
  get trackingMode => $composableBuilder(
    column: $table.trackingMode,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  Expression<bool> exerciseEquipmentsRefs(
    Expression<bool> Function($$ExerciseEquipmentsTableFilterComposer f) f,
  ) {
    final $$ExerciseEquipmentsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.exerciseEquipments,
      getReferencedColumn: (t) => t.exerciseId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ExerciseEquipmentsTableFilterComposer(
            $db: $db,
            $table: $db.exerciseEquipments,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> workoutExercisesRefs(
    Expression<bool> Function($$WorkoutExercisesTableFilterComposer f) f,
  ) {
    final $$WorkoutExercisesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.workoutExercises,
      getReferencedColumn: (t) => t.exerciseId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WorkoutExercisesTableFilterComposer(
            $db: $db,
            $table: $db.workoutExercises,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ExercisesTableOrderingComposer
    extends Composer<_$AppDatabase, $ExercisesTable> {
  $$ExercisesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get primaryMuscle => $composableBuilder(
    column: $table.primaryMuscle,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get secondaryMuscles => $composableBuilder(
    column: $table.secondaryMuscles,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get mediaPath => $composableBuilder(
    column: $table.mediaPath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get trackingMode => $composableBuilder(
    column: $table.trackingMode,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ExercisesTableAnnotationComposer
    extends Composer<_$AppDatabase, $ExercisesTable> {
  $$ExercisesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumnWithTypeConverter<MuscleGroup, String> get primaryMuscle =>
      $composableBuilder(
        column: $table.primaryMuscle,
        builder: (column) => column,
      );

  GeneratedColumnWithTypeConverter<List<MuscleGroup>, String>
  get secondaryMuscles => $composableBuilder(
    column: $table.secondaryMuscles,
    builder: (column) => column,
  );

  GeneratedColumn<String> get mediaPath =>
      $composableBuilder(column: $table.mediaPath, builder: (column) => column);

  GeneratedColumnWithTypeConverter<TrackingMode, String> get trackingMode =>
      $composableBuilder(
        column: $table.trackingMode,
        builder: (column) => column,
      );

  Expression<T> exerciseEquipmentsRefs<T extends Object>(
    Expression<T> Function($$ExerciseEquipmentsTableAnnotationComposer a) f,
  ) {
    final $$ExerciseEquipmentsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.exerciseEquipments,
          getReferencedColumn: (t) => t.exerciseId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$ExerciseEquipmentsTableAnnotationComposer(
                $db: $db,
                $table: $db.exerciseEquipments,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<T> workoutExercisesRefs<T extends Object>(
    Expression<T> Function($$WorkoutExercisesTableAnnotationComposer a) f,
  ) {
    final $$WorkoutExercisesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.workoutExercises,
      getReferencedColumn: (t) => t.exerciseId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WorkoutExercisesTableAnnotationComposer(
            $db: $db,
            $table: $db.workoutExercises,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ExercisesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ExercisesTable,
          Exercise,
          $$ExercisesTableFilterComposer,
          $$ExercisesTableOrderingComposer,
          $$ExercisesTableAnnotationComposer,
          $$ExercisesTableCreateCompanionBuilder,
          $$ExercisesTableUpdateCompanionBuilder,
          (Exercise, $$ExercisesTableReferences),
          Exercise,
          PrefetchHooks Function({
            bool exerciseEquipmentsRefs,
            bool workoutExercisesRefs,
          })
        > {
  $$ExercisesTableTableManager(_$AppDatabase db, $ExercisesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ExercisesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ExercisesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ExercisesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<MuscleGroup> primaryMuscle = const Value.absent(),
                Value<List<MuscleGroup>> secondaryMuscles =
                    const Value.absent(),
                Value<String?> mediaPath = const Value.absent(),
                Value<TrackingMode> trackingMode = const Value.absent(),
              }) => ExercisesCompanion(
                id: id,
                name: name,
                primaryMuscle: primaryMuscle,
                secondaryMuscles: secondaryMuscles,
                mediaPath: mediaPath,
                trackingMode: trackingMode,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                required MuscleGroup primaryMuscle,
                Value<List<MuscleGroup>> secondaryMuscles =
                    const Value.absent(),
                Value<String?> mediaPath = const Value.absent(),
                Value<TrackingMode> trackingMode = const Value.absent(),
              }) => ExercisesCompanion.insert(
                id: id,
                name: name,
                primaryMuscle: primaryMuscle,
                secondaryMuscles: secondaryMuscles,
                mediaPath: mediaPath,
                trackingMode: trackingMode,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$ExercisesTable, Exercise>(table),
                  $$ExercisesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({exerciseEquipmentsRefs = false, workoutExercisesRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (exerciseEquipmentsRefs) db.exerciseEquipments,
                    if (workoutExercisesRefs) db.workoutExercises,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (exerciseEquipmentsRefs)
                        await $_getPrefetchedDataByColumns<
                          Exercise,
                          $ExercisesTable,
                          ExerciseEquipment,
                          $ExerciseEquipmentsTable
                        >(
                          currentTable: table,
                          referencedTable: $$ExercisesTableReferences
                              ._exerciseEquipmentsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ExercisesTableReferences(
                                db,
                                table,
                                p0,
                              ).exerciseEquipmentsRefs,
                          currentColumn: 'id',
                          referencedColumn: 'exercise_id',
                          typedResults: items,
                        ),
                      if (workoutExercisesRefs)
                        await $_getPrefetchedDataByColumns<
                          Exercise,
                          $ExercisesTable,
                          WorkoutExercise,
                          $WorkoutExercisesTable
                        >(
                          currentTable: table,
                          referencedTable: $$ExercisesTableReferences
                              ._workoutExercisesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ExercisesTableReferences(
                                db,
                                table,
                                p0,
                              ).workoutExercisesRefs,
                          currentColumn: 'id',
                          referencedColumn: 'exercise_id',
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$ExercisesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ExercisesTable,
      Exercise,
      $$ExercisesTableFilterComposer,
      $$ExercisesTableOrderingComposer,
      $$ExercisesTableAnnotationComposer,
      $$ExercisesTableCreateCompanionBuilder,
      $$ExercisesTableUpdateCompanionBuilder,
      (Exercise, $$ExercisesTableReferences),
      Exercise,
      PrefetchHooks Function({
        bool exerciseEquipmentsRefs,
        bool workoutExercisesRefs,
      })
    >;
typedef $$ExerciseEquipmentsTableCreateCompanionBuilder =
    ExerciseEquipmentsCompanion Function({
      required int exerciseId,
      required int equipmentId,
      Value<int> rowid,
    });
typedef $$ExerciseEquipmentsTableUpdateCompanionBuilder =
    ExerciseEquipmentsCompanion Function({
      Value<int> exerciseId,
      Value<int> equipmentId,
      Value<int> rowid,
    });

final class $$ExerciseEquipmentsTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $ExerciseEquipmentsTable,
          ExerciseEquipment
        > {
  $$ExerciseEquipmentsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $ExercisesTable _exerciseIdTable(_$AppDatabase db) => db.exercises
      .createAlias('exercise_equipments__exercise_id__exercises__id');

  $$ExercisesTableProcessedTableManager get exerciseId {
    final $_column = $_itemColumn<int>('exercise_id')!;

    final manager = $$ExercisesTableTableManager(
      $_db,
      $_db.exercises,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_exerciseIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $EquipmentsTable _equipmentIdTable(_$AppDatabase db) => db.equipments
      .createAlias('exercise_equipments__equipment_id__equipments__id');

  $$EquipmentsTableProcessedTableManager get equipmentId {
    final $_column = $_itemColumn<int>('equipment_id')!;

    final manager = $$EquipmentsTableTableManager(
      $_db,
      $_db.equipments,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_equipmentIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$ExerciseEquipmentsTableFilterComposer
    extends Composer<_$AppDatabase, $ExerciseEquipmentsTable> {
  $$ExerciseEquipmentsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  $$ExercisesTableFilterComposer get exerciseId {
    final $$ExercisesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.exerciseId,
      referencedTable: $db.exercises,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ExercisesTableFilterComposer(
            $db: $db,
            $table: $db.exercises,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$EquipmentsTableFilterComposer get equipmentId {
    final $$EquipmentsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.equipmentId,
      referencedTable: $db.equipments,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EquipmentsTableFilterComposer(
            $db: $db,
            $table: $db.equipments,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ExerciseEquipmentsTableOrderingComposer
    extends Composer<_$AppDatabase, $ExerciseEquipmentsTable> {
  $$ExerciseEquipmentsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  $$ExercisesTableOrderingComposer get exerciseId {
    final $$ExercisesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.exerciseId,
      referencedTable: $db.exercises,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ExercisesTableOrderingComposer(
            $db: $db,
            $table: $db.exercises,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$EquipmentsTableOrderingComposer get equipmentId {
    final $$EquipmentsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.equipmentId,
      referencedTable: $db.equipments,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EquipmentsTableOrderingComposer(
            $db: $db,
            $table: $db.equipments,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ExerciseEquipmentsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ExerciseEquipmentsTable> {
  $$ExerciseEquipmentsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  $$ExercisesTableAnnotationComposer get exerciseId {
    final $$ExercisesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.exerciseId,
      referencedTable: $db.exercises,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ExercisesTableAnnotationComposer(
            $db: $db,
            $table: $db.exercises,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$EquipmentsTableAnnotationComposer get equipmentId {
    final $$EquipmentsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.equipmentId,
      referencedTable: $db.equipments,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EquipmentsTableAnnotationComposer(
            $db: $db,
            $table: $db.equipments,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ExerciseEquipmentsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ExerciseEquipmentsTable,
          ExerciseEquipment,
          $$ExerciseEquipmentsTableFilterComposer,
          $$ExerciseEquipmentsTableOrderingComposer,
          $$ExerciseEquipmentsTableAnnotationComposer,
          $$ExerciseEquipmentsTableCreateCompanionBuilder,
          $$ExerciseEquipmentsTableUpdateCompanionBuilder,
          (ExerciseEquipment, $$ExerciseEquipmentsTableReferences),
          ExerciseEquipment,
          PrefetchHooks Function({bool exerciseId, bool equipmentId})
        > {
  $$ExerciseEquipmentsTableTableManager(
    _$AppDatabase db,
    $ExerciseEquipmentsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ExerciseEquipmentsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ExerciseEquipmentsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ExerciseEquipmentsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> exerciseId = const Value.absent(),
                Value<int> equipmentId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ExerciseEquipmentsCompanion(
                exerciseId: exerciseId,
                equipmentId: equipmentId,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required int exerciseId,
                required int equipmentId,
                Value<int> rowid = const Value.absent(),
              }) => ExerciseEquipmentsCompanion.insert(
                exerciseId: exerciseId,
                equipmentId: equipmentId,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$ExerciseEquipmentsTable, ExerciseEquipment>(
                    table,
                  ),
                  $$ExerciseEquipmentsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({exerciseId = false, equipmentId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (exerciseId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.exerciseId,
                        referencedTable: $$ExerciseEquipmentsTableReferences
                            ._exerciseIdTable(db),
                        referencedColumn: $$ExerciseEquipmentsTableReferences
                            ._exerciseIdTable(db)
                            .id,
                      ) as T;
                    }
                    if (equipmentId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.equipmentId,
                        referencedTable: $$ExerciseEquipmentsTableReferences
                            ._equipmentIdTable(db),
                        referencedColumn: $$ExerciseEquipmentsTableReferences
                            ._equipmentIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$ExerciseEquipmentsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ExerciseEquipmentsTable,
      ExerciseEquipment,
      $$ExerciseEquipmentsTableFilterComposer,
      $$ExerciseEquipmentsTableOrderingComposer,
      $$ExerciseEquipmentsTableAnnotationComposer,
      $$ExerciseEquipmentsTableCreateCompanionBuilder,
      $$ExerciseEquipmentsTableUpdateCompanionBuilder,
      (ExerciseEquipment, $$ExerciseEquipmentsTableReferences),
      ExerciseEquipment,
      PrefetchHooks Function({bool exerciseId, bool equipmentId})
    >;
typedef $$GymsTableCreateCompanionBuilder = GymsCompanion Function({
  Value<int> id,
  required String name,
  Value<double?> latitude,
  Value<double?> longitude,
  Value<double> radiusM,
});
typedef $$GymsTableUpdateCompanionBuilder = GymsCompanion Function({
  Value<int> id,
  Value<String> name,
  Value<double?> latitude,
  Value<double?> longitude,
  Value<double> radiusM,
});

final class $$GymsTableReferences
    extends BaseReferences<_$AppDatabase, $GymsTable, Gym> {
  $$GymsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$GymEquipmentsTable, List<GymEquipment>>
  _gymEquipmentsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.gymEquipments,
    aliasName: 'gyms__id__gym_equipments__gym_id',
  );

  $$GymEquipmentsTableProcessedTableManager get gymEquipmentsRefs {
    final manager = $$GymEquipmentsTableTableManager(
      $_db,
      $_db.gymEquipments,
    ).filter((f) => f.gymId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_gymEquipmentsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$WorkoutsTable, List<Workout>> _workoutsRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.workouts,
    aliasName: 'gyms__id__workouts__gym_id',
  );

  $$WorkoutsTableProcessedTableManager get workoutsRefs {
    final manager = $$WorkoutsTableTableManager(
      $_db,
      $_db.workouts,
    ).filter((f) => f.gymId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_workoutsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$GymsTableFilterComposer extends Composer<_$AppDatabase, $GymsTable> {
  $$GymsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get latitude => $composableBuilder(
    column: $table.latitude,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get longitude => $composableBuilder(
    column: $table.longitude,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get radiusM => $composableBuilder(
    column: $table.radiusM,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> gymEquipmentsRefs(
    Expression<bool> Function($$GymEquipmentsTableFilterComposer f) f,
  ) {
    final $$GymEquipmentsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.gymEquipments,
      getReferencedColumn: (t) => t.gymId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GymEquipmentsTableFilterComposer(
            $db: $db,
            $table: $db.gymEquipments,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> workoutsRefs(
    Expression<bool> Function($$WorkoutsTableFilterComposer f) f,
  ) {
    final $$WorkoutsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.workouts,
      getReferencedColumn: (t) => t.gymId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WorkoutsTableFilterComposer(
            $db: $db,
            $table: $db.workouts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$GymsTableOrderingComposer extends Composer<_$AppDatabase, $GymsTable> {
  $$GymsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get latitude => $composableBuilder(
    column: $table.latitude,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get longitude => $composableBuilder(
    column: $table.longitude,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get radiusM => $composableBuilder(
    column: $table.radiusM,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$GymsTableAnnotationComposer
    extends Composer<_$AppDatabase, $GymsTable> {
  $$GymsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<double> get latitude =>
      $composableBuilder(column: $table.latitude, builder: (column) => column);

  GeneratedColumn<double> get longitude =>
      $composableBuilder(column: $table.longitude, builder: (column) => column);

  GeneratedColumn<double> get radiusM =>
      $composableBuilder(column: $table.radiusM, builder: (column) => column);

  Expression<T> gymEquipmentsRefs<T extends Object>(
    Expression<T> Function($$GymEquipmentsTableAnnotationComposer a) f,
  ) {
    final $$GymEquipmentsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.gymEquipments,
      getReferencedColumn: (t) => t.gymId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GymEquipmentsTableAnnotationComposer(
            $db: $db,
            $table: $db.gymEquipments,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> workoutsRefs<T extends Object>(
    Expression<T> Function($$WorkoutsTableAnnotationComposer a) f,
  ) {
    final $$WorkoutsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.workouts,
      getReferencedColumn: (t) => t.gymId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WorkoutsTableAnnotationComposer(
            $db: $db,
            $table: $db.workouts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$GymsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $GymsTable,
          Gym,
          $$GymsTableFilterComposer,
          $$GymsTableOrderingComposer,
          $$GymsTableAnnotationComposer,
          $$GymsTableCreateCompanionBuilder,
          $$GymsTableUpdateCompanionBuilder,
          (Gym, $$GymsTableReferences),
          Gym,
          PrefetchHooks Function({bool gymEquipmentsRefs, bool workoutsRefs})
        > {
  $$GymsTableTableManager(_$AppDatabase db, $GymsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$GymsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$GymsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$GymsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<double?> latitude = const Value.absent(),
                Value<double?> longitude = const Value.absent(),
                Value<double> radiusM = const Value.absent(),
              }) => GymsCompanion(
                id: id,
                name: name,
                latitude: latitude,
                longitude: longitude,
                radiusM: radiusM,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                Value<double?> latitude = const Value.absent(),
                Value<double?> longitude = const Value.absent(),
                Value<double> radiusM = const Value.absent(),
              }) => GymsCompanion.insert(
                id: id,
                name: name,
                latitude: latitude,
                longitude: longitude,
                radiusM: radiusM,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$GymsTable, Gym>(table),
                  $$GymsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({gymEquipmentsRefs = false, workoutsRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (gymEquipmentsRefs) db.gymEquipments,
                    if (workoutsRefs) db.workouts,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (gymEquipmentsRefs)
                        await $_getPrefetchedDataByColumns<
                          Gym,
                          $GymsTable,
                          GymEquipment,
                          $GymEquipmentsTable
                        >(
                          currentTable: table,
                          referencedTable: $$GymsTableReferences
                              ._gymEquipmentsRefsTable(db),
                          managerFromTypedResult: (p0) => $$GymsTableReferences(
                            db,
                            table,
                            p0,
                          ).gymEquipmentsRefs,
                          currentColumn: 'id',
                          referencedColumn: 'gym_id',
                          typedResults: items,
                        ),
                      if (workoutsRefs)
                        await $_getPrefetchedDataByColumns<
                          Gym,
                          $GymsTable,
                          Workout,
                          $WorkoutsTable
                        >(
                          currentTable: table,
                          referencedTable: $$GymsTableReferences
                              ._workoutsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$GymsTableReferences(db, table, p0).workoutsRefs,
                          currentColumn: 'id',
                          referencedColumn: 'gym_id',
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$GymsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $GymsTable,
      Gym,
      $$GymsTableFilterComposer,
      $$GymsTableOrderingComposer,
      $$GymsTableAnnotationComposer,
      $$GymsTableCreateCompanionBuilder,
      $$GymsTableUpdateCompanionBuilder,
      (Gym, $$GymsTableReferences),
      Gym,
      PrefetchHooks Function({bool gymEquipmentsRefs, bool workoutsRefs})
    >;
typedef $$GymEquipmentsTableCreateCompanionBuilder =
    GymEquipmentsCompanion Function({
      required int gymId,
      required int equipmentId,
      Value<int> rowid,
    });
typedef $$GymEquipmentsTableUpdateCompanionBuilder =
    GymEquipmentsCompanion Function({
      Value<int> gymId,
      Value<int> equipmentId,
      Value<int> rowid,
    });

final class $$GymEquipmentsTableReferences
    extends BaseReferences<_$AppDatabase, $GymEquipmentsTable, GymEquipment> {
  $$GymEquipmentsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $GymsTable _gymIdTable(_$AppDatabase db) =>
      db.gyms.createAlias('gym_equipments__gym_id__gyms__id');

  $$GymsTableProcessedTableManager get gymId {
    final $_column = $_itemColumn<int>('gym_id')!;

    final manager = $$GymsTableTableManager(
      $_db,
      $_db.gyms,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_gymIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $EquipmentsTable _equipmentIdTable(_$AppDatabase db) =>
      db.equipments.createAlias('gym_equipments__equipment_id__equipments__id');

  $$EquipmentsTableProcessedTableManager get equipmentId {
    final $_column = $_itemColumn<int>('equipment_id')!;

    final manager = $$EquipmentsTableTableManager(
      $_db,
      $_db.equipments,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_equipmentIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$GymEquipmentsTableFilterComposer
    extends Composer<_$AppDatabase, $GymEquipmentsTable> {
  $$GymEquipmentsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  $$GymsTableFilterComposer get gymId {
    final $$GymsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.gymId,
      referencedTable: $db.gyms,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GymsTableFilterComposer(
            $db: $db,
            $table: $db.gyms,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$EquipmentsTableFilterComposer get equipmentId {
    final $$EquipmentsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.equipmentId,
      referencedTable: $db.equipments,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EquipmentsTableFilterComposer(
            $db: $db,
            $table: $db.equipments,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$GymEquipmentsTableOrderingComposer
    extends Composer<_$AppDatabase, $GymEquipmentsTable> {
  $$GymEquipmentsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  $$GymsTableOrderingComposer get gymId {
    final $$GymsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.gymId,
      referencedTable: $db.gyms,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GymsTableOrderingComposer(
            $db: $db,
            $table: $db.gyms,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$EquipmentsTableOrderingComposer get equipmentId {
    final $$EquipmentsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.equipmentId,
      referencedTable: $db.equipments,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EquipmentsTableOrderingComposer(
            $db: $db,
            $table: $db.equipments,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$GymEquipmentsTableAnnotationComposer
    extends Composer<_$AppDatabase, $GymEquipmentsTable> {
  $$GymEquipmentsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  $$GymsTableAnnotationComposer get gymId {
    final $$GymsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.gymId,
      referencedTable: $db.gyms,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GymsTableAnnotationComposer(
            $db: $db,
            $table: $db.gyms,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$EquipmentsTableAnnotationComposer get equipmentId {
    final $$EquipmentsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.equipmentId,
      referencedTable: $db.equipments,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EquipmentsTableAnnotationComposer(
            $db: $db,
            $table: $db.equipments,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$GymEquipmentsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $GymEquipmentsTable,
          GymEquipment,
          $$GymEquipmentsTableFilterComposer,
          $$GymEquipmentsTableOrderingComposer,
          $$GymEquipmentsTableAnnotationComposer,
          $$GymEquipmentsTableCreateCompanionBuilder,
          $$GymEquipmentsTableUpdateCompanionBuilder,
          (GymEquipment, $$GymEquipmentsTableReferences),
          GymEquipment,
          PrefetchHooks Function({bool gymId, bool equipmentId})
        > {
  $$GymEquipmentsTableTableManager(_$AppDatabase db, $GymEquipmentsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$GymEquipmentsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$GymEquipmentsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$GymEquipmentsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> gymId = const Value.absent(),
                Value<int> equipmentId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => GymEquipmentsCompanion(
                gymId: gymId,
                equipmentId: equipmentId,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required int gymId,
                required int equipmentId,
                Value<int> rowid = const Value.absent(),
              }) => GymEquipmentsCompanion.insert(
                gymId: gymId,
                equipmentId: equipmentId,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$GymEquipmentsTable, GymEquipment>(table),
                  $$GymEquipmentsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({gymId = false, equipmentId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (gymId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.gymId,
                        referencedTable: $$GymEquipmentsTableReferences
                            ._gymIdTable(db),
                        referencedColumn: $$GymEquipmentsTableReferences
                            ._gymIdTable(db)
                            .id,
                      ) as T;
                    }
                    if (equipmentId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.equipmentId,
                        referencedTable: $$GymEquipmentsTableReferences
                            ._equipmentIdTable(db),
                        referencedColumn: $$GymEquipmentsTableReferences
                            ._equipmentIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$GymEquipmentsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $GymEquipmentsTable,
      GymEquipment,
      $$GymEquipmentsTableFilterComposer,
      $$GymEquipmentsTableOrderingComposer,
      $$GymEquipmentsTableAnnotationComposer,
      $$GymEquipmentsTableCreateCompanionBuilder,
      $$GymEquipmentsTableUpdateCompanionBuilder,
      (GymEquipment, $$GymEquipmentsTableReferences),
      GymEquipment,
      PrefetchHooks Function({bool gymId, bool equipmentId})
    >;
typedef $$WorkoutsTableCreateCompanionBuilder = WorkoutsCompanion Function({
  Value<int> id,
  required DateTime startedAt,
  Value<DateTime?> endedAt,
  Value<int?> gymId,
  Value<int?> restCustomSec,
  Value<DateTime?> restEndsAt,
  Value<DateTime?> timerEndsAt,
  Value<Effort?> effort,
});
typedef $$WorkoutsTableUpdateCompanionBuilder = WorkoutsCompanion Function({
  Value<int> id,
  Value<DateTime> startedAt,
  Value<DateTime?> endedAt,
  Value<int?> gymId,
  Value<int?> restCustomSec,
  Value<DateTime?> restEndsAt,
  Value<DateTime?> timerEndsAt,
  Value<Effort?> effort,
});

final class $$WorkoutsTableReferences
    extends BaseReferences<_$AppDatabase, $WorkoutsTable, Workout> {
  $$WorkoutsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $GymsTable _gymIdTable(_$AppDatabase db) =>
      db.gyms.createAlias('workouts__gym_id__gyms__id');

  $$GymsTableProcessedTableManager? get gymId {
    final $_column = $_itemColumn<int>('gym_id');
    if ($_column == null) return null;
    final manager = $$GymsTableTableManager(
      $_db,
      $_db.gyms,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_gymIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$WorkoutExercisesTable, List<WorkoutExercise>>
  _workoutExercisesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.workoutExercises,
    aliasName: 'workouts__id__workout_exercises__workout_id',
  );

  $$WorkoutExercisesTableProcessedTableManager get workoutExercisesRefs {
    final manager = $$WorkoutExercisesTableTableManager(
      $_db,
      $_db.workoutExercises,
    ).filter((f) => f.workoutId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _workoutExercisesRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$WorkoutsTableFilterComposer
    extends Composer<_$AppDatabase, $WorkoutsTable> {
  $$WorkoutsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get startedAt => $composableBuilder(
    column: $table.startedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get endedAt => $composableBuilder(
    column: $table.endedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get restCustomSec => $composableBuilder(
    column: $table.restCustomSec,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get restEndsAt => $composableBuilder(
    column: $table.restEndsAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get timerEndsAt => $composableBuilder(
    column: $table.timerEndsAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<Effort?, Effort, String> get effort =>
      $composableBuilder(
        column: $table.effort,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  $$GymsTableFilterComposer get gymId {
    final $$GymsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.gymId,
      referencedTable: $db.gyms,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GymsTableFilterComposer(
            $db: $db,
            $table: $db.gyms,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> workoutExercisesRefs(
    Expression<bool> Function($$WorkoutExercisesTableFilterComposer f) f,
  ) {
    final $$WorkoutExercisesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.workoutExercises,
      getReferencedColumn: (t) => t.workoutId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WorkoutExercisesTableFilterComposer(
            $db: $db,
            $table: $db.workoutExercises,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$WorkoutsTableOrderingComposer
    extends Composer<_$AppDatabase, $WorkoutsTable> {
  $$WorkoutsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get startedAt => $composableBuilder(
    column: $table.startedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get endedAt => $composableBuilder(
    column: $table.endedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get restCustomSec => $composableBuilder(
    column: $table.restCustomSec,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get restEndsAt => $composableBuilder(
    column: $table.restEndsAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get timerEndsAt => $composableBuilder(
    column: $table.timerEndsAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get effort => $composableBuilder(
    column: $table.effort,
    builder: (column) => ColumnOrderings(column),
  );

  $$GymsTableOrderingComposer get gymId {
    final $$GymsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.gymId,
      referencedTable: $db.gyms,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GymsTableOrderingComposer(
            $db: $db,
            $table: $db.gyms,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$WorkoutsTableAnnotationComposer
    extends Composer<_$AppDatabase, $WorkoutsTable> {
  $$WorkoutsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get startedAt =>
      $composableBuilder(column: $table.startedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get endedAt =>
      $composableBuilder(column: $table.endedAt, builder: (column) => column);

  GeneratedColumn<int> get restCustomSec => $composableBuilder(
    column: $table.restCustomSec,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get restEndsAt => $composableBuilder(
    column: $table.restEndsAt,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get timerEndsAt => $composableBuilder(
    column: $table.timerEndsAt,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<Effort?, String> get effort =>
      $composableBuilder(column: $table.effort, builder: (column) => column);

  $$GymsTableAnnotationComposer get gymId {
    final $$GymsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.gymId,
      referencedTable: $db.gyms,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GymsTableAnnotationComposer(
            $db: $db,
            $table: $db.gyms,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> workoutExercisesRefs<T extends Object>(
    Expression<T> Function($$WorkoutExercisesTableAnnotationComposer a) f,
  ) {
    final $$WorkoutExercisesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.workoutExercises,
      getReferencedColumn: (t) => t.workoutId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WorkoutExercisesTableAnnotationComposer(
            $db: $db,
            $table: $db.workoutExercises,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$WorkoutsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $WorkoutsTable,
          Workout,
          $$WorkoutsTableFilterComposer,
          $$WorkoutsTableOrderingComposer,
          $$WorkoutsTableAnnotationComposer,
          $$WorkoutsTableCreateCompanionBuilder,
          $$WorkoutsTableUpdateCompanionBuilder,
          (Workout, $$WorkoutsTableReferences),
          Workout,
          PrefetchHooks Function({bool gymId, bool workoutExercisesRefs})
        > {
  $$WorkoutsTableTableManager(_$AppDatabase db, $WorkoutsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$WorkoutsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$WorkoutsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$WorkoutsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<DateTime> startedAt = const Value.absent(),
                Value<DateTime?> endedAt = const Value.absent(),
                Value<int?> gymId = const Value.absent(),
                Value<int?> restCustomSec = const Value.absent(),
                Value<DateTime?> restEndsAt = const Value.absent(),
                Value<DateTime?> timerEndsAt = const Value.absent(),
                Value<Effort?> effort = const Value.absent(),
              }) => WorkoutsCompanion(
                id: id,
                startedAt: startedAt,
                endedAt: endedAt,
                gymId: gymId,
                restCustomSec: restCustomSec,
                restEndsAt: restEndsAt,
                timerEndsAt: timerEndsAt,
                effort: effort,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required DateTime startedAt,
                Value<DateTime?> endedAt = const Value.absent(),
                Value<int?> gymId = const Value.absent(),
                Value<int?> restCustomSec = const Value.absent(),
                Value<DateTime?> restEndsAt = const Value.absent(),
                Value<DateTime?> timerEndsAt = const Value.absent(),
                Value<Effort?> effort = const Value.absent(),
              }) => WorkoutsCompanion.insert(
                id: id,
                startedAt: startedAt,
                endedAt: endedAt,
                gymId: gymId,
                restCustomSec: restCustomSec,
                restEndsAt: restEndsAt,
                timerEndsAt: timerEndsAt,
                effort: effort,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$WorkoutsTable, Workout>(table),
                  $$WorkoutsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({gymId = false, workoutExercisesRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (workoutExercisesRefs) db.workoutExercises,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (gymId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.gymId,
                            referencedTable: $$WorkoutsTableReferences
                                ._gymIdTable(db),
                            referencedColumn: $$WorkoutsTableReferences
                                ._gymIdTable(db)
                                .id,
                          ) as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (workoutExercisesRefs)
                        await $_getPrefetchedDataByColumns<
                          Workout,
                          $WorkoutsTable,
                          WorkoutExercise,
                          $WorkoutExercisesTable
                        >(
                          currentTable: table,
                          referencedTable: $$WorkoutsTableReferences
                              ._workoutExercisesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$WorkoutsTableReferences(
                                db,
                                table,
                                p0,
                              ).workoutExercisesRefs,
                          currentColumn: 'id',
                          referencedColumn: 'workout_id',
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$WorkoutsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $WorkoutsTable,
      Workout,
      $$WorkoutsTableFilterComposer,
      $$WorkoutsTableOrderingComposer,
      $$WorkoutsTableAnnotationComposer,
      $$WorkoutsTableCreateCompanionBuilder,
      $$WorkoutsTableUpdateCompanionBuilder,
      (Workout, $$WorkoutsTableReferences),
      Workout,
      PrefetchHooks Function({bool gymId, bool workoutExercisesRefs})
    >;
typedef $$WorkoutExercisesTableCreateCompanionBuilder =
    WorkoutExercisesCompanion Function({
      Value<int> id,
      required int workoutId,
      required int exerciseId,
      required int position,
      Value<int> targetSets,
      Value<TrackingMode> mode,
      Value<int> targetReps,
      Value<int> targetSeconds,
      Value<double> targetWeightKg,
      Value<bool> done,
    });
typedef $$WorkoutExercisesTableUpdateCompanionBuilder =
    WorkoutExercisesCompanion Function({
      Value<int> id,
      Value<int> workoutId,
      Value<int> exerciseId,
      Value<int> position,
      Value<int> targetSets,
      Value<TrackingMode> mode,
      Value<int> targetReps,
      Value<int> targetSeconds,
      Value<double> targetWeightKg,
      Value<bool> done,
    });

final class $$WorkoutExercisesTableReferences
    extends
        BaseReferences<_$AppDatabase, $WorkoutExercisesTable, WorkoutExercise> {
  $$WorkoutExercisesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $WorkoutsTable _workoutIdTable(_$AppDatabase db) =>
      db.workouts.createAlias('workout_exercises__workout_id__workouts__id');

  $$WorkoutsTableProcessedTableManager get workoutId {
    final $_column = $_itemColumn<int>('workout_id')!;

    final manager = $$WorkoutsTableTableManager(
      $_db,
      $_db.workouts,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_workoutIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $ExercisesTable _exerciseIdTable(_$AppDatabase db) =>
      db.exercises.createAlias('workout_exercises__exercise_id__exercises__id');

  $$ExercisesTableProcessedTableManager get exerciseId {
    final $_column = $_itemColumn<int>('exercise_id')!;

    final manager = $$ExercisesTableTableManager(
      $_db,
      $_db.exercises,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_exerciseIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$WorkoutSetsTable, List<WorkoutSet>>
  _workoutSetsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.workoutSets,
    aliasName: 'workout_exercises__id__workout_sets__workout_exercise_id',
  );

  $$WorkoutSetsTableProcessedTableManager get workoutSetsRefs {
    final manager = $$WorkoutSetsTableTableManager(
      $_db,
      $_db.workoutSets,
    ).filter((f) => f.workoutExerciseId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_workoutSetsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$WorkoutExercisesTableFilterComposer
    extends Composer<_$AppDatabase, $WorkoutExercisesTable> {
  $$WorkoutExercisesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get position => $composableBuilder(
    column: $table.position,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get targetSets => $composableBuilder(
    column: $table.targetSets,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<TrackingMode, TrackingMode, String> get mode =>
      $composableBuilder(
        column: $table.mode,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<int> get targetReps => $composableBuilder(
    column: $table.targetReps,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get targetSeconds => $composableBuilder(
    column: $table.targetSeconds,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get targetWeightKg => $composableBuilder(
    column: $table.targetWeightKg,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get done => $composableBuilder(
    column: $table.done,
    builder: (column) => ColumnFilters(column),
  );

  $$WorkoutsTableFilterComposer get workoutId {
    final $$WorkoutsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.workoutId,
      referencedTable: $db.workouts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WorkoutsTableFilterComposer(
            $db: $db,
            $table: $db.workouts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ExercisesTableFilterComposer get exerciseId {
    final $$ExercisesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.exerciseId,
      referencedTable: $db.exercises,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ExercisesTableFilterComposer(
            $db: $db,
            $table: $db.exercises,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> workoutSetsRefs(
    Expression<bool> Function($$WorkoutSetsTableFilterComposer f) f,
  ) {
    final $$WorkoutSetsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.workoutSets,
      getReferencedColumn: (t) => t.workoutExerciseId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WorkoutSetsTableFilterComposer(
            $db: $db,
            $table: $db.workoutSets,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$WorkoutExercisesTableOrderingComposer
    extends Composer<_$AppDatabase, $WorkoutExercisesTable> {
  $$WorkoutExercisesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get position => $composableBuilder(
    column: $table.position,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get targetSets => $composableBuilder(
    column: $table.targetSets,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get mode => $composableBuilder(
    column: $table.mode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get targetReps => $composableBuilder(
    column: $table.targetReps,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get targetSeconds => $composableBuilder(
    column: $table.targetSeconds,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get targetWeightKg => $composableBuilder(
    column: $table.targetWeightKg,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get done => $composableBuilder(
    column: $table.done,
    builder: (column) => ColumnOrderings(column),
  );

  $$WorkoutsTableOrderingComposer get workoutId {
    final $$WorkoutsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.workoutId,
      referencedTable: $db.workouts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WorkoutsTableOrderingComposer(
            $db: $db,
            $table: $db.workouts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ExercisesTableOrderingComposer get exerciseId {
    final $$ExercisesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.exerciseId,
      referencedTable: $db.exercises,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ExercisesTableOrderingComposer(
            $db: $db,
            $table: $db.exercises,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$WorkoutExercisesTableAnnotationComposer
    extends Composer<_$AppDatabase, $WorkoutExercisesTable> {
  $$WorkoutExercisesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get position =>
      $composableBuilder(column: $table.position, builder: (column) => column);

  GeneratedColumn<int> get targetSets => $composableBuilder(
    column: $table.targetSets,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<TrackingMode, String> get mode =>
      $composableBuilder(column: $table.mode, builder: (column) => column);

  GeneratedColumn<int> get targetReps => $composableBuilder(
    column: $table.targetReps,
    builder: (column) => column,
  );

  GeneratedColumn<int> get targetSeconds => $composableBuilder(
    column: $table.targetSeconds,
    builder: (column) => column,
  );

  GeneratedColumn<double> get targetWeightKg => $composableBuilder(
    column: $table.targetWeightKg,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get done =>
      $composableBuilder(column: $table.done, builder: (column) => column);

  $$WorkoutsTableAnnotationComposer get workoutId {
    final $$WorkoutsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.workoutId,
      referencedTable: $db.workouts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WorkoutsTableAnnotationComposer(
            $db: $db,
            $table: $db.workouts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ExercisesTableAnnotationComposer get exerciseId {
    final $$ExercisesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.exerciseId,
      referencedTable: $db.exercises,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ExercisesTableAnnotationComposer(
            $db: $db,
            $table: $db.exercises,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> workoutSetsRefs<T extends Object>(
    Expression<T> Function($$WorkoutSetsTableAnnotationComposer a) f,
  ) {
    final $$WorkoutSetsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.workoutSets,
      getReferencedColumn: (t) => t.workoutExerciseId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WorkoutSetsTableAnnotationComposer(
            $db: $db,
            $table: $db.workoutSets,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$WorkoutExercisesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $WorkoutExercisesTable,
          WorkoutExercise,
          $$WorkoutExercisesTableFilterComposer,
          $$WorkoutExercisesTableOrderingComposer,
          $$WorkoutExercisesTableAnnotationComposer,
          $$WorkoutExercisesTableCreateCompanionBuilder,
          $$WorkoutExercisesTableUpdateCompanionBuilder,
          (WorkoutExercise, $$WorkoutExercisesTableReferences),
          WorkoutExercise,
          PrefetchHooks Function({
            bool workoutId,
            bool exerciseId,
            bool workoutSetsRefs,
          })
        > {
  $$WorkoutExercisesTableTableManager(
    _$AppDatabase db,
    $WorkoutExercisesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$WorkoutExercisesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$WorkoutExercisesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$WorkoutExercisesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> workoutId = const Value.absent(),
                Value<int> exerciseId = const Value.absent(),
                Value<int> position = const Value.absent(),
                Value<int> targetSets = const Value.absent(),
                Value<TrackingMode> mode = const Value.absent(),
                Value<int> targetReps = const Value.absent(),
                Value<int> targetSeconds = const Value.absent(),
                Value<double> targetWeightKg = const Value.absent(),
                Value<bool> done = const Value.absent(),
              }) => WorkoutExercisesCompanion(
                id: id,
                workoutId: workoutId,
                exerciseId: exerciseId,
                position: position,
                targetSets: targetSets,
                mode: mode,
                targetReps: targetReps,
                targetSeconds: targetSeconds,
                targetWeightKg: targetWeightKg,
                done: done,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int workoutId,
                required int exerciseId,
                required int position,
                Value<int> targetSets = const Value.absent(),
                Value<TrackingMode> mode = const Value.absent(),
                Value<int> targetReps = const Value.absent(),
                Value<int> targetSeconds = const Value.absent(),
                Value<double> targetWeightKg = const Value.absent(),
                Value<bool> done = const Value.absent(),
              }) => WorkoutExercisesCompanion.insert(
                id: id,
                workoutId: workoutId,
                exerciseId: exerciseId,
                position: position,
                targetSets: targetSets,
                mode: mode,
                targetReps: targetReps,
                targetSeconds: targetSeconds,
                targetWeightKg: targetWeightKg,
                done: done,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$WorkoutExercisesTable, WorkoutExercise>(table),
                  $$WorkoutExercisesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                workoutId = false,
                exerciseId = false,
                workoutSetsRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (workoutSetsRefs) db.workoutSets,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (workoutId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.workoutId,
                            referencedTable: $$WorkoutExercisesTableReferences
                                ._workoutIdTable(db),
                            referencedColumn: $$WorkoutExercisesTableReferences
                                ._workoutIdTable(db)
                                .id,
                          ) as T;
                        }
                        if (exerciseId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.exerciseId,
                            referencedTable: $$WorkoutExercisesTableReferences
                                ._exerciseIdTable(db),
                            referencedColumn: $$WorkoutExercisesTableReferences
                                ._exerciseIdTable(db)
                                .id,
                          ) as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (workoutSetsRefs)
                        await $_getPrefetchedDataByColumns<
                          WorkoutExercise,
                          $WorkoutExercisesTable,
                          WorkoutSet,
                          $WorkoutSetsTable
                        >(
                          currentTable: table,
                          referencedTable: $$WorkoutExercisesTableReferences
                              ._workoutSetsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$WorkoutExercisesTableReferences(
                                db,
                                table,
                                p0,
                              ).workoutSetsRefs,
                          currentColumn: 'id',
                          referencedColumn: 'workout_exercise_id',
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$WorkoutExercisesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $WorkoutExercisesTable,
      WorkoutExercise,
      $$WorkoutExercisesTableFilterComposer,
      $$WorkoutExercisesTableOrderingComposer,
      $$WorkoutExercisesTableAnnotationComposer,
      $$WorkoutExercisesTableCreateCompanionBuilder,
      $$WorkoutExercisesTableUpdateCompanionBuilder,
      (WorkoutExercise, $$WorkoutExercisesTableReferences),
      WorkoutExercise,
      PrefetchHooks Function({
        bool workoutId,
        bool exerciseId,
        bool workoutSetsRefs,
      })
    >;
typedef $$WorkoutSetsTableCreateCompanionBuilder =
    WorkoutSetsCompanion Function({
      Value<int> id,
      required int workoutExerciseId,
      required double weightKg,
      Value<int?> reps,
      Value<int?> durationSec,
      required DateTime doneAt,
    });
typedef $$WorkoutSetsTableUpdateCompanionBuilder =
    WorkoutSetsCompanion Function({
      Value<int> id,
      Value<int> workoutExerciseId,
      Value<double> weightKg,
      Value<int?> reps,
      Value<int?> durationSec,
      Value<DateTime> doneAt,
    });

final class $$WorkoutSetsTableReferences
    extends BaseReferences<_$AppDatabase, $WorkoutSetsTable, WorkoutSet> {
  $$WorkoutSetsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $WorkoutExercisesTable _workoutExerciseIdTable(_$AppDatabase db) => db
      .workoutExercises
      .createAlias('workout_sets__workout_exercise_id__workout_exercises__id');

  $$WorkoutExercisesTableProcessedTableManager get workoutExerciseId {
    final $_column = $_itemColumn<int>('workout_exercise_id')!;

    final manager = $$WorkoutExercisesTableTableManager(
      $_db,
      $_db.workoutExercises,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_workoutExerciseIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$WorkoutSetsTableFilterComposer
    extends Composer<_$AppDatabase, $WorkoutSetsTable> {
  $$WorkoutSetsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get weightKg => $composableBuilder(
    column: $table.weightKg,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get reps => $composableBuilder(
    column: $table.reps,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get durationSec => $composableBuilder(
    column: $table.durationSec,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get doneAt => $composableBuilder(
    column: $table.doneAt,
    builder: (column) => ColumnFilters(column),
  );

  $$WorkoutExercisesTableFilterComposer get workoutExerciseId {
    final $$WorkoutExercisesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.workoutExerciseId,
      referencedTable: $db.workoutExercises,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WorkoutExercisesTableFilterComposer(
            $db: $db,
            $table: $db.workoutExercises,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$WorkoutSetsTableOrderingComposer
    extends Composer<_$AppDatabase, $WorkoutSetsTable> {
  $$WorkoutSetsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get weightKg => $composableBuilder(
    column: $table.weightKg,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get reps => $composableBuilder(
    column: $table.reps,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get durationSec => $composableBuilder(
    column: $table.durationSec,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get doneAt => $composableBuilder(
    column: $table.doneAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$WorkoutExercisesTableOrderingComposer get workoutExerciseId {
    final $$WorkoutExercisesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.workoutExerciseId,
      referencedTable: $db.workoutExercises,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WorkoutExercisesTableOrderingComposer(
            $db: $db,
            $table: $db.workoutExercises,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$WorkoutSetsTableAnnotationComposer
    extends Composer<_$AppDatabase, $WorkoutSetsTable> {
  $$WorkoutSetsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<double> get weightKg =>
      $composableBuilder(column: $table.weightKg, builder: (column) => column);

  GeneratedColumn<int> get reps =>
      $composableBuilder(column: $table.reps, builder: (column) => column);

  GeneratedColumn<int> get durationSec => $composableBuilder(
    column: $table.durationSec,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get doneAt =>
      $composableBuilder(column: $table.doneAt, builder: (column) => column);

  $$WorkoutExercisesTableAnnotationComposer get workoutExerciseId {
    final $$WorkoutExercisesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.workoutExerciseId,
      referencedTable: $db.workoutExercises,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WorkoutExercisesTableAnnotationComposer(
            $db: $db,
            $table: $db.workoutExercises,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$WorkoutSetsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $WorkoutSetsTable,
          WorkoutSet,
          $$WorkoutSetsTableFilterComposer,
          $$WorkoutSetsTableOrderingComposer,
          $$WorkoutSetsTableAnnotationComposer,
          $$WorkoutSetsTableCreateCompanionBuilder,
          $$WorkoutSetsTableUpdateCompanionBuilder,
          (WorkoutSet, $$WorkoutSetsTableReferences),
          WorkoutSet,
          PrefetchHooks Function({bool workoutExerciseId})
        > {
  $$WorkoutSetsTableTableManager(_$AppDatabase db, $WorkoutSetsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$WorkoutSetsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$WorkoutSetsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$WorkoutSetsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> workoutExerciseId = const Value.absent(),
                Value<double> weightKg = const Value.absent(),
                Value<int?> reps = const Value.absent(),
                Value<int?> durationSec = const Value.absent(),
                Value<DateTime> doneAt = const Value.absent(),
              }) => WorkoutSetsCompanion(
                id: id,
                workoutExerciseId: workoutExerciseId,
                weightKg: weightKg,
                reps: reps,
                durationSec: durationSec,
                doneAt: doneAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int workoutExerciseId,
                required double weightKg,
                Value<int?> reps = const Value.absent(),
                Value<int?> durationSec = const Value.absent(),
                required DateTime doneAt,
              }) => WorkoutSetsCompanion.insert(
                id: id,
                workoutExerciseId: workoutExerciseId,
                weightKg: weightKg,
                reps: reps,
                durationSec: durationSec,
                doneAt: doneAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$WorkoutSetsTable, WorkoutSet>(table),
                  $$WorkoutSetsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({workoutExerciseId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (workoutExerciseId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.workoutExerciseId,
                        referencedTable: $$WorkoutSetsTableReferences
                            ._workoutExerciseIdTable(db),
                        referencedColumn: $$WorkoutSetsTableReferences
                            ._workoutExerciseIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$WorkoutSetsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $WorkoutSetsTable,
      WorkoutSet,
      $$WorkoutSetsTableFilterComposer,
      $$WorkoutSetsTableOrderingComposer,
      $$WorkoutSetsTableAnnotationComposer,
      $$WorkoutSetsTableCreateCompanionBuilder,
      $$WorkoutSetsTableUpdateCompanionBuilder,
      (WorkoutSet, $$WorkoutSetsTableReferences),
      WorkoutSet,
      PrefetchHooks Function({bool workoutExerciseId})
    >;
typedef $$BodyMetricsTableCreateCompanionBuilder =
    BodyMetricsCompanion Function({
      Value<int> id,
      required DateTime date,
      Value<double?> weightKg,
      Value<double?> heightCm,
      Value<double?> bodyFatPct,
      Value<double?> chestCm,
      Value<double?> waistCm,
      Value<double?> hipCm,
      Value<double?> armCm,
      Value<double?> thighCm,
    });
typedef $$BodyMetricsTableUpdateCompanionBuilder =
    BodyMetricsCompanion Function({
      Value<int> id,
      Value<DateTime> date,
      Value<double?> weightKg,
      Value<double?> heightCm,
      Value<double?> bodyFatPct,
      Value<double?> chestCm,
      Value<double?> waistCm,
      Value<double?> hipCm,
      Value<double?> armCm,
      Value<double?> thighCm,
    });

class $$BodyMetricsTableFilterComposer
    extends Composer<_$AppDatabase, $BodyMetricsTable> {
  $$BodyMetricsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get weightKg => $composableBuilder(
    column: $table.weightKg,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get heightCm => $composableBuilder(
    column: $table.heightCm,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get bodyFatPct => $composableBuilder(
    column: $table.bodyFatPct,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get chestCm => $composableBuilder(
    column: $table.chestCm,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get waistCm => $composableBuilder(
    column: $table.waistCm,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get hipCm => $composableBuilder(
    column: $table.hipCm,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get armCm => $composableBuilder(
    column: $table.armCm,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get thighCm => $composableBuilder(
    column: $table.thighCm,
    builder: (column) => ColumnFilters(column),
  );
}

class $$BodyMetricsTableOrderingComposer
    extends Composer<_$AppDatabase, $BodyMetricsTable> {
  $$BodyMetricsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get weightKg => $composableBuilder(
    column: $table.weightKg,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get heightCm => $composableBuilder(
    column: $table.heightCm,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get bodyFatPct => $composableBuilder(
    column: $table.bodyFatPct,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get chestCm => $composableBuilder(
    column: $table.chestCm,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get waistCm => $composableBuilder(
    column: $table.waistCm,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get hipCm => $composableBuilder(
    column: $table.hipCm,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get armCm => $composableBuilder(
    column: $table.armCm,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get thighCm => $composableBuilder(
    column: $table.thighCm,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$BodyMetricsTableAnnotationComposer
    extends Composer<_$AppDatabase, $BodyMetricsTable> {
  $$BodyMetricsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<double> get weightKg =>
      $composableBuilder(column: $table.weightKg, builder: (column) => column);

  GeneratedColumn<double> get heightCm =>
      $composableBuilder(column: $table.heightCm, builder: (column) => column);

  GeneratedColumn<double> get bodyFatPct => $composableBuilder(
    column: $table.bodyFatPct,
    builder: (column) => column,
  );

  GeneratedColumn<double> get chestCm =>
      $composableBuilder(column: $table.chestCm, builder: (column) => column);

  GeneratedColumn<double> get waistCm =>
      $composableBuilder(column: $table.waistCm, builder: (column) => column);

  GeneratedColumn<double> get hipCm =>
      $composableBuilder(column: $table.hipCm, builder: (column) => column);

  GeneratedColumn<double> get armCm =>
      $composableBuilder(column: $table.armCm, builder: (column) => column);

  GeneratedColumn<double> get thighCm =>
      $composableBuilder(column: $table.thighCm, builder: (column) => column);
}

class $$BodyMetricsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $BodyMetricsTable,
          BodyMetric,
          $$BodyMetricsTableFilterComposer,
          $$BodyMetricsTableOrderingComposer,
          $$BodyMetricsTableAnnotationComposer,
          $$BodyMetricsTableCreateCompanionBuilder,
          $$BodyMetricsTableUpdateCompanionBuilder,
          (
            BodyMetric,
            BaseReferences<_$AppDatabase, $BodyMetricsTable, BodyMetric>,
          ),
          BodyMetric,
          PrefetchHooks Function()
        > {
  $$BodyMetricsTableTableManager(_$AppDatabase db, $BodyMetricsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$BodyMetricsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$BodyMetricsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$BodyMetricsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<DateTime> date = const Value.absent(),
                Value<double?> weightKg = const Value.absent(),
                Value<double?> heightCm = const Value.absent(),
                Value<double?> bodyFatPct = const Value.absent(),
                Value<double?> chestCm = const Value.absent(),
                Value<double?> waistCm = const Value.absent(),
                Value<double?> hipCm = const Value.absent(),
                Value<double?> armCm = const Value.absent(),
                Value<double?> thighCm = const Value.absent(),
              }) => BodyMetricsCompanion(
                id: id,
                date: date,
                weightKg: weightKg,
                heightCm: heightCm,
                bodyFatPct: bodyFatPct,
                chestCm: chestCm,
                waistCm: waistCm,
                hipCm: hipCm,
                armCm: armCm,
                thighCm: thighCm,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required DateTime date,
                Value<double?> weightKg = const Value.absent(),
                Value<double?> heightCm = const Value.absent(),
                Value<double?> bodyFatPct = const Value.absent(),
                Value<double?> chestCm = const Value.absent(),
                Value<double?> waistCm = const Value.absent(),
                Value<double?> hipCm = const Value.absent(),
                Value<double?> armCm = const Value.absent(),
                Value<double?> thighCm = const Value.absent(),
              }) => BodyMetricsCompanion.insert(
                id: id,
                date: date,
                weightKg: weightKg,
                heightCm: heightCm,
                bodyFatPct: bodyFatPct,
                chestCm: chestCm,
                waistCm: waistCm,
                hipCm: hipCm,
                armCm: armCm,
                thighCm: thighCm,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$BodyMetricsTable, BodyMetric>(table),
                  BaseReferences<_$AppDatabase, $BodyMetricsTable, BodyMetric>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$BodyMetricsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $BodyMetricsTable,
      BodyMetric,
      $$BodyMetricsTableFilterComposer,
      $$BodyMetricsTableOrderingComposer,
      $$BodyMetricsTableAnnotationComposer,
      $$BodyMetricsTableCreateCompanionBuilder,
      $$BodyMetricsTableUpdateCompanionBuilder,
      (
        BodyMetric,
        BaseReferences<_$AppDatabase, $BodyMetricsTable, BodyMetric>,
      ),
      BodyMetric,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$EquipmentsTableTableManager get equipments =>
      $$EquipmentsTableTableManager(_db, _db.equipments);
  $$ExercisesTableTableManager get exercises =>
      $$ExercisesTableTableManager(_db, _db.exercises);
  $$ExerciseEquipmentsTableTableManager get exerciseEquipments =>
      $$ExerciseEquipmentsTableTableManager(_db, _db.exerciseEquipments);
  $$GymsTableTableManager get gyms => $$GymsTableTableManager(_db, _db.gyms);
  $$GymEquipmentsTableTableManager get gymEquipments =>
      $$GymEquipmentsTableTableManager(_db, _db.gymEquipments);
  $$WorkoutsTableTableManager get workouts =>
      $$WorkoutsTableTableManager(_db, _db.workouts);
  $$WorkoutExercisesTableTableManager get workoutExercises =>
      $$WorkoutExercisesTableTableManager(_db, _db.workoutExercises);
  $$WorkoutSetsTableTableManager get workoutSets =>
      $$WorkoutSetsTableTableManager(_db, _db.workoutSets);
  $$BodyMetricsTableTableManager get bodyMetrics =>
      $$BodyMetricsTableTableManager(_db, _db.bodyMetrics);
}
