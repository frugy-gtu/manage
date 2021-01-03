<<<<<<< HEAD
import 'package:manage/core/model/manage_model.dart';
import 'package:manage/core/model/task_status.dart';
import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';
=======
import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';
import 'manage_model.dart';
>>>>>>> develop

part 'task_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
<<<<<<< HEAD
class TaskModel extends ManageModel{
  final String name;
  final String description;
  final String deadLine;
  final String scheduledTime;
  final TaskStatus status;
  
  const TaskModel({@required this.name, @required this.deadLine, @required this.scheduledTime, this.description, @required this.status});
=======
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
>>>>>>> develop

  factory TaskModel.fromJson(Map<String, dynamic> json) => _$TaskModelFromJson(json);

  Map<String, dynamic> toJson() => _$TaskModelToJson(this);
<<<<<<< HEAD
}
=======
}
>>>>>>> develop
