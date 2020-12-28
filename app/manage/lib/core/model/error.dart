import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';
import 'manage_model.dart';

part 'error.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class Error extends ManageModel {
  @JsonKey(name: 'errors')
  final Map<String, Map<String, List<String>>> table;

  const Error({@required this.table});

  factory Error.fromJson(Map<String, dynamic> json) => _$ErrorFromJson(json);

  Map<String, dynamic> toJson() => _$ErrorToJson(this);
}
