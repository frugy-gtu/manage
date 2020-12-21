import 'package:flutter/material.dart' hide Theme;
import 'package:manage/core/router/team_route_information_parser.dart';
import 'package:manage/core/router/team_router_delegate.dart';
import 'package:manage/core/team.dart';

import 'settings.dart';
import 'theme.dart';
import 'screens/teams_screen.dart';

class App extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  TeamRouterDelegate _teamRouterDelegate = TeamRouterDelegate();
  TeamRouteInformationParser _teamRouteInformationParser =
      TeamRouteInformationParser();

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: Settings.listenable(['themeMode']),
        builder: (context, box, widget) {
          return MaterialApp.router(
            title: 'Manage',
            theme: Theme.light,
            darkTheme: Theme.dark,
            debugShowCheckedModeBanner: false,
            routerDelegate: _teamRouterDelegate,
            routeInformationParser: _teamRouteInformationParser,
          );
        });
  }
}
