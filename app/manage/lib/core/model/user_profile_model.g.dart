// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_profile_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserProfileModel _$UserProfileModelFromJson(Map<String, dynamic> json) {
  return UserProfileModel(
    name: json['name'] as String,
    surname: json['surname'] as String,
    avatar: json['avatar'] as String,
  );
}

Map<String, dynamic> _$UserProfileModelToJson(UserProfileModel instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('name', instance.name);
  writeNotNull('surname', instance.surname);
  writeNotNull('avatar', instance.avatar);
  return val;
}
