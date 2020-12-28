
import 'package:manage/core/model/team.dart';
import 'package:manage/core/service/response_status.dart';
import 'package:manage/core/service/team_service.dart' as service;

class TeamsScreenController {

  Future<List<Team>> teams() async {
    ResponseResult<List<Team>> result = await service.teams();
    if(result.status == Status.fail) {
      throw('Something went wrong ${result.msg}');
    }

    return result.data;
  }
}
