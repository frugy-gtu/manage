import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';
import 'manage_model.dart';

part 'error_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class ErrorModel extends ManageModel {
  final String msg;

  const ErrorModel({@required this.msg});

  factory ErrorModel.fromJson(Map<String, dynamic> json) => _$ErrorModelFromJson(json);

  Map<String, dynamic> toJson() => _$ErrorModelToJson(this);
}
