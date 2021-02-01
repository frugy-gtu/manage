import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';
import 'manage_model.dart';

part 'task_state_put_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
class TaskStatePutModel extends ManageModel {
  final String stateId;

  const TaskStatePutModel({
    @required this.stateId,
  });

  factory TaskStatePutModel.fromJson(Map<String, dynamic> json) =>
      _$TaskStatePutModelFromJson(json);

  Map<String, dynamic> toJson() => _$TaskStatePutModelToJson(this);
}
