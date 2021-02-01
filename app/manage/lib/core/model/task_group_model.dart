import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:manage/core/model/manage_model.dart';

part 'task_group_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class TaskGroupModel extends ManageModel {
  final String name;
  final String id;
  final String createdAt;

  const TaskGroupModel({@required this.name, this.id, this.createdAt});

  factory TaskGroupModel.fromJson(Map<String, dynamic> json) => _$TaskGroupModelFromJson(json);

  Map<String, dynamic> toJson() => _$TaskGroupModelToJson(this);
}
