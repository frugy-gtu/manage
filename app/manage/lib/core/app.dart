import 'package:flutter/material.dart' hide Theme;
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
  Team _currentTeam;
  bool _show404 = false;
  List<Team> teams = [
    Team('User Team'),
  ];

  void _handleTeamTapped(Team team) {
    setState(() {
      _currentTeam = team;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: Settings.listenable(['themeMode']),
        builder: (context, box, widget) {
          return MaterialApp(
            title: 'Manage',
            theme: Theme.light,
            darkTheme: Theme.dark,
            home: Navigator(
              pages: [
                MaterialPage(
                  key: ValueKey('TeamsPage'),
                  child: TeamsScreen(
                    teams: teams,
                    onTapped: _handleTeamTapped,
                  ),
                ),
                if (_show404)
                  MaterialPage(
                    key: ValueKey('UnknownPage'),
                    child: Scaffold(),
                  )
                else if (_currentTeam != null)
                  MaterialPage(
                      key: ValueKey(_currentTeam),
                      child: Scaffold(
                        appBar: AppBar(
                          title: Text(_currentTeam.name),
                        ),
                      )),
              ],
              onPopPage: (route, result) {
                if (!route.didPop(result)) {
                  return false;
                }

                setState(() {
                  _currentTeam = null;
                });

                return true;
              },
            ),
            debugShowCheckedModeBanner: false,
          );
        });
  }
}
