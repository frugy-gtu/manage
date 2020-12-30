import 'package:manage/core/model/team_model.dart';
import 'package:manage/core/model/team_project_model.dart';
import 'package:manage/core/service/request_result.dart';
import 'package:manage/core/service/team_service.dart' as service;

class TeamScreenController {

  final TeamModel team;

  const TeamScreenController(this.team);

  Future<List<TeamProjectModel>> projects() async {
    RequestResult<List<TeamProjectModel>> result = await service.projectsOf(team);
    if(result.status == Status.fail) {
      throw('Something went wrong ${result.msg}');
    }

    return result.data;
  }
}
