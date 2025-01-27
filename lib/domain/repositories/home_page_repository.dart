import 'package:dio/dio.dart';
import 'package:harry_potter_sorting_flutter/domain/models/character.dart';

abstract class HomePageRepository {
  Future<Character?> loadRandomCharacter(Dio client);
}