import 'package:flutter/material.dart';
import 'package:manage/core/controller/project_screen_controller.dart';
import 'package:manage/core/model/project_state_model.dart';
import 'package:manage/core/model/task_model.dart';
import 'package:manage/core/model/team_project_model.dart';
import 'package:manage/extra/widgets/InkedContainer.dart';
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
        future: _controller.requestStates(),
        onSuccess: (data) => _ProjectScreenBody(
          controller: _controller,
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
  final ProjectScreenController _controller;

  _ProjectScreenBody({
    List<ProjectStateModel> states,
    ProjectScreenController controller,
  })  : _states = states,
        _controller = controller;

  @override
  _ProjectScreenBodyState createState() =>
      _ProjectScreenBodyState(controller: _controller);
}

class _ProjectScreenBodyState extends State<_ProjectScreenBody>
    with SingleTickerProviderStateMixin {
  final ProjectScreenController _controller;

  _ProjectScreenBodyState({ProjectScreenController controller})
      : _controller = controller;

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
                (context, index) => Padding(
                  padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                  child: InkedContainer(
                    color: _controller.getStateColor(_state),
                    onTap: () => _controller.onTaskTap(context, _tasks[index]),
                    child: Center(
                      child: Text(
                        _tasks[index].name,
                        style: Theme.of(context)
                            .textTheme
                            .button
                            .copyWith(color: Theme.of(context).buttonColor),
                      ),
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
