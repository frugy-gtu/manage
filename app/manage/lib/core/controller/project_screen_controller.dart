import 'package:flutter/material.dart';
import 'package:manage/core/model/project_state_model.dart';
import 'package:manage/core/model/task_group_model.dart';
import 'package:manage/core/model/task_model.dart';
import 'package:manage/core/model/team_project_model.dart';
import 'package:manage/core/router/manage_route.dart';
import 'package:manage/core/router/manage_route_state.dart';
import 'package:manage/core/service/queries/task_query.dart';
import 'package:manage/core/service/request_result.dart';
import 'package:provider/provider.dart';

import 'package:manage/core/service/project_service.dart' as service;
import 'package:manage/core/service/tasks_service.dart' as service;

class ProjectScreenController extends ChangeNotifier {
  TeamProjectModel _project;
  List<TaskGroupModel> _taskGroups;
  TabController tabController;
  ScrollController scrollController;
  bool isAtTop = true;
  List<ProjectStateModel> states;
  ProjectStateModel _currenState;

  ProjectScreenController({
    @required TeamProjectModel project,
    @required this.scrollController,
    ProjectStateModel currentState,
  }) : _project = project, _currenState = currentState {
    scrollController.addListener(_checkIsTop);
  }

  ProjectScreenController.empty();

  TeamProjectModel get project => _project;

  List<TaskGroupModel> get taskGroups => _taskGroups;

  void onFloatingActionPress(BuildContext context) {
    context.read<ManageRouteState>().update(ManageRoute.task_create,
        project: _project, initialState: _currenState);
  }

  void onTaskTap(BuildContext context, TaskModel task) {
    context
        .read<ManageRouteState>()
        .update(ManageRoute.task_details, task: task,
        initialState: _currenState);
  }

  Future<List<ProjectStateModel>> requestStates() async {
    RequestResult<List<ProjectStateModel>> result =
        await service.statesOf(_project);
    if (result.status == Status.fail) {
      throw ('Something went wrong ${result.msg}');
    }

    states = result.data;
    if (_currenState == null) {
      _currenState = states[0];
    }

    return result.data;
  }

  void initState(TickerProvider vsync, int length) {

    int initial = 0;
    if(_currenState != null) {
      for (int i = 0; i < states.length; ++i) {
        if(_currenState.name == states[i].name) {
          initial = i;
        }
      }
    }
    tabController = TabController(initialIndex: initial, length: length, vsync: vsync);
    tabController.addListener(onTabIndexChange);
  }

  void onTabIndexChange() {
    if (!tabController.indexIsChanging) {
      _currenState = states[tabController.index];
      notifyListeners();
    }
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

  Future<void> deleteTask(String taskId) async {
    RequestResult result = await service.deleteTask(taskId);
    if (result.status == Status.fail) {
      throw ('Something went wrong ${result.msg}');
    }
  }

  Color getStateColor(ProjectStateModel state) {
    switch (state.name) {
      case 'todo':
        return Color.fromRGBO(244, 146, 59, 1);
      case 'in-progress':
        return Color.fromRGBO(0, 0, 174, 1);
      case 'done':
        return Color.fromRGBO(68, 188, 68, 1);
      case 'cancel':
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

  Widget showAlertDialog(BuildContext context, String taskId) {
    Widget cancelButton = FlatButton(
      color: Theme.of(context).colorScheme.primary,
      child: Text(
        'Cancel',
        style: TextStyle(color: Theme.of(context).colorScheme.secondary),
      ),
      onPressed: () {
        Navigator.of(context, rootNavigator: true).pop();
      },
    );

    Widget applyButton = FlatButton(
      color: Theme.of(context).colorScheme.primary,
      child: Text(
        'Apply',
        style: TextStyle(color: Theme.of(context).colorScheme.secondary),
      ),
      onPressed: () {
        deleteTask(taskId);
        Navigator.of(context, rootNavigator: true).pop();
        context.read<ManageRouteState>().update(ManageRoute.project,
            project: _project, initialState: _currenState);
      },
    );

    AlertDialog alert = AlertDialog(
      backgroundColor: Theme.of(context).colorScheme.secondary,
      title: Text('Are you sure?',
          style: TextStyle(color: Theme.of(context).colorScheme.primary)),
      content: Text('The task will be lost forever.',
          style: TextStyle(color: Theme.of(context).colorScheme.primary)),
      actions: [
        applyButton,
        cancelButton,
      ],
    );

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return alert;
        });
  }

  @override
  void dispose() {
    tabController.dispose();
    scrollController.dispose();
    super.dispose();
  }
}
