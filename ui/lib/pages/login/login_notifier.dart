import 'package:flutter/material.dart';

class LoginNotifier extends ChangeNotifier {
  bool _isLoggedIn = false;

  bool get isLoggedIn => _isLoggedIn;

  set isLoggedIn(bool value) {
    _isLoggedIn = value;
    notifyListeners();
  }

  void toggleLogin() {
    isLoggedIn = !isLoggedIn;
    notifyListeners();
  }
}
