// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'team_user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TeamUserModel _$TeamUserModelFromJson(Map<String, dynamic> json) {
  return TeamUserModel(
    email: json['email'] as String,
    password: json['password'] as String,
    username: json['username'] as String,
    createdAt: json['created_at'] as String,
  );
}

Map<String, dynamic> _$TeamUserModelToJson(TeamUserModel instance) =>
    <String, dynamic>{
      'username': instance.username,
      'password': instance.password,
      'email': instance.email,
      'created_at': instance.createdAt,
    };
