import 'package:flutter/material.dart';

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

  static get light => _light;

  static get dark => _dark;
}
