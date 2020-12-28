import 'package:manage/core/cache/auth.dart';
import 'package:manage/core/model/access_model.dart';
import 'package:manage/core/model/error_model.dart';
import 'package:manage/core/model/user_model.dart';
import 'package:manage/core/service/manage_response.dart';
import 'package:manage/core/service/response_status.dart';

import 'manage_service.dart' as service;

Future<ResponseResult> login(UserModel request) async {
  ManageResponse response =
      await service.post('/users/login', data: request.toJson());

  if (response == null) {
    return ResponseResult(Status.fail);
  }

  if (response.success == null) {
    ErrorModel error = ErrorModel.fromJson(response.fail.data);
    String errorMsg = error?.table['schema_errors']?.values?.first[0];
    return ResponseResult(Status.fail, msg: errorMsg ?? 'Something went wrong.');
  }

  Auth.accessToken = AccessModel.fromJson(response.success.data).accessToken;
  Auth.status = AuthStatus.logged_in;

  return ResponseResult(Status.success);
}

Future<ResponseResult> signUp(UserModel request) async {
  ManageResponse response =
      await service.post('/users/signup', data: request.toJson());

  if (response == null) {
    return ResponseResult(Status.fail);
  }

  if (response.success == null) {
    ErrorModel error = ErrorModel.fromJson(response.fail.data);
    String errorMsg = error?.table['schema_errors']?.values?.first[0];
    return ResponseResult(Status.fail, msg: errorMsg ?? 'Something went wrong');
  }

  return ResponseResult(Status.success);
}
