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
import 'package:harry_potter_sorting_flutter/presentation/pages/home_page/nav_pages/home_nav_page/notifiers/character_notifier.dart';
import 'package:harry_potter_sorting_flutter/presentation/pages/home_page/nav_pages/home_nav_page/notifiers/character_stats_notifier.dart';
import 'package:provider/provider.dart';

class CharacterRepositoryImpl implements CharacterRepository {

  final Dio client;

  CharacterRepositoryImpl(this.client);

  @override
  Future<CharacterDTO> loadRandomCharacter() async {

    try {

      debugPrint('New service');

      final service = CharacterApiService(client);
      final List<CharacterDTO> response = await service.getAllCharacters();

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
  Future<Character> getCharacter(Character? selectedCharacter, BuildContext context) async {
    if (selectedCharacter != null) {
      //clear the selection
      context.read<CharacterNotifier>().selectCharacter(null);

      return selectedCharacter;
    }
    else {

      final result = await loadRandomCharacter();

      //load tries from the base or insert a new character
      Character? dbResult = await DatabaseProvider.getDatabase().managers.characters.filter((table) => table.name.equals(result.name)).getSingleOrNull();
      if (dbResult == null) {

        final totalCount = context.read<CharacterStatsNotifier>().totalCount;
        final successCount = context.read<CharacterStatsNotifier>().successCount;
        final failedCount = context.read<CharacterStatsNotifier>().failedCount;

        //insert a new character
        await DatabaseProvider.getDatabase().into(DatabaseProvider.getDatabase().characters).insert(

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
          successCount: successCount,
          failCount: failedCount,
          totalCount: totalCount,
        );
      }

      return dbResult;
    }
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
  void resetAllCharactersAttemptsStats() {

    final database = DatabaseProvider.getDatabase();

    database.update(database.characters)
      .write(const CharactersCompanion(
        totalCount: Value(0),
        failCount: Value(0),
        successCount: Value(0),
      ));

  }

}
