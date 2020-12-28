
import 'package:manage/core/model/team_model.dart';
import 'package:manage/core/service/request_result.dart';
import 'package:manage/core/service/team_service.dart' as service;

class TeamsScreenController {

  Future<List<TeamModel>> teams() async {
    RequestResult<List<TeamModel>> result = await service.teams();
    if(result.status == Status.fail) {
      throw('Something went wrong ${result.msg}');
    }

    return result.data;
  }
}
