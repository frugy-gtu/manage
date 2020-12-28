import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';
import 'manage_model.dart';

part 'error_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class ErrorModel extends ManageModel {
  @JsonKey(name: 'errors')
  final Map<String, Map<String, List<String>>> table;

  const ErrorModel({@required this.table});

  factory ErrorModel.fromJson(Map<String, dynamic> json) => _$ErrorModelFromJson(json);

  Map<String, dynamic> toJson() => _$ErrorModelToJson(this);
}
