import 'package:flutter/material.dart';
import 'package:harry_potter_sorting_flutter/domain/entities/character_entity.dart';
import 'package:harry_potter_sorting_flutter/domain/repositories/character_repository.dart';

class CharacterCacheProvider extends ChangeNotifier {
  final CharacterRepository _characterRepository;

  CharacterCacheProvider(this._characterRepository);

  //todo: dto in provider;
  List<CharacterEntity> _characters = [];
  bool _isLoading = false;

  List<CharacterEntity> get characters => _characters;
  bool get isLoading => _isLoading;

  Future<void> loadCharacters() async {
    try {
      _isLoading = true;
      notifyListeners();

      _characters = await _characterRepository.loadCharacters();
    } catch (e) {
      debugPrint('Error fetching characters: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
