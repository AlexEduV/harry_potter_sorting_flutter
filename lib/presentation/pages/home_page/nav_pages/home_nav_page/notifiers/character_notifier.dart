import 'package:flutter/cupertino.dart';
import 'package:harry_potter_sorting_flutter/data/database/database_schema.dart';
import 'package:harry_potter_sorting_flutter/domain/models/character_dto.dart';

class CharacterNotifier extends ChangeNotifier {
  Character? _selectedCharacter;
  Character? get selectedCharacter => _selectedCharacter;

  CharacterDTO? _character;
  CharacterDTO? get character => _character;

  void selectCharacter(Character? character) {
    _selectedCharacter = character;
    notifyListeners();
  }

  void clearSelection() {
    _selectedCharacter = null;
  }

  void updateCharacter(CharacterDTO character) {
    _character = character;
    notifyListeners();
  }

}
