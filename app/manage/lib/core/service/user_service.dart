import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:manage/core/cache/auth.dart';
import 'package:manage/core/model/user.dart';

import 'manage_service.dart' as service;

Future<bool> login(User request) async {
  Response response = await service.post('/users/login', data: request.toJson());

  if(response == null) {
    return false;
  }

  Auth.accessToken = jsonDecode(response.data)['access_token'];
  Auth.status = AuthStatus.logged_in;

  return true;
}

Future<bool> signUp(User request) async {
  Response response = await service.post('/users/signup', data: request.toJson());

  if(response == null) {
    return false;
  }

  return true;
}