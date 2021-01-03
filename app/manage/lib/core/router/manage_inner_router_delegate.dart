import 'package:flutter/material.dart';
import 'package:manage/core/cache/auth.dart';
import 'package:manage/core/router/manage_route.dart';
import 'package:manage/core/router/manage_route_path.dart';
import 'package:manage/core/router/manage_route_state.dart';
import 'package:manage/core/screens/profile_screen.dart';
import 'package:manage/core/screens/project_create_screen.dart';
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
          state.route == ManageRoute.project_create ||
          state.route == ManageRoute.team_invite ||
          state.route == ManageRoute.member
          ) {
        pages.add(MaterialPage(
          key: ValueKey('TeamPage'),
          child: TeamScreen(team: state.team),
        ));

        if (state.route == ManageRoute.member) {
          pages.add(MaterialPage(
            key: ValueKey('MemberProfilePage'),
            child: ProfileScreen(state.member),
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
    }
    else if (state.tab == BottomBarTab.projects) {
      pages.add(MaterialPage(
        key: ValueKey('xTeamsPage'),
        child: TeamsScreen(),
      ));

      if (state.route == ManageRoute.team_create) {
        pages.add(MaterialPage(
          key: ValueKey('xTeamCreatePage'),
          child: TeamCreateScreen(),
        ));
      }

      if (state.route == ManageRoute.team ||
          state.route == ManageRoute.project_create ||
          state.route == ManageRoute.team_invite ||
          state.route == ManageRoute.member
          ) {
        pages.add(MaterialPage(
          key: ValueKey('xTeamPage'),
          child: TeamScreen(team: state.team),
        ));


        if (state.route == ManageRoute.member) {
          pages.add(MaterialPage(
            key: ValueKey('xMemberProfilePage'),
            child: ProfileScreen(state.member),
          ));
        }

        if (state.route == ManageRoute.project_create) {
          pages.add(MaterialPage(
            key: ValueKey('xProjectCreatePage'),
            child: ProjectCreateScreen(state.team),
          ));
        }

        if (state.route == ManageRoute.team_invite) {
          pages.add(MaterialPage(
            key: ValueKey('xTeamInvitePage'),
            child: TeamInviteScreen(state.team),
          ));
        }
      }
    }
    else if (state.tab == BottomBarTab.profile) {
      pages.add(MaterialPage(
        key: ValueKey('UserProfileFromTeamsPage'),
        child: ProfileScreen(Auth.user),
      ));
    }

    return pages;
  }

  bool _onPopPage(Route<dynamic> route, dynamic result) {
    if (!route.didPop(result)) {
      return false;
    }

    switch (state.route) {
      case ManageRoute.project_create:
      case ManageRoute.team_invite:
      case ManageRoute.member:
        state.update(ManageRoute.team, team: state.team);
        break;
      default:
        state.update(ManageRoute.teams);
    }

    return true;
  }
}
