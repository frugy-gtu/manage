import 'package:json_annotation/json_annotation.dart';
import 'package:manage/core/model/manage_model.dart';

part 'general_user_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class GeneralUserModel extends ManageModel {
  final String createdAt;
  final String email;
  final String username;
  final String id;

  const GeneralUserModel({this.email, this.id, this.username, this.createdAt});

  factory GeneralUserModel.fromJson(Map<String, dynamic> json) =>
      _$GeneralUserModelFromJson(json);

  Map<String, dynamic> toJson() => _$GeneralUserModelToJson(this);
}
