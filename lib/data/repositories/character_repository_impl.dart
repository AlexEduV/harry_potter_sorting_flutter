import 'dart:math';

import 'package:drift/drift.dart';
import 'package:flutter/cupertino.dart';
import 'package:harry_potter_sorting_flutter/data/database/database_schema.dart';
import 'package:harry_potter_sorting_flutter/data/services/character_api_service.dart';
import 'package:harry_potter_sorting_flutter/domain/entities/character_entity.dart';
import 'package:harry_potter_sorting_flutter/domain/entities/info_stats_entity.dart';
import 'package:harry_potter_sorting_flutter/domain/repositories/character_repository.dart';

class CharacterRepositoryImpl implements CharacterRepository {
  final CharacterApiService _characterApiService;
  final AppDatabase _database;

  CharacterRepositoryImpl(this._characterApiService, this._database);

  @override
  Future<List<CharacterEntity>> loadCharacters() async {
    final results = await _characterApiService.getAllCharacters();
    return results.map((element) => CharacterEntity.fromDto(element)).toList();
  }

  @override
  Future<List<Character>> getAllSubmittedCharacters({String filter = ''}) async {
    final result = await _database.managers.characters.get();

    if (filter.isEmpty) return result;

    return result
        .where((character) => character.name.toLowerCase().contains(filter.toLowerCase()))
        .toList();
  }

  @override
  Future<Character?> getCharacterByName(String name) async {
    final results = await _database.managers.characters.get();
    return results.where((character) => character.name == name).firstOrNull;
  }

  @override
  Future<Character?> getCharacter() async {
    final results = await _database.managers.characters.get();
    final result = _loadRandomCharacter(
        results.map((element) => CharacterEntity.fromSchema(element)).toList());

    if (result == null) return null;
    //todo: add error state to provider;

    //load tries from the base or insert a new character
    Character? dbResult = await _database.managers.characters
        .filter((table) => table.name.equals(result.name))
        .getSingleOrNull();

    if (dbResult != null) return dbResult;

    //insert a new character
    await _database.into(_database.characters).insert(CharactersCompanion.insert(
          longId: result.id,
          name: result.name,
          imageSrc: result.imageSrc,
          house: result.house,
          actor: result.actor,
          species: result.species,
          dateOfBirth: result.dateOfBirth ?? '',
        ));

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

  CharacterEntity? _loadRandomCharacter(List<CharacterEntity> characters) {
    try {
      //get random character
      if (characters.isEmpty) {
        debugPrint('List is empty!');
        return null;
      }

      final random = Random();
      final index = random.nextInt(characters.length);
      return characters[index];
    } catch (e) {
      debugPrint('Error while loading new character: $e');
      return null;
    }
  }

  @override
  Future<InfoStatsEntity> getTotalStats() async {
    final result = await (_database.selectOnly(_database.characters)
          ..addColumns([
            _database.characters.totalCount.sum(),
            _database.characters.successCount.sum(),
            _database.characters.failCount.sum(),
          ]))
        .map((row) => (
              totalCount: row.read(_database.characters.totalCount.sum()) ?? 0,
              successCount: row.read(_database.characters.successCount.sum()) ?? 0,
              failCount: row.read(_database.characters.failCount.sum()) ?? 0,
            ))
        .getSingle();

    return InfoStatsEntity.fromSchemaResult(result);
  }

  @override
  void resetCharacterAttemptsStatsByName(String name) {
    _database.update(_database.characters)
      ..where((table) => table.name.equals(name))
      ..write(const CharactersCompanion(
        totalCount: Value(0),
        failCount: Value(0),
        successCount: Value(0),
      ));
  }

  @override
  Future<void> resetAllCharactersAttemptsStats() async {
    await _database.update(_database.characters).write(const CharactersCompanion(
          totalCount: Value(0),
          failCount: Value(0),
          successCount: Value(0),
        ));
  }
}
