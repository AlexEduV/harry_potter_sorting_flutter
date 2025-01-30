import 'dart:math';

import 'package:dio/dio.dart';
import 'package:drift/drift.dart';
import 'package:flutter/cupertino.dart';
import 'package:harry_potter_sorting_flutter/data/database/database_provider.dart';
import 'package:harry_potter_sorting_flutter/data/database/database_schema.dart';
import 'package:harry_potter_sorting_flutter/data/network/dio_client.dart';
import 'package:harry_potter_sorting_flutter/data/services/character_api_service.dart';
import 'package:harry_potter_sorting_flutter/domain/models/character_dto.dart';
import 'package:harry_potter_sorting_flutter/domain/models/info_stats_entity.dart';
import 'package:harry_potter_sorting_flutter/domain/repositories/character_repository.dart';
import 'package:harry_potter_sorting_flutter/presentation/pages/home_page/nav_pages/home_nav_page/notifiers/character_cache_provider.dart';
import 'package:harry_potter_sorting_flutter/presentation/pages/home_page/nav_pages/home_nav_page/notifiers/character_notifier.dart';
import 'package:harry_potter_sorting_flutter/presentation/pages/home_page/nav_pages/home_nav_page/notifiers/character_stats_notifier.dart';
import 'package:harry_potter_sorting_flutter/presentation/pages/home_page/nav_pages/home_nav_page/notifiers/picker_color_notifier.dart';
import 'package:provider/provider.dart';

class CharacterRepositoryImpl implements CharacterRepository {

  final Dio client;

  CharacterRepositoryImpl(this.client);

  @override
  CharacterDTO loadRandomCharacter(BuildContext context) {

    try {

      final response = context.read<CharacterCacheProvider>().characters;

      //get random character
      if (response.isEmpty) {
        throw Exception('List is empty!');
      }

      final random = Random();
      int index = random.nextInt(response.length);

      //todo: use entity here, not dto objects
      return response[index];

    } on DioException catch (e) {
      DioClient.handleError(e);
      throw Exception('Error while loading new character');
    }

  }

  @override
  Future<List<Character>> getAllSubmittedCharacters({String filter = ''}) async {

    final result = await DatabaseProvider.getDatabase().managers.characters.get();

    final filteredResult = filter.isNotEmpty
        ? result.where((character) =>
        character.name.toLowerCase().contains(filter.toLowerCase()))
        .toList()
        : result;

    return filteredResult;
  }

  @override
  Future<Character> getCharacterByName(String name) async {

    final results = await DatabaseProvider.getDatabase().managers.characters.get();

    final result = results.firstWhere((character) => character.name == name);

    return result;

  }

  @override
  Future<Character> getCharacter(BuildContext context) async {

    final result = loadRandomCharacter(context);

    final database = DatabaseProvider.getDatabase();

    //load tries from the base or insert a new character
    Character? dbResult = await database.managers
        .characters.filter((table) => table.name.equals(result.name))
        .getSingleOrNull();

    if (dbResult == null) {

      //insert a new character
      await database.into(database.characters).insert(

          CharactersCompanion.insert(
            longId: result.id,
            name: result.name,
            imageSrc: result.imageSrc,
            house: result.house,
            actor: result.actor,
            species: result.species,
            dateOfBirth: result.dateOfBirth ?? '',
          )
      );

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

    final database = DatabaseProvider.getDatabase();

    final result = await (database.selectOnly(database.characters)
        ..addColumns([
          database.characters.totalCount.sum(),
          database.characters.successCount.sum(),
          database.characters.failCount.sum(),
        ]))
    .map((row) => (
      totalCount: row.read(database.characters.totalCount.sum()) ?? 0,
      successCount: row.read(database.characters.successCount.sum()) ?? 0,
      failCount: row.read(database.characters.failCount.sum()) ?? 0,
    )).getSingle();

    return InfoStatsEntity(
      totalCount: result.totalCount,
      successCount: result.successCount,
      failCount: result.failCount,
    );

  }

  @override
  void resetCharacterAttemptsStats(String name) {
    //update database values for the character
    final database = DatabaseProvider.getDatabase();

    database.update(database.characters)
      ..where((table) => table.name.equals(name))
      ..write(const CharactersCompanion(
        totalCount: Value(0),
        failCount: Value(0),
        successCount: Value(0),
      ));
  }

  @override
  Future<void> resetAllCharactersAttemptsStats() async {

    final database = DatabaseProvider.getDatabase();

    await database.update(database.characters)
      .write(const CharactersCompanion(
        totalCount: Value(0),
        failCount: Value(0),
        successCount: Value(0),
      ));

  }

  @override
  void mapCharacterToProviders(Character result, BuildContext context) {

    final character = CharacterDTO(
      id: result.longId,
      name: result.name,
      imageSrc: result.imageSrc,
      house: result.house,
      actor: result.actor,
      species: result.species,
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
