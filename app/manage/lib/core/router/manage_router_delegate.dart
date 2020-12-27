import 'package:flutter/material.dart';
import 'package:manage/core/cache/auth.dart';
import 'package:manage/core/router/manage_route.dart';
import 'package:manage/core/router/manage_route_path.dart';
import 'package:manage/core/router/manage_route_state.dart';
import 'package:manage/core/screens/login_screen.dart';
import 'package:manage/core/screens/sign_up_screen.dart';
import 'package:manage/core/screens/team_create_screen.dart';
import 'package:manage/core/screens/teams_screen.dart';
import 'package:manage/core/model/team.dart';

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
      pages: _buildPages(),
      onPopPage: (route, result) {
        if (!route.didPop(result)) {
          return false;
        }

        if (state.route == ManageRoute.signup) {
          state.update(ManageRoute.login);
        } else {
          state.update(ManageRoute.teams);
        }

        return true;
      },
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
      state.update(ManageRoute.team, team: Team(name: 'Not implemented', abbrv: 'NI', id: path.id));
    } else if (path is ManageUnknownPath) {
      state.update(ManageRoute.unknown);
    }
  }

  List<Page<dynamic>> _buildPages() {
    List<Page<dynamic>> pages = [];

    if (!Auth.isLoggedIn()) {
      pages.add(MaterialPage(
          key: ValueKey('LoginPage'),
          child: LoginScreen(),
      ));

      if(state.route == ManageRoute.signup) {
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
            child: Scaffold(
              appBar: AppBar(
                title: Text(state.team.name),
              ),
            )));
      }

      if (state.route == ManageRoute.team_create) {
        pages.add(MaterialPage(
          key: ValueKey('TeamCreatePage'),
          child: TeamCreateScreen(),
        ));
      }
    }

    return pages;
  }
}
