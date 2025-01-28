import 'package:dio/dio.dart';
import 'package:harry_potter_sorting_flutter/domain/models/character_dto.dart';
import 'package:retrofit/error_logger.dart';
import 'package:retrofit/http.dart';

part 'character_api_service.g.dart';

const randomUserEndPoint = 'https://hp-api.onrender.com/api';

@RestApi(baseUrl: randomUserEndPoint)
abstract class CharacterApiService {
  factory CharacterApiService(Dio dio, {String baseUrl}) = _CharacterApiService;

  @GET('/characters')
  Future<List<CharacterDTO>> getAllCharacters();

}
