import 'package:manage/core/cache/auth.dart';
import 'package:manage/core/model/login_result_model.dart';
import 'package:manage/core/model/login_model.dart';
import 'package:manage/core/service/request_method.dart';
import 'package:manage/core/service/request_result.dart';

import 'manage_service.dart' as service;

Future<RequestResult> login(LoginModel model) async => service.request(
    method: RequestMethod.post,
    url: '/users/login',
    jsonData: model.toJson(),
    successCallback: (success) {
      LoginResultModel result = LoginResultModel.fromJson(success.data);
      Auth.accessToken = result.accessToken;
      Auth.status = AuthStatus.logged_in;
      Auth.user = result.user;
    });

Future<RequestResult> signUp(LoginModel model) async => service.request(
      method: RequestMethod.post,
      url: '/users/signup',
      jsonData: model.toJson(),
    );
