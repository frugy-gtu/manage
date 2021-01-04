import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';
import 'manage_model.dart';

part 'task_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
class TaskModel extends ManageModel {
  final String details;
  final String projectId;
  final String createdAt;
  final String id;
  final String taskStateId;
  final String taskTagId;
  final String deadline;
  final String schedule;
  final String name;
  final String taskGroupId;

  const TaskModel({
    @required this.details,
    @required this.projectId,
    @required this.createdAt,
    @required this.id,
    @required this.taskStateId,
    @required this.taskTagId,
    @required this.deadline,
    @required this.schedule,
    @required this.name,
    @required this.taskGroupId,
  });

  factory TaskModel.fromJson(Map<String, dynamic> json) =>
      _$TaskModelFromJson(json);

  Map<String, dynamic> toJson() => _$TaskModelToJson(this);
}
