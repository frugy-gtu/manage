import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:manage/core/model/user_model.dart';
import 'manage_model.dart';

part 'login_result_model.g.dart';

@JsonSerializable(
  fieldRename: FieldRename.snake,
  includeIfNull: false,
  explicitToJson: true,
)
class LoginResultModel extends ManageModel {
  final String accessToken;
  final UserModel user;

  const LoginResultModel({@required this.accessToken, this.user});

  factory LoginResultModel.fromJson(Map<String, dynamic> json) =>
      _$LoginResultModelFromJson(json);

  Map<String, dynamic> toJson() => _$LoginResultModelToJson(this);
}
