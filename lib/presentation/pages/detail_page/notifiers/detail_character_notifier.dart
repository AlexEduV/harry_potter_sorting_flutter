import 'package:flutter/cupertino.dart';
import 'package:harry_potter_sorting_flutter/data/database/database_schema.dart';
import 'package:harry_potter_sorting_flutter/domain/repositories/character_repository.dart';

class DetailCharacterNotifier extends ChangeNotifier {
  final CharacterRepository _characterRepository;

  DetailCharacterNotifier(this._characterRepository);

  Character? _character;
  Character? get character => _character;

  void setCharacter(String name) async {
    final character = await _characterRepository.getCharacterByName(name);
    _character = character;

    notifyListeners();
  }
}
