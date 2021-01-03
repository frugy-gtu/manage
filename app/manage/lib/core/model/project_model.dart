import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';

import 'package:manage/core/model/team_project_model.dart';

part 'project_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class ProjectModel extends TeamProjectModel {
  final String teamId;

  const ProjectModel(
      {@required String name, String id, String createdAt, this.teamId})
      : super(name: name, id: id, createdAt: createdAt);

  factory ProjectModel.fromJson(Map<String, dynamic> json) =>
      _$ProjectModelFromJson(json);

  Map<String, dynamic> toJson() => _$ProjectModelToJson(this);
}
