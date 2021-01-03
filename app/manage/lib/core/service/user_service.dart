import 'package:manage/core/cache/auth.dart';
import 'package:manage/core/model/general_user_model.dart';
import 'package:manage/core/model/token_model.dart';
import 'package:manage/core/model/login_model.dart';
import 'package:manage/core/service/request_method.dart';
import 'package:manage/core/service/request_result.dart';

import 'manage_service.dart' as service;

Future<RequestResult> login(LoginModel model) async => service.request(
    method: RequestMethod.post,
    url: '/users/login',
    jsonData: model.toJson(),
    successCallback: (success) {
      Auth.accessToken = TokenModel.fromJson(success.data).accessToken;
      Auth.status = AuthStatus.logged_in;
      Auth.user = GeneralUserModel(
          email: 'demo@demo.com',
          username: 'demo',
          createdAt: '02/02/2021');
    });

Future<RequestResult> signUp(LoginModel model) async => service.request(
      method: RequestMethod.post,
      url: '/users/signup',
      jsonData: model.toJson(),
    );
