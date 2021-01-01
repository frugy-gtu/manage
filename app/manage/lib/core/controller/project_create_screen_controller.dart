import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:manage/core/model/team_projects_post_model.dart';
import 'package:manage/core/router/manage_route.dart';
import 'package:manage/core/router/manage_route_state.dart';
import 'package:manage/core/service/request_result.dart';
import 'package:manage/core/model/team_model.dart';
import 'package:manage/core/service/team_service.dart' as service;
import 'package:provider/provider.dart';

class ProjectCreateScreenController extends ChangeNotifier {
  final TextEditingController _name = TextEditingController();
  final TeamModel team;

  ProjectCreateScreenController(this.team);

  String _nameError;

  String _requestError = '';

  TextEditingController get name => _name;

  String get nameError => _nameError;
  String get requestError => _requestError;

  bool _checkStatus() {
    if (_name.text.isNotEmpty) {
      return true;
    }

    return false;
  }

  Future<void> onCreate(BuildContext context) async {
    if (_checkStatus()) {
      RequestResult result = await service
          .createProjectTo(team, TeamProjectsPostModel(name: _name.text));

      if (result.status == Status.success) {
        context.read<ManageRouteState>().update(ManageRoute.team, team: team);
        return;
      } else {
        _requestError = result.msg;
      }
    } else {
      _requestError = '';
    }

    _nameError = name.text.isEmpty ? 'Enter a name' : null;

    notifyListeners();
  }

  @override
  void dispose() {
    name.dispose();
    super.dispose();
  }
}
