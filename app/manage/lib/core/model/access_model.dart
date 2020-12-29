import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';
import 'manage_model.dart';

part 'access_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class AccessModel extends ManageModel {
  final String accessToken;

  const AccessModel({@required this.accessToken});

  factory AccessModel.fromJson(Map<String, dynamic> json) => _$AccessModelFromJson(json);

  Map<String, dynamic> toJson() => _$AccessModelToJson(this);
}
