import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';

import 'manage_model.dart';

part 'user.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class User extends ManageModel {
  final String username;
  final String password;
  final String mail;

  const User(
    {@required this.mail, @required this.password, this.username});

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);
}
