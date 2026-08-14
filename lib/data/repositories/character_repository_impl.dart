import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:harry_potter_sorting_flutter/data/database/database_schema.dart';
import 'package:harry_potter_sorting_flutter/data/services/character_api_service.dart';
import 'package:harry_potter_sorting_flutter/domain/data_sources/local/character_local_storage.dart';
import 'package:harry_potter_sorting_flutter/domain/entities/character_entity.dart';
import 'package:harry_potter_sorting_flutter/domain/entities/info_stats_entity.dart';
import 'package:harry_potter_sorting_flutter/domain/repositories/character_repository.dart';

class CharacterRepositoryImpl implements CharacterRepository {
  final CharacterApiService _characterApiService;
  final CharacterLocalStorage _localStorage;

  CharacterRepositoryImpl(this._characterApiService, this._localStorage);

  List<CharacterEntity> _characters = [];

  @override
  Future<List<CharacterEntity>> loadCharacters() async {
    try {
      final results = await _characterApiService.getAllCharacters();
      _characters = results.map((element) => CharacterEntity.fromDto(element)).toList();
    } catch (e) {
      debugPrint('error loading characters: $e');
      return [];
    }
    return _characters;
  }

  @override
  Future<List<Character>> getAllSubmittedCharacters({String filter = ''}) async {
    final result = await _localStorage.getAll();

    if (filter.isEmpty) return result;

    return result
        .where((character) => character.name.toLowerCase().contains(filter.toLowerCase()))
        .toList();
  }

  @override
  Future<Character?> getCharacterByName(String name) => _localStorage.findByName(name);

  @override
  Future<Character?> getCharacter() async {
    final result = _loadRandomCharacter(_characters);
    if (result == null) return null;

    final existing = await _localStorage.findByName(result.name);
    if (existing != null) return existing;

    await _localStorage.insert(result);

    return Character(
      id: 0,
      longId: result.id,
      name: result.name,
      imageSrc: result.imageSrc,
      house: result.house,
      actor: result.actor,
      species: result.species,
      dateOfBirth: result.dateOfBirth ?? '',
      successCount: 0,
      failCount: 0,
      totalCount: 0,
    );
  }

  @override
  Future<InfoStatsEntity> getTotalStats() => _localStorage.getTotalStats();

  @override
  void resetCharacterAttemptsStatsByName(String name) => _localStorage.resetStatsByName(name);

  @override
  Future<void> resetAllCharactersAttemptsStats() => _localStorage.resetAllStats();

  CharacterEntity? _loadRandomCharacter(List<CharacterEntity> characters) {
    if (characters.isEmpty) {
      debugPrint('List is empty!');
      return null;
    }

    return characters[Random().nextInt(characters.length)];
  }
}
