import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:manage/core/model/project_model.dart';
import 'package:manage/core/model/team_model.dart';
import 'package:manage/core/model/team_project_model.dart';
import 'package:manage/core/model/user_model.dart';
import 'package:manage/core/router/manage_route.dart';
import 'package:manage/core/router/manage_route_state.dart';
import 'package:manage/core/service/request_result.dart';
import 'package:manage/core/service/team_service.dart' as service;
import 'package:provider/provider.dart';

class TeamScreenController extends ChangeNotifier {
  final TeamModel team;
  final List<String> tabs = ['Projects', 'Members'];
  bool isAtTop = true;
  TabController tabController;
  ScrollController scrollController;
  Text _floatingActionButtonText;

  TeamScreenController({this.team}) : scrollController = ScrollController() {
    scrollController.addListener(_checkIsTop);
  }

  Future<List<TeamProjectModel>> projects() async {
    RequestResult<List<TeamProjectModel>> result =
        await service.projectsOf(team);
    if (result.status == Status.fail) {
      throw ('Something went wrong ${result.msg}');
    }

    return result.data;
  }

  Future<List<UserModel>> members() async {
    RequestResult<List<UserModel>> result = await service.membersOf(team);
    if (result.status == Status.fail) {
      throw ('Something went wrong ${result.msg}');
    }

    return result.data;
  }

  void onTabIndexChange() {
    if (!tabController.indexIsChanging) {
      if (isAtTop) {
        if (tabController.index == 0) {
          _floatingActionButtonText = Text('Create Project');
        } else if (tabController.index == 1) {
          _floatingActionButtonText = Text('Invite Member');
        }
      }
      notifyListeners();
    }
  }

  Icon _floatingActionButtonIcon(BuildContext context) {
    return tabController.index == 0
        ? Icon(
            Icons.add,
            color: Theme.of(context).colorScheme.primary,
          )
        : Icon(Icons.person_add, color: Theme.of(context).colorScheme.primary);
  }

  void _onFloatingActionPress(BuildContext context) {
    if (tabController.index == 0) {
      context
          .read<ManageRouteState>()
          .update(ManageRoute.project_create, team: team);
    } else {
      context
          .read<ManageRouteState>()
          .update(ManageRoute.team_invite, team: team);
    }
  }

  void initState({@required TickerProvider vsync}) {
    tabController = TabController(length: tabs.length, vsync: vsync);
    tabController.addListener(onTabIndexChange);
    if (isAtTop) {
      if (tabController.index == 0) {
        _floatingActionButtonText = Text('Create Project');
      } else if (tabController.index == 1) {
        _floatingActionButtonText = Text('Invite Member');
      }
    }
  }

  void onProjectTap(BuildContext context, TeamProjectModel project) {
    context
        .read<ManageRouteState>()
        .update(ManageRoute.project, project: project);
  }

  void onMemberTap(BuildContext context, UserModel user) {
    context
        .read<ManageRouteState>()
        .update(ManageRoute.member, team: team, member: user);
  }

  void _checkIsTop() {
    if (scrollController.position.pixels ==
        scrollController.position.minScrollExtent) {
      if (isAtTop == false) {
        isAtTop = true;
        _floatingActionButtonText = tabController.index == 0
            ? Text('Create Project')
            : Text('Invite Member');
        notifyListeners();
      }
    } else if (isAtTop == true) {
      _floatingActionButtonText = Text('');
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
            _floatingActionButtonIcon(context)
            : Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 4.0),
                    child: _floatingActionButtonIcon(context),
                  ),
                  _floatingActionButtonText,
                ],
              ),
      ),
      onPressed: () => _onFloatingActionPress(context),
      backgroundColor: Theme.of(context).colorScheme.onPrimary,
      foregroundColor: Theme.of(context).colorScheme.onSecondary,
    );
  }

  Future<void> deleteProject(TeamProjectModel project) async{
    RequestResult result = await service.deleteProject(project.id);
    if(result.status == Status.fail) {
      throw('Something went wrong ${result.msg}');
    }
  }

  showAlertDialog(BuildContext context, TeamModel team, TeamProjectModel project){
    Widget cancelButton = FlatButton(
      color: Theme.of(context).colorScheme.primary,
      child: Text('Cancel', style: TextStyle(color: Theme.of(context).colorScheme.secondary),),
      onPressed: (){
        Navigator.of(context, rootNavigator: true).pop();
      }, 
    );
    
    Widget applyButton = FlatButton(
      color: Theme.of(context).colorScheme.primary,
      child: Text('Apply', style: TextStyle(color: Theme.of(context).colorScheme.secondary),),
      onPressed: (){
        deleteProject(project);
        context
          .read<ManageRouteState>()
          .update(ManageRoute.team, team:team);
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

  @override
  void dispose() {
    tabController.dispose();
    scrollController.dispose();
    super.dispose();
  }
}
