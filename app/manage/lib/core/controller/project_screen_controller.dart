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
  ScrollController scrollController;
  bool isAtTop = true;

  ProjectScreenController({
    @required TeamProjectModel project,
  })  : _project = project,
        scrollController = ScrollController() {
    scrollController.addListener(_checkIsTop);
  }

  ProjectScreenController.withTab(
      {@required TeamProjectModel project,
      TickerProvider vsync,
      @required ScrollController scrollController,
      int stateLength})
      : scrollController = scrollController,
        tabController = TabController(length: stateLength, vsync: vsync),
        _project = project {
    scrollController.addListener(_checkIsTop);
  }

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

  void _checkIsTop() {
    if (scrollController.position.pixels ==
        scrollController.position.minScrollExtent) {
      if (isAtTop == false) {
        isAtTop = true;
        notifyListeners();
      }
    } else if (isAtTop == true) {
      isAtTop = false;
      notifyListeners();
    }
  }

  FloatingActionButton floatingActionButton(BuildContext context) {
    return FloatingActionButton.extended(
      label: AnimatedSwitcher(
        duration: Duration(milliseconds: 700),
        transitionBuilder: (Widget child, Animation<double> animation) =>
            FadeTransition(
          opacity: animation,
          child: SizeTransition(
            child: child,
            sizeFactor: animation,
            axis: Axis.horizontal,
          ),
        ),
        child: !isAtTop
            ?
            //TODO: find error when remove param
            Icon(Icons.add)
            : Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 4.0),
                    child: Icon(Icons.add),
                  ),
                  Text('Add Task'),
                ],
              ),
      ),
      onPressed: () => onFloatingActionPress(context),
      backgroundColor: Theme.of(context).colorScheme.onPrimary,
      foregroundColor: Theme.of(context).colorScheme.onSecondary,
    );
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }
}
