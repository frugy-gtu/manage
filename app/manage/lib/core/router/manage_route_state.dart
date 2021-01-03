import 'package:flutter/material.dart';
import 'package:manage/core/model/general_user_model.dart';
import 'package:manage/core/model/team_project_model.dart';
import 'package:manage/core/router/manage_route.dart';

import '../model/team_model.dart';

class ManageRouteState extends ChangeNotifier {
  ManageRoute _route;
  TeamModel _team;
  TeamProjectModel _project;
  GeneralUserModel _member;

  static BottomBarTab _selectedTab = BottomBarTab.teams;

  static List<ManageRouteState> _tabRoutes = [
    ManageRouteState(ManageRoute.teams),
    ManageRouteState(ManageRoute.projects),
    ManageRouteState(ManageRoute.profile),
    ManageRouteState(ManageRoute.settings),
  ];

  ManageRouteState([ManageRoute route = ManageRoute.teams]) : _route = route;

  void _copy(ManageRouteState value) {
    _route = value._route;
    _team = value._team;
    _member = value._member;
  }

  ManageRoute get route => _route;
  TeamModel get team => _team;
  GeneralUserModel get member => _member;

  BottomBarTab get tab => _selectedTab;
  TeamProjectModel get project => _project;

  set tab(BottomBarTab value) {
    if (_selectedTab != value) {
      _tabRoutes[_selectedTab.index]._copy(this);
      _copy(_tabRoutes[value.index]);
      _selectedTab = value;
      notifyListeners();
    }
  }

  void update(
    ManageRoute route, {
      TeamModel team,
      TeamProjectModel project,
    GeneralUserModel member,
  }) {
    assert(route != null);

    if (route == ManageRoute.team) {
      assert(team != null);
      _team = team;
    }

    if (route == ManageRoute.member) {
      assert(member != null);
      _member = member;
    }

    if (route == ManageRoute.project) {
      assert(project != null);
      _project = project;
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
