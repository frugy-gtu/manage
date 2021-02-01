import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';

import 'login_model.dart';

part 'sign_up_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
class SignUpModel extends LoginModel {
  final String avatar;
  final String name;
  final String surname;

  const SignUpModel({
    @required String email,
    @required String password,
    @required String username,
    @required this.name,
    @required this.surname,
    this.avatar,
  }) : super(email: email, password: password, username: username);

  factory SignUpModel.fromJson(Map<String, dynamic> json) =>
      _$SignUpModelFromJson(json);

  Map<String, dynamic> toJson() => _$SignUpModelToJson(this);
}
