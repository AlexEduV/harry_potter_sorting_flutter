import 'package:flutter/cupertino.dart';
import 'package:harry_potter_sorting_flutter/domain/models/character_entity.dart';

class CharacterNotifier extends ChangeNotifier {

  CharacterEntity? _character;
  CharacterEntity? get character => _character;

  void updateCharacter(CharacterEntity character) {
    _character = character;
    notifyListeners();
  }

}
