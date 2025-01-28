import 'package:dio/dio.dart';
import 'package:harry_potter_sorting_flutter/domain/models/character_dto.dart';

abstract class CharacterRepository {
  Future<CharacterDTO?> loadRandomCharacter(Dio client);
}