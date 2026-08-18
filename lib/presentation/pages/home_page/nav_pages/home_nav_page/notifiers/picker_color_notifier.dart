import 'dart:async';

import 'package:flutter/material.dart';

enum ButtonPickerState { idle, success, error }

class PickerColorNotifier extends ChangeNotifier {
  static const _pickerButtonCount = 5;

  List<ButtonPickerState> _buttonStates = List.filled(_pickerButtonCount, ButtonPickerState.idle);

  List<ButtonPickerState> get buttonStates => List.unmodifiable(_buttonStates);

  Timer? _resetTimer;

  void updateState(int index, ButtonPickerState state) {
    if (_buttonStates.length <= index) {
      debugPrint(
          'invalid index at resetting color: $index, while the length is ${_buttonStates.length}');
      return;
    }

    _buttonStates[index] = state;
    notifyListeners();

    //reset state after 1 second to default, but only on error, since the green stays.
    if (state == ButtonPickerState.error) {
      _resetTimer?.cancel();
      _resetTimer = Timer(const Duration(seconds: 1), () => _resetStateByIndex(index));
    }
  }

  void resetColors() {
    _resetTimer?.cancel();
    _buttonStates = List.filled(_pickerButtonCount, ButtonPickerState.idle);
    notifyListeners();
  }

  void _resetStateByIndex(int index) {
    if (_buttonStates.length <= index) {
      debugPrint(
          'invalid index at resetting color: $index, while the length is ${_buttonStates.length}');
      return;
    }

    _buttonStates[index] = ButtonPickerState.idle;
    notifyListeners();
  }

  bool get containsSelectedItem =>
      _buttonStates.contains(ButtonPickerState.success) ||
      _buttonStates.contains(ButtonPickerState.error);

  @override
  void dispose() {
    _resetTimer?.cancel();
    super.dispose();
  }
}
