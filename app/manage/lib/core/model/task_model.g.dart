// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TaskModel _$TaskModelFromJson(Map<String, dynamic> json) {
  return TaskModel(
    details: json['details'] as String,
    projectId: json['project_id'] as String,
    createdAt: json['created_at'] as String,
    id: json['id'] as String,
    stateId: json['state_id'] as String,
    taskTagId: json['task_tag_id'] as String,
    deadline: json['deadline'] as String,
    schedule: json['schedule'] as String,
    name: json['name'] as String,
    taskGroupId: json['task_group_id'] as String,
  );
}

Map<String, dynamic> _$TaskModelToJson(TaskModel instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('details', instance.details);
  writeNotNull('project_id', instance.projectId);
  writeNotNull('created_at', instance.createdAt);
  writeNotNull('id', instance.id);
  writeNotNull('state_id', instance.stateId);
  writeNotNull('task_tag_id', instance.taskTagId);
  writeNotNull('deadline', instance.deadline);
  writeNotNull('schedule', instance.schedule);
  writeNotNull('name', instance.name);
  writeNotNull('task_group_id', instance.taskGroupId);
  return val;
}
