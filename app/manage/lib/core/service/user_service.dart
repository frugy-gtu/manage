import 'package:manage/core/cache/auth.dart';
import 'package:manage/core/model/access_model.dart';
import 'package:manage/core/model/user_model.dart';
import 'package:manage/core/service/request_method.dart';
import 'package:manage/core/service/request_result.dart';

import 'manage_service.dart' as service;

Future<RequestResult> login(UserModel model) async => service.request(
    method: RequestMethod.post,
    url: '/users/login',
    jsonData: model.toJson(),
    successCallback: (success) {
      Auth.accessToken = AccessModel.fromJson(success.data).accessToken;
      Auth.status = AuthStatus.logged_in;
    });

Future<RequestResult> signUp(UserModel model) async => service.request(
      method: RequestMethod.post,
      url: '/users/signup',
      jsonData: model.toJson(),
    );
