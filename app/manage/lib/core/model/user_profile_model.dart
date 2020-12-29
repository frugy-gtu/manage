import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'manage_model.dart';

class UserProfileModel extends ManageModel{
  final String userName;
  final String name;
  final String surname;
  final Image profilePhoto;

  const UserProfileModel({@required this.userName, @required this.name, @required this.surname, this.profilePhoto});
}