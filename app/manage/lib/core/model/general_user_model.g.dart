// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'general_user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GeneralUserModel _$GeneralUserModelFromJson(Map<String, dynamic> json) {
  return GeneralUserModel(
    email: json['email'] as String,
    id: json['id'] as String,
    username: json['username'] as String,
    createdAt: json['created_at'] as String,
  );
}

Map<String, dynamic> _$GeneralUserModelToJson(GeneralUserModel instance) =>
    <String, dynamic>{
      'created_at': instance.createdAt,
      'email': instance.email,
      'username': instance.username,
      'id': instance.id,
    };
