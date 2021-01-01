
import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';

import 'user_model.dart';

part 'team_user_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class TeamUserModel extends UserModel {
  final String createdAt;

  const TeamUserModel(
    {@required String email, @required String password, String username = '', this.createdAt})
  : super(email: email, password: password, username: username);

  factory TeamUserModel.fromJson(Map<String, dynamic> json) => _$TeamUserModelFromJson(json);

  Map<String, dynamic> toJson() => _$TeamUserModelToJson(this);
}
