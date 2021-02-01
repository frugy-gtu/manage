import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:manage/core/model/manage_model.dart';

part 'team_create_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class TeamCreateModel extends ManageModel {
  final String name;
  final String abbreviation;

  const TeamCreateModel({@required this.name, @required this.abbreviation});

  factory TeamCreateModel.fromJson(Map<String, dynamic> json) => _$TeamCreateModelFromJson(json);

  Map<String, dynamic> toJson() => _$TeamCreateModelToJson(this);
}
