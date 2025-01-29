import 'package:flutter/material.dart';

class PickerColorNotifier extends ChangeNotifier {

  static final Color defaultColor = Colors.grey.shade300;

  List<Color> _buttonColors = List.filled(5, defaultColor);
  List<Color> get buttonColors => _buttonColors;

  void updateColor(int index, Color color) {
    _buttonColors[index] = color;
    notifyListeners();
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
