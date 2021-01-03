import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:manage/core/controller/teams_screen_controller.dart';
import 'package:manage/core/router/manage_route.dart';
import 'package:manage/extra/widgets/InkedContainer.dart';
import 'package:manage/core/router/manage_route_state.dart';
import 'package:provider/provider.dart';

import '../model/team_model.dart';

class TeamsScreen extends StatelessWidget {
  final controller = TeamsScreenController();

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
        title: const Text('Teams'),
        actions: [
          IconButton(
            icon: Icon(Icons.account_circle),
            enableFeedback: false,
            onPressed: () {
              context.read<ManageRouteState>().update(ManageRoute.user_profile,
                  prevUserProfileRoute: ManageRoute.teams);
            },
            splashRadius: 20,
          ),
        ],
      ),
      body: FutureBuilder(
        future: controller.teams(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              return Center(
                child: Text(snapshot.error),
              );
            }
            return _TeamsScreenBody(snapshot.data);
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}

class _TeamsScreenBody extends StatelessWidget {
  final List<TeamModel> teams;

  _TeamsScreenBody(this.teams);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) => Padding(
        padding: EdgeInsets.symmetric(
          vertical: constraints.maxHeight / 9,
        ),
        //TODO: switch to GridView.extent
        child: GridView.count(
          primary: true,
          childAspectRatio: 0.9,
          padding: _teamGridTilePadding(constraints.maxWidth,
              constraints.maxHeight - constraints.maxHeight / 4.5),
          crossAxisCount: _teamAxisCount(teams.length),
          children: [
            for (TeamModel team in teams)
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
                                team.abbreviation,
                                style: Theme.of(context).textTheme.button,
                              ),
                            ),
                          ),
                        ),
                        onTap: () {
                          context
                              .read<ManageRouteState>()
                              .update(ManageRoute.team, team: team);
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
