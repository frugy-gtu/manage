import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:manage/core/controller/team_screen_controller.dart';
import 'package:manage/core/model/team_project_model.dart';
import 'package:manage/core/model/user_model.dart';
import 'package:manage/extra/widgets/InkedContainer.dart';
import 'package:manage/extra/widgets/handled_future_builder.dart';
import 'package:provider/provider.dart';

import '../model/team_model.dart';

class TeamScreen extends StatefulWidget {
  final TeamModel team;

  TeamScreen({this.team});

  @override
  _TeamScreenState createState() => _TeamScreenState(team);
}

class _TeamScreenState extends State<TeamScreen>
    with SingleTickerProviderStateMixin {
  final TeamScreenController _controller;

  _TeamScreenState(TeamModel team)
      : _controller = TeamScreenController(team: team);

  @override
  void initState() {
    super.initState();
    _controller.initState(vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ChangeNotifierProvider.value(value: _controller, child:_TeamScreenBodyView(_controller),),
      floatingActionButton: ChangeNotifierProvider.value(
          value: _controller, child: _TeamScreenFloatingActionButton()),
    );
  }
}

class _TeamScreenFloatingActionButton extends StatelessWidget {
  const _TeamScreenFloatingActionButton({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<TeamScreenController>(
      builder: (context, controller, child) =>
          controller.floatingActionButton(context),
    );
  }
}

class _TeamScreenBodyView extends StatelessWidget {
  final TeamScreenController _controller;

  _TeamScreenBodyView(this._controller);

  Widget build(BuildContext context) {
    return NestedScrollView(
      controller: _controller.scrollController,
      headerSliverBuilder: (context, innerBoxIsScrolled) => <Widget>[
        SliverOverlapAbsorber(
          handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
          sliver: SliverAppBar(
            title: Text(_controller.team.name, style: TextStyle(color: Theme.of(context).colorScheme.secondary),),
            expandedHeight: 120.0,
            forceElevated: innerBoxIsScrolled,
            bottom: TabBar(
              labelColor: Theme.of(context).colorScheme.secondary,
              tabs: _controller.tabs.map((name) => Tab(text: name)).toList(),
              controller: _controller.tabController,
            ),
          ),
        ),
      ],
      body: TabBarView(
        controller: _controller.tabController,
        children: [
          SafeArea(
            top: false,
            bottom: false,
            child: Consumer<TeamScreenController>(
              builder: (context, controller, snapshot) {
                return HandledFutureBuilder(
                  future: controller.projects(),
                  onSuccess: (data) => _TeamProjectsView(
                    projects: data,
                    controller: controller,
                  ),
                );
              }
            ),
          ),
          SafeArea(
            top: false,
            bottom: false,
            child: HandledFutureBuilder(
              future: _controller.members(),
              onSuccess: (data) => _TeamMembersView(
                members: data,
                controller: _controller,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TeamProjectsView extends StatelessWidget {
  const _TeamProjectsView({
    Key key,
    @required List<TeamProjectModel> projects,
    @required TeamScreenController controller,
  })  : _projects = projects,
        _controller = controller,
        super(key: key);

  final List<TeamProjectModel> _projects;
  final TeamScreenController _controller;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) => CustomScrollView(
        key: PageStorageKey<String>('TeamProjectsView'),
        slivers: <Widget>[
          SliverOverlapInjector(
            handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
          ),
          SliverPadding(
            padding: EdgeInsets.symmetric(
                vertical: 32, horizontal: constraints.maxWidth / 9),
            sliver: SliverFixedExtentList(
              itemExtent: 50.0,
              delegate: SliverChildBuilderDelegate(
                (context, index) => InkedContainer(
                  onLongPress: () => _controller.showAlertDialog(context, _projects[index]),
                  onTap: () =>
                      _controller.onProjectTap(context, _projects[index]),
                  child: Center(
                      child: Text('${_projects[index].name}',
                          style: Theme.of(context).textTheme.headline6.copyWith(
                              color: Theme.of(context).colorScheme.primary))),
                ),
                childCount: _projects.length,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TeamMembersView extends StatelessWidget {
  final TeamScreenController controller;
  const _TeamMembersView({
    Key key,
    @required List<UserModel> members,
    @required this.controller,
  })  : _members = members,
        super(key: key);

  final List<UserModel> _members;

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
                  onTap: () => controller.onMemberTap(context, _members[index]),
                  child: Row(
                    children: [
                      Spacer(),
                      Icon(
                        Icons.account_circle,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      Spacer(flex: 2),
                      Flexible(
                        flex: 6,
                        child: Text('${_members[index].username}',
                            style: Theme.of(context)
                                .textTheme
                                .headline6
                                .copyWith(
                                    color:
                                        Theme.of(context).colorScheme.primary)),
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
