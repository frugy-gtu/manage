import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:manage/core/model/team_users_post_model.dart';
import 'package:manage/core/router/manage_route.dart';
import 'package:manage/core/router/manage_route_state.dart';
import 'package:manage/core/service/request_result.dart';
import 'package:manage/core/model/team_model.dart';
import 'package:manage/core/service/team_service.dart' as service;
import 'package:provider/provider.dart';

class TeamInviteScreenController extends ChangeNotifier {
  final TextEditingController _uName = TextEditingController();
  final TeamModel team;

  TeamInviteScreenController(this.team);

  String _uNameError;

  String _requestError = '';

  TextEditingController get uName => _uName;

  String get uNameError => _uNameError;
  String get requestError => _requestError;

  bool _checkStatus() {
    if (_uName.text.isNotEmpty) {
      return true;
    }

    return false;
  }

  Future<void> onCreate(BuildContext context) async {
    if (_checkStatus()) {
      RequestResult result = await service
          .inviteMemberTo(team, TeamUsersPostModel(username: _uName.text));

      if (result.status == Status.success) {
        context.read<ManageRouteState>().update(ManageRoute.team, team: team);
        return;
      } else {
        _requestError = result.msg;
      }
    } else {
      _requestError = '';
    }

    _uNameError = uName.text.isEmpty ? 'Enter a name' : null;

    notifyListeners();
  }

  @override
  void dispose() {
    uName.dispose();
    super.dispose();
  }
}
