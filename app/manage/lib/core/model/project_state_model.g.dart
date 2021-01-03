// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'project_state_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProjectStateModel _$ProjectStateModelFromJson(Map<String, dynamic> json) {
  return ProjectStateModel(
    name: json['name'] as String,
    id: json['id'] as String,
    createdAt: json['created_at'] as String,
    rank: json['rank'] as int,
  );
}

Map<String, dynamic> _$ProjectStateModelToJson(ProjectStateModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'created_at': instance.createdAt,
      'rank': instance.rank,
    };
