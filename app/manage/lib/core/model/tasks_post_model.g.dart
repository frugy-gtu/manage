// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tasks_post_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TasksPostModel _$TasksPostModelFromJson(Map<String, dynamic> json) {
  return TasksPostModel(
    details: json['details'] as String,
    stateId: json['state_id'] as String,
    deadline: json['deadline'] as String,
    schedule: json['schedule'] as String,
    taskGroupId: json['task_group_id'] as String,
    name: json['name'] as String,
    tagId: json['tag_id'] as String,
  );
}

Map<String, dynamic> _$TasksPostModelToJson(TasksPostModel instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('details', instance.details);
  writeNotNull('state_id', instance.stateId);
  writeNotNull('deadline', instance.deadline);
  writeNotNull('schedule', instance.schedule);
  writeNotNull('task_group_id', instance.taskGroupId);
  writeNotNull('name', instance.name);
  writeNotNull('tag_id', instance.tagId);
  return val;
}
