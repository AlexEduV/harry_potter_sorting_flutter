import 'package:flutter/material.dart';
import 'package:harry_potter_sorting_flutter/domain/repositories/character_repository.dart';

class CharacterCacheProvider extends ChangeNotifier {
  final CharacterRepository _characterRepository;

  CharacterCacheProvider(this._characterRepository);

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<void> loadCharacters() async {
    try {
      _isLoading = true;
      notifyListeners();

      await _characterRepository.loadCharacters();
    } catch (e) {
      debugPrint('Error fetching characters: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
