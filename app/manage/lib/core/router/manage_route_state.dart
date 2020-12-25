import 'package:flutter/material.dart';

import '../team.dart';

class ManageRouteState extends ChangeNotifier {
  ManageRoute _route;
  Team _team;

  ManageRouteState() : _route = ManageRoute.teams;

  ManageRoute get route => _route;

  Team get team => _team;

  void update(ManageRoute route, {Team team}) {
    assert(route != null);

    if(route == ManageRoute.team) {
      assert(team != null);
      _team = team;
    }

    _route = route;

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
