import 'package:harry_potter_sorting_flutter/data/database/database_schema.dart';
import 'package:harry_potter_sorting_flutter/domain/data_sources/local/base_local_storage.dart';
import 'package:harry_potter_sorting_flutter/domain/entities/character_entity.dart';
import 'package:harry_potter_sorting_flutter/domain/entities/info_stats_entity.dart';

abstract class CharacterLocalStorage extends BaseLocalStorage<Character> {
  Future<Character?> findByName(String name);

  Future<List<Character>> filterCharactersByName(String name);

  Future<void> insert(CharacterEntity entity);

  Future<void> saveAll(List<CharacterEntity> entities);

  Future<void> updateStatsByName(String name, InfoStatsEntity stats);

  Future<void> resetStatsByName(String name);

  Future<void> resetAllStats();

  Future<InfoStatsEntity> getTotalStats();

  Future<Character?> getRandomCharacter();
}
