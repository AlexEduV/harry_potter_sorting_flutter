import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:harry_potter_sorting_flutter/data/network/dio_client.dart';
import 'package:harry_potter_sorting_flutter/data/services/character_api_service.dart';
import 'package:harry_potter_sorting_flutter/domain/models/character_dto.dart';
import 'package:harry_potter_sorting_flutter/domain/repositories/home_page_repository.dart';

class HomePageRepositoryImpl implements HomePageRepository {

  @override
  Future<CharacterDTO> loadRandomCharacter(Dio client) async {

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

      return response[index];

    } on DioException catch (e) {
      DioClient.handleError(e);
      throw Exception('Error while loading new character');
    }

  }

}
