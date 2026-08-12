import 'dart:math';

import 'package:dio/dio.dart';
import 'package:drift/drift.dart';
import 'package:flutter/cupertino.dart';
import 'package:harry_potter_sorting_flutter/data/database/database_schema.dart';
import 'package:harry_potter_sorting_flutter/data/dto/character_dto.dart';
import 'package:harry_potter_sorting_flutter/data/services/character_api_service.dart';
import 'package:harry_potter_sorting_flutter/domain/entities/character_entity.dart';
import 'package:harry_potter_sorting_flutter/domain/entities/info_stats_entity.dart';
import 'package:harry_potter_sorting_flutter/domain/repositories/character_repository.dart';
import 'package:harry_potter_sorting_flutter/presentation/pages/home_page/nav_pages/home_nav_page/notifiers/character_cache_provider.dart';
import 'package:harry_potter_sorting_flutter/presentation/pages/home_page/nav_pages/home_nav_page/notifiers/character_notifier.dart';
import 'package:harry_potter_sorting_flutter/presentation/pages/home_page/nav_pages/home_nav_page/notifiers/character_stats_notifier.dart';
import 'package:harry_potter_sorting_flutter/presentation/pages/home_page/nav_pages/home_nav_page/notifiers/picker_color_notifier.dart';
import 'package:provider/provider.dart';

class CharacterRepositoryImpl implements CharacterRepository {
  final Dio client;
  final AppDatabase _database;

  CharacterRepositoryImpl(this.client, this._database);

  @override
  CharacterEntity loadRandomCharacter(BuildContext context) {
    try {
      final characters = context.read<CharacterCacheProvider>().characters;

      //get random character
      if (characters.isEmpty) {
        throw Exception('List is empty!');
      }

      final random = Random();
      int index = random.nextInt(characters.length);

      final result = characters[index];

      return CharacterEntity(
        id: result.id,
        name: result.name,
        imageSrc: result.imageSrc,
        house: result.house,
        dateOfBirth: result.dateOfBirth,
        actor: result.actor,
        species: result.species,
      );
    } catch (e) {
      throw Exception('Error while loading new character');
    }
  }

  @override
  Future<List<Character>> getAllSubmittedCharacters({String filter = ''}) async {
    final result = await _database.managers.characters.get();

    final filteredResult = filter.isNotEmpty
        ? result
            .where((character) => character.name.toLowerCase().contains(filter.toLowerCase()))
            .toList()
        : result;

    return filteredResult;
  }

  @override
  Future<Character> getCharacterByName(String name) async {
    final results = await _database.managers.characters.get();

    final result = results.firstWhere((character) => character.name == name);

    return result;
  }

  @override
  Future<Character> getCharacter(BuildContext context) async {
    final result = loadRandomCharacter(context);

    //load tries from the base or insert a new character
    Character? dbResult = await _database.managers.characters
        .filter((table) => table.name.equals(result.name))
        .getSingleOrNull();

    if (dbResult == null) {
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

      dbResult = Character(
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

    return dbResult;
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

    return InfoStatsEntity(
      totalCount: result.totalCount,
      successCount: result.successCount,
      failCount: result.failCount,
    );
  }

  @override
  void resetCharacterAttemptsStats(String name) {
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

  @override
  void mapCharacterToProviders(Character result, BuildContext context) {
    final character = CharacterEntity(
      id: result.longId,
      name: result.name,
      imageSrc: result.imageSrc,
      house: result.house,
      actor: result.actor,
      species: result.species,
      dateOfBirth: '',
    );

    final statsEntity = InfoStatsEntity(
      totalCount: result.totalCount,
      successCount: result.successCount,
      failCount: result.failCount,
    );

    context.read<CharacterNotifier>().updateCharacter(character);
    context.read<PickerColorNotifier>().resetColors();
    context.read<CharacterStatsNotifier>().updateAllCounts(statsEntity);
  }

  @override
  Future<List<CharacterDTO>> loadCharacters() async {
    final service = CharacterApiService(client);
    return await service.getAllCharacters();
  }
}
