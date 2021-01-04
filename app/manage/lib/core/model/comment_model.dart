import 'package:flutter/cupertino.dart';
import 'package:manage/core/model/user_profile_model.dart';

class CommentModel{
  String comment;
  UserProfileModel writer;

  CommentModel({@required this.comment, @required this.writer});
}