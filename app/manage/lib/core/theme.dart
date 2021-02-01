import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:manage/core/cache/settings.dart';

class Theme {
  //TODO: Select a font familty.
  static final _light = (() {
    ColorScheme colorScheme = ColorScheme(
      brightness: Brightness.light,
      primary: Colors.white,
      onPrimary: Colors.black,
      primaryVariant: Colors.white54,
      secondary: Colors.black,
      onSecondary: Colors.white,
      secondaryVariant: Colors.black54,
      background: Colors.white,
      onBackground: Colors.black,
      surface: Colors.black,
      onSurface: Colors.white,
      error: Colors.red,
      onError: Colors.white,
    );

    //TODO: Complete left styles.
    TextTheme textTheme = TextTheme(
      bodyText1: TextStyle(
        color: Colors.black,
      ),
      button: TextStyle(
        color: Colors.white,
      ),
    );

    return ThemeData.from(
      colorScheme: colorScheme,
      textTheme: textTheme,
    ).copyWith(
      scaffoldBackgroundColor: colorScheme.primary,
      appBarTheme: AppBarTheme(
        centerTitle: true,
        elevation: 0,
        brightness: Brightness.light,
      ),
    );
  })();

  static final _dark = ((){
    ColorScheme colorScheme = ColorScheme(
      brightness: Brightness.dark,
      primary: Colors.black,
      onPrimary: Colors.white,
      primaryVariant: Colors.black54,
      secondary: Colors.white,
      onSecondary: Colors.black,
      secondaryVariant: Colors.white54,
      background: Colors.black,
      onBackground: Colors.white,
      surface: Colors.white,
      onSurface: Colors.black,
      error: Colors.red,
      onError: Colors.black,
    );

    TextTheme textTheme = TextTheme(
      bodyText1: TextStyle(
        color: colorScheme.secondary,
      ),
      button: TextStyle(
        color: colorScheme.primary,
      ),
    );

    return ThemeData.from(
      colorScheme: colorScheme,
      textTheme: textTheme,
    ).copyWith(
      scaffoldBackgroundColor: colorScheme.primary,
      appBarTheme: AppBarTheme(
        color: colorScheme.primary,
        centerTitle: true,
        elevation: 0,
        brightness: Brightness.light,
      ),
    );

  })();

  /// This method called accordingly to system's
  /// [Brightness]. Returns [ThemeMode.dark] only
  /// if user's preference is dark theme, otherwise
  /// [ThemeMode.light].
  static get light {
    switch (Settings.themeMode) {
      case ThemeMode.system:
      case ThemeMode.light:
        return _light;
      case ThemeMode.dark:
        return _dark;
    }
  }

  /// This method called accordingly to system's
  /// [Brightness]. Returns [ThemeMode.light] only
  /// if user's preference is light theme, otherwise
  /// [ThemeMode.dark].
  static get dark {
    switch (Settings.themeMode) {
      case ThemeMode.system:
      case ThemeMode.dark:
        return _dark;
      case ThemeMode.light:
        return _light;
    }
  }

  /// This method called accordingly to system's
  /// [Brightness]. Returns [ThemeMode.dark] only
  /// if user's preference is dark theme, otherwise
  /// [ThemeMode.light].
  static ThemeData get currentTheme {
    switch (Settings.themeMode) {
      case ThemeMode.system:
        if (SchedulerBinding.instance.window.platformBrightness ==
            Brightness.light) {
            return ThemeData.light();
        }
        else {
          return ThemeData.dark();
        }
        break;
      case ThemeMode.light:
        return ThemeData.light();
      case ThemeMode.dark:
        return ThemeData.dark();
    }

    return ThemeData.light();
  }
}
