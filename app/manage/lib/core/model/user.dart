import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';

import 'manage_model.dart';

part 'user.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class User extends ManageModel {
  final String username;
  final String password;
  final String email;

  const User(
    {@required this.username, @required this.password, @required this.email});

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);
}
