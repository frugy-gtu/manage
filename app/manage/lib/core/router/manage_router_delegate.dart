import 'package:flutter/material.dart';
import 'package:manage/core/app_shell.dart';
import 'package:manage/core/cache/auth.dart';
import 'package:manage/core/model/user_model.dart';
import 'package:manage/core/model/team_model.dart';
import 'package:manage/core/model/team_project_model.dart';
import 'package:manage/core/router/manage_route.dart';
import 'package:manage/core/router/manage_route_path.dart';
import 'package:manage/core/router/manage_route_state.dart';
import 'package:manage/core/screens/login_screen.dart';
import 'package:manage/core/screens/sign_up_screen.dart';

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
      pages: [
        if (!Auth.isLoggedIn()) ...[
          MaterialPage(
            key: ValueKey('LoginPage'),
            child: LoginScreen(),
          ),
          if (state.route == ManageRoute.signup)
            MaterialPage(
              key: ValueKey('SignUpPage'),
              child: SignUpScreen(),
            ),
        ] else
          MaterialPage(
              key: ValueKey('BottomNavigationBar'),
              child: AppShell(
                state: state,
              )),
      ],
      onPopPage: (route, result) {
        if (!route.didPop(result)) {
          return false;
        }

        state.update(ManageRoute.login);

        return true;
      },
    );
  }

  @override
  GlobalKey<NavigatorState> get navigatorKey => _navigatorKey;

  @override
  Future<void> setNewRoutePath(ManageRoutePath path) async {
    //TODO: Implement getting models with querying.
    if (path is LoginPath) {
      state.update(ManageRoute.login);
    } else if (path is SignUpPath) {
      state.update(ManageRoute.signup);
    } else if (path is TeamsPath) {
      state.update(ManageRoute.teams);
    } else if (path is ProjectsPath) {
      state.update(ManageRoute.projects);
    } else if (path is SettingsPath) {
      state.update(ManageRoute.settings);
    } else if (path is ProfilePath) {
      state.update(
        ManageRoute.profile,
      );
    } else if (path is TeamPath) {
      state.update(ManageRoute.team,
          team: TeamModel(
              name: 'Not implemented', abbreviation: 'NI', id: path.id));
    } else if (path is TeamCreatePath) {
      state.update(ManageRoute.team_create);
    } else if (path is ProjectCreatePath) {
      state.update(ManageRoute.project_create,
          team: TeamModel(
              name: 'Not implemented', abbreviation: 'NI', id: path.id));
    } else if (path is TeamInvitePath) {
      state.update(ManageRoute.team_invite,
          team: TeamModel(
              name: 'Not implemented', abbreviation: 'NI', id: path.id));
    } else if (path is MemberProfileTeamPath) {
      state.update(
        ManageRoute.member,
        team: TeamModel(
            name: 'Not implemented', abbreviation: 'NI', id: path.teamId),
        member: UserModel(
            email: 'Not implemented',
            username: 'Not implemented'),
      );
    } else if (path is ProjectTeamPath) {
      state.update(
        ManageRoute.project,
        team: TeamModel(
            name: 'Not implemented', abbreviation: 'NI', id: path.teamId),
        project: TeamProjectModel(
          name: 'Not implemented',
          id: path.projectId,
        ),
      );
    }
    if (path is UnknownPath) {
      state.update(ManageRoute.unknown);
    }
  }
}
