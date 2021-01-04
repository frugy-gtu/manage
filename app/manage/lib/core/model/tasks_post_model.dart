import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';
import 'manage_model.dart';

part 'tasks_post_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
class TasksPostModel extends ManageModel {
  final String details;
  final String stateId;
  final String deadline;
  final String schedule;
  final String taskGroupId;
  final String name;
  final String tagId;

  const TasksPostModel({
    @required this.details,
    @required this.stateId,
    @required this.deadline,
    @required this.schedule,
    @required this.taskGroupId,
    @required this.name,
    this.tagId,
  });

  factory TasksPostModel.fromJson(Map<String, dynamic> json) =>
      _$TasksPostModelFromJson(json);

  Map<String, dynamic> toJson() => _$TasksPostModelToJson(this);
}
