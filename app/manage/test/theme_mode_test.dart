import 'package:flutter/material.dart' hide Theme;
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:manage/core/settings.dart';
import 'package:manage/core/theme.dart';
import 'package:flutter/scheduler.dart';

void main() {
  test('Init app settings', () async {
    await Hive.initFlutter((await getApplicationDocumentsDirectory()).path);
    await Settings.init();
    expect(Hive.isBoxOpen('settings'), true);
  });

  group('Switching theme', () {
    test('to system', () async {
      Settings.themeMode = ThemeMode.system;
      expect(Hive.box('settings').get('themeMode'), 0);
      switch (SchedulerBinding.instance.window.platformBrightness) {
        case Brightness.light:
          expect(Theme.light.brightness, Brightness.light);
          break;
        case Brightness.dark:
          expect(Theme.dark.brightness, Brightness.dark);
          break;
      }
    });

    test('to light', () async {
      Settings.themeMode = ThemeMode.light;
      expect(Hive.box('settings').get('themeMode'), 1);
      expect(Theme.dark.brightness, Brightness.light);
      expect(Theme.light.brightness, Brightness.light);
    });

    test('to dark', () async {
      Settings.themeMode = ThemeMode.dark;
      expect(Hive.box('settings').get('themeMode'), 2);
      expect(Theme.dark.brightness, Brightness.dark);
      expect(Theme.light.brightness, Brightness.dark);
    });
  });
}
