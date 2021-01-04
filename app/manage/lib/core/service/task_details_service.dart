
import 'package:manage/core/model/project_state_model.dart';
import 'package:manage/core/model/task_group_model.dart';
import 'package:manage/core/service/request_method.dart';
import 'package:manage/core/service/request_result.dart';

import 'manage_service.dart' as service;

Future<RequestResult<List<TaskGroupModel>>> taskGroupsOf(String projectID) async =>
  (await service.request<TaskGroupModel>(
    method: RequestMethod.get,
    url: '/projects/' + projectID + '/task-groups',
    decode: (i) => TaskGroupModel.fromJson(i),
  ))
      .castTo<List<TaskGroupModel>>();
  
Future<RequestResult<List<ProjectStateModel>>> statesOf(String projectID) async =>
  (await service.request<ProjectStateModel>(
    method: RequestMethod.get,
    url: '/projects/' + projectID + '/states',
    decode: (i) => ProjectStateModel.fromJson(i),
  ))
      .castTo<List<ProjectStateModel>>();
  