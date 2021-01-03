<<<<<<< HEAD
part of 'task_model.dart';

TaskModel _$TaskModelFromJson(Map<String, dynamic> json){
  return TaskModel(
    name: json['name'] as String, 
    deadLine: json['deadLine'] as String, 
    scheduledTime: json['scheduledTime'] as String,
    description: json['description'] as String,
    status: json['status'] as TaskStatus
=======
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
>>>>>>> develop
  );
}

Map<String, dynamic> _$TaskModelToJson(TaskModel instance) => <String, dynamic>{
<<<<<<< HEAD
  'name': instance.name,
  'deadLine': instance.deadLine,
  'scheduledTime': instance.scheduledTime,
  'description': instance.description,
  'status': instance.status,
};
=======
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
>>>>>>> develop
