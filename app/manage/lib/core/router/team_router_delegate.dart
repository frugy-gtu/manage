import 'package:flutter/material.dart';
import 'package:manage/core/router/team_route_path.dart';
import 'package:manage/core/screens/teams_screen.dart';

import '../team.dart';

class TeamRouterDelegate extends RouterDelegate<TeamRoutePath>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<TeamRoutePath> {
  final GlobalKey<NavigatorState> _navigatorKey;

  Team _currentTeam;
  bool _show404 = false;
  List<Team> teams = [
    Team('User Team', '0'),
  ];

  TeamRouterDelegate() : _navigatorKey = GlobalKey<NavigatorState>();

  void _handleTeamTapped(Team team) {
    _currentTeam = team;
    notifyListeners();
  }

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: navigatorKey,
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
        _currentTeam = null;
        _show404 = false;

        notifyListeners();

        return true;
      },
    );
  }

  @override
  GlobalKey<NavigatorState> get navigatorKey => _navigatorKey;

  @override
  Future<void> setNewRoutePath(TeamRoutePath configuration) async {
    if(configuration.isUnknown) {
      _currentTeam = null;
      _show404 = true;
      return;
    }

    if(configuration.isDetailsPage) {
      int id = int.parse(configuration.id);
      if(id < 0 || id >= teams.length) {
        _show404 = true;
        return;
      }

      _currentTeam = teams[id];
    }
    else {
      _currentTeam = null;
    }

    _show404 = false;
  }

  TeamRoutePath get currentConfiguration {
    if (_show404) {
      return TeamRoutePath.unknown();
    }

    return _currentTeam == null
        ? TeamRoutePath.home()
        : TeamRoutePath.details(_currentTeam.id);
  }
}
