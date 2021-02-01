// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task_state_put_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TaskStatePutModel _$TaskStatePutModelFromJson(Map<String, dynamic> json) {
  return TaskStatePutModel(
    stateId: json['state_id'] as String,
  );
}

Map<String, dynamic> _$TaskStatePutModelToJson(TaskStatePutModel instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('state_id', instance.stateId);
  return val;
}
