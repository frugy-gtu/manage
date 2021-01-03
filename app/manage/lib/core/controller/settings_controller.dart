import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:manage/core/cache/settings.dart';

class SettingsController extends ChangeNotifier {
  List<bool> selections = [false, false, false];

  SettingsController() {
    selections[_indexOf(Settings.themeMode)] = true;
  }

  Future<void> onPressed(int index) async {
    ThemeMode pressed = _themeModeFrom(index);

    if (Settings.themeMode == pressed) {
      return;
    }

    int pressedIndex = _indexOf(pressed);
    selections[pressedIndex] = true;
    selections[(pressedIndex + 1) % 3] = false;
    selections[(pressedIndex + 2) % 3] = false;

    Settings.themeMode = pressed;

    notifyListeners();
  }

  int _indexOf(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.system:
        return 1;
      case ThemeMode.light:
        return 0;
      case ThemeMode.dark:
        return 2;
      default:
        assert(false);
        return 0;
    }
  }

  ThemeMode _themeModeFrom(int index) {
    switch (index) {
      case 1:
        return ThemeMode.system;
      case 0:
        return ThemeMode.light;
      case 2:
        return ThemeMode.dark;
      default:
        assert(false);
        return ThemeMode.system;
    }
  }
}
