import 'package:flutter/material.dart';

class ManageTheme {
  static var _themeMode = ThemeMode.system;

  static final _light = ThemeData.light();
  static final _dark = ThemeData.dark();

  static get light {
    switch (_themeMode) {
      case ThemeMode.system:
      case ThemeMode.light:
        return _light;
      case ThemeMode.dark:
        return _dark;
    }
  }

  static get dark {
    switch (_themeMode) {
      case ThemeMode.system:
      case ThemeMode.dark:
        return _dark;
      case ThemeMode.light:
        return _light;
    }
  }
}
