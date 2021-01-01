part of 'task_model.dart';

TaskModel _$TaskModelFromJson(Map<String, dynamic> json){
  return TaskModel(
    name: json['name'] as String, 
    deadLine: json['deadLine'] as String, 
    description: json['description'] as String,
    status: json['status'] as TaskStatus
  );
}

Map<String, dynamic> _$TaskModelToJson(TaskModel instance) => <String, dynamic>{
  'name': instance.name,
  'deadLine': instance.deadLine,
  'description': instance.description,
  'status': instance.status,
};