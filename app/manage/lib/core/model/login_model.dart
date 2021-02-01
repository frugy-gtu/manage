import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';

import 'manage_model.dart';

part 'login_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
class LoginModel extends ManageModel {
  final String username;
  final String password;
  final String email;

  const LoginModel({
    this.email,
    @required this.password,
    this.username = '',
  });

  factory LoginModel.fromJson(Map<String, dynamic> json) =>
      _$LoginModelFromJson(json);

  Map<String, dynamic> toJson() => _$LoginModelToJson(this);
}
