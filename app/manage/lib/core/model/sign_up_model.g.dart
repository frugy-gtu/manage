// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sign_up_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SignUpModel _$SignUpModelFromJson(Map<String, dynamic> json) {
  return SignUpModel(
    email: json['email'] as String,
    password: json['password'] as String,
    username: json['username'] as String,
    name: json['name'] as String,
    surname: json['surname'] as String,
    avatar: json['avatar'] as String,
  );
}

Map<String, dynamic> _$SignUpModelToJson(SignUpModel instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('username', instance.username);
  writeNotNull('password', instance.password);
  writeNotNull('email', instance.email);
  writeNotNull('avatar', instance.avatar);
  writeNotNull('name', instance.name);
  writeNotNull('surname', instance.surname);
  return val;
}
