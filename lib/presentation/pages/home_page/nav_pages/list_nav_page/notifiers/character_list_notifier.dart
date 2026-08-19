import 'package:flutter/widgets.dart';
import 'package:harry_potter_sorting_flutter/domain/entities/character_entity.dart';
import 'package:harry_potter_sorting_flutter/domain/usecases/get_characters_usecase.dart';

import '../../../../../../domain/repositories/character_repository.dart';

class CharacterListNotifier extends ChangeNotifier {
  final CharacterRepository _characterRepository;
  final GetCharactersUseCase _getCharactersUseCase;

  CharacterListNotifier(this._characterRepository, this._getCharactersUseCase);

  List<CharacterEntity> _entries = [];

  List<CharacterEntity> get entries => _entries;

  int _totalAll = 0;

  int get total => _totalAll;

  void updateTotal(int newValue) {
    _totalAll = newValue;
    notifyListeners();
  }

  int _successAll = 0;

  int get success => _successAll;

  void updateSuccess(int newValue) {
    _successAll = newValue;
    notifyListeners();
  }

  int _failedAll = 0;

  int get failed => _failedAll;

  void updateFailures(int newValue) {
    _failedAll = newValue;
    notifyListeners();
  }

  Future<void> fetchCharacters({String filter = ''}) async {
    debugPrint('fetching list with filter: $filter');

    _entries = await _getCharactersUseCase.call(filter);
    notifyListeners();
  }

  Future<void> getInitCombinedStats() async {
    final result = await _characterRepository.getTotalStats();

    _successAll = result.successCount;
    _failedAll = result.failCount;
    _totalAll = result.totalCount;

    notifyListeners();
  }

  Future<void> resetAllCounts() async {
    //reset all attempts
    await _characterRepository.resetAllCharactersAttemptsStats();

    _successAll = 0;
    _failedAll = 0;
    _totalAll = 0;

    notifyListeners();
  }

  ({int success, int fail, int total}) getCurrentStats() {
    return (success: _successAll, fail: _failedAll, total: _totalAll);
  }
}
