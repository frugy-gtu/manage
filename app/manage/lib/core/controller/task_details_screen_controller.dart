import 'package:flutter/cupertino.dart';
import 'package:manage/core/model/project_state_model.dart';
import 'package:manage/core/model/task_group_model.dart';
import 'package:manage/core/model/team_project_model.dart';
import 'package:manage/core/service/request_result.dart';
import 'package:manage/core/service/task_details_service.dart' as service;
import 'package:manage/core/router/manage_route.dart';
import 'package:manage/core/router/manage_route_state.dart';
import 'package:provider/provider.dart';


class TaskDetailsScreenController extends ChangeNotifier{

  ProjectStateModel stateModel;

  Future<TaskGroupModel> group(String projectID, String groupID) async {
    RequestResult<List<TaskGroupModel>> result = await service.taskGroupsOf(projectID);
    if(result.status == Status.fail) {
      throw('Something went wrong ${result.msg}');
    }
    for(TaskGroupModel wantedGroup in result.data){
      if(wantedGroup.id == groupID){
        return wantedGroup;
      }
    }
    return result.data[0]; 
  }
  
  Future<ProjectStateModel> state(String projectID, String stateID) async {
    RequestResult<List<ProjectStateModel>> result = await service.statesOf(projectID);
    if(result.status == Status.fail) {
      throw('Something went wrong ${result.msg}');
    }
    for(ProjectStateModel wantedState in result.data){
      if(wantedState.id == stateID){
        return wantedState;
      }
    }
    return result.data[0];
  }
  
  Future<List<ProjectStateModel>> allStates(String projectID) async{
    RequestResult<List<ProjectStateModel>> result = await service.statesOf(projectID);
    if(result.status == Status.fail) {
      throw('Something went wrong ${result.msg}');
    }
    return result.data;
  }

  Future<TeamProjectModel> project(String projectID) async{
    RequestResult<TeamProjectModel> result = await service.projectOf(projectID);
    if(result.status == Status.fail) {
      throw('Something went wrong ${result.msg}');
    }
    return result.data;
  }
  
  Future<void> updateTaskState(String taskID, String stateID) async{
    RequestResult result = await service.updateTaskState(taskID, stateID);
    if(result.status == Status.fail) {
      throw('Something went wrong ${result.msg}');
    }
  }

  Future<void> applyChanges(BuildContext context, String projectID, String taskID, String stateID) async{
    TeamProjectModel projectModel = await project(projectID);
    updateTaskState(taskID, stateID);
    context
      .read<ManageRouteState>()
      .update(ManageRoute.project, project: projectModel);
      return;
  }

  Future<void> applyWithNoChange(BuildContext context, String projectID) async{
    TeamProjectModel projectModel = await project(projectID);
    context
      .read<ManageRouteState>()
      .update(ManageRoute.project, project: projectModel);
      return;
  }

}
