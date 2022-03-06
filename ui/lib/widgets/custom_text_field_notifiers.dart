part of widgets;

class TextFieldNotifier extends ChangeNotifier {
  bool _isFocus = false;
  bool _obscured = false;
  Color _shadowColor = kcLightGrey;
  double _shadowSpread = 1.0;
  double _blur = 5.0;

  bool get isFocus => _isFocus;
  bool get obscured => _obscured;
  Color get shadowColor => _shadowColor;
  double get shadowSpread => _shadowSpread;
  double get blurRadius => _blur;

  set isFocus(bool newIsFocus) {
    _isFocus = newIsFocus;
    shadowColor = newIsFocus ? kcVeryLightBlue : kcLightGrey;
    shadowSpread = newIsFocus ? 10.0 : 1.0;
    blurRadius = newIsFocus ? 20.0 : 5.0;
    notifyListeners();
  }

  set obscured(bool newObscured) {
    _obscured = newObscured;
    notifyListeners();
  }

  set shadowColor(Color newShadowColor) {
    _shadowColor = newShadowColor;
    notifyListeners();
  }

  set shadowSpread(double newSpread) {
    _shadowSpread = newSpread;
    notifyListeners();
  }

  set blurRadius(double newBlur) {
    _blur = newBlur;
    notifyListeners();
  }

  void onTextFieldHover(bool val, Key key) async {
    key = key;
    isFocus = val;
    notifyListeners();
  }
}

class ButtonColorChangeNotifier extends ChangeNotifier {
  Color backgroundColor = Colors.white;
  Color color = kcMedBlue;

  void onHover(bool val) {
    backgroundColor = val ? kcMedBlue : Colors.white;
    color = val ? kcVeryLightBlue : kcMedBlue;
    notifyListeners();
  }
}
