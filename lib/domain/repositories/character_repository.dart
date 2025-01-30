import 'package:flutter/cupertino.dart';
import 'package:harry_potter_sorting_flutter/data/database/database_schema.dart';
import 'package:harry_potter_sorting_flutter/domain/models/character_dto.dart';
import 'package:harry_potter_sorting_flutter/domain/models/info_stats_entity.dart';

abstract class CharacterRepository {
  Future<CharacterDTO> loadRandomCharacter();
  Future<Character?> getCharacterByName(String name);
  Future<Character> getCharacter(Character? selectedCharacter, BuildContext context);
  void resetCharacterAttemptsStats(String name);

  Future<List<Character>> getAllSubmittedCharacters({String filter = ''});
  Future<InfoStatsEntity> getTotalStats();
  void resetAllCharactersAttemptsStats();
}
