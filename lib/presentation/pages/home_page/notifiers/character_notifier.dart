import 'package:flutter/cupertino.dart';
import 'package:harry_potter_sorting_flutter/data/database/database_schema.dart';

class CharacterNotifier extends ChangeNotifier {
  Character? _selectedCharacter;
  Character? get selectedCharacter => _selectedCharacter;

  void selectCharacter(Character? character) {
    _selectedCharacter = character;
    notifyListeners();
  }

}
