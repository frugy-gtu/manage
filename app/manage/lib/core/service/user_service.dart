import 'package:manage/core/cache/auth.dart';
import 'package:manage/core/model/login_user_model.dart';
import 'package:manage/core/model/token_model.dart';
import 'package:manage/core/model/user_model.dart';
import 'package:manage/core/service/request_method.dart';
import 'package:manage/core/service/request_result.dart';

import 'manage_service.dart' as service;

Future<RequestResult> login(UserModel model) async => service.request(
    method: RequestMethod.post,
    url: '/users/login',
    jsonData: model.toJson(),
    successCallback: (success) {
      Auth.accessToken = TokenModel.fromJson(success.data).accessToken;
      Auth.status = AuthStatus.logged_in;
      Auth.user = LoginUserModel(
          email: 'demo@gmail.com',
          username: 'DemoDemo',
          createdAt: '02/02/2021');
    });

Future<RequestResult> signUp(UserModel model) async => service.request(
      method: RequestMethod.post,
      url: '/users/signup',
      jsonData: model.toJson(),
    );
