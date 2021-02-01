import 'package:json_annotation/json_annotation.dart';
import 'manage_model.dart';

part 'team_users_post_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
class TeamUsersPostModel extends ManageModel {
  final String userId;
  final String username;

  const TeamUsersPostModel({this.userId, this.username});

  factory TeamUsersPostModel.fromJson(Map<String, dynamic> json) =>
      _$TeamUsersPostModelFromJson(json);

  Map<String, dynamic> toJson() => _$TeamUsersPostModelToJson(this);
}
