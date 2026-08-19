import 'package:flutter/material.dart';
import 'package:harry_potter_sorting_flutter/domain/entities/character_entity.dart';
import 'package:harry_potter_sorting_flutter/domain/repositories/character_repository.dart';

class CharacterCacheProvider extends ChangeNotifier {
  final CharacterRepository _characterRepository;

  CharacterCacheProvider(this._characterRepository);

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _hasError = false;
  bool get hasError => _hasError;

  Future<void> loadCharacters() async {
    try {
      _isLoading = true;
      _hasError = false;
      notifyListeners();

      await _characterRepository.loadCharacters();
    } catch (e) {
      debugPrint('Error fetching characters: $e');
      _hasError = true;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<CharacterEntity?> getNextCharacter() => _characterRepository.getCharacter();
}
