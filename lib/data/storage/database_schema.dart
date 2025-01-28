import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

part 'database_schema.g.dart';

class Characters extends Table {

  IntColumn get id => integer().autoIncrement()();

  TextColumn get longId => text()();
  TextColumn get name => text()();
  TextColumn get imageSrc => text()();
  TextColumn get house => text()();
  TextColumn get actor => text()();
  TextColumn get species => text()();

  TextColumn get dateOfBirth => text()();

  IntColumn get successCount => integer().withDefault(const Constant(0))();
  IntColumn get failCount => integer().withDefault(const Constant(0))();
  IntColumn get totalCount => integer().withDefault(const Constant(0))();

}

@DriftDatabase(tables: [Characters])
class AppDatabase extends _$AppDatabase {

  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
      onCreate: (Migrator migrator) async {
        migrator.createAll();
      },
      onUpgrade: (Migrator migrator, int from, int to) async {

        if (from < 1) {
          await migrator.deleteTable('characters');
          await migrator.createAll();
        }
      }
  );

  static QueryExecutor _openConnection() {
    return driftDatabase(name: 'my_database');
  }

}