import 'package:harry_potter_sorting_flutter/domain/entities/character_entity.dart';
import 'package:harry_potter_sorting_flutter/domain/entities/info_stats_entity.dart';

abstract class CharacterRepository {
  Future<List<CharacterEntity>> loadCharacters();

  Future<CharacterEntity?> getCharacterByName(String name);

  Future<CharacterEntity?> getCharacter();

  Future<void> resetCharacterAttemptsStatsByName(String name);

  Future<List<CharacterEntity>> filterCharactersByName({String name = ''});

  Future<InfoStatsEntity> getTotalStats();

  Future<void> resetAllCharactersAttemptsStats();
}
