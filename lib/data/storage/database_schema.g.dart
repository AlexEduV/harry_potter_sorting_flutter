// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database_schema.dart';

// ignore_for_file: type=lint
class $CharactersTable extends Characters
    with TableInfo<$CharactersTable, Character> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CharactersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _longIdMeta = const VerificationMeta('longId');
  @override
  late final GeneratedColumn<String> longId = GeneratedColumn<String>(
      'long_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _imageSrcMeta =
      const VerificationMeta('imageSrc');
  @override
  late final GeneratedColumn<String> imageSrc = GeneratedColumn<String>(
      'image_src', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _houseMeta = const VerificationMeta('house');
  @override
  late final GeneratedColumn<String> house = GeneratedColumn<String>(
      'house', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _actorMeta = const VerificationMeta('actor');
  @override
  late final GeneratedColumn<String> actor = GeneratedColumn<String>(
      'actor', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _speciesMeta =
      const VerificationMeta('species');
  @override
  late final GeneratedColumn<String> species = GeneratedColumn<String>(
      'species', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _dateOfBirthMeta =
      const VerificationMeta('dateOfBirth');
  @override
  late final GeneratedColumn<String> dateOfBirth = GeneratedColumn<String>(
      'date_of_birth', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _successCountMeta =
      const VerificationMeta('successCount');
  @override
  late final GeneratedColumn<int> successCount = GeneratedColumn<int>(
      'success_count', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _failCountMeta =
      const VerificationMeta('failCount');
  @override
  late final GeneratedColumn<int> failCount = GeneratedColumn<int>(
      'fail_count', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _totalCountMeta =
      const VerificationMeta('totalCount');
  @override
  late final GeneratedColumn<int> totalCount = GeneratedColumn<int>(
      'total_count', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  @override
  List<GeneratedColumn> get $columns => [
        id,
        longId,
        name,
        imageSrc,
        house,
        actor,
        species,
        dateOfBirth,
        successCount,
        failCount,
        totalCount
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'characters';
  @override
  VerificationContext validateIntegrity(Insertable<Character> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('long_id')) {
      context.handle(_longIdMeta,
          longId.isAcceptableOrUnknown(data['long_id']!, _longIdMeta));
    } else if (isInserting) {
      context.missing(_longIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('image_src')) {
      context.handle(_imageSrcMeta,
          imageSrc.isAcceptableOrUnknown(data['image_src']!, _imageSrcMeta));
    } else if (isInserting) {
      context.missing(_imageSrcMeta);
    }
    if (data.containsKey('house')) {
      context.handle(
          _houseMeta, house.isAcceptableOrUnknown(data['house']!, _houseMeta));
    } else if (isInserting) {
      context.missing(_houseMeta);
    }
    if (data.containsKey('actor')) {
      context.handle(
          _actorMeta, actor.isAcceptableOrUnknown(data['actor']!, _actorMeta));
    } else if (isInserting) {
      context.missing(_actorMeta);
    }
    if (data.containsKey('species')) {
      context.handle(_speciesMeta,
          species.isAcceptableOrUnknown(data['species']!, _speciesMeta));
    } else if (isInserting) {
      context.missing(_speciesMeta);
    }
    if (data.containsKey('date_of_birth')) {
      context.handle(
          _dateOfBirthMeta,
          dateOfBirth.isAcceptableOrUnknown(
              data['date_of_birth']!, _dateOfBirthMeta));
    } else if (isInserting) {
      context.missing(_dateOfBirthMeta);
    }
    if (data.containsKey('success_count')) {
      context.handle(
          _successCountMeta,
          successCount.isAcceptableOrUnknown(
              data['success_count']!, _successCountMeta));
    }
    if (data.containsKey('fail_count')) {
      context.handle(_failCountMeta,
          failCount.isAcceptableOrUnknown(data['fail_count']!, _failCountMeta));
    }
    if (data.containsKey('total_count')) {
      context.handle(
          _totalCountMeta,
          totalCount.isAcceptableOrUnknown(
              data['total_count']!, _totalCountMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Character map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Character(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      longId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}long_id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      imageSrc: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}image_src'])!,
      house: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}house'])!,
      actor: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}actor'])!,
      species: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}species'])!,
      dateOfBirth: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}date_of_birth'])!,
      successCount: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}success_count'])!,
      failCount: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}fail_count'])!,
      totalCount: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}total_count'])!,
    );
  }

  @override
  $CharactersTable createAlias(String alias) {
    return $CharactersTable(attachedDatabase, alias);
  }
}

class Character extends DataClass implements Insertable<Character> {
  final int id;
  final String longId;
  final String name;
  final String imageSrc;
  final String house;
  final String actor;
  final String species;
  final String dateOfBirth;
  final int successCount;
  final int failCount;
  final int totalCount;
  const Character(
      {required this.id,
      required this.longId,
      required this.name,
      required this.imageSrc,
      required this.house,
      required this.actor,
      required this.species,
      required this.dateOfBirth,
      required this.successCount,
      required this.failCount,
      required this.totalCount});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['long_id'] = Variable<String>(longId);
    map['name'] = Variable<String>(name);
    map['image_src'] = Variable<String>(imageSrc);
    map['house'] = Variable<String>(house);
    map['actor'] = Variable<String>(actor);
    map['species'] = Variable<String>(species);
    map['date_of_birth'] = Variable<String>(dateOfBirth);
    map['success_count'] = Variable<int>(successCount);
    map['fail_count'] = Variable<int>(failCount);
    map['total_count'] = Variable<int>(totalCount);
    return map;
  }

  CharactersCompanion toCompanion(bool nullToAbsent) {
    return CharactersCompanion(
      id: Value(id),
      longId: Value(longId),
      name: Value(name),
      imageSrc: Value(imageSrc),
      house: Value(house),
      actor: Value(actor),
      species: Value(species),
      dateOfBirth: Value(dateOfBirth),
      successCount: Value(successCount),
      failCount: Value(failCount),
      totalCount: Value(totalCount),
    );
  }

  factory Character.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Character(
      id: serializer.fromJson<int>(json['id']),
      longId: serializer.fromJson<String>(json['longId']),
      name: serializer.fromJson<String>(json['name']),
      imageSrc: serializer.fromJson<String>(json['imageSrc']),
      house: serializer.fromJson<String>(json['house']),
      actor: serializer.fromJson<String>(json['actor']),
      species: serializer.fromJson<String>(json['species']),
      dateOfBirth: serializer.fromJson<String>(json['dateOfBirth']),
      successCount: serializer.fromJson<int>(json['successCount']),
      failCount: serializer.fromJson<int>(json['failCount']),
      totalCount: serializer.fromJson<int>(json['totalCount']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'longId': serializer.toJson<String>(longId),
      'name': serializer.toJson<String>(name),
      'imageSrc': serializer.toJson<String>(imageSrc),
      'house': serializer.toJson<String>(house),
      'actor': serializer.toJson<String>(actor),
      'species': serializer.toJson<String>(species),
      'dateOfBirth': serializer.toJson<String>(dateOfBirth),
      'successCount': serializer.toJson<int>(successCount),
      'failCount': serializer.toJson<int>(failCount),
      'totalCount': serializer.toJson<int>(totalCount),
    };
  }

  Character copyWith(
          {int? id,
          String? longId,
          String? name,
          String? imageSrc,
          String? house,
          String? actor,
          String? species,
          String? dateOfBirth,
          int? successCount,
          int? failCount,
          int? totalCount}) =>
      Character(
        id: id ?? this.id,
        longId: longId ?? this.longId,
        name: name ?? this.name,
        imageSrc: imageSrc ?? this.imageSrc,
        house: house ?? this.house,
        actor: actor ?? this.actor,
        species: species ?? this.species,
        dateOfBirth: dateOfBirth ?? this.dateOfBirth,
        successCount: successCount ?? this.successCount,
        failCount: failCount ?? this.failCount,
        totalCount: totalCount ?? this.totalCount,
      );
  Character copyWithCompanion(CharactersCompanion data) {
    return Character(
      id: data.id.present ? data.id.value : this.id,
      longId: data.longId.present ? data.longId.value : this.longId,
      name: data.name.present ? data.name.value : this.name,
      imageSrc: data.imageSrc.present ? data.imageSrc.value : this.imageSrc,
      house: data.house.present ? data.house.value : this.house,
      actor: data.actor.present ? data.actor.value : this.actor,
      species: data.species.present ? data.species.value : this.species,
      dateOfBirth:
          data.dateOfBirth.present ? data.dateOfBirth.value : this.dateOfBirth,
      successCount: data.successCount.present
          ? data.successCount.value
          : this.successCount,
      failCount: data.failCount.present ? data.failCount.value : this.failCount,
      totalCount:
          data.totalCount.present ? data.totalCount.value : this.totalCount,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Character(')
          ..write('id: $id, ')
          ..write('longId: $longId, ')
          ..write('name: $name, ')
          ..write('imageSrc: $imageSrc, ')
          ..write('house: $house, ')
          ..write('actor: $actor, ')
          ..write('species: $species, ')
          ..write('dateOfBirth: $dateOfBirth, ')
          ..write('successCount: $successCount, ')
          ..write('failCount: $failCount, ')
          ..write('totalCount: $totalCount')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, longId, name, imageSrc, house, actor,
      species, dateOfBirth, successCount, failCount, totalCount);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Character &&
          other.id == this.id &&
          other.longId == this.longId &&
          other.name == this.name &&
          other.imageSrc == this.imageSrc &&
          other.house == this.house &&
          other.actor == this.actor &&
          other.species == this.species &&
          other.dateOfBirth == this.dateOfBirth &&
          other.successCount == this.successCount &&
          other.failCount == this.failCount &&
          other.totalCount == this.totalCount);
}

class CharactersCompanion extends UpdateCompanion<Character> {
  final Value<int> id;
  final Value<String> longId;
  final Value<String> name;
  final Value<String> imageSrc;
  final Value<String> house;
  final Value<String> actor;
  final Value<String> species;
  final Value<String> dateOfBirth;
  final Value<int> successCount;
  final Value<int> failCount;
  final Value<int> totalCount;
  const CharactersCompanion({
    this.id = const Value.absent(),
    this.longId = const Value.absent(),
    this.name = const Value.absent(),
    this.imageSrc = const Value.absent(),
    this.house = const Value.absent(),
    this.actor = const Value.absent(),
    this.species = const Value.absent(),
    this.dateOfBirth = const Value.absent(),
    this.successCount = const Value.absent(),
    this.failCount = const Value.absent(),
    this.totalCount = const Value.absent(),
  });
  CharactersCompanion.insert({
    this.id = const Value.absent(),
    required String longId,
    required String name,
    required String imageSrc,
    required String house,
    required String actor,
    required String species,
    required String dateOfBirth,
    this.successCount = const Value.absent(),
    this.failCount = const Value.absent(),
    this.totalCount = const Value.absent(),
  })  : longId = Value(longId),
        name = Value(name),
        imageSrc = Value(imageSrc),
        house = Value(house),
        actor = Value(actor),
        species = Value(species),
        dateOfBirth = Value(dateOfBirth);
  static Insertable<Character> custom({
    Expression<int>? id,
    Expression<String>? longId,
    Expression<String>? name,
    Expression<String>? imageSrc,
    Expression<String>? house,
    Expression<String>? actor,
    Expression<String>? species,
    Expression<String>? dateOfBirth,
    Expression<int>? successCount,
    Expression<int>? failCount,
    Expression<int>? totalCount,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (longId != null) 'long_id': longId,
      if (name != null) 'name': name,
      if (imageSrc != null) 'image_src': imageSrc,
      if (house != null) 'house': house,
      if (actor != null) 'actor': actor,
      if (species != null) 'species': species,
      if (dateOfBirth != null) 'date_of_birth': dateOfBirth,
      if (successCount != null) 'success_count': successCount,
      if (failCount != null) 'fail_count': failCount,
      if (totalCount != null) 'total_count': totalCount,
    });
  }

  CharactersCompanion copyWith(
      {Value<int>? id,
      Value<String>? longId,
      Value<String>? name,
      Value<String>? imageSrc,
      Value<String>? house,
      Value<String>? actor,
      Value<String>? species,
      Value<String>? dateOfBirth,
      Value<int>? successCount,
      Value<int>? failCount,
      Value<int>? totalCount}) {
    return CharactersCompanion(
      id: id ?? this.id,
      longId: longId ?? this.longId,
      name: name ?? this.name,
      imageSrc: imageSrc ?? this.imageSrc,
      house: house ?? this.house,
      actor: actor ?? this.actor,
      species: species ?? this.species,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      successCount: successCount ?? this.successCount,
      failCount: failCount ?? this.failCount,
      totalCount: totalCount ?? this.totalCount,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (longId.present) {
      map['long_id'] = Variable<String>(longId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (imageSrc.present) {
      map['image_src'] = Variable<String>(imageSrc.value);
    }
    if (house.present) {
      map['house'] = Variable<String>(house.value);
    }
    if (actor.present) {
      map['actor'] = Variable<String>(actor.value);
    }
    if (species.present) {
      map['species'] = Variable<String>(species.value);
    }
    if (dateOfBirth.present) {
      map['date_of_birth'] = Variable<String>(dateOfBirth.value);
    }
    if (successCount.present) {
      map['success_count'] = Variable<int>(successCount.value);
    }
    if (failCount.present) {
      map['fail_count'] = Variable<int>(failCount.value);
    }
    if (totalCount.present) {
      map['total_count'] = Variable<int>(totalCount.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CharactersCompanion(')
          ..write('id: $id, ')
          ..write('longId: $longId, ')
          ..write('name: $name, ')
          ..write('imageSrc: $imageSrc, ')
          ..write('house: $house, ')
          ..write('actor: $actor, ')
          ..write('species: $species, ')
          ..write('dateOfBirth: $dateOfBirth, ')
          ..write('successCount: $successCount, ')
          ..write('failCount: $failCount, ')
          ..write('totalCount: $totalCount')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $CharactersTable characters = $CharactersTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [characters];
}

typedef $$CharactersTableCreateCompanionBuilder = CharactersCompanion Function({
  Value<int> id,
  required String longId,
  required String name,
  required String imageSrc,
  required String house,
  required String actor,
  required String species,
  required String dateOfBirth,
  Value<int> successCount,
  Value<int> failCount,
  Value<int> totalCount,
});
typedef $$CharactersTableUpdateCompanionBuilder = CharactersCompanion Function({
  Value<int> id,
  Value<String> longId,
  Value<String> name,
  Value<String> imageSrc,
  Value<String> house,
  Value<String> actor,
  Value<String> species,
  Value<String> dateOfBirth,
  Value<int> successCount,
  Value<int> failCount,
  Value<int> totalCount,
});

class $$CharactersTableFilterComposer
    extends Composer<_$AppDatabase, $CharactersTable> {
  $$CharactersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get longId => $composableBuilder(
      column: $table.longId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get imageSrc => $composableBuilder(
      column: $table.imageSrc, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get house => $composableBuilder(
      column: $table.house, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get actor => $composableBuilder(
      column: $table.actor, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get species => $composableBuilder(
      column: $table.species, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get dateOfBirth => $composableBuilder(
      column: $table.dateOfBirth, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get successCount => $composableBuilder(
      column: $table.successCount, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get failCount => $composableBuilder(
      column: $table.failCount, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get totalCount => $composableBuilder(
      column: $table.totalCount, builder: (column) => ColumnFilters(column));
}

class $$CharactersTableOrderingComposer
    extends Composer<_$AppDatabase, $CharactersTable> {
  $$CharactersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get longId => $composableBuilder(
      column: $table.longId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get imageSrc => $composableBuilder(
      column: $table.imageSrc, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get house => $composableBuilder(
      column: $table.house, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get actor => $composableBuilder(
      column: $table.actor, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get species => $composableBuilder(
      column: $table.species, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get dateOfBirth => $composableBuilder(
      column: $table.dateOfBirth, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get successCount => $composableBuilder(
      column: $table.successCount,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get failCount => $composableBuilder(
      column: $table.failCount, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get totalCount => $composableBuilder(
      column: $table.totalCount, builder: (column) => ColumnOrderings(column));
}

class $$CharactersTableAnnotationComposer
    extends Composer<_$AppDatabase, $CharactersTable> {
  $$CharactersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get longId =>
      $composableBuilder(column: $table.longId, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get imageSrc =>
      $composableBuilder(column: $table.imageSrc, builder: (column) => column);

  GeneratedColumn<String> get house =>
      $composableBuilder(column: $table.house, builder: (column) => column);

  GeneratedColumn<String> get actor =>
      $composableBuilder(column: $table.actor, builder: (column) => column);

  GeneratedColumn<String> get species =>
      $composableBuilder(column: $table.species, builder: (column) => column);

  GeneratedColumn<String> get dateOfBirth => $composableBuilder(
      column: $table.dateOfBirth, builder: (column) => column);

  GeneratedColumn<int> get successCount => $composableBuilder(
      column: $table.successCount, builder: (column) => column);

  GeneratedColumn<int> get failCount =>
      $composableBuilder(column: $table.failCount, builder: (column) => column);

  GeneratedColumn<int> get totalCount => $composableBuilder(
      column: $table.totalCount, builder: (column) => column);
}

class $$CharactersTableTableManager extends RootTableManager<
    _$AppDatabase,
    $CharactersTable,
    Character,
    $$CharactersTableFilterComposer,
    $$CharactersTableOrderingComposer,
    $$CharactersTableAnnotationComposer,
    $$CharactersTableCreateCompanionBuilder,
    $$CharactersTableUpdateCompanionBuilder,
    (Character, BaseReferences<_$AppDatabase, $CharactersTable, Character>),
    Character,
    PrefetchHooks Function()> {
  $$CharactersTableTableManager(_$AppDatabase db, $CharactersTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CharactersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CharactersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CharactersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> longId = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String> imageSrc = const Value.absent(),
            Value<String> house = const Value.absent(),
            Value<String> actor = const Value.absent(),
            Value<String> species = const Value.absent(),
            Value<String> dateOfBirth = const Value.absent(),
            Value<int> successCount = const Value.absent(),
            Value<int> failCount = const Value.absent(),
            Value<int> totalCount = const Value.absent(),
          }) =>
              CharactersCompanion(
            id: id,
            longId: longId,
            name: name,
            imageSrc: imageSrc,
            house: house,
            actor: actor,
            species: species,
            dateOfBirth: dateOfBirth,
            successCount: successCount,
            failCount: failCount,
            totalCount: totalCount,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String longId,
            required String name,
            required String imageSrc,
            required String house,
            required String actor,
            required String species,
            required String dateOfBirth,
            Value<int> successCount = const Value.absent(),
            Value<int> failCount = const Value.absent(),
            Value<int> totalCount = const Value.absent(),
          }) =>
              CharactersCompanion.insert(
            id: id,
            longId: longId,
            name: name,
            imageSrc: imageSrc,
            house: house,
            actor: actor,
            species: species,
            dateOfBirth: dateOfBirth,
            successCount: successCount,
            failCount: failCount,
            totalCount: totalCount,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$CharactersTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $CharactersTable,
    Character,
    $$CharactersTableFilterComposer,
    $$CharactersTableOrderingComposer,
    $$CharactersTableAnnotationComposer,
    $$CharactersTableCreateCompanionBuilder,
    $$CharactersTableUpdateCompanionBuilder,
    (Character, BaseReferences<_$AppDatabase, $CharactersTable, Character>),
    Character,
    PrefetchHooks Function()>;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$CharactersTableTableManager get characters =>
      $$CharactersTableTableManager(_db, _db.characters);
}
