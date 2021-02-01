import 'package:flutter/material.dart';
import 'package:manage/core/model/login_model.dart';
import 'package:manage/core/router/manage_route.dart';
import 'package:manage/core/router/manage_route_state.dart';
import 'package:manage/core/service/request_result.dart';
import 'package:provider/provider.dart';
import 'package:manage/core/service/user_service.dart' as service;

class LoginController extends ChangeNotifier {
  final TextEditingController emailOrUName = TextEditingController();
  final TextEditingController password = TextEditingController();

  String _emailOrUNameError = '';
  String _passwordError = '';
  String _credentialsError = '';

  String get emailOrUNameError => _emailOrUNameError;
  String get passwordError => _passwordError;
  String get credentialsError => _credentialsError;

  Future<void> onLogin(BuildContext context) async {
    if (_checkStatus()) {
      RequestResult status;
      if (emailOrUName.text.contains('@')) {
        status = await service
            .login(LoginModel(email: emailOrUName.text.trim(), password: password.text));
      } else {
        status = await service
            .login(LoginModel(username: emailOrUName.text.trim(), password: password.text));
      }
      if (status.status == Status.success) {
        context.read<ManageRouteState>()
          ..resetRoutes()
          ..update(ManageRoute.teams);
        return;
      } else {
        _credentialsError = status.msg;
      }
    } else
      _credentialsError = '';

    _emailOrUNameError = emailOrUName.text.isEmpty ? 'Enter your email' : '';
    _passwordError = password.text.isEmpty ? 'Enter your password' : '';

    notifyListeners();
  }

  void onSignUp(BuildContext context) {
    context.read<ManageRouteState>().update(ManageRoute.signup);
  }

  bool _checkStatus() {
    if (emailOrUName.text.isNotEmpty && password.text.isNotEmpty) {
      return true;
    }

    return false;
  }

  @override
  void dispose() {
    emailOrUName.dispose();
    password.dispose();
    super.dispose();
  }
}
