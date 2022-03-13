import 'package:flutter/material.dart';

class FilterButtonNotifier extends ChangeNotifier {
  bool _filtering = false;
  bool _selecting = false;
  Map<String, String> _filterVals = {};

  bool get filtering => _filtering;
  bool get selecting => _selecting;
  Map<String, String> get filterVals => _filterVals;

  set filtering(bool value) {
    _filtering = value;
    notifyListeners();
  }

  set selecting(bool val) {
    _selecting = val;
    notifyListeners();
  }

  void addFilter(List<String> val) {
    _filterVals[val[0]] = val[1];
    notifyListeners();
  }

  void openFilter(bool val) {
    _filtering = val;
    notifyListeners();
  }

  void openDropDown(bool val) {
    _selecting = val;
    notifyListeners();
  }
}
