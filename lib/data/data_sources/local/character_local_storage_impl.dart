import 'package:drift/drift.dart';
import 'package:harry_potter_sorting_flutter/data/database/database_schema.dart';
import 'package:harry_potter_sorting_flutter/domain/data_sources/local/character_local_storage.dart';
import 'package:harry_potter_sorting_flutter/domain/entities/character_entity.dart';
import 'package:harry_potter_sorting_flutter/domain/entities/info_stats_entity.dart';

class CharacterLocalStorageImpl implements CharacterLocalStorage {
  final AppDatabase _database;

  CharacterLocalStorageImpl(this._database);

  @override
  Future<List<Character>> getAll() => _database.managers.characters.get();

  @override
  Future<void> delete(int id) => _database.managers.characters.filter((f) => f.id(id)).delete();

  @override
  Future<Character?> findByName(String name) async {
    final results = await _database.managers.characters.filter((f) => f.name.equals(name)).get();
    return results.firstOrNull;
  }

  @override
  Future<void> saveAll(List<CharacterEntity> entities) async {
    final existing = (await getAll()).map((c) => c.longId).toSet();
    final newEntities = entities.where((e) => !existing.contains(e.id)).toList();

    if (newEntities.isEmpty) return;

    await _database.batch((batch) => batch.insertAll(
          _database.characters,
          newEntities.map((e) => CharactersCompanion.insert(
                longId: e.id,
                name: e.name,
                imageSrc: e.imageSrc,
                house: e.house.displayName,
                actor: e.actor,
                species: e.species,
                dateOfBirth: e.dateOfBirth ?? '',
              )),
        ));
  }

  @override
  Future<void> insert(CharacterEntity entity) =>
      _database.into(_database.characters).insert(CharactersCompanion.insert(
            longId: entity.id,
            name: entity.name,
            imageSrc: entity.imageSrc,
            house: entity.house.displayName,
            actor: entity.actor,
            species: entity.species,
            dateOfBirth: entity.dateOfBirth ?? '',
          ));

  @override
  Future<void> resetStatsByName(String name) async {
    _database.update(_database.characters)
      ..where((table) => table.name.equals(name))
      ..write(const CharactersCompanion(
        totalCount: Value(0),
        failCount: Value(0),
        successCount: Value(0),
      ));
  }

  @override
  Future<void> resetAllStats() =>
      _database.update(_database.characters).write(const CharactersCompanion(
            totalCount: Value(0),
            failCount: Value(0),
            successCount: Value(0),
          ));

  @override
  Future<InfoStatsEntity> getTotalStats() async {
    final result = await (_database.selectOnly(_database.characters)
          ..addColumns([
            _database.characters.totalCount.sum(),
            _database.characters.successCount.sum(),
            _database.characters.failCount.sum(),
          ]))
        .map((row) => (
              totalCount: row.read(_database.characters.totalCount.sum()) ?? 0,
              successCount: row.read(_database.characters.successCount.sum()) ?? 0,
              failCount: row.read(_database.characters.failCount.sum()) ?? 0,
            ))
        .getSingle();

    return InfoStatsEntity.fromSchemaResult(result);
  }

  @override
  Future<void> updateStatsByName(String name, InfoStatsEntity stats) async {
    _database.update(_database.characters)
      ..where((table) => table.name.equals(name))
      ..write(CharactersCompanion(
        totalCount: Value(stats.totalCount),
        failCount: Value(stats.failCount),
        successCount: Value(stats.successCount),
      ));
  }

  @override
  Future<Character?> getRandomCharacter() {
    return (_database.select(_database.characters)
          ..orderBy([(t) => OrderingTerm.random()])
          ..limit(1))
        .getSingleOrNull();
  }
}
