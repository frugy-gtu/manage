import 'package:flutter/material.dart';
import 'package:manage/core/model/general_user_model.dart';
import 'package:manage/core/router/manage_route.dart';

import '../model/team_model.dart';

class ManageRouteState extends ChangeNotifier {
  ManageRoute _route;
  ManageRoute _prevRoute;
  TeamModel _team;
  GeneralUserModel _member;
  GeneralUserModel user;
  BottomBarTab _selectedTab = BottomBarTab.teams;

  ManageRoute get route => _route;
  ManageRoute get prevRoute => _prevRoute;

  TeamModel get team => _team;

  GeneralUserModel get member => _member;

  BottomBarTab get tab => _selectedTab;

  set tab(BottomBarTab value) {
    _selectedTab = value;
    notifyListeners();
  }

  void update(ManageRoute route,
      {TeamModel team, GeneralUserModel member, ManageRoute prevRoute}) {
    assert(route != null);

    if (route == ManageRoute.team) {
      assert(team != null);
      _team = team;
    }

    if (route == ManageRoute.member_profile) {
      assert(member != null);
      _member = member;
    }

    if (route == ManageRoute.user_profile) {
      assert(prevRoute != null);
      _prevRoute = prevRoute;
    }

    _route = route;

    notifyListeners();
  }
}

enum BottomBarTab {
  teams,
  projects,
  profile,
  settings,
}
