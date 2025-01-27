import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:harry_potter_sorting_flutter/data/network/dio_client.dart';
import 'package:harry_potter_sorting_flutter/domain/models/character.dart';
import 'package:harry_potter_sorting_flutter/domain/repositories/home_page_repository.dart';

class HomePageRepositoryImpl implements HomePageRepository {

  final randomCharacterEndPoint = 'https://hp-api.onrender.com/api/characters/students';

  @override
  Future<Character> loadRandomCharacter(DioClient client) async {

    try {

      final UserApiService service = UserApiService(client);
      final Character response = await service.getRandomUser();

      debugPrint(response.toString());

      if (response.results.isNotEmpty) {
        GlobalMockStorage.user = response.results.first;
      }

    } on DioException catch (e) {
      DioClient.handleError(e);
    }

    return '';

  }

}