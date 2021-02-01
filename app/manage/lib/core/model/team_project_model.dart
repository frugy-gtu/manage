import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';

import 'package:manage/core/model/manage_model.dart';

part 'team_project_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class TeamProjectModel extends ManageModel {
  final String id;
  final String name;
  final String createdAt;

  const TeamProjectModel({@required this.name, this.id, this.createdAt});

  factory TeamProjectModel.fromJson(Map<String, dynamic> json) => _$TeamProjectModelFromJson(json);

  Map<String, dynamic> toJson() => _$TeamProjectModelToJson(this);
}
