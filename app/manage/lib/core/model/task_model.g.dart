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
    taskStateId: json['task_state_id'] as String,
    taskTagId: json['task_tag_id'] as String,
    deadline: json['deadline'] as String,
    schedule: json['schedule'] as String,
    name: json['name'] as String,
    taskGroupId: json['task_group_id'] as String,
  );
}

Map<String, dynamic> _$TaskModelToJson(TaskModel instance) => <String, dynamic>{
      'details': instance.details,
      'project_id': instance.projectId,
      'created_at': instance.createdAt,
      'id': instance.id,
      'task_state_id': instance.taskStateId,
      'task_tag_id': instance.taskTagId,
      'deadline': instance.deadline,
      'schedule': instance.schedule,
      'name': instance.name,
      'task_group_id': instance.taskGroupId,
    };
