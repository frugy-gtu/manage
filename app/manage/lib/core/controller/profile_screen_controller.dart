import 'package:flutter/material.dart';
import 'package:manage/core/cache/auth.dart';
import 'package:manage/core/router/manage_route.dart';
import 'package:manage/core/router/manage_route_state.dart';
import 'package:provider/provider.dart';

class ProfileScreenController {

  ProfileScreenController();

  bool isUserProfile(BuildContext context) {
    if(context.read<ManageRouteState>().route == ManageRoute.profile) {
      return true;
    }

    return false;
  }

  void onLogout(BuildContext context) {
    Auth.status = AuthStatus.logged_out;
    context.read<ManageRouteState>().update(ManageRoute.login);
  }
}
