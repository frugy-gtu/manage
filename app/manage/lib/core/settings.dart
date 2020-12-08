import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

part '.g/settings.g.dart';

@HiveType(typeId: 0)
class _SettingsData {
  @HiveField(0)
  int themeMode;
}

//TODO: Change caching only on the start
//and end of the app. This can be done by:
//1- Holding settings internally
//2- Calling read method and reading all settings
//from cache at the beginning of app cycle
//at appropriate place.
//3- Calling save method and saving all settings
//to cache at the end of app cycle
//at appropriate place.
//4- Modifying settings will notify accordingly
//using methods other than Hive's listener.
class Settings {
  static Box _box;

  static Future<void> init() async {
    Hive.registerAdapter(SettingsDataAdapter());
    _box = await Hive.openBox('settings');
  }

  static get box => _box;

  static get themeMode {
    assert(Hive.isBoxOpen('settings'));
    switch (box.get('themeMode', defaultValue: 0)) {
      case 0:
        return ThemeMode.system;
      case 1:
        return ThemeMode.light;
      case 2:
        return ThemeMode.dark;
    }
  }

  static set themeMode(ThemeMode newMode) {
    assert(Hive.isBoxOpen('settings'));
    switch (newMode) {
      case ThemeMode.system:
        box.put('themeMode', 0);
        break;
      case ThemeMode.light:
        box.put('themeMode', 1);
        break;
      case ThemeMode.dark:
        box.put('themeMode', 2);
        break;
    }
  }

  static ValueListenable<Box> listenable(List<String> keys) {
    return _box.listenable(keys: keys);
  }
}
