import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:manage/extra/widgets/InkedContainer.dart';

import '../team.dart';

class TeamsScreen extends StatelessWidget {
  final List<Team> teams = [Team('User Team')];
  final ValueChanged<Team> onTapped;

  TeamsScreen({Key key, @required this.onTapped})
      : assert(onTapped != null),
        super(key: key);

  // const TeamsScreen({Key key, @required this.teams, @required this.onTapped})
  //     : assert(teams != null),
  //       assert(onTapped != null),
  //       super(key: key);

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
            padding: _teamGridTilePadding(constraints.maxWidth,
                constraints.maxHeight - constraints.maxHeight / 4.5),
            crossAxisCount: _teamAxisCount(teams.length),
            children: [
              for (Team team in teams)
                InkedContainer(
                  child: Text(
                    team.name,
                    style: Theme.of(context).textTheme.button,
                  ),
                  onTap: () => onTapped(team),
                ),
              InkedContainer(
                onTap: () {},
                child: Icon(
                  Icons.add_circle,
                  color: Theme.of(context).textTheme.button.color,
                  size: 28,
                ),
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
          horizontal: (maxWidth - (maxHeight / 2)) / 1.6);
    } else {
      return EdgeInsets.all(10);
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
