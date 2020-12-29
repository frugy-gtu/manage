// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'team_create_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TeamCreateModel _$TeamCreateModelFromJson(Map<String, dynamic> json) {
  return TeamCreateModel(
    name: json['name'] as String,
    abbreviation: json['abbreviation'] as String,
  );
}

Map<String, dynamic> _$TeamCreateModelToJson(TeamCreateModel instance) =>
    <String, dynamic>{
      'name': instance.name,
      'abbreviation': instance.abbreviation,
    };
