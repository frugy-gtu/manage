// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task_query.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TaskQuery _$TaskQueryFromJson(Map<String, dynamic> json) {
  return TaskQuery(
    projectId: json['project_id'] as String,
    taskGroupId: json['task_group_id'] as String,
    stateId: json['state_id'] as String,
  );
}

Map<String, dynamic> _$TaskQueryToJson(TaskQuery instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('project_id', instance.projectId);
  writeNotNull('task_group_id', instance.taskGroupId);
  writeNotNull('state_id', instance.stateId);
  return val;
}
