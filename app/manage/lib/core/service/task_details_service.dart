import 'package:manage/core/model/project_state_model.dart';
import 'package:manage/core/model/task_group_model.dart';
import 'package:manage/core/model/task_state_put_model.dart';
import 'package:manage/core/model/team_project_model.dart';
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
 
 Future<RequestResult<TeamProjectModel>> projectOf(String projectID) async =>
  (await service.request<TeamProjectModel>(
    method: RequestMethod.get,
    url : '/projects/' + projectID,
    decode: (i) => TeamProjectModel.fromJson(i),
  ))
      .castTo<TeamProjectModel>();

Future<RequestResult> updateTaskState(String taskID, TaskStatePutModel model) async =>
  (await service.request(
    method: RequestMethod.put,
    url: '/tasks/' + taskID + '/state',
    jsonData: model.toJson(),
    ));
