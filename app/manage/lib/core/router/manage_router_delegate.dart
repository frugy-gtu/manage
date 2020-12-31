import 'package:flutter/material.dart';
import 'package:manage/core/cache/auth.dart';
import 'package:manage/core/router/manage_route.dart';
import 'package:manage/core/router/manage_route_path.dart';
import 'package:manage/core/router/manage_route_state.dart';
import 'package:manage/core/screens/login_screen.dart';
import 'package:manage/core/screens/project_create_screen.dart';
import 'package:manage/core/screens/sign_up_screen.dart';
import 'package:manage/core/screens/team_create_screen.dart';
import 'package:manage/core/screens/team_invite_screen.dart';
import 'package:manage/core/screens/team_screen.dart';
import 'package:manage/core/screens/teams_screen.dart';
import 'package:manage/core/model/team_model.dart';

class ManageRouterDelegate extends RouterDelegate<ManageRoutePath>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<ManageRoutePath> {
  final GlobalKey<NavigatorState> _navigatorKey;

  final ManageRouteState state = ManageRouteState();

  ManageRouterDelegate() : _navigatorKey = GlobalKey<NavigatorState>() {
    state.addListener(notifyListeners);
  }

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: navigatorKey,
      pages: _pages,
      onPopPage: _onPopPage,
    );
  }

  @override
  GlobalKey<NavigatorState> get navigatorKey => _navigatorKey;

  @override
  Future<void> setNewRoutePath(ManageRoutePath path) async {
    if (path is ManageLoginPath) {
      state.update(ManageRoute.login);
    } else if (path is ManageSignUpPath) {
      state.update(ManageRoute.signup);
    } else if (path is ManageTeamsPath) {
      state.update(ManageRoute.teams);
    } else if (path is ManageTeamPath) {
      state.update(ManageRoute.team,
          team: TeamModel(
              name: 'Not implemented', abbreviation: 'NI', id: path.id));
    } else if (path is ManageProjectCreatePath) {
      state.update(ManageRoute.project_create);
    } else if (path is ManageTeamInvitePath) {
      state.update(ManageRoute.team_invite);
    } else if (path is ManageUnknownPath) {
      state.update(ManageRoute.unknown);
    }
  }

  List<Page<dynamic>> get _pages {
    List<Page<dynamic>> pages = [];

    if (!Auth.isLoggedIn()) {
      pages.add(MaterialPage(
        key: ValueKey('LoginPage'),
        child: LoginScreen(),
      ));

      if (state.route == ManageRoute.signup) {
        pages.add(MaterialPage(
          key: ValueKey('SignUpPage'),
          child: SignUpScreen(),
        ));
      }
    } else {
      pages.add(MaterialPage(
        key: ValueKey('TeamsPage'),
        child: TeamsScreen(),
      ));

      if (state.route == ManageRoute.team) {
        pages.add(MaterialPage(
          key: ValueKey('TeamPage'),
          child: TeamScreen(team: state.team),
        ));
      }

      if (state.route == ManageRoute.team_create) {
        pages.add(MaterialPage(
          key: ValueKey('TeamCreatePage'),
          child: TeamCreateScreen(),
        ));
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

    return pages;
  }

  bool _onPopPage(Route<dynamic> route, dynamic result) {
    if (!route.didPop(result)) {
      return false;
    }

    switch (state.route) {
      case ManageRoute.signup:
        state.update(ManageRoute.login);
        break;
      case ManageRoute.project_create:
      case ManageRoute.team_invite:
        state.update(ManageRoute.team, team: state.team);
        break;
      default:
        state.update(ManageRoute.teams);
    }

    return true;
  }
}
