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
	  
	  if(uri.pathSegments[0] == 'profile') {
	    return ManageProfilePath();
	  }
    }

    if (uri.pathSegments.length == 2) {
      if (uri.pathSegments[0] == 'teams') {
        return ManageTeamPath(uri.pathSegments[1]);
      }
      else if(uri.pathSegments[0] == 'create') {
        return ManageTeamCreatePath();
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
	
	if (configuration is ManageProfilePath) {
	  return RouteInformation(location '/profile');
	}
	
    return null;
  }
}
