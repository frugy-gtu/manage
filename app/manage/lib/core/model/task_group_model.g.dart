// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task_group_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TaskGroupModel _$TaskGroupModelFromJson(Map<String, dynamic> json) {
  return TaskGroupModel(
    name: json['name'] as String,
    id: json['id'] as String,
    createdAt: json['created_at'] as String,
  );
}

Map<String, dynamic> _$TaskGroupModelToJson(TaskGroupModel instance) =>
    <String, dynamic>{
      'name': instance.name,
      'id': instance.id,
      'created_at': instance.createdAt,
    };
