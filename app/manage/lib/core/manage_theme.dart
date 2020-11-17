import 'package:flutter/material.dart';

enum ManageThemeMode {
  system,
  light,
  dark,
}

class ManageTheme {
  static var _themeMode = ManageThemeMode.system;

  static final _light = ThemeData.light();
  static final _dark = ThemeData.dark();

  static get light {
    switch (_themeMode) {
      case ManageThemeMode.system:
      case ManageThemeMode.light:
        return _light;
      case ManageThemeMode.dark:
        return _dark;
    }
  }

  static get dark {
    switch (_themeMode) {
      case ManageThemeMode.system:
      case ManageThemeMode.dark:
        return _dark;
      case ManageThemeMode.light:
        return _light;
    }
  }
}
