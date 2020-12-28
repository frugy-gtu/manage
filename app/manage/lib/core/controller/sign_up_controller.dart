import 'package:flutter/material.dart';
import 'package:manage/core/model/user.dart';
import 'package:manage/core/router/manage_route.dart';
import 'package:manage/core/router/manage_route_state.dart';
import 'package:manage/core/service/response_status.dart';
import 'package:provider/provider.dart';
import 'package:manage/core/service/user_service.dart' as service;

class SignUpScreenController extends ChangeNotifier {
  final TextEditingController uName = TextEditingController();
  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();

  String _uNameError = '';
  String _emailError = '';
  String _passwordError = '';
  String _credentialsError = '';

  String get uNameError => _uNameError;
  String get emailError => _emailError;
  String get passwordError => _passwordError;
  String get credentialsError => _credentialsError;

  Future<void> onSignUp(BuildContext context) async {
    if (_checkStatus()) {
      ResponseResult status = await service.signUp(User(
        username: uName.text,
        email: email.text,
        password: password.text,
      ));

      if (status.status == Status.success) {
        context.read<ManageRouteState>().update(ManageRoute.login);
        return;
      } else {
        _credentialsError = status.msg;
      }
    } else
      _credentialsError = '';

    _uNameError = uName.text.isEmpty ? 'Enter your username' : '';
    _emailError = email.text.isEmpty ? 'Enter your email' : '';
    _passwordError = password.text.isEmpty ? 'Enter your password' : '';

    notifyListeners();
  }

  bool _checkStatus() {
    if (uName.text.isNotEmpty &&
        email.text.isNotEmpty &&
        password.text.isNotEmpty) {
      return true;
    }

    return false;
  }

  @override
  void dispose() {
    uName.dispose();
    email.dispose();
    password.dispose();
    super.dispose();
  }
}
