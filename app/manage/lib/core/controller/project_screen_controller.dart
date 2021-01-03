import 'package:flutter/material.dart';
import 'package:manage/core/model/project_state_model.dart';
import 'package:manage/core/model/task_group_model.dart';
import 'package:manage/core/model/task_model.dart';
import 'package:manage/core/model/team_project_model.dart';
import 'package:manage/core/service/queries/task_query.dart';
import 'package:manage/core/service/request_result.dart';

import 'package:manage/core/service/project_service.dart' as service;
import 'package:manage/core/service/tasks_service.dart' as service;

class ProjectScreenController extends ChangeNotifier {
  final TeamProjectModel _project;
  List<TaskGroupModel> _taskGroups;
  TabController tabController;

  ProjectScreenController({
    @required TeamProjectModel project,
  }) : _project = project;

  ProjectScreenController.withTab(
      {@required TeamProjectModel project,
      TickerProvider vsync,
      int stateLength})
      : tabController = TabController(length: stateLength, vsync: vsync),
        _project = project;

  TeamProjectModel get project => _project;

  List<TaskGroupModel> get taskGroups => _taskGroups;

  void onFloatingActionPress(BuildContext context) {}

  void onTaskTap(BuildContext context, TaskModel task) {}

  Future<List<ProjectStateModel>> states() async {
    RequestResult<List<ProjectStateModel>> result =
        await service.statesOf(_project);
    if (result.status == Status.fail) {
      throw ('Something went wrong ${result.msg}');
    }

    return result.data;
  }

  Future<List<TaskGroupModel>> _requestGroups() async {
    RequestResult<List<TaskGroupModel>> result =
        await service.taskGroupsOf(_project);
    if (result.status == Status.fail) {
      throw ('Something went wrong ${result.msg}');
    }

    return result.data;
  }

  Future<List<TaskModel>> tasksWith(ProjectStateModel state) async {
    _taskGroups = await _requestGroups();
    RequestResult<List<TaskModel>> result = await service
        .tasks(TaskQuery(stateId: state.id, projectId: project.id));
    if (result.status == Status.fail) {
      throw ('Something went wrong ${result.msg}');
    }

    return result.data;
  }

  Color getStateColor(ProjectStateModel state) {
    switch (state.name) {
      case 'TODO':
        return Color.fromRGBO(244, 146, 59, 1);
      case 'IN-PROGRESS':
        return Color.fromRGBO(0, 0, 174, 1);
      case 'DONE':
        return Color.fromRGBO(68, 188, 68, 1);
      case 'CANCEL':
        return Colors.red;
    }

    return Colors.black;
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }
}