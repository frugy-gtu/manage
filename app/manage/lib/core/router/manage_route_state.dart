import 'package:flutter/material.dart';
import 'package:manage/core/router/manage_route.dart';

import '../model/team_model.dart';

class ManageRouteState extends ChangeNotifier {
  ManageRoute _route;
  TeamModel _team;

  ManageRouteState() : _route = ManageRoute.teams;

  ManageRoute get route => _route;

  TeamModel get team => _team;

  void update(ManageRoute route, {TeamModel team}) {
    assert(route != null);

    if(route == ManageRoute.team) {
      assert(team != null);
      _team = team;
    }

    _route = route;

    notifyListeners();
  }
}

