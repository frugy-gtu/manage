import 'package:flutter/material.dart';
import 'package:manage/core/model/sign_up_model.dart';
import 'package:manage/core/router/manage_route.dart';
import 'package:manage/core/router/manage_route_state.dart';
import 'package:manage/core/service/request_result.dart';
import 'package:provider/provider.dart';
import 'package:manage/core/service/user_service.dart' as service;

class SignUpScreenController extends ChangeNotifier {
  final TextEditingController uName = TextEditingController();
  final TextEditingController fName = TextEditingController();
  final TextEditingController lName = TextEditingController();
  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();

  String _uNameError = '';
  String _fNameError = '';
  String _lNameError = '';
  String _emailError = '';
  String _passwordError = '';
  String _credentialsError = '';

  String get uNameError => _uNameError;
  String get fNameError => _fNameError;
  String get lNameError => _lNameError;
  String get emailError => _emailError;
  String get passwordError => _passwordError;
  String get credentialsError => _credentialsError;

  Future<void> onSignUp(BuildContext context) async {
    if (_checkStatus()) {
      RequestResult status = await service.signUp(SignUpModel(
        username: uName.text.trim(),
        name: fName.text.trim(),
        surname: lName.text.trim(),
        email: email.text.trim(),
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
    _fNameError = fName.text.isEmpty ? 'Enter your name' : '';
    _lNameError = lName.text.isEmpty ? 'Enter your surname' : '';
    _emailError = email.text.isEmpty ? 'Enter your email' : '';
    _passwordError = password.text.isEmpty ? 'Enter your password' : '';

    notifyListeners();
  }

  bool _checkStatus() {
    if (uName.text.isNotEmpty &&
        fName.text.isNotEmpty &&
        lName.text.isNotEmpty &&
        email.text.isNotEmpty &&
        password.text.isNotEmpty) {
      return true;
    }

    return false;
  }

  @override
  void dispose() {
    uName.dispose();
    fName.dispose();
    lName.dispose();
    email.dispose();
    password.dispose();
    super.dispose();
  }
}
