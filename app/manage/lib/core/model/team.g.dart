// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'team.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Team _$TeamFromJson(Map<String, dynamic> json) {
  return Team(
    name: json['name'] as String,
    abbrv: json['abbrv'] as String,
    id: json['id'] as String,
    createdAt: json['created_at'] as String,
  );
}

Map<String, dynamic> _$TeamToJson(Team instance) => <String, dynamic>{
      'name': instance.name,
      'abbrv': instance.abbrv,
      'id': instance.id,
      'created_at': instance.createdAt,
    };
