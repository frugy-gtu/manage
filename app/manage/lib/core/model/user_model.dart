import 'package:json_annotation/json_annotation.dart';
import 'package:manage/core/model/manage_model.dart';
import 'package:manage/core/model/user_profile_model.dart';

part 'user_model.g.dart';

@JsonSerializable(
    fieldRename: FieldRename.snake, includeIfNull: false, explicitToJson: true)
class UserModel extends ManageModel {
  final String email;
  final String username;
  final String id;
  final UserProfileModel profile;

  const UserModel({this.email, this.id, this.username, this.profile});

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserModelToJson(this);
}
