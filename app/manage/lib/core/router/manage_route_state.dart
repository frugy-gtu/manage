import 'package:flutter/material.dart';
import 'package:manage/core/model/team_user_model.dart';
import 'package:manage/core/router/manage_route.dart';

import '../model/team_model.dart';

class ManageRouteState extends ChangeNotifier {
  ManageRoute _route;
  ManageRoute _prevRoute;
  TeamModel _team;
  TeamUserModel _member;
  TeamUserModel user;

  ManageRouteState();

  ManageRoute get route => _route;
  ManageRoute get prevRoute => _prevRoute;

  TeamModel get team => _team;

  TeamUserModel get member => _member;

  void update(ManageRoute route, {TeamModel team, TeamUserModel member,}) {
    assert(route != null);

    if(route == ManageRoute.team) {
      assert(team != null);
      _team = team;
    }

    if(route == ManageRoute.member_profile) {
      assert(member != null);
      _member = member;
    }

    _prevRoute = _route;
    _route = route;

    notifyListeners();
  }
}

