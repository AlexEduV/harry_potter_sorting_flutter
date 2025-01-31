import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:harry_potter_sorting_flutter/core/di/dependency_injection.dart';
import 'package:harry_potter_sorting_flutter/data/network/dio_client.dart';
import 'package:harry_potter_sorting_flutter/data/repositories/character_repository_impl.dart';
import 'package:harry_potter_sorting_flutter/domain/models/character_dto.dart';

class CharacterCacheProvider extends ChangeNotifier {

  List<CharacterDTO> _characters = [];
  bool _isLoading = false;

  List<CharacterDTO> get characters => _characters;
  bool get isLoading => _isLoading;

  Future<void> loadCharacters() async {

    try {
      _isLoading = true;
      notifyListeners();

      _characters = await CharacterRepositoryImpl(getIt<Dio>()).loadCharacters();
    } catch(e) {
      debugPrint('Error fetching characters: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }

  }

}