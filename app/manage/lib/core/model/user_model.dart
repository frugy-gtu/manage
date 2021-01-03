import 'package:json_annotation/json_annotation.dart';
import 'package:manage/core/model/manage_model.dart';

part 'user_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class UserModel extends ManageModel {
  final String createdAt;
  final String email;
  final String username;
  final String id;

  const UserModel({this.email, this.id, this.username, this.createdAt});

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserModelToJson(this);
}
