import 'package:harry_potter_sorting_flutter/common/enums/house.dart';
import 'package:harry_potter_sorting_flutter/domain/entities/character_entity.dart';
import 'package:harry_potter_sorting_flutter/domain/entities/info_stats_entity.dart';
import 'package:harry_potter_sorting_flutter/domain/repositories/character_repository.dart';

class FakeCharacterRepository implements CharacterRepository {
  // Recorded call arguments for assertion
  String? lastResetName;
  String? lastGetAllFilter;

  // Configurable return values
  List<CharacterEntity> submittedCharacters = [];

  @override
  Future<List<CharacterEntity>> getAllSubmittedCharacters({String filter = ''}) {
    lastGetAllFilter = filter;
    return Future.value(submittedCharacters);
  }

  @override
  Future<void> resetCharacterAttemptsStatsByName(String name) async {
    lastResetName = name;
  }

  // Unused by tested use cases — minimal stubs
  @override
  Future<List<CharacterEntity>> loadCharacters() => Future.value([]);

  @override
  Future<CharacterEntity?> getCharacterByName(String name) => Future.value(null);

  @override
  Future<CharacterEntity> getCharacter() => throw UnimplementedError();

  @override
  Future<InfoStatsEntity> getTotalStats() =>
      Future.value(const InfoStatsEntity(totalCount: 0, successCount: 0, failCount: 0));

  @override
  Future<void> resetAllCharactersAttemptsStats() => Future.value();
}

CharacterEntity makeCharacter({
  String id = '1',
  String longId = 'abc',
  String name = 'Harry Potter',
  String imageSrc = 'https://example.com/harry.jpg',
  House house = House.gryffindor,
  String actor = 'Daniel Radcliffe',
  String species = 'human',
  String dateOfBirth = '31-07-1980',
  int successCount = 0,
  int failCount = 0,
  int totalCount = 0,
}) =>
    CharacterEntity(
      id: id,
      name: name,
      imageSrc: imageSrc,
      house: house,
      actor: actor,
      species: species,
      dateOfBirth: dateOfBirth,
      infoStatsEntity:
          InfoStatsEntity(totalCount: totalCount, successCount: successCount, failCount: failCount),
    );
