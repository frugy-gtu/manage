import 'package:manage/core/model/task_model.dart';
import 'package:manage/core/service/queries/task_query.dart';
import 'package:manage/core/service/request_method.dart';
import 'package:manage/core/service/request_result.dart';

import 'manage_service.dart' as service;

Future<RequestResult<List<TaskModel>>> tasks(TaskQuery query) async =>
    (await service.request<TaskModel>(
      method: RequestMethod.get,
      url: '/tasks/',
      decode: (i) => TaskModel.fromJson(i),
      queryParameters: query.toJson(),
    ))
        .castTo<List<TaskModel>>();
