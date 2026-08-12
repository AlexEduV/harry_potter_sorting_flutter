import 'package:flutter/material.dart';
import 'package:harry_potter_sorting_flutter/core/di/dependency_injection.dart';
import 'package:harry_potter_sorting_flutter/data/dto/character_dto.dart';
import 'package:harry_potter_sorting_flutter/domain/repositories/character_repository.dart';

class CharacterCacheProvider extends ChangeNotifier {
  List<CharacterDTO> _characters = [];
  bool _isLoading = false;

  List<CharacterDTO> get characters => _characters;
  bool get isLoading => _isLoading;

  Future<void> loadCharacters() async {
    try {
      _isLoading = true;
      notifyListeners();

      _characters = await getIt<CharacterRepository>().loadCharacters();
    } catch (e) {
      debugPrint('Error fetching characters: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
