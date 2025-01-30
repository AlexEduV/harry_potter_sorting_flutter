import 'package:flutter/widgets.dart';

class FilterValueNotifier extends ChangeNotifier {

  String _value = '';
  String get value => _value;

  void update(String newValue) {
    _value = newValue;
    notifyListeners();
  }

}