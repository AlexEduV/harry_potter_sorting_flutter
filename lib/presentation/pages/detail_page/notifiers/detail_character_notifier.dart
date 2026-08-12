import 'package:flutter/cupertino.dart';
import 'package:harry_potter_sorting_flutter/core/di/dependency_injection.dart';
import 'package:harry_potter_sorting_flutter/data/database/database_schema.dart';
import 'package:harry_potter_sorting_flutter/domain/repositories/character_repository.dart';

class DetailCharacterNotifier extends ChangeNotifier {
  Character? _character;
  Character? get character => _character;

  void setCharacter(String name) async {
    final character = await getIt<CharacterRepository>().getCharacterByName(name);
    _character = character;

    notifyListeners();
  }
}
