import 'package:harry_potter_sorting_flutter/data/services/character_api_service.dart';
import 'package:harry_potter_sorting_flutter/domain/data_sources/local/character_local_storage.dart';
import 'package:harry_potter_sorting_flutter/domain/entities/character_entity.dart';
import 'package:harry_potter_sorting_flutter/domain/entities/info_stats_entity.dart';
import 'package:harry_potter_sorting_flutter/domain/mappers/character_dto_mapper.dart';
import 'package:harry_potter_sorting_flutter/domain/mappers/character_schema_mapper.dart';
import 'package:harry_potter_sorting_flutter/domain/repositories/character_repository.dart';

class CharacterRepositoryImpl implements CharacterRepository {
  final CharacterApiService _characterApiService;
  final CharacterLocalStorage _localStorage;

  CharacterRepositoryImpl(this._characterApiService, this._localStorage);

  @override
  Future<List<CharacterEntity>> loadCharacters() async {
    final cachedCharacters = await _localStorage.getAll();
    if (cachedCharacters.isNotEmpty) {
      return cachedCharacters.map((element) => element.toEntity()).toList();
    }

    final results = await _characterApiService.getAllCharacters();
    final characters = results.map((e) => e.toEntity()).toList();
    await _localStorage.saveAll(characters);
    return characters;
  }

  @override
  Future<List<CharacterEntity>> filterCharactersByName({String name = ''}) async {
    final result = await _localStorage.filterCharactersByName(name);
    return result.map((element) => element.toEntity()).toList();
  }

  @override
  Future<CharacterEntity?> getCharacterByName(String name) async {
    final result = await _localStorage.findByName(name);
    if (result == null) return null;

    return result.toEntity();
  }

  @override
  Future<CharacterEntity?> getCharacter() async {
    final randomCharacter = await _localStorage.getRandomCharacter();
    if (randomCharacter == null) return null;

    return randomCharacter.toEntity();
  }

  @override
  Future<void> updateStatsByName(String name, InfoStatsEntity stats) =>
      _localStorage.updateStatsByName(name, stats);

  @override
  Future<InfoStatsEntity> getTotalStats() => _localStorage.getTotalStats();

  @override
  Future<void> resetCharacterAttemptsStatsByName(String name) =>
      _localStorage.resetStatsByName(name);

  @override
  Future<void> resetAllCharactersAttemptsStats() => _localStorage.resetAllStats();
}
