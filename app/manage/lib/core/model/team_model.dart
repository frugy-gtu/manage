import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:manage/core/model/manage_model.dart';

part 'team_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class TeamModel extends ManageModel {
  final String name;
  final String abbreviation;
  final String id;
  final String createdAt;

  const TeamModel({@required this.name, @required this.abbreviation, this.id, this.createdAt});

  factory TeamModel.fromJson(Map<String, dynamic> json) => _$TeamModelFromJson(json);

  Map<String, dynamic> toJson() => _$TeamModelToJson(this);
}
