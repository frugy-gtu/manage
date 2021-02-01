import 'package:manage/core/model/manage_model.dart';
import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user_profile_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
class UserProfileModel extends ManageModel {
  final String name;
  final String surname;
  final String avatar;

  const UserProfileModel(
      {@required this.name, @required this.surname, this.avatar});

  factory UserProfileModel.fromJson(Map<String, dynamic> json) =>
      _$UserProfileModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserProfileModelToJson(this);
}
