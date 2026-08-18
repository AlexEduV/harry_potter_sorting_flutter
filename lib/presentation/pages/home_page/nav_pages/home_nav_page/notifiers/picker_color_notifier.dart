import 'dart:async';

import 'package:flutter/material.dart';
import 'package:harry_potter_sorting_flutter/presentation/style/app_colors.dart';

class PickerColorNotifier extends ChangeNotifier {
  //todo: this file might need some refactoring in the variable definition and usage of unnamed vars and debounce mechanism;

  static const Color defaultColor = AppColors.pickerDefaultButtonColor;

  List<Color> _buttonColors = List.filled(5, defaultColor);

  List<Color> get buttonColors => _buttonColors;

  Timer? _resetTimer;

  void updateColor(int index, Color color) {
    _buttonColors[index] = color;
    notifyListeners();

    //reset red color after 1 second, the green stays the same;
    if (color == AppColors.error) {
      _resetTimer = Timer(const Duration(seconds: 1), () => _resetColor(index));
    }
  }

  void resetColors() {
    _resetTimer?.cancel();
    _buttonColors = List.filled(5, defaultColor);
    notifyListeners();
  }

  void _resetColor(int index) {
    _buttonColors[index] = defaultColor;
    notifyListeners();
  }

  bool get containsSelectedItem =>
      _buttonColors.contains(AppColors.success) || _buttonColors.contains(AppColors.error);

  @override
  void dispose() {
    _resetTimer?.cancel();
    super.dispose();
  }
}
