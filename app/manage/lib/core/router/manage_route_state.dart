import 'package:flutter/material.dart';
import 'package:manage/core/model/project_state_model.dart';
import 'package:manage/core/model/task_model.dart';
import 'package:manage/core/model/user_model.dart';
import 'package:manage/core/model/team_project_model.dart';
import 'package:manage/core/router/manage_route.dart';

import '../model/team_model.dart';

class ManageRouteState extends ChangeNotifier {
  ManageRoute _route;
  TeamModel _team;
  TeamProjectModel _project;
  UserModel _member;
  TaskModel _task;
  ProjectStateModel _initialState;

  static BottomBarTab _selectedTab = BottomBarTab.teams;

  static List<ManageRouteState> _tabRoutes = _initialRoutes();

  ManageRouteState([ManageRoute route = ManageRoute.teams]) : _route = route;

  void _copy(ManageRouteState value) {
    _route = value._route;
    _team = value._team;
    _member = value._member;
    _project = value._project;
    _task = value._task;
    _initialState = value._initialState;
  }

  void resetRoutes() {
    _tabRoutes = _initialRoutes();
    _selectedTab = BottomBarTab.teams;
  }

  static List<ManageRouteState> _initialRoutes() => [
        ManageRouteState(ManageRoute.teams),
        ManageRouteState(ManageRoute.projects),
        ManageRouteState(ManageRoute.profile),
        ManageRouteState(ManageRoute.settings),
      ];

  ManageRoute get route => _route;
  TeamModel get team => _team;
  UserModel get member => _member;
  TeamProjectModel get project => _project;
  TaskModel get task => _task;
  ProjectStateModel get initialState => _initialState;

  BottomBarTab get tab => _selectedTab;

  set tab(BottomBarTab value) {
    _tabRoutes[_selectedTab.index]._copy(this);
    _copy(_tabRoutes[value.index]);
    _selectedTab = value;
    notifyListeners();
  }

  void update(
    ManageRoute route, {
    TeamModel team,
    TeamProjectModel project,
    UserModel member,
    TaskModel task,
    ProjectStateModel initialState,
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
      _initialState = initialState;
    }

    if (route == ManageRoute.task_details) {
      assert(task != null);
      _task = task;
      _initialState = initialState;
    }

    if (route == ManageRoute.task_create) {
      assert(initialState != null);
      _initialState = initialState;
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
