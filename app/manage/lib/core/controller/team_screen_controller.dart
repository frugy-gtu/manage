import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:manage/core/model/team_model.dart';
import 'package:manage/core/model/team_project_model.dart';
import 'package:manage/core/model/team_user_model.dart';
import 'package:manage/core/service/request_result.dart';
import 'package:manage/core/service/team_service.dart' as service;

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

  Future<List<TeamUserModel>> members() async {
    RequestResult<List<TeamUserModel>> result =
        await service.membersOf(team);
    if (result.status == Status.fail) {
      throw ('Something went wrong ${result.msg}');
    }

    return result.data;
  }

  void onTabIndexChange() {
    if(!tabController.indexIsChanging) {
      notifyListeners();
    }
  }

  void initState({@required TickerProvider vsync}) {
    tabController = TabController(length: tabs.length, vsync: vsync);
    tabController.addListener(onTabIndexChange);
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }
}
