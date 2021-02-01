import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:manage/core/model/project_model.dart';
import 'package:manage/core/model/team_model.dart';
import 'package:manage/core/router/manage_route.dart';
import 'package:manage/core/router/manage_route_state.dart';
import 'package:manage/core/service/project_service.dart' as service;
import 'package:manage/core/service/team_service.dart' as service;
import 'package:manage/core/service/request_result.dart';
import 'package:provider/provider.dart';

class ProjectsController extends ChangeNotifier {
  final Map<String, String> _teamNames = {};

  Future<List<ProjectModel>> projects() async {
    RequestResult<List<ProjectModel>> result = await service.projects();
    if (result.status == Status.fail) {
      throw ('Something went wrong ${result.msg}');
    }

    return result.data;
  }

  void onProjectTap(BuildContext context, ProjectModel project) {
    context
        .read<ManageRouteState>()
        .update(ManageRoute.project, project: project);
  }

  Future<String> teamNameOf(String teamId) async {
    if (_teamNames.containsKey(teamId)) {
      return _teamNames[teamId];
    } else {
      RequestResult<TeamModel> result = await service.teamWith(teamId);
      if (result.status == Status.fail) {
        throw ('Something went wrong ${result.msg}');
      }

      _teamNames[teamId] = result.data.name;

      return result.data.name;
    }
  }

  Future<void> deleteProject(BuildContext context, ProjectModel project) async{
    RequestResult result = await service.deleteProject(project.id);
    RequestResult teamResult = await service.teamWith(project.teamId);
    if(result.status == Status.fail) {
      throw('Something went wrong ${result.msg}');
    }
    if(teamResult.status == Status.fail){
      throw('Something went wrong ${result.msg}');
    }
    context
      .read<ManageRouteState>()
      .update(ManageRoute.projects, team: teamResult.data);
  }

  showAlertDialog(BuildContext context, ProjectModel project){
    Widget cancelButton = FlatButton(
      color: Theme.of(context).colorScheme.primary,
      child: Text('Cancel', style: TextStyle(color: Theme.of(context).colorScheme.secondary),),
      onPressed: (){
        Navigator.of(context, rootNavigator: true).pop();
      }, 
    );
    
    Widget applyButton = FlatButton (
      color: Theme.of(context).colorScheme.primary,
      child: Text('Apply', style: TextStyle(color: Theme.of(context).colorScheme.secondary),),
      onPressed: (){
        deleteProject(context, project);
      //  notifyListeners();
        Navigator.of(context, rootNavigator: true).pop();
      }, 
    );

    AlertDialog alert = AlertDialog(
      backgroundColor: Theme.of(context).colorScheme.secondary,
      title: Text('Are you sure?', style: TextStyle(color: Theme.of(context).colorScheme.primary)),
      content: Text('The project will be lost forever.', style: TextStyle(color: Theme.of(context).colorScheme.primary)),
      actions: [
        applyButton,
        cancelButton,
      ],
    );
    
    showDialog(
      context: context,
      builder: (BuildContext context){
        return alert;
      }
    );
  }
}
