import 'package:flutter/widgets.dart';

class CharacterStatsNotifier extends ChangeNotifier {

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

  void resetTotal() {
    _totalCount = 0;
    notifyListeners();
  }

  void updateTotal(int newValue) {
    _totalCount = newValue;
  }

  void incrementSuccessCount() {
    _successCount++;
    notifyListeners();
  }

  void resetSuccessCount() {
    _successCount = 0;
    notifyListeners();
  }

  void updateSuccessCount(int newValue) {
    _successCount = newValue;
    notifyListeners();
  }

  void incrementFailedCount() {
    _failedCount++;
    notifyListeners();
  }

  void resetFailedCount() {
    _failedCount = 0;
    notifyListeners();
  }

  void updateFailedCount(int newValue) {
    _failedCount = newValue;
    notifyListeners();
  }
}