import 'package:flutter/material.dart';
import 'package:manage/core/cache/auth.dart';
import 'package:manage/core/router/manage_route.dart';
import 'package:manage/core/router/manage_route_path.dart';
import 'package:manage/core/router/manage_route_state.dart';
import 'package:manage/core/screens/profile_screen.dart';
import 'package:manage/core/screens/project_create_screen.dart';
import 'package:manage/core/screens/project_screen.dart';
import 'package:manage/core/screens/projects_screen.dart';
import 'package:manage/core/screens/settings_screen.dart';
import 'package:manage/core/screens/task_create_screen.dart';
import 'package:manage/core/screens/task_details_screen.dart';
import 'package:manage/core/screens/team_create_screen.dart';
import 'package:manage/core/screens/team_invite_screen.dart';
import 'package:manage/core/screens/team_screen.dart';
import 'package:manage/core/screens/teams_screen.dart';

class ManageInnerRouterDelegate extends RouterDelegate<ManageRoutePath>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<ManageRoutePath> {
  final GlobalKey<NavigatorState> _navigatorKey;
  final HeroController _heroController;

  ManageRouteState _state;

  ManageRouteState get state => _state;

  set state(ManageRouteState value) {
    if (value == _state) {
      return;
    }

    _state = value;
    notifyListeners();
  }

  ManageInnerRouterDelegate(this._state, this._heroController)
      : _navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: navigatorKey,
      pages: _pages,
      onPopPage: _onPopPage,
      observers: [_heroController],
    );
  }

  @override
  GlobalKey<NavigatorState> get navigatorKey => _navigatorKey;

  @override
  Future<void> setNewRoutePath(ManageRoutePath path) async {
    assert(false);
  }

  List<Page<dynamic>> get _pages {
    List<Page<dynamic>> pages = [];

    if (state.tab == BottomBarTab.teams) {
      pages.add(MaterialPage(
        key: ValueKey('TeamsPage'),
        child: TeamsScreen(),
      ));

      if (state.route == ManageRoute.team_create) {
        pages.add(MaterialPage(
          key: ValueKey('TeamCreatePage'),
          child: TeamCreateScreen(),
        ));
      }

      if (state.route == ManageRoute.team ||
          state.route == ManageRoute.project ||
          state.route == ManageRoute.project_create ||
          state.route == ManageRoute.team_invite ||
          state.route == ManageRoute.task_details ||
          state.route == ManageRoute.task_create ||
          state.route == ManageRoute.member) {
        pages.add(MaterialPage(
          key: ValueKey('TeamPage'),
          child: TeamScreen(team: state.team),
        ));

        if (state.route == ManageRoute.member) {
          pages.add(MaterialPage(
            key: ValueKey('MemberPage'),
            child: ProfileScreen(state.member),
          ));
        }

        if (state.route == ManageRoute.project ||
            state.route == ManageRoute.task_create ||
            state.route == ManageRoute.task_details) {
          pages.add(MaterialPage(
            key: ValueKey('ProjectPage'),
            child: ProjectScreen(state.project, state: state.initialState),
          ));

          if (state.route == ManageRoute.task_details) {
            pages.add(MaterialPage(
              key: ValueKey('TaskDetailsPage'),
              child: TaskDetailsScreen(task: state.task),
            ));
          }

          if (state.route == ManageRoute.task_create) {
            pages.add(MaterialPage(
              key: ValueKey('TaskCreatePage'),
              child: TaskCreateScreen(
                initialState: state.initialState,
                project: state.project,
              ),
            ));
          }
        }

        if (state.route == ManageRoute.project_create) {
          pages.add(MaterialPage(
            key: ValueKey('ProjectCreatePage'),
            child: ProjectCreateScreen(state.team),
          ));
        }

        if (state.route == ManageRoute.team_invite) {
          pages.add(MaterialPage(
            key: ValueKey('TeamInvitePage'),
            child: TeamInviteScreen(state.team),
          ));
        }
      }
    } else if (state.tab == BottomBarTab.projects) {
      pages.add(MaterialPage(
        key: ValueKey('ProjectsPage'),
        child: ProjectsScreen(),
      ));

      if (state.route == ManageRoute.task_details ||
          state.route == ManageRoute.task_create ||
          state.route == ManageRoute.project) {
        pages.add(MaterialPage(
          key: ValueKey('ProjectPage'),
          child: ProjectScreen(state.project),
        ));

        if (state.route == ManageRoute.task_details) {
          pages.add(MaterialPage(
            key: ValueKey('TaskDetailsPage'),
            child: TaskDetailsScreen(task: state.task),
          ));
        }

        if (state.route == ManageRoute.task_create) {
          pages.add(MaterialPage(
            key: ValueKey('TaskCreatePage'),
            child: TaskCreateScreen(
                initialState: state.initialState,
                project: state.project,
            ),
          ));
        }
      }
    } else if (state.tab == BottomBarTab.profile) {
      pages.add(MaterialPage(
        key: ValueKey('ProfilePage'),
        child: ProfileScreen(Auth.user),
      ));
    } else if (state.tab == BottomBarTab.settings) {
      pages.add(MaterialPage(
        key: ValueKey('SettingsPage'),
        child: SettingsScreen(),
      ));
    }

    return pages;
  }

  bool _onPopPage(Route<dynamic> route, dynamic result) {
    if (!route.didPop(result)) {
      return false;
    }

    switch (state.route) {
      case ManageRoute.task_details:
      case ManageRoute.task_create:
        state.update(ManageRoute.project, project: state.project,
          initialState: state.initialState);
        break;
      case ManageRoute.project_create:
      case ManageRoute.team_invite:
      case ManageRoute.member:
        state.update(ManageRoute.team, team: state.team);
        break;
      case ManageRoute.project:
        if (state.tab == BottomBarTab.projects) {
          state.update(ManageRoute.projects);
        } else
          state.update(ManageRoute.team, team: state.team);
        break;
      default:
        state.update(ManageRoute.teams);
    }

    return true;
  }
}
