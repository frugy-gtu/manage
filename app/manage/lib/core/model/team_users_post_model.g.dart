// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'team_users_post_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TeamUsersPostModel _$TeamUsersPostModelFromJson(Map<String, dynamic> json) {
  return TeamUsersPostModel(
    userId: json['user_id'] as String,
    username: json['username'] as String,
  );
}

Map<String, dynamic> _$TeamUsersPostModelToJson(TeamUsersPostModel instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('user_id', instance.userId);
  writeNotNull('username', instance.username);
  return val;
}
