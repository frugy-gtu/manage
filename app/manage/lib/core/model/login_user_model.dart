import 'package:flutter/foundation.dart';

import 'manage_model.dart';

class LoginUserModel extends ManageModel {
  final String username;
  final String email;
  final String createdAt;

  const LoginUserModel(
    {@required this.email, @required this.createdAt, @required this.username});

}
