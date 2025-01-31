import 'package:flutter/material.dart';
import 'package:harry_potter_sorting_flutter/presentation/style/app_colors.dart';

class PickerColorNotifier extends ChangeNotifier {

  static const Color defaultColor = AppColors.pickerDefaultButtonColor;

  List<Color> _buttonColors = List.filled(5, defaultColor);
  List<Color> get buttonColors => _buttonColors;

  void updateColor(int index, Color color) {
    _buttonColors[index] = color;
    notifyListeners();

    //reset red color after 1 second, the green stays the same;
    if (color == Colors.red) {
      Future.delayed(const Duration(seconds: 1), () {
        resetColor(index);
      });
    }

  }

  void resetColors() {
    _buttonColors = List.filled(5, defaultColor);
    notifyListeners();
  }

  void resetColor(int index) {
    _buttonColors[index] = defaultColor;
    notifyListeners();
  }

  bool get containsActiveColor => _buttonColors.contains(Colors.green) || _buttonColors.contains(Colors.red);

}
