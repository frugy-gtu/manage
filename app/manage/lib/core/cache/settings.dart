import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

class Settings {
  static Box _box;

  static Future<void> init() async {
    _box = await Hive.openBox('settings');
  }

  static get themeMode {
    switch (_box.get('themeMode', defaultValue: 0)) {
      case 0:
        return ThemeMode.system;
      case 1:
        return ThemeMode.light;
      case 2:
        return ThemeMode.dark;
    }
  }

  static set themeMode(ThemeMode newMode) {
    switch (newMode) {
      case ThemeMode.system:
        _box.put('themeMode', 0);
        break;
      case ThemeMode.light:
        _box.put('themeMode', 1);
        break;
      case ThemeMode.dark:
        _box.put('themeMode', 2);
        break;
    }
  }

  static ValueListenable<Box> listenable(List<String> keys) {
    return _box.listenable(keys: keys);
  }
}
