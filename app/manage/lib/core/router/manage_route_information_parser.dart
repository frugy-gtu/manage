import 'package:flutter/material.dart';
import 'package:manage/core/cache/auth.dart';
import 'package:manage/core/router/manage_route_path.dart';

class ManageRouteInformationParser
    extends RouteInformationParser<ManageRoutePath> {
  @override
  Future<ManageRoutePath> parseRouteInformation(
      RouteInformation routeInformation) async {
    final uri = Uri.parse(routeInformation.location);

    if (!Auth.isLoggedIn()) {
      return ManageLoginPath();
    }

    if (uri.pathSegments.length == 0) {
      return ManageTeamsPath();
    }

    if (uri.pathSegments.length == 1) {
      if (uri.pathSegments[0] == 'login') {
        return ManageLoginPath();
      }

      if (uri.pathSegments[0] == 'sign-up') {
        return ManageSignUpPath();
      }

      if (uri.pathSegments[0] == 'teams') {
        return ManageTeamsPath();
      }

      if (uri.pathSegments[0] == 'profile') {
        return ManageUserProfilePath();
      }
    }

    if (uri.pathSegments.length == 2) {
      if (uri.pathSegments[0] == 'teams') {
        return ManageTeamPath(uri.pathSegments[1]);
      } else if (uri.pathSegments[0] == 'create') {
        return ManageTeamCreatePath();
      }
      if (uri.pathSegments[0] == 'users') {
        return ManageMemberProfilePath(uri.pathSegments[1]);
      }
    }

    if (uri.pathSegments.length == 3) {
      if (uri.pathSegments[0] == 'teams') {
        if (uri.pathSegments[2] == 'create') {
          return ManageProjectCreatePath(uri.pathSegments[1]);
        }

        if (uri.pathSegments[2] == 'invite') {
          return ManageTeamInvitePath(uri.pathSegments[1]);
        }
      }
    }

    return ManageUnknownPath();
  }

  @override
  RouteInformation restoreRouteInformation(ManageRoutePath configuration) {
    if (configuration is ManageLoginPath) {
      return RouteInformation(location: '/login');
    }

    if (configuration is ManageSignUpPath) {
      return RouteInformation(location: '/sign-up');
    }

    if (configuration is ManageTeamsPath) {
      return RouteInformation(location: '/teams');
    }

    if (configuration is ManageTeamPath) {
      return RouteInformation(location: 'teams/${configuration.id}');
    }

    if (configuration is ManageTeamCreatePath) {
      return RouteInformation(location: 'teams/create');
    }

    if (configuration is ManageProjectCreatePath) {
      return RouteInformation(location: 'teams/${configuration.id}/create');
    }

    if (configuration is ManageTeamInvitePath) {
      return RouteInformation(location: 'teams/${configuration.id}/invite');
    }

    if (configuration is ManageUserProfilePath) {
      return RouteInformation(location: '/profile');
    }

    if (configuration is ManageMemberProfilePath) {
      return RouteInformation(location: '/users/${configuration.id}');
    }

    return null;
  }
}
