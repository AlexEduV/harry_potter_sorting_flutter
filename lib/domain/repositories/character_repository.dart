
import 'package:flutter/cupertino.dart';
import 'package:harry_potter_sorting_flutter/data/database/database_schema.dart';
import 'package:harry_potter_sorting_flutter/domain/models/character_dto.dart';
import 'package:harry_potter_sorting_flutter/domain/models/character_entity.dart';
import 'package:harry_potter_sorting_flutter/domain/models/info_stats_entity.dart';

abstract class CharacterRepository {
  Future<List<CharacterDTO>> loadCharacters();
  CharacterEntity loadRandomCharacter(BuildContext context);
  Future<Character?> getCharacterByName(String name);
  Future<Character> getCharacter(BuildContext context);
  void resetCharacterAttemptsStats(String name);
  void mapCharacterToProviders(Character character, BuildContext context);

  Future<List<Character>> getAllSubmittedCharacters({String filter = ''});
  Future<InfoStatsEntity> getTotalStats();
  Future<void> resetAllCharactersAttemptsStats();
}
