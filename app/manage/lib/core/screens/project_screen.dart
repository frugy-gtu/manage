import 'package:flutter/material.dart';
import 'package:manage/core/controller/project_screen_controller.dart';
import 'package:manage/core/model/project_state_model.dart';
import 'package:manage/core/model/task_model.dart';
import 'package:manage/core/model/team_project_model.dart';
import 'package:manage/extra/widgets/handled_future_builder.dart';

class ProjectScreen extends StatefulWidget {
  final TeamProjectModel project;

  const ProjectScreen(this.project);

  @override
  State<StatefulWidget> createState() => _ProjectScreenState(project);
}

class _ProjectScreenState extends State<ProjectScreen>
    with SingleTickerProviderStateMixin {
  final ProjectScreenController _controller;

  _ProjectScreenState(TeamProjectModel project)
      : _controller = ProjectScreenController(project: project);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: HandledFutureBuilder(
        future: _controller.states(),
        onSuccess: (data) => _ProjectScreenBody(
          project: _controller.project,
          states: data,
          vsync: this,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _controller.onFloatingActionPress(context),
        backgroundColor: Theme.of(context).colorScheme.onPrimary,
        foregroundColor: Theme.of(context).colorScheme.onSecondary,
        child: Icon(Icons.add, color: Theme.of(context).colorScheme.primary),
      ),
    );
  }
}

class _ProjectScreenBody extends StatelessWidget {
  final ProjectScreenController _controller;
  final List<ProjectStateModel> _states;

  _ProjectScreenBody(
      {TeamProjectModel project,
      List<ProjectStateModel> states,
      TickerProvider vsync})
      : _controller = ProjectScreenController.withTab(
            project: project, stateLength: states.length, vsync: vsync),
        _states = states;

  @override
  Widget build(BuildContext context) {
    return NestedScrollView(
      headerSliverBuilder: (context, innerBoxIsScrolled) => <Widget>[
        SliverOverlapAbsorber(
          handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
          sliver: SliverAppBar(
            title: Text(_controller.project.name),
            expandedHeight: 120.0,
            forceElevated: innerBoxIsScrolled,
            bottom: TabBar(
              tabs: _states.map((state) => Tab(text: state.name)).toList(),
              isScrollable: true,
              controller: _controller.tabController,
            ),
          ),
        ),
      ],
      body: TabBarView(
        controller: _controller.tabController,
        children: _states
            .map(
              (state) => SafeArea(
                top: false,
                bottom: false,
                child: HandledFutureBuilder(
                  future: _controller.tasksWith(state),
                  onSuccess: (data) {
                    return _TasksWithStateView(
                        state: state,
                        controller: _controller,
                        tasks: data);
                  },
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}

class _TasksWithStateView extends StatelessWidget {
  const _TasksWithStateView({
    Key key,
    @required List<TaskModel> tasks,
    @required ProjectStateModel state,
    @required ProjectScreenController controller,
  })  : _tasks = tasks,
        _controller = controller,
        _state = state,
        super(key: key);

  final List<TaskModel> _tasks;
  final ProjectStateModel _state;
  final ProjectScreenController _controller;

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
                (context, index) => Card(
                  color: _controller.getStateColor(_state),
                  margin: EdgeInsets.all(5.0),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          _tasks[index].name,
                          style: TextStyle(fontSize: 15.0),
                        ),
                        Expanded(child: SizedBox()),
                        Text(
                          _tasks[index].deadline,
                          style: TextStyle(fontSize: 15.0),
                        ),
                        IconButton(
                          icon: Icon(
                            Icons.navigate_next,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Scaffold(
                                    appBar: AppBar(
                                  title: Text(_tasks[index].name),
                                )),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                childCount: _tasks.length,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
