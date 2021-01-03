// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserModel _$UserModelFromJson(Map<String, dynamic> json) {
  return UserModel(
    email: json['email'] as String,
    id: json['id'] as String,
    username: json['username'] as String,
    createdAt: json['created_at'] as String,
  );
}

Map<String, dynamic> _$UserModelToJson(UserModel instance) => <String, dynamic>{
      'created_at': instance.createdAt,
      'email': instance.email,
      'username': instance.username,
      'id': instance.id,
    };
