// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'team.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Team _$TeamFromJson(Map<String, dynamic> json) {
  return Team(
    name: json['name'] as String,
    abbreviation: json['abbreviation'] as String,
    id: json['id'] as String,
    createdAt: json['created_at'] as String,
  );
}

Map<String, dynamic> _$TeamToJson(Team instance) => <String, dynamic>{
      'name': instance.name,
      'abbreviation': instance.abbreviation,
      'id': instance.id,
      'created_at': instance.createdAt,
    };
