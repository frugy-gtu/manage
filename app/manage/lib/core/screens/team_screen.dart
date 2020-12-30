import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:manage/core/controller/team_screen_controller.dart';
import 'package:manage/core/model/team_project_model.dart';
import 'package:manage/core/router/manage_route.dart';
import 'package:manage/extra/widgets/InkedContainer.dart';
import 'package:manage/core/router/manage_route_state.dart';
import 'package:provider/provider.dart';

import '../model/team_model.dart';

class TeamScreen extends StatelessWidget {
  final TeamScreenController controller;

  TeamScreen(TeamModel team) : controller = TeamScreenController(team);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.menu_rounded),
          enableFeedback: false,
          onPressed: () {},
          splashRadius: 20,
        ),
        title: Text(controller.team.name),
        actions: [
          IconButton(
            icon: Icon(Icons.account_circle),
            enableFeedback: false,
            onPressed: () {},
            splashRadius: 20,
          ),
        ],
      ),
      body: FutureBuilder(
        future: controller.projects(),
        builder: (context, snapshot) {
          if(snapshot.connectionState ==
            ConnectionState.done) {
            if(snapshot.hasError) {
              return Center(child: Text(snapshot.error),);
            }
            return _TeamScreenBody(snapshot.data);
          }
          else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}

class _TeamScreenBody extends StatelessWidget {

  final List<TeamProjectModel> teams;

  _TeamScreenBody(this.teams);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) => Padding(
        padding: EdgeInsets.symmetric(
          vertical: constraints.maxHeight / 9,
        ),
        child: GridView.count(
          primary: true,
          childAspectRatio: 0.9,
          padding: _teamGridTilePadding(constraints.maxWidth,
              constraints.maxHeight - constraints.maxHeight / 4.5),
          crossAxisCount: _teamAxisCount(teams.length),
          children: [
            for (TeamProjectModel team in teams)
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: InkedContainer(
                        child: LayoutBuilder(
                          builder: (context, constraints) => Padding(
                            padding: EdgeInsets.symmetric(
                              vertical: constraints.maxHeight / 3.6,
                            ),
                            child: FittedBox(
                              fit: BoxFit.fitHeight,
                              child: Text(
                                team.name,
                                style: Theme.of(context).textTheme.button,
                              ),
                            ),
                          ),
                        ),
                        onTap: () {
                        }),
                  ),
                  Center(
                      child: Text(
                    team.name,
                    textAlign: TextAlign.center,
                  )),
                  SizedBox(
                    height: 5,
                  ),
                ],
              ),
            Column(
              children: [
                Expanded(
                  child: InkedContainer(
                    onTap: () {
                      context
                          .read<ManageRouteState>()
                          .update(ManageRoute.team_create);
                    },
                    child: LayoutBuilder(
                      builder: (context, constraints) => Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: constraints.maxWidth / 3.6),
                        child: FittedBox(
                          fit: BoxFit.fitWidth,
                          child: Icon(
                            Icons.add_circle,
                            color: Theme.of(context).textTheme.button.color,
                            size: 28,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Text(''),
                SizedBox(
                  height: 5,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  EdgeInsetsGeometry _teamGridTilePadding(double maxWidth, double maxHeight) {
    if (teams.length == 1) {
      return EdgeInsets.symmetric(
          horizontal: (maxWidth - (maxHeight / 2)) / 1.5);
    } else {
      return EdgeInsets.all(25);
    }
  }

  int _teamAxisCount(int teamCount) {
    if (teamCount < 2)
      return 1;
    else if (teamCount < 4)
      return 2;
    else
      return 3;
  }
}