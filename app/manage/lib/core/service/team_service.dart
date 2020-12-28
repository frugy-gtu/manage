import 'package:manage/core/model/team.dart';
import 'package:manage/core/model/team_create_model.dart';
import 'package:manage/core/service/response_status.dart';
import 'package:manage/core/model/error.dart';

import 'manage_response.dart';
import 'manage_service.dart' as service;

Future<ResponseResult<List<Team>>> teams() async {
  ManageResponse response = await service.get('/teams/');

  if (response == null) {
    return ResponseResult(Status.fail);
  }

  if (response.success == null) {
    return ResponseResult(Status.fail, msg: response.fail.data);
  }

  return ResponseResult<List<Team>>(Status.success,
      data: (response.success.data as List)
          .map((i) => Team.fromJson(i))
          .toList());
}

Future<ResponseResult> createTeam(TeamCreateModel request) async {
  ManageResponse response =
      await service.post('/teams/', data: request.toJson());

  if (response == null) {
    return ResponseResult(Status.fail);
  }

  if (response.success == null) {
    Error error = Error.fromJson(response.fail.data);
    String errorMsg = error?.table['schema_errors']?.values?.first[0];
    return ResponseResult(Status.fail, msg: errorMsg ?? 'Something went wrong.');
  }

  return ResponseResult(Status.success);
}
