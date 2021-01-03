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
      return LoginPath();
    }

    if (uri.pathSegments.length == 0) {
      return TeamsPath();
    }

    if (uri.pathSegments.length == 1) {
      if (uri.pathSegments[0] == 'login') {
        return LoginPath();
      }

      if (uri.pathSegments[0] == 'sign-up') {
        return SignUpPath();
      }

      if (uri.pathSegments[0] == 'teams') {
        return TeamsPath();
      }

      if (uri.pathSegments[0] == 'profile') {
        return ProfilePath();
      }

      if (uri.pathSegments[0] == 'projects') {
        return ProjectsPath();
      }

      if (uri.pathSegments[0] == 'settings') {
        return SettingsPath();
      }
    }

    if (uri.pathSegments.length == 2) {
      if (uri.pathSegments[0] == 'teams') {
        if (uri.pathSegments[1] == 'create') {
          return TeamCreatePath();
        }

        return TeamPath(uri.pathSegments[1]);
      }
    }

    if (uri.pathSegments.length == 3) {
      if (uri.pathSegments[0] == 'teams') {
        if (uri.pathSegments[2] == 'create') {
          return ProjectCreatePath(uri.pathSegments[1]);
        }

        if (uri.pathSegments[2] == 'invite') {
          return TeamInvitePath(uri.pathSegments[1]);
        }

        return ProjectTeamPath(uri.pathSegments[1], uri.pathSegments[2]);
      }
    }

    if (uri.pathSegments.length == 4) {
      if (uri.pathSegments[0] == 'teams') {
        if (uri.pathSegments[2] == 'members') {
          return MemberProfileTeamPath(
              uri.pathSegments[1], uri.pathSegments[3]);
        }
      }
    }

    return UnknownPath();
  }

  @override
  RouteInformation restoreRouteInformation(ManageRoutePath configuration) {
    if (configuration is LoginPath) {
      return RouteInformation(location: '/login');
    }

    if (configuration is SignUpPath) {
      return RouteInformation(location: '/sign-up');
    }

    if (configuration is TeamsPath) {
      return RouteInformation(location: '/teams');
    }

    if (configuration is ProfilePath) {
      return RouteInformation(location: '/profile');
    }

    if (configuration is SettingsPath) {
      return RouteInformation(location: '/settings');
    }

    if (configuration is ProjectsPath) {
      return RouteInformation(location: '/projects');
    }

    if (configuration is TeamPath) {
      return RouteInformation(location: '/teams/${configuration.id}');
    }

    if (configuration is TeamCreatePath) {
      return RouteInformation(location: '/teams/create');
    }

    if (configuration is ProjectCreatePath) {
      return RouteInformation(location: '/teams/${configuration.id}/create');
    }

    if (configuration is TeamInvitePath) {
      return RouteInformation(location: '/teams/${configuration.id}/invite');
    }

    if (configuration is MemberProfileTeamPath) {
      return RouteInformation(
          location:
              '/teams/${configuration.teamId}/member/${configuration.memberId}');
    }

    if (configuration is ProjectTeamPath) {
      return RouteInformation(
          location:
              '/teams/${configuration.teamId}/${configuration.projectId}');
    }

    return null;
  }
}
