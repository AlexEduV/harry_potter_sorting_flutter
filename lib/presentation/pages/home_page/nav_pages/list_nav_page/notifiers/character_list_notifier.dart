import 'package:flutter/widgets.dart';
import 'package:harry_potter_sorting_flutter/data/database/database_schema.dart';
import 'package:harry_potter_sorting_flutter/presentation/pages/home_page/nav_pages/list_nav_page/usecases/get_characters_usecase.dart';

class CharacterListNotifier extends ChangeNotifier {

  final GetCharactersUseCase _getCharactersUseCase;

  CharacterListNotifier(this._getCharactersUseCase);

  List<Character> _entries = [];
  List<Character> get entries => _entries;

  Future<void> fetchCharacters({String filter = ''}) async {
    _entries = await _getCharactersUseCase.execute(filter: filter);
    notifyListeners();
  }

}