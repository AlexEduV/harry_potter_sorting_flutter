import 'package:flutter/cupertino.dart';
import 'package:harry_potter_sorting_flutter/data/database/database_schema.dart';
import 'package:harry_potter_sorting_flutter/data/dto/character_dto.dart';
import 'package:harry_potter_sorting_flutter/domain/entities/character_entity.dart';
import 'package:harry_potter_sorting_flutter/domain/entities/info_stats_entity.dart';
import 'package:harry_potter_sorting_flutter/domain/repositories/character_repository.dart';

class FakeCharacterRepository implements CharacterRepository {
  // Recorded call arguments for assertion
  String? lastResetName;
  String? lastGetAllFilter;

  // Configurable return values
  List<Character> submittedCharacters = [];

  @override
  Future<List<Character>> getAllSubmittedCharacters({String filter = ''}) {
    lastGetAllFilter = filter;
    return Future.value(submittedCharacters);
  }

  @override
  void resetCharacterAttemptsStats(String name) {
    lastResetName = name;
  }

  // Unused by tested use cases — minimal stubs
  @override
  Future<List<CharacterDTO>> loadCharacters() => Future.value([]);

  @override
  CharacterEntity loadRandomCharacter(BuildContext context) =>
      throw UnimplementedError();

  @override
  Future<Character?> getCharacterByName(String name) => Future.value(null);

  @override
  Future<Character> getCharacter(BuildContext context) =>
      throw UnimplementedError();

  @override
  void mapCharacterToProviders(Character character, BuildContext context) {}

  @override
  Future<InfoStatsEntity> getTotalStats() =>
      Future.value(const InfoStatsEntity(totalCount: 0, successCount: 0, failCount: 0));

  @override
  Future<void> resetAllCharactersAttemptsStats() => Future.value();
}

Character makeCharacter({
  int id = 1,
  String longId = 'abc',
  String name = 'Harry Potter',
  String imageSrc = 'https://example.com/harry.jpg',
  String house = 'Gryffindor',
  String actor = 'Daniel Radcliffe',
  String species = 'human',
  String dateOfBirth = '31-07-1980',
  int successCount = 0,
  int failCount = 0,
  int totalCount = 0,
}) =>
    Character(
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
    );
