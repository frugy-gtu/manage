import 'package:manage/core/model/team_model.dart';
import 'package:manage/core/model/team_create_model.dart';
import 'package:manage/core/service/request_method.dart';
import 'package:manage/core/service/response_status.dart';

import 'manage_service.dart' as service;

Future<RequestResult<List<TeamModel>>> teams() async =>
    (await service.request<TeamModel>(
      method: RequestMethod.get,
      url: '/teams/',
      decode: (i) => TeamModel.fromJson(i),
    ))
        .castTo<List<TeamModel>>();

Future<RequestResult> createTeam(TeamCreateModel model) async => await service
    .request(method: RequestMethod.post, url: '/teams/', jsonData: model.toJson());
