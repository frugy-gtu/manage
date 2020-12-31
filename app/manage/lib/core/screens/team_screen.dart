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
class _TeamScreenFloatingActionButton extends StatelessWidget {
  const _TeamScreenFloatingActionButton({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {},
      backgroundColor: Theme.of(context).colorScheme.onSecondary,
      foregroundColor: Theme.of(context).colorScheme.onPrimary,
      child: context.watch<TeamScreenController>().tabController.index == 0
          ? Icon(Icons.add_circle_outlined)
          : Icon(Icons.person_add),
    );
  }
}
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
class _TeamMembersView extends StatelessWidget {
  const _TeamMembersView({
    Key key,
    @required List<TeamUserModel> members,
  })  : _members = members,
        super(key: key);

  final List<TeamUserModel> _members;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) => CustomScrollView(
        key: PageStorageKey<String>('TeamMembersView'),
        slivers: <Widget>[
          SliverOverlapInjector(
            handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
          ),
          SliverPadding(
            padding: EdgeInsets.symmetric(
                vertical: 30, horizontal: constraints.maxWidth / 6),
            sliver: SliverFixedExtentList(
              itemExtent: 60.0,
              delegate: SliverChildBuilderDelegate(
                (context, index) => InkedContainer(
                  onTap: () {},
                  child: Row(
                    children: [
                      Spacer(),
                      Icon(
                        Icons.account_circle,
                        color: Colors.white,
                      ),
                      Spacer(flex: 2),
                      Flexible(
                        flex: 6,
                        child: Text('${_members[index].username}',
                            style: Theme.of(context)
                                .textTheme
                                .headline6
                                .copyWith(color: Colors.white)),
                      ),
                    ],
                  ),
                ),
                childCount: _members.length,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
