import 'dart:math' show Random;

import 'package:flutter/foundation.dart';
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
    final all = await _localStorage.getAll();
    if (all.isEmpty) return null;
    return all[Random().nextInt(all.length)];
  }

  @override
  Future<InfoStatsEntity> getTotalStats() => _localStorage.getTotalStats();

  @override
  void resetCharacterAttemptsStatsByName(String name) => _localStorage.resetStatsByName(name);

  @override
  Future<void> resetAllCharactersAttemptsStats() => _localStorage.resetAllStats();
}
