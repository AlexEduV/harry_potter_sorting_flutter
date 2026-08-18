import 'package:harry_potter_sorting_flutter/data/database/database_schema.dart';
import 'package:harry_potter_sorting_flutter/domain/entities/character_entity.dart';
import 'package:harry_potter_sorting_flutter/domain/entities/info_stats_entity.dart';

abstract class CharacterRepository {
  Future<List<CharacterEntity>> loadCharacters();

  Future<Character?> getCharacterByName(String name);

  Future<Character?> getCharacter();

  Future<void> resetCharacterAttemptsStatsByName(String name);

  Future<List<Character>> getAllSubmittedCharacters({String filter = ''});

  Future<InfoStatsEntity> getTotalStats();

  Future<void> resetAllCharactersAttemptsStats();
}
