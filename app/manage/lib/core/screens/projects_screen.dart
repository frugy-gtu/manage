import 'package:flutter/material.dart';
import 'package:manage/core/controller/projects_controller.dart';
import 'package:manage/core/model/project_model.dart';
import 'package:manage/extra/widgets/InkedContainer.dart';
import 'package:manage/extra/widgets/handled_future_builder.dart';

class ProjectsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _ProjectsScreenBodyView(),
    );
  }
}

class _ProjectsScreenBodyView extends StatelessWidget {
  final _controller = ProjectsController();

  @override
  Widget build(BuildContext context) {
    return NestedScrollView(
      headerSliverBuilder: (context, innerBoxIsScrolled) => <Widget>[
        SliverOverlapAbsorber(
          handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
          sliver: SliverAppBar(
            automaticallyImplyLeading: false,
            title: Text('Projects'),
            forceElevated: innerBoxIsScrolled,
          ),
        ),
      ],
      body: SafeArea(
        top: false,
        bottom: false,
        child: HandledFutureBuilder(
          future: _controller.projects(),
          onSuccess: (data) => _ProjectsView(
            projects: data,
            controller: _controller,
          ),
        ),
      ),
    );
  }
}

class _ProjectsView extends StatelessWidget {
  const _ProjectsView({
    Key key,
    @required List<ProjectModel> projects,
    @required ProjectsController controller,
  })  : _projects = projects,
        _controller = controller,
        super(key: key);

  final List<ProjectModel> _projects;
  final ProjectsController _controller;

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
              itemExtent: 70.0,
              delegate: SliverChildBuilderDelegate(
                (context, index) => InkedContainer(
                  onTap: () =>
                      _controller.onProjectTap(context, _projects[index]),
                  child: Center(
                      child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('${_projects[index].name}',
                          style: Theme.of(context).textTheme.headline6.copyWith(
                              color: Theme.of(context).colorScheme.primary)),
                      SizedBox(
                        height: 3,
                      ),
                      FutureBuilder(
                        future: _controller.teamNameOf(_projects[index].teamId),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.done) {
                            if (snapshot.hasError) {
                              return Center(
                                child: Text(snapshot.error),
                              );
                            }
                            return Text(snapshot.data,
                                style: Theme.of(context)
                                    .textTheme
                                    .caption
                                    .copyWith(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary));
                          } else {
                            return Container(
                              constraints: BoxConstraints(
                                maxHeight: 15,
                                maxWidth: 15,
                              ),
                              child: RefreshProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      Theme.of(context).colorScheme.primary)),
                            );
                          }
                        },
                      ),
                    ],
                  )),
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
