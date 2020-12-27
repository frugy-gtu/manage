import 'package:flutter/material.dart' hide Theme;
import 'package:manage/core/team_home_page.dart';

import 'theme.dart';
import 'settings.dart';

class App extends StatelessWidget {

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: Settings.listenable(['themeMode']),
        builder: (context, box, widget) {
          return MaterialApp(
            title: 'Manage',
            theme: Theme.light,
            darkTheme: Theme.dark,
            home: TeamHomePage(),
            debugShowCheckedModeBanner: false,
          );
        });
  }
}
