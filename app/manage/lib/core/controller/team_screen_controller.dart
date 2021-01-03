import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:manage/core/model/team_model.dart';
import 'package:manage/core/model/team_project_model.dart';
import 'package:manage/core/model/general_user_model.dart';
import 'package:manage/core/router/manage_route.dart';
import 'package:manage/core/router/manage_route_state.dart';
import 'package:manage/core/service/request_result.dart';
import 'package:manage/core/service/team_service.dart' as service;
import 'package:provider/provider.dart';

class TeamScreenController extends ChangeNotifier {
  final TeamModel team;
  final List<String> tabs = ['Projects', 'Members'];
  TabController tabController;

  TeamScreenController({this.team});

  Future<List<TeamProjectModel>> projects() async {
    RequestResult<List<TeamProjectModel>> result =
        await service.projectsOf(team);
    if (result.status == Status.fail) {
      throw ('Something went wrong ${result.msg}');
    }

    return result.data;
  }

  Future<List<GeneralUserModel>> members() async {
    RequestResult<List<GeneralUserModel>> result =
        await service.membersOf(team);
    if (result.status == Status.fail) {
      throw ('Something went wrong ${result.msg}');
    }

    return result.data;
  }

  void onTabIndexChange() {
    if (!tabController.indexIsChanging) {
      notifyListeners();
    }
  }

  Icon floatingActionButtonIcon(BuildContext context) {
    return tabController.index == 0
        ? Icon(Icons.add, color: Theme.of(context).colorScheme.primary,)
        : Icon(Icons.person_add, color: Theme.of(context).colorScheme.primary);
  }

  void onFloatingActionPress(BuildContext context) {
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
  }

  void onProjectTap(BuildContext context, TeamProjectModel project) {
    context
        .read<ManageRouteState>()
        .update(ManageRoute.project, project: project);
  }

  void onMemberTap(BuildContext context, GeneralUserModel user) {
    context
        .read<ManageRouteState>()
        .update(ManageRoute.member, team: team, member: user);
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }
}
