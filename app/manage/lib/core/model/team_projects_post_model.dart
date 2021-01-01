import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';
import 'manage_model.dart';

part 'team_projects_post_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class TeamProjectsPostModel extends ManageModel {
  final String name;

  const TeamProjectsPostModel({@required this.name});

  factory TeamProjectsPostModel.fromJson(Map<String, dynamic> json) => _$TeamProjectsPostModelFromJson(json);

  Map<String, dynamic> toJson() => _$TeamProjectsPostModelToJson(this);
}
