import 'package:flutter/widgets.dart';
import 'package:harry_potter_sorting_flutter/data/database/database_schema.dart';

class CharacterListNotifier extends ChangeNotifier {

  List<Character> _entries = [];
  List<Character> get entries => _entries;

  void update(List<Character> newValues) {
    _entries = newValues;
    notifyListeners();
  }

}