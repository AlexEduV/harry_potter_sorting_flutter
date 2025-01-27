import 'package:harry_potter_sorting_flutter/data/network/dio_client.dart';
import 'package:harry_potter_sorting_flutter/domain/models/character.dart';

abstract class HomePageRepository {

  Future<Character> loadRandomCharacter(DioClient client);

}