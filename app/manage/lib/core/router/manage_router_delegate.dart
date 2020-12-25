import 'package:flutter/material.dart';
import 'package:manage/core/router/manage_route_path.dart';
import 'package:manage/core/router/manage_route_state.dart';
import 'package:manage/core/router/manage_teams_path.dart';
import 'package:manage/core/router/manage_unknown_path.dart';
import 'package:manage/core/screens/teams_screen.dart';
import 'package:manage/core/team.dart';

import 'manage_team_path.dart';

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

        state.update(ManageRoute.teams);

        return true;
      },
    );
  }

  @override
  GlobalKey<NavigatorState> get navigatorKey => _navigatorKey;

  @override
  Future<void> setNewRoutePath(ManageRoutePath path) async {
    if (path is ManageTeamsPath) {
      state.update(ManageRoute.teams);
    } else if (path is ManageTeamPath) {
      state.update(ManageRoute.team, team: Team.fromId(path.id));
    } else if (path is ManageUnknownPath) {
      state.update(ManageRoute.unknown);
    }
  }

  List<Page<dynamic>> _buildPages() {
    List<Page<dynamic>> pages = [
      MaterialPage(
        key: ValueKey('TeamsPage'),
        child: TeamsScreen(
          onTapped: _handleTeamTapped,
        ),
      ),
    ];

    if (state.route == ManageRoute.team) {
      pages.add(MaterialPage(
          key: ValueKey('TeamPage'),
          child: Scaffold(
            appBar: AppBar(
              title: Text(state.team.name),
            ),
          )
        )
      );
    }

    return pages;
  }

  void _handleTeamTapped(Team team) {
    state.update(ManageRoute.team, team: team);
  }
}
