import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';

part 'team.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class Team {
  final String name;
  final String abbrv;
  final String id;
  final String createdAt;

  const Team({@required this.name, @required this.abbrv, this.id, this.createdAt});

  factory Team.fromJson(Map<String, dynamic> json) => _$TeamFromJson(json);

  Map<String, dynamic> toJson() => _$TeamToJson(this);
}