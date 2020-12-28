import 'package:flutter/material.dart';
import 'package:manage/core/model/user.dart';
import 'package:manage/core/router/manage_route.dart';
import 'package:manage/core/router/manage_route_state.dart';
import 'package:provider/provider.dart';
import 'package:manage/core/service/user_service.dart' as service;

class LoginController extends ChangeNotifier {
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();

  String _emailError = '';
  String _passwordError = '';
  String _credentialsError = '';

  TextEditingController get email => _email;
  TextEditingController get password => _password;

  String get emailError => _emailError;
  String get passwordError => _passwordError;
  String get credentialsError => _credentialsError;

  Future<void> onLogin(BuildContext context) async {
    if (_checkStatus()) {
      if (await service
          .login(User(email: _email.text, password: _password.text))) {
        context.read<ManageRouteState>().update(ManageRoute.teams);
        return;
      } else {
        _credentialsError = 'Incorrect email or password!';
      }
    }
    else _credentialsError = '';

    _emailError = email.text.isEmpty ? 'Enter your email' : '';
    _passwordError = password.text.isEmpty ? 'Enter your password' : '';

    notifyListeners();
  }

  void onSignUp(BuildContext context) {
    context.read<ManageRouteState>().update(ManageRoute.signup);
  }

  bool _checkStatus() {
    if (_email.text.isNotEmpty && _password.text.isNotEmpty) {
      return true;
    }

    return false;
  }

  @override
  void dispose() {
    email.dispose();
    password.dispose();
    super.dispose();
  }
}
