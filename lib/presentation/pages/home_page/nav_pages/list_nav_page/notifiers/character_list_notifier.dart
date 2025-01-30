import 'package:flutter/widgets.dart';
import 'package:harry_potter_sorting_flutter/data/database/database_schema.dart';
import 'package:harry_potter_sorting_flutter/data/network/dio_client.dart';
import 'package:harry_potter_sorting_flutter/data/repositories/character_repository_impl.dart';
import 'package:harry_potter_sorting_flutter/domain/usecases/get_characters_usecase.dart';

class CharacterListNotifier extends ChangeNotifier {

  final GetCharactersUseCase _getCharactersUseCase;

  CharacterListNotifier(this._getCharactersUseCase);

  List<Character> _entries = [];
  List<Character> get entries => _entries;

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
    _entries = await _getCharactersUseCase.execute(filter: filter);
    notifyListeners();
  }

  Future<void> getInitCombinedStats() async {

    final result = await CharacterRepositoryImpl(DioClient.client).getTotalStats();

    _successAll = result.successCount;
    _failedAll = result.failCount;
    _totalAll = result.totalCount;

    notifyListeners();

  }

  void resetAllCounts() {

    //reset all attempts
    CharacterRepositoryImpl(DioClient.client).resetAllCharactersAttemptsStats();

    _successAll = 0;
    _failedAll = 0;
    _totalAll = 0;

    //reset list entries

    notifyListeners();

  }

}