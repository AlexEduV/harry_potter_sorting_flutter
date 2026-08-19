import 'package:drift/drift.dart' show Value;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:harry_potter_sorting_flutter/data/database/database_schema.dart';

AppDatabase _openDb() => AppDatabase.forTesting(NativeDatabase.memory());

const _minimalInsert = CharactersCompanion(
  longId: Value('abc'),
  name: Value('Harry Potter'),
  imageSrc: Value('https://example.com/harry.jpg'),
  house: Value('Gryffindor'),
  actor: Value('Daniel Radcliffe'),
  species: Value('human'),
  dateOfBirth: Value('31-07-1980'),
);

void main() {
  late AppDatabase db;

  setUp(() => db = _openDb());
  tearDown(() => db.close());

  test('schemaVersion is 2', () {
    expect(db.schemaVersion, 2);
  });

  group('characters table — defaults', () {
    test('is empty on creation', () async {
      expect(await db.select(db.characters).get(), isEmpty);
    });

    test('successCount defaults to 0', () async {
      await db.into(db.characters).insert(_minimalInsert);
      final row = await db.select(db.characters).getSingle();
      expect(row.successCount, 0);
    });

    test('failCount defaults to 0', () async {
      await db.into(db.characters).insert(_minimalInsert);
      final row = await db.select(db.characters).getSingle();
      expect(row.failCount, 0);
    });

    test('totalCount defaults to 0', () async {
      await db.into(db.characters).insert(_minimalInsert);
      final row = await db.select(db.characters).getSingle();
      expect(row.totalCount, 0);
    });
  });

  group('characters table — round-trip', () {
    test('persists all text fields', () async {
      await db.into(db.characters).insert(const CharactersCompanion(
            longId: Value('xyz'),
            name: Value('Hermione Granger'),
            imageSrc: Value('https://example.com/hermione.jpg'),
            house: Value('Gryffindor'),
            actor: Value('Emma Watson'),
            species: Value('human'),
            dateOfBirth: Value('19-09-1979'),
          ));

      final row = await db.select(db.characters).getSingle();
      expect(row.longId, 'xyz');
      expect(row.name, 'Hermione Granger');
      expect(row.imageSrc, 'https://example.com/hermione.jpg');
      expect(row.house, 'Gryffindor');
      expect(row.actor, 'Emma Watson');
      expect(row.species, 'human');
      expect(row.dateOfBirth, '19-09-1979');
    });

    test('persists explicit stat values', () async {
      await db.into(db.characters).insert(const CharactersCompanion(
            longId: Value('s1'),
            name: Value('Ron Weasley'),
            imageSrc: Value(''),
            house: Value('Gryffindor'),
            actor: Value('Rupert Grint'),
            species: Value('human'),
            dateOfBirth: Value('01-03-1980'),
            successCount: Value(5),
            failCount: Value(3),
            totalCount: Value(8),
          ));

      final row = await db.select(db.characters).getSingle();
      expect(row.successCount, 5);
      expect(row.failCount, 3);
      expect(row.totalCount, 8);
    });
  });

  group('characters table — autoincrement', () {
    test('id column is unique across rows', () async {
      await db
          .into(db.characters)
          .insert(_minimalInsert.copyWith(longId: const Value('a'), name: const Value('Harry')));
      await db
          .into(db.characters)
          .insert(_minimalInsert.copyWith(longId: const Value('b'), name: const Value('Ron')));

      final rows = await db.select(db.characters).get();
      expect(rows[0].id, isNot(rows[1].id));
    });
  });

  group('migration onUpgrade', () {
    test('from v1: dropping and recreating the table leaves it functional', () async {
      // Seed one row before the migration wipes the table.
      await db.into(db.characters).insert(_minimalInsert);

      // Execute the same steps that onUpgrade(from < 2) performs.
      final migrator = db.createMigrator();
      await db.transaction(() async {
        await migrator.deleteTable('characters');
        await migrator.createAll();
      });

      // The table should be empty (wiped) but still accept inserts.
      expect(await db.select(db.characters).get(), isEmpty);

      await db.into(db.characters).insert(_minimalInsert);
      expect(await db.select(db.characters).get(), hasLength(1));
    });
  });
}
