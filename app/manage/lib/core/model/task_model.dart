import 'package:manage/core/model/manage_model.dart';
import 'package:manage/core/model/task_status_model.dart';
import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';

part 'task_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class TaskModel extends ManageModel{
  final String name;
  final String description;
  final String deadLine;
  final TaskStatus status;
  
  const TaskModel({@required this.name, @required this.deadLine, this.description, @required this.status});

  factory TaskModel.fromJson(Map<String, dynamic> json) => _$TaskModelFromJson(json);

  Map<String, dynamic> toJson() => _$TaskModelToJson(this);
}