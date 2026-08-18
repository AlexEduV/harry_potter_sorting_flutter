import 'package:flutter/cupertino.dart';
import 'package:harry_potter_sorting_flutter/domain/entities/character_entity.dart';
import 'package:harry_potter_sorting_flutter/domain/repositories/character_repository.dart';

class DetailCharacterNotifier extends ChangeNotifier {
  final CharacterRepository _characterRepository;

  DetailCharacterNotifier(this._characterRepository);

  CharacterEntity? _character;

  CharacterEntity? get character => _character;

  void setCharacter(String name) async {
    final character = await _characterRepository.getCharacterByName(name);
    _character = character;

    notifyListeners();
  }
}
