import 'package:flutter/cupertino.dart';
import 'package:harry_potter_sorting_flutter/data/database/database_schema.dart';
import 'package:harry_potter_sorting_flutter/domain/models/character_dto.dart';

class CharacterNotifier extends ChangeNotifier {

  CharacterDTO? _character;
  CharacterDTO? get character => _character;

  void updateCharacter(CharacterDTO character) {
    _character = character;
    notifyListeners();
  }

}
