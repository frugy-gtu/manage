// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'team_project_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TeamProjectModel _$TeamProjectModelFromJson(Map<String, dynamic> json) {
  return TeamProjectModel(
    name: json['name'] as String,
    id: json['id'] as String,
    createdAt: json['created_at'] as String,
  );
}

Map<String, dynamic> _$TeamProjectModelToJson(TeamProjectModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'created_at': instance.createdAt,
    };
