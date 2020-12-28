import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';
import 'manage_model.dart';

part 'access.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class Access extends ManageModel {
  final String accessToken;

  const Access({@required this.accessToken});

  factory Access.fromJson(Map<String, dynamic> json) => _$AccessFromJson(json);

  Map<String, dynamic> toJson() => _$AccessToJson(this);
}
