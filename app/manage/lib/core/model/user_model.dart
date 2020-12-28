import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';

import 'manage_model.dart';

part 'user_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class UserModel extends ManageModel {
  final String username;
  final String password;
  final String email;

  const UserModel(
    {@required this.email, @required this.password, this.username = ''});

  factory UserModel.fromJson(Map<String, dynamic> json) => _$UserModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserModelToJson(this);
}
