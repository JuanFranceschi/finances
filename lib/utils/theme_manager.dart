import 'package:flutter/material.dart';

class ThemeManager with ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.system;
  ThemeManager(this._themeMode);

  ThemeMode get themeMode => _themeMode;

  void toggleTheme(ThemeMode newMode) {
    _themeMode = newMode;

    notifyListeners();
  }
}
