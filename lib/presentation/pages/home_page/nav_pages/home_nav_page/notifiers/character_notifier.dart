import 'package:flutter/cupertino.dart';
import 'package:harry_potter_sorting_flutter/domain/entities/character_entity.dart';
import 'package:harry_potter_sorting_flutter/domain/repositories/character_repository.dart';

class CharacterNotifier extends ChangeNotifier {
  final CharacterRepository _characterRepository;

  CharacterNotifier(this._characterRepository);

  CharacterEntity? _character;

  CharacterEntity? get character => _character;

  void updateCharacter(CharacterEntity character) {
    _character = character;
    notifyListeners();
  }

  Future<void> loadNextCharacter() async {
    final character = await _characterRepository.getCharacter();
    if (character == null) return;

    updateCharacter(character);
  }
}
