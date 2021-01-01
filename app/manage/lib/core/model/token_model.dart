import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';
import 'manage_model.dart';

part 'token_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class TokenModel extends ManageModel {
  final String accessToken;

  const TokenModel({@required this.accessToken});

  factory TokenModel.fromJson(Map<String, dynamic> json) => _$TokenModelFromJson(json);

  Map<String, dynamic> toJson() => _$TokenModelToJson(this);
}
