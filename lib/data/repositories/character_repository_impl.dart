import 'package:flutter/foundation.dart';
import 'package:harry_potter_sorting_flutter/data/services/character_api_service.dart';
import 'package:harry_potter_sorting_flutter/domain/data_sources/local/character_local_storage.dart';
import 'package:harry_potter_sorting_flutter/domain/entities/character_entity.dart';
import 'package:harry_potter_sorting_flutter/domain/entities/info_stats_entity.dart';
import 'package:harry_potter_sorting_flutter/domain/repositories/character_repository.dart';

class CharacterRepositoryImpl implements CharacterRepository {
  final CharacterApiService _characterApiService;
  final CharacterLocalStorage _localStorage;

  CharacterRepositoryImpl(this._characterApiService, this._localStorage);

  @override
  Future<List<CharacterEntity>> loadCharacters() async {
    try {
      final results = await _characterApiService.getAllCharacters();
      final characters = results.map((e) => CharacterEntity.fromDto(e)).toList();
      await _localStorage.saveAll(characters);
      return characters;
    } catch (e) {
      debugPrint('error loading characters: $e');
      return [];
    }
  }

  @override
  Future<List<CharacterEntity>> filterCharactersByName({String name = ''}) async {
    final result = await _localStorage.filterCharactersByName(name);
    return result.map((element) => CharacterEntity.fromSchema(element)).toList();
  }

  @override
  Future<CharacterEntity?> getCharacterByName(String name) async {
    final result = await _localStorage.findByName(name);
    if (result == null) return null;

    return CharacterEntity.fromSchema(result);
  }

  @override
  Future<CharacterEntity?> getCharacter() async {
    final randomCharacter = await _localStorage.getRandomCharacter();
    if (randomCharacter == null) return null;

    return CharacterEntity.fromSchema(randomCharacter);
  }

  @override
  Future<InfoStatsEntity> getTotalStats() => _localStorage.getTotalStats();

  @override
  Future<void> resetCharacterAttemptsStatsByName(String name) =>
      _localStorage.resetStatsByName(name);

  @override
  Future<void> resetAllCharactersAttemptsStats() => _localStorage.resetAllStats();
}
