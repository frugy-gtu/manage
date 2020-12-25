import 'package:flutter/material.dart';

import '../team.dart';

class ManageRouteState extends ChangeNotifier {
  ManageRoute _currentRoute;
  Team _currentTeam;

  ManageRouteState() : _currentRoute = ManageRoute.teams;

  ManageRoute get currentRoute => _currentRoute;

  Team get currentTeam => _currentTeam;

  void update(ManageRoute route, {Team team}) {
    assert(route != null);

    if(route == ManageRoute.team) {
      assert(team != null);
      _currentTeam = team;
    }

    _currentRoute = route;

    notifyListeners();
  }
}

enum ManageRoute {
  login,
  signup,
  teams,
  team,
  team_creation,
  unknown,
}
