import 'package:flutter/material.dart';

class ManageTheme {
  static var _themeMode = ThemeMode.system;

  static final _light = ThemeData.light();
  static final _dark = ThemeData.dark();

  ManageTheme(ThemeMode mode) {
    _themeMode = mode;
  }

  static get light => _light;

  static get dark => _dark;

  static get themeMode => _themeMode;

  static set themeMode(ThemeMode newMode) => _themeMode = newMode;
}
