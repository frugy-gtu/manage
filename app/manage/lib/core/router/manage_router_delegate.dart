import 'package:flutter/material.dart';
import 'package:manage/core/app_shell.dart';
import 'package:manage/core/cache/auth.dart';
import 'package:manage/core/model/general_user_model.dart';
import 'package:manage/core/model/team_model.dart';
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

        switch (state.route) {
          case ManageRoute.signup:
            state.update(ManageRoute.login);
            break;
          case ManageRoute.teams:
            state.update(ManageRoute.teams);
            break;
          default:
            break;
        }

        return true;
      },
    );
  }

  @override
  GlobalKey<NavigatorState> get navigatorKey => _navigatorKey;

  @override
  Future<void> setNewRoutePath(ManageRoutePath path) async {
    //TODO: Implement getting models with querying.
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
    } else if (path is ManageUserProfileFromTeamsPath) {
      state.update(ManageRoute.user_profile, prevRoute: ManageRoute.teams);
    } else if (path is ManageMemberProfilePath) {
      state.update(
        ManageRoute.member_profile,
        member: GeneralUserModel(
            email: 'Not implemented',
            createdAt: 'Not implemented',
            username: 'Not implemented'),
      );
    } else if (path is ManageUnknownPath) {
      state.update(ManageRoute.unknown);
    }
  }
}
