import 'package:flutter/material.dart';
import 'package:manage/core/model/general_user_model.dart';
import 'package:manage/core/router/manage_route.dart';

import '../model/team_model.dart';

class ManageRouteState extends ChangeNotifier {
  ManageRoute _route;
  ManageRoute _prevUserProfileRoute;
  TeamModel _team;
  GeneralUserModel _member;
  GeneralUserModel user;
  BottomBarTab _selectedTab = BottomBarTab.teams;

  ManageRoute get route => _route;
  ManageRoute get prevUserProfileRoute => _prevUserProfileRoute;

  TeamModel get team => _team;

  GeneralUserModel get member => _member;

  BottomBarTab get tab => _selectedTab;

  set tab(BottomBarTab value) {
    _selectedTab = value;
    notifyListeners();
  }

  void update(ManageRoute route,
      {TeamModel team,
      GeneralUserModel member,
      ManageRoute prevUserProfileRoute}) {
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
      assert(prevUserProfileRoute != null);
      _prevUserProfileRoute = prevUserProfileRoute;
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
