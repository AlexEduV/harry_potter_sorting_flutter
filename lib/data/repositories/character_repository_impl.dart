import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:harry_potter_sorting_flutter/data/database/database_provider.dart';
import 'package:harry_potter_sorting_flutter/data/database/database_schema.dart';
import 'package:harry_potter_sorting_flutter/data/network/dio_client.dart';
import 'package:harry_potter_sorting_flutter/data/services/character_api_service.dart';
import 'package:harry_potter_sorting_flutter/domain/models/character_dto.dart';
import 'package:harry_potter_sorting_flutter/domain/repositories/character_repository.dart';

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
      
      final character = response[index];
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

}
