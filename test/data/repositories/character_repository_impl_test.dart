import 'package:flutter_test/flutter_test.dart';
import 'package:harry_potter_sorting_flutter/common/enums/house.dart';
import 'package:harry_potter_sorting_flutter/data/database/database_schema.dart';
import 'package:harry_potter_sorting_flutter/data/dto/character_dto.dart';
import 'package:harry_potter_sorting_flutter/data/repositories/character_repository_impl.dart';
import 'package:harry_potter_sorting_flutter/data/services/character_api_service.dart';
import 'package:harry_potter_sorting_flutter/domain/data_sources/local/character_local_storage.dart';
import 'package:harry_potter_sorting_flutter/domain/entities/character_entity.dart';
import 'package:harry_potter_sorting_flutter/domain/entities/info_stats_entity.dart';

// ---------------------------------------------------------------------------
// Fakes
// ---------------------------------------------------------------------------

class FakeCharacterApiService implements CharacterApiService {
  List<CharacterDto> response = [];
  bool shouldThrow = false;

  @override
  Future<List<CharacterDto>> getAllCharacters() async {
    if (shouldThrow) throw Exception('network error');
    return response;
  }
}

class FakeCharacterLocalStorage implements CharacterLocalStorage {
  List<Character> stored = [];
  String? lastFilterName;
  String? lastResetName;
  bool resetAllCalled = false;

  @override
  Future<List<Character>> getAll() async => stored;

  @override
  Future<List<Character>> filterCharactersByName(String name) async {
    lastFilterName = name;
    return stored.where((c) => c.name.contains(name)).toList();
  }

  @override
  Future<Character?> findByName(String name) async =>
      stored.where((c) => c.name == name).firstOrNull;

  @override
  Future<Character?> getRandomCharacter() async => stored.firstOrNull;

  @override
  Future<void> saveAll(List<CharacterEntity> entities) async {
    for (final e in entities) {
      stored.add(_entityToCharacter(e));
    }
  }

  @override
  Future<void> insert(CharacterEntity entity) async => stored.add(_entityToCharacter(entity));

  @override
  Future<void> delete(int id) async => stored.removeWhere((c) => c.id == id);

  @override
  Future<void> resetStatsByName(String name) async => lastResetName = name;

  @override
  Future<void> resetAllStats() async => resetAllCalled = true;

  @override
  Future<void> updateStatsByName(String name, InfoStatsEntity stats) async {}

  @override
  Future<InfoStatsEntity> getTotalStats() async =>
      const InfoStatsEntity(totalCount: 0, successCount: 0, failCount: 0);
}

// ---------------------------------------------------------------------------
// Helpers
// ---------------------------------------------------------------------------

Character _entityToCharacter(CharacterEntity e, {int id = 1}) => Character(
      id: id,
      longId: e.id,
      name: e.name,
      imageSrc: e.imageSrc,
      house: e.house.displayName,
      actor: e.actor,
      species: e.species,
      dateOfBirth: e.dateOfBirth ?? '',
      successCount: 0,
      failCount: 0,
      totalCount: 0,
    );

CharacterDto makeDto({
  String id = '1',
  String name = 'Harry Potter',
  String house = 'Gryffindor',
}) =>
    CharacterDto(
      id: id,
      name: name,
      imageSrc: 'https://example.com/$id.jpg',
      house: house,
      actor: 'Daniel Radcliffe',
      species: 'human',
    );

Character makeCharacter({
  int id = 1,
  String longId = '1',
  String name = 'Harry Potter',
  String house = 'Gryffindor',
}) =>
    Character(
      id: id,
      longId: longId,
      name: name,
      imageSrc: 'https://example.com/$longId.jpg',
      house: house,
      actor: 'Daniel Radcliffe',
      species: 'human',
      dateOfBirth: '31-07-1980',
      successCount: 0,
      failCount: 0,
      totalCount: 0,
    );

// ---------------------------------------------------------------------------
// Tests
// ---------------------------------------------------------------------------

void main() {
  late FakeCharacterApiService api;
  late FakeCharacterLocalStorage storage;
  late CharacterRepositoryImpl repository;

  setUp(() {
    api = FakeCharacterApiService();
    storage = FakeCharacterLocalStorage();
    repository = CharacterRepositoryImpl(api, storage);
  });

  group('loadCharacters', () {
    test('returns cached entities without calling the API when cache is non-empty', () async {
      storage.stored = [makeCharacter()];
      api.response = [makeDto(id: '99', name: 'Should not appear')];

      final result = await repository.loadCharacters();

      expect(result, hasLength(1));
      expect(result.first.name, 'Harry Potter');
      expect(storage.stored, hasLength(1)); // saveAll was not called
    });

    test('fetches from API and saves to storage when cache is empty', () async {
      api.response = [makeDto(id: '1', name: 'Harry Potter')];

      final result = await repository.loadCharacters();

      expect(result, hasLength(1));
      expect(result.first.name, 'Harry Potter');
      expect(storage.stored, hasLength(1));
    });

    test('maps DTOs to CharacterEntity with correct house', () async {
      api.response = [makeDto(house: 'Slytherin')];

      final result = await repository.loadCharacters();

      expect(result.first.house, House.slytherin);
    });

    test('returns empty list when cache is empty and API throws', () async {
      api.shouldThrow = true;

      final result = await repository.loadCharacters();

      expect(result, isEmpty);
    });

    test('does not write to storage when API throws', () async {
      api.shouldThrow = true;

      await repository.loadCharacters();

      expect(storage.stored, isEmpty);
    });
  });

  group('filterCharactersByName', () {
    test('delegates filter to storage', () async {
      storage.stored = [makeCharacter(name: 'Harry Potter')];

      await repository.filterCharactersByName(name: 'Harry');

      expect(storage.lastFilterName, 'Harry');
    });

    test('maps storage results to CharacterEntity', () async {
      storage.stored = [makeCharacter(name: 'Harry Potter', house: 'Gryffindor')];

      final result = await repository.filterCharactersByName(name: 'Harry');

      expect(result, hasLength(1));
      expect(result.first, isA<CharacterEntity>());
      expect(result.first.house, House.gryffindor);
    });

    test('returns empty list when no match', () async {
      final result = await repository.filterCharactersByName(name: 'Nobody');

      expect(result, isEmpty);
    });
  });

  group('getCharacterByName', () {
    test('returns mapped entity when character exists', () async {
      storage.stored = [makeCharacter(name: 'Harry Potter')];

      final result = await repository.getCharacterByName('Harry Potter');

      expect(result, isNotNull);
      expect(result!.name, 'Harry Potter');
    });

    test('returns null when character does not exist', () async {
      final result = await repository.getCharacterByName('Nobody');

      expect(result, isNull);
    });
  });

  group('getCharacter', () {
    test('returns mapped entity when storage returns a character', () async {
      storage.stored = [makeCharacter(name: 'Harry Potter')];

      final result = await repository.getCharacter();

      expect(result, isNotNull);
      expect(result!.name, 'Harry Potter');
    });

    test('returns null when storage is empty', () async {
      final result = await repository.getCharacter();

      expect(result, isNull);
    });
  });

  group('resetCharacterAttemptsStatsByName', () {
    test('delegates name to storage', () async {
      await repository.resetCharacterAttemptsStatsByName('Harry Potter');

      expect(storage.lastResetName, 'Harry Potter');
    });
  });

  group('resetAllCharactersAttemptsStats', () {
    test('delegates to storage', () async {
      await repository.resetAllCharactersAttemptsStats();

      expect(storage.resetAllCalled, isTrue);
    });
  });

  group('getTotalStats', () {
    test('delegates to storage', () async {
      final result = await repository.getTotalStats();

      expect(result, const InfoStatsEntity(totalCount: 0, successCount: 0, failCount: 0));
    });
  });
}
