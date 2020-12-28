import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';
import 'manage_model.dart';

part 'generated_error_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class GeneratedErrorModel extends ManageModel {
  @JsonKey(name: 'errors')
  final Map<String, Map<String, List<String>>> table;

  const GeneratedErrorModel({@required this.table});

  factory GeneratedErrorModel.fromJson(Map<String, dynamic> json) => _$GeneratedErrorModelFromJson(json);

  Map<String, dynamic> toJson() => _$GeneratedErrorModelToJson(this);

  @override
  ManageModel decode(Map<String, dynamic> json) => GeneratedErrorModel.fromJson(json);
}
