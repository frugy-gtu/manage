import 'package:flutter/material.dart';
import 'package:manage/core/router/team_route_path.dart';

class TeamRouteInformationParser extends RouteInformationParser<TeamRoutePath> {
  @override
  Future<TeamRoutePath> parseRouteInformation(RouteInformation routeInformation) async {
    final uri = Uri.parse(routeInformation.location);

    if(uri.pathSegments.length == 0) {
      return TeamRoutePath.home();
    }

    if(uri.pathSegments.length == 1) {
      if(uri.pathSegments[0] != 'teams') {
        return TeamRoutePath.unknown();
      }

      return TeamRoutePath.home();
    }

    if(uri.pathSegments.length == 2) {
      if(uri.pathSegments[0] != 'teams') {
        return TeamRoutePath.unknown();
      }

      return TeamRoutePath.details(uri.pathSegments[1]);
    }

    return TeamRoutePath.unknown();
  }

  @override
  RouteInformation restoreRouteInformation(TeamRoutePath configuration) {
    if(configuration.isUnknown) {
      return RouteInformation(location: '/404');
    }

    if(configuration.isHomePage) {
      return RouteInformation(location: '/teams');
    }

    if(configuration.isDetailsPage) {
      return RouteInformation(location: '/teams/${configuration.id}');
    }

    return null;
  }
}
