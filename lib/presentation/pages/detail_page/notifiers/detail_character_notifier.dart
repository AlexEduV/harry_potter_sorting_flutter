import 'package:flutter/cupertino.dart';
import 'package:harry_potter_sorting_flutter/data/database/database_schema.dart';

class DetailCharacterNotifier extends ChangeNotifier {

  Character? _character;
  Character? get character => _character;

  void setCharacter(Character character) {
    _character = character;
    notifyListeners();
  }


}