import 'package:manage/core/cache/auth.dart';
import 'package:manage/core/model/access.dart';
import 'package:manage/core/model/error.dart';
import 'package:manage/core/model/user.dart';
import 'package:manage/core/service/manage_response.dart';
import 'package:manage/core/service/response_status.dart';

import 'manage_service.dart' as service;

Future<ResponseStatus> login(User request) async {
  ManageResponse response = await service.post('/users/login', data: request.toJson());

  if(response == null) {
    return ResponseStatus(Status.fail);
  }

  if(response.success == null) {
    Error error = Error.fromJson(response.fail.data);
    String errorMsg = error?.table['schema_errors']?.values?.first[0];
    return ResponseStatus(Status.fail, errorMsg ?? 'Invalid credentials.');
  }

  Auth.accessToken = Access.fromJson(response.success.data).accessToken;
  Auth.status = AuthStatus.logged_in;

  return ResponseStatus(Status.success);
}

Future<bool> signUp(User request) async {
  ManageResponse response = await service.post('/users/signup', data: request.toJson());

  if(response == null) {
    return false;
  }

  if(response.success == null) {
    return false;
  }

  return true;
}
