// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task_query.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TaskQuery _$TaskQueryFromJson(Map<String, dynamic> json) {
  return TaskQuery(
    projectId: json['project_id'] as String,
    taskGroupId: json['task_group_id'] as String,
  );
}

Map<String, dynamic> _$TaskQueryToJson(TaskQuery instance) => <String, dynamic>{
      'project_id': instance.projectId,
      'task_group_id': instance.taskGroupId,
    };
