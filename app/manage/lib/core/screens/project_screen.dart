import 'package:flutter/material.dart';
import 'package:manage/core/controller/project_screen_controller.dart';
import 'package:manage/core/model/project_state_model.dart';
import 'package:manage/core/model/task_model.dart';
import 'package:manage/core/model/team_project_model.dart';
import 'package:manage/extra/widgets/handled_future_builder.dart';
import 'package:provider/provider.dart';

class ProjectScreen extends StatelessWidget {
  final TeamProjectModel project;
  final ProjectScreenController _controller;

  ProjectScreen(this.project)
      : _controller = ProjectScreenController(
            project: project, scrollController: ScrollController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: HandledFutureBuilder(
        future: _controller.states(),
        onSuccess: (data) => _ProjectScreenBody(
          scrollController: _controller.scrollController,
          project: _controller.project,
          states: data,
        ),
      ),
      floatingActionButton: ChangeNotifierProvider.value(
          value: _controller, child: _ProjectScreenFloatingActionButton()),
    );
  }
}

class _ProjectScreenFloatingActionButton extends StatelessWidget {
  const _ProjectScreenFloatingActionButton({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<ProjectScreenController>(
      builder: (context, controller, child) =>
          controller.floatingActionButton(context),
    );
  }
}

class _ProjectScreenBody extends StatefulWidget {
  final List<ProjectStateModel> _states;
  final TeamProjectModel _project;
  final ScrollController _scrollController;

  _ProjectScreenBody({
    TeamProjectModel project,
    List<ProjectStateModel> states,
    ScrollController scrollController,
  })  : _project = project,
        _states = states,
        _scrollController = scrollController;

  @override
  _ProjectScreenBodyState createState() => _ProjectScreenBodyState(
        project: _project,
        scrollController: _scrollController,
      );
}

class _ProjectScreenBodyState extends State<_ProjectScreenBody>
    with SingleTickerProviderStateMixin {
  final ProjectScreenController _controller;

  _ProjectScreenBodyState({
    TeamProjectModel project,
    ScrollController scrollController,
  }) : _controller = ProjectScreenController(
          project: project,
          scrollController: scrollController,
        );

  @override
  void initState() {
    super.initState();
    _controller.initState(this, widget._states.length);
  }

  @override
  Widget build(BuildContext context) {
    return NestedScrollView(
      controller: _controller.scrollController,
      headerSliverBuilder: (context, innerBoxIsScrolled) => <Widget>[
        SliverOverlapAbsorber(
          handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
          sliver: SliverAppBar(
            title: Text(_controller.project.name),
            expandedHeight: 120.0,
            forceElevated: innerBoxIsScrolled,
            bottom: TabBar(
              tabs:
                  widget._states.map((state) => Tab(text: state.name)).toList(),
              isScrollable: true,
              controller: _controller.tabController,
            ),
          ),
        ),
      ],
      body: TabBarView(
        controller: _controller.tabController,
        children: widget._states
            .map(
              (state) => SafeArea(
                top: false,
                bottom: false,
                child: HandledFutureBuilder(
                  future: _controller.tasksWith(state),
                  onSuccess: (data) {
                    return _TasksWithStateView(
                        state: state, controller: _controller, tasks: data);
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
