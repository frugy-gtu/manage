// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'team_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TeamModel _$TeamModelFromJson(Map<String, dynamic> json) {
  return TeamModel(
    name: json['name'] as String,
    abbreviation: json['abbreviation'] as String,
    id: json['id'] as String,
    createdAt: json['created_at'] as String,
  );
}

Map<String, dynamic> _$TeamModelToJson(TeamModel instance) => <String, dynamic>{
      'name': instance.name,
      'abbreviation': instance.abbreviation,
      'id': instance.id,
      'created_at': instance.createdAt,
    };
