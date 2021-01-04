import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:manage/core/model/project_state_model.dart';
import 'package:manage/core/model/task_group_model.dart';
import 'package:manage/core/model/tasks_post_model.dart';
import 'package:manage/core/model/team_project_model.dart';
import 'package:manage/core/router/manage_route.dart';
import 'package:manage/core/router/manage_route_state.dart';
import 'package:manage/core/service/request_result.dart';
import 'package:manage/core/service/tasks_service.dart' as service;
import 'package:manage/core/service/project_service.dart' as service;
import 'package:provider/provider.dart';

class TaskCreateController extends ChangeNotifier {
  final TextEditingController name = TextEditingController();
  final TextEditingController details = TextEditingController();
  DateTime schedule = DateTime.now();
  DateTime deadline;
  List<ProjectStateModel> states;
  List<TaskGroupModel> groups;
  ProjectStateModel currentState;
  TaskGroupModel currentGroup;
  TeamProjectModel project;
  final format = DateFormat("EEEE, MMMM d, yyyy 'at' h:mma");

  TaskCreateController(
      {this.states,
      this.groups,
      this.currentState,
      this.currentGroup,
      this.project});

  String _nameError = '';
  String _credentialsError = '';

  String get nameError => _nameError;
  String get credentialsError => _credentialsError;

  Future<void> onAddTask(BuildContext context) async {
    if (_checkStatus()) {
      RequestResult status = await service.createTask(TasksPostModel(
          deadline: deadline.toIso8601String(),
          schedule: schedule.toIso8601String(),
          details: details.text,
          name: name.text,
          stateId: currentState.id,
          taskGroupId: currentGroup.id,
      ));

      if (status.status == Status.success) {
        context
            .read<ManageRouteState>()
            .update(ManageRoute.project, project: project);
        return;
      } else {
        _credentialsError = status.msg;
      }
    } else
      _credentialsError = '';

    _nameError = name.text.isEmpty ? 'Enter task name' : '';

    notifyListeners();
  }

  Future<DateTime> onShowPicker(BuildContext context, DateTime value) async {
    final date = await showDatePicker(
        context: context,
        firstDate: DateTime.now(),
        initialDate: new DateTime.now(),
        lastDate: DateTime(2050));
    if (date != null) {
      final time = await showTimePicker(
          context: context, initialTime: new TimeOfDay(hour: 0, minute: 0));
      return DateTimeField.combine(date, time);
    } else {
      return value;
    }
  }

  void onDeadlineChange(DateTime newDate) {
    deadline = newDate;
    notifyListeners();
  }

  void onScheduleDate(DateTime newDate) {
    schedule = newDate;
    notifyListeners();
  }

  void onStateChange(ProjectStateModel newState) {
    currentState = newState;
    notifyListeners();
  }

  void onGroupChange(TaskGroupModel newGroup) {
    currentGroup = newGroup;
    notifyListeners();
  }

  bool _checkStatus() {
    if (name.text.isNotEmpty &&
        currentState != null &&
        deadline != null &&
        schedule != null &&
        currentGroup != null) {
      return true;
    }

    return false;
  }

  Future<List<ProjectStateModel>> requestStates() async {
    RequestResult<List<ProjectStateModel>> result =
        await service.statesOf(project);
    if (result.status == Status.fail) {
      throw ('Something went wrong ${result.msg}');
    }

    return result.data;
  }

  Future<List<TaskGroupModel>> requestGroups() async {
    RequestResult<List<TaskGroupModel>> result =
        await service.taskGroupsOf(project);
    if (result.status == Status.fail) {
      throw ('Something went wrong ${result.msg}');
    }

    return result.data;
  }

  Future<void> requestFormFields() async {
    groups = await requestGroups();
    states = await requestStates();
  }

  @override
  void dispose() {
    name.dispose();
    super.dispose();
  }
}
