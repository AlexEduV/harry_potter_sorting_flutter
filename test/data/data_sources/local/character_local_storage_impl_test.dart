import 'package:drift/drift.dart' show Value;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:harry_potter_sorting_flutter/common/enums/house.dart';
import 'package:harry_potter_sorting_flutter/data/data_sources/local/character_local_storage_impl.dart';
import 'package:harry_potter_sorting_flutter/data/database/database_schema.dart';
import 'package:harry_potter_sorting_flutter/domain/entities/character_entity.dart';
import 'package:harry_potter_sorting_flutter/domain/entities/info_stats_entity.dart';

CharacterEntity makeEntity({
  String id = '1',
  String name = 'Harry Potter',
  House house = House.gryffindor,
  String? dateOfBirth = '31-07-1980',
}) =>
    CharacterEntity(
      id: id,
      name: name,
      imageSrc: 'https://example.com/$id.jpg',
      house: house,
      dateOfBirth: dateOfBirth,
      actor: 'Daniel Radcliffe',
      species: 'human',
    );

void main() {
  late AppDatabase db;
  late CharacterLocalStorageImpl storage;

  setUp(() {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    storage = CharacterLocalStorageImpl(db);
  });

  tearDown(() => db.close());

  group('getAll', () {
    test('returns empty list when database is empty', () async {
      expect(await storage.getAll(), isEmpty);
    });

    test('returns all inserted characters', () async {
      await storage.saveAll([makeEntity(id: '1'), makeEntity(id: '2', name: 'Ron')]);
      expect(await storage.getAll(), hasLength(2));
    });
  });

  group('insert', () {
    test('inserts a single character', () async {
      await storage.insert(makeEntity());
      expect(await storage.getAll(), hasLength(1));
    });

    test('persists house as displayName string', () async {
      await storage.insert(makeEntity(house: House.slytherin));
      final row = (await storage.getAll()).first;
      expect(row.house, House.slytherin.displayName);
    });

    test('uses empty string when dateOfBirth is null', () async {
      await storage.insert(makeEntity(dateOfBirth: null));
      final row = (await storage.getAll()).first;
      expect(row.dateOfBirth, '');
    });
  });

  group('saveAll', () {
    test('inserts only new entities (skips existing longIds)', () async {
      await storage.saveAll([makeEntity(id: '1')]);
      await storage.saveAll([makeEntity(id: '1'), makeEntity(id: '2', name: 'Ron')]);
      expect(await storage.getAll(), hasLength(2));
    });

    test('does nothing when all entities already exist', () async {
      await storage.saveAll([makeEntity(id: '1')]);
      await storage.saveAll([makeEntity(id: '1')]);
      expect(await storage.getAll(), hasLength(1));
    });

    test('does nothing when list is empty', () async {
      await storage.saveAll([]);
      expect(await storage.getAll(), isEmpty);
    });
  });

  group('findByName', () {
    test('returns the character when found', () async {
      await storage.insert(makeEntity(name: 'Harry Potter'));
      final result = await storage.findByName('Harry Potter');
      expect(result, isNotNull);
      expect(result!.name, 'Harry Potter');
    });

    test('returns null when not found', () async {
      final result = await storage.findByName('Nobody');
      expect(result, isNull);
    });
  });

  group('delete', () {
    test('removes the character with the given id', () async {
      await storage.insert(makeEntity());
      final row = (await storage.getAll()).first;
      await storage.delete(row.id);
      expect(await storage.getAll(), isEmpty);
    });

    test('does not affect other characters', () async {
      await storage.saveAll([makeEntity(id: '1'), makeEntity(id: '2', name: 'Ron')]);
      final rows = await storage.getAll();
      await storage.delete(rows.first.id);
      expect(await storage.getAll(), hasLength(1));
    });
  });

  group('resetStatsByName', () {
    test('resets counts to zero for the named character', () async {
      await storage.insert(makeEntity(name: 'Harry Potter'));

      // Manually bump the stats so there is something to reset
      final row = (await storage.getAll()).first;
      await (db.update(db.characters)..where((t) => t.id.equals(row.id)))
          .write(const CharactersCompanion(
        totalCount: Value(5),
        successCount: Value(3),
        failCount: Value(2),
      ));

      storage.resetStatsByName('Harry Potter');
      // resetStatsByName is fire-and-forget (void); give the DB a tick
      await Future<void>.delayed(Duration.zero);

      final updated = await storage.findByName('Harry Potter');
      expect(updated!.totalCount, 0);
      expect(updated.successCount, 0);
      expect(updated.failCount, 0);
    });

    test('does not affect other characters', () async {
      await storage.saveAll([makeEntity(id: '1', name: 'Harry'), makeEntity(id: '2', name: 'Ron')]);

      final harryRow = (await storage.findByName('Harry'))!;
      await (db.update(db.characters)..where((t) => t.id.equals(harryRow.id)))
          .write(const CharactersCompanion(
        totalCount: Value(4),
        successCount: Value(2),
        failCount: Value(2),
      ));

      storage.resetStatsByName('Harry');
      await Future<void>.delayed(Duration.zero);

      final ron = await storage.findByName('Ron');
      expect(ron!.totalCount, 0);
    });
  });

  group('resetAllStats', () {
    test('resets counts to zero for every character', () async {
      await storage.saveAll([makeEntity(id: '1', name: 'Harry'), makeEntity(id: '2', name: 'Ron')]);

      await db.update(db.characters).write(const CharactersCompanion(
            totalCount: Value(10),
            successCount: Value(6),
            failCount: Value(4),
          ));

      await storage.resetAllStats();

      final all = await storage.getAll();
      for (final row in all) {
        expect(row.totalCount, 0);
        expect(row.successCount, 0);
        expect(row.failCount, 0);
      }
    });
  });

  group('getTotalStats', () {
    test('returns zeros when database is empty', () async {
      final stats = await storage.getTotalStats();
      expect(stats, const InfoStatsEntity(totalCount: 0, successCount: 0, failCount: 0));
    });

    test('sums stats across all characters', () async {
      await storage.saveAll([makeEntity(id: '1', name: 'Harry'), makeEntity(id: '2', name: 'Ron')]);

      final rows = await storage.getAll();
      await (db.update(db.characters)..where((t) => t.id.equals(rows[0].id)))
          .write(const CharactersCompanion(
        totalCount: Value(3),
        successCount: Value(2),
        failCount: Value(1),
      ));
      await (db.update(db.characters)..where((t) => t.id.equals(rows[1].id)))
          .write(const CharactersCompanion(
        totalCount: Value(5),
        successCount: Value(1),
        failCount: Value(4),
      ));

      final stats = await storage.getTotalStats();
      expect(stats, const InfoStatsEntity(totalCount: 8, successCount: 3, failCount: 5));
    });
  });
}
