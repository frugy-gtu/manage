import 'package:manage/core/model/team_create_model.dart';
import 'package:manage/core/model/team_model.dart';
import 'package:manage/core/model/team_project_model.dart';
import 'package:manage/core/model/team_projects_post_model.dart';
import 'package:manage/core/model/general_user_model.dart';
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

Future<RequestResult<List<GeneralUserModel>>> membersOf(TeamModel team) async =>
    (await service.request<GeneralUserModel>(
      method: RequestMethod.get,
      url: '/teams/' + team.id + '/users',
      decode: (i) => GeneralUserModel.fromJson(i),
    ))
        .castTo<List<GeneralUserModel>>();

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
