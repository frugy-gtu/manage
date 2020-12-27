import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:manage/core/router/manage_route.dart';
import 'package:manage/extra/widgets/InkedContainer.dart';
import 'package:manage/core/router/manage_route_state.dart';
import 'package:provider/provider.dart';

import '../team.dart';

class TeamsScreen extends StatelessWidget {
  final List<Team> teams = const [
    Team(name: 'User Team', abbrv: 'TUC'),
    Team(name: 'User Team', abbrv: 'C'),
    Team(name: 'User Team', abbrv: 'UC'),
    Team(name: 'User Team', abbrv: 'UC'),
  ];

  const TeamsScreen({Key key}) : super(key: key);

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
            onPressed: () {},
            splashRadius: 20,
          ),
        ],
      ),
      body: LayoutBuilder(
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
              for (Team team in teams)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      child: LayoutBuilder(
                        builder: (context, constraints) => InkedContainer(
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                vertical: constraints.maxHeight / 4,
                              ),
                              child: FittedBox(
                                fit: BoxFit.fitHeight,
                                child: Text(
                                  team.abbrv,
                                  style: Theme.of(context).textTheme.button,
                                ),
                              ),
                            ),
                            onTap: () {
                              context
                                  .read<ManageRouteState>()
                                  .update(ManageRoute.team, team: team);
                            }),
                      ),
                    ),
                    Center(child:
                      Text(team.name,
                        textAlign: TextAlign.center,
                      )
                    ),
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
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: constraints.maxWidth /
                                4.5 /
                                _teamAxisCount(teams.length)),
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
                  Text(''),
                  SizedBox(
                    height: 5,
                  ),
                ],
              ),
            ],
          ),
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
