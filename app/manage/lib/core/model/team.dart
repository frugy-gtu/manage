import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:manage/core/model/manage_model.dart';

part 'team.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class Team extends ManageModel {
  final String name;
  final String abbreviation;
  final String id;
  final String createdAt;

  const Team({@required this.name, @required this.abbreviation, this.id, this.createdAt});

  factory Team.fromJson(Map<String, dynamic> json) => _$TeamFromJson(json);

  Map<String, dynamic> toJson() => _$TeamToJson(this);
}
