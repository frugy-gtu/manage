import 'package:manage/core/model/team_create_model.dart';
import 'package:manage/core/model/team_model.dart';
import 'package:manage/core/model/team_project_model.dart';
import 'package:manage/core/model/team_projects_post_model.dart';
import 'package:manage/core/model/user_model.dart';
import 'package:manage/core/model/team_users_post_model.dart';
import 'package:manage/core/service/request_method.dart';
import 'package:manage/core/service/request_result.dart';

import 'manage_service.dart' as service;

Future<RequestResult<List<TeamModel>>> teams() async =>
    (await service.request<TeamModel>(
      method: RequestMethod.get,
      url: '/teams/',
      decode: (i) => TeamModel.fromJson(i),
    ))
        .castTo<List<TeamModel>>();

Future<RequestResult> createTeam(TeamCreateModel model) async =>
    await service.request(
        method: RequestMethod.post, url: '/teams/', jsonData: model.toJson());

Future<RequestResult<List<TeamProjectModel>>> projectsOf(
        TeamModel team) async =>
    (await service.request<TeamProjectModel>(
      method: RequestMethod.get,
      url: '/teams/' + team.id + '/projects',
      decode: (i) => TeamProjectModel.fromJson(i),
    ))
        .castTo<List<TeamProjectModel>>();

Future<RequestResult<List<UserModel>>> membersOf(TeamModel team) async =>
    (await service.request<UserModel>(
      method: RequestMethod.get,
      url: '/teams/' + team.id + '/users',
      decode: (i) => UserModel.fromJson(i),
    ))
        .castTo<List<UserModel>>();

Future<RequestResult> createProjectTo(
        TeamModel team, TeamProjectsPostModel model) async =>
    await service.request(
        method: RequestMethod.post,
        url: '/teams/${team.id}/projects',
        jsonData: model.toJson()
      );

Future<RequestResult> inviteMemberTo(
        TeamModel team, TeamUsersPostModel model) async =>
    await service.request(
        method: RequestMethod.post,
        url: '/teams/${team.id}/users',
        jsonData: model.toJson()
      );

Future<RequestResult<TeamModel>> teamWith(
        String teamId) async =>
    (await service.request<TeamModel>(
      method: RequestMethod.get,
      url: '/teams/' + teamId,
      decode: (i) => TeamModel.fromJson(i),
    ))
        .castTo<TeamModel>();

Future<RequestResult> deleteProjectStates(String projectId) async =>
    (await service.request(
      method: RequestMethod.del,
      url: '/projects/' + projectId + '/states',
    ));

Future<RequestResult> deleteProjectTags(String projectId) async =>
    (await service.request(
      method: RequestMethod.del,
      url: '/projects/' + projectId + '/tags',
    ));

Future<RequestResult> deleteProject(String projectId) async{
//  await deleteProjectStates(projectId);
//  await deleteProjectTags(projectId);
  return (await service.request(
      method: RequestMethod.del,
      url: '/projects/' + projectId,
    ));
}