import 'package:flutter/widgets.dart';
import 'package:harry_potter_sorting_flutter/domain/models/info_stats_entity.dart';
import 'package:harry_potter_sorting_flutter/domain/usecases/reset_character_stats_usecase.dart';

class CharacterStatsNotifier extends ChangeNotifier {

  final ResetCharacterStatsUseCase _resetCharacterStatsUseCase;

  CharacterStatsNotifier(this._resetCharacterStatsUseCase);

  int _totalCount = 0;
  int _successCount = 0;
  int _failedCount = 0;

  int get totalCount => _totalCount;
  int get successCount => _successCount;
  int get failedCount => _failedCount;

  void incrementTotal() {
    _totalCount++;
    notifyListeners();
  }

  void incrementSuccessCount() {
    _successCount++;
    notifyListeners();
  }

  void incrementFailedCount() {
    _failedCount++;
    notifyListeners();
  }

  void updateAllCounts(InfoStatsEntity stats) {
    _failedCount = stats.failCount;
    _successCount = stats.successCount;
    _totalCount = stats.totalCount;

    notifyListeners();
  }

  void resetAllCounts(String name) {

    _resetCharacterStatsUseCase.execute(name);

    _totalCount = 0;
    _failedCount = 0;
    _successCount = 0;

    notifyListeners();
  }
}