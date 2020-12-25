import 'package:flutter/material.dart';
import 'package:manage/core/auth.dart';
import 'package:manage/core/router/manage_route_path.dart';
import 'package:manage/core/router/manage_team_path.dart';
import 'package:manage/core/router/manage_teams_path.dart';
import 'package:manage/core/router/manage_unknown_path.dart';

class ManageRouteInformationParser
    extends RouteInformationParser<ManageRoutePath> {
  @override
  Future<ManageRoutePath> parseRouteInformation(
      RouteInformation routeInformation) async {
    final uri = Uri.parse(routeInformation.location);

    //TODO: Forward to login page if log out
    if (!Auth.isLoggedIn()) return ManageTeamsPath();

    if (uri.pathSegments.length == 0) {
      return ManageTeamsPath();
    }

    if (uri.pathSegments.length == 1) {
      if (uri.pathSegments[0] == 'teams') {
        return ManageTeamsPath();
      }
    }

    if (uri.pathSegments.length == 2) {
      if (uri.pathSegments[0] == 'teams') {
        return ManageTeamPath(uri.pathSegments[1]);
      }
    }

    return ManageUnknownPath();
  }

  @override
  RouteInformation restoreRouteInformation(ManageRoutePath configuration) {
    if (configuration is ManageTeamsPath) {
      return RouteInformation(location: '/teams');
    }

    if (configuration is ManageTeamPath) {
      return RouteInformation(location: 'teams/${configuration.id}');
    }

    return null;
  }
}