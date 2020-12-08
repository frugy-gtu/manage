import 'package:flutter/material.dart';
import 'package:manage/core/settings.dart';

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

  static final _dark = ThemeData.dark();

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
}
