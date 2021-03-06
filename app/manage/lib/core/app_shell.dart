import 'package:flutter/material.dart';
import 'package:manage/core/router/manage_inner_router_delegate.dart';
import 'package:manage/core/router/manage_route_state.dart';

class AppShell extends StatefulWidget {
  final ManageRouteState state;

  AppShell({
    @required this.state,
  });

  @override
  _AppShellState createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  ManageInnerRouterDelegate _routerDelegate;
  ChildBackButtonDispatcher _backButtonDispatcher;

  void initState() {
    super.initState();
    _routerDelegate = ManageInnerRouterDelegate(
        widget.state, HeroController(createRectTween: _createRectTween));
  }

  @override
  void didUpdateWidget(covariant AppShell oldWidget) {
    super.didUpdateWidget(oldWidget);
    _routerDelegate.state = widget.state;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _backButtonDispatcher = Router.of(context)
        .backButtonDispatcher
        .createChildBackButtonDispatcher();
  }

  @override
  Widget build(BuildContext context) {
    _backButtonDispatcher.takePriority();

    return Scaffold(
      body: Router(
        routerDelegate: _routerDelegate,
        backButtonDispatcher: _backButtonDispatcher,
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Theme.of(context).colorScheme.background,
        unselectedItemColor:
            Theme.of(context).colorScheme.onBackground.withAlpha(160),
        selectedItemColor: Theme.of(context).colorScheme.onBackground,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Teams'),
          BottomNavigationBarItem(
              icon: Icon(Icons.stacked_bar_chart), label: 'Projects'),
          BottomNavigationBarItem(
              icon: Icon(Icons.account_circle), label: 'Profile'),
          BottomNavigationBarItem(
              icon: Icon(Icons.settings), label: 'Settings'),
        ],
        currentIndex: widget.state.tab.index,
        onTap: (newIndex) {
          widget.state.tab = BottomBarTab.values[newIndex];
        },
      ),
    );
  }

  RectTween _createRectTween(Rect begin, Rect end) {
    return MaterialRectArcTween(begin: begin, end: end);
  }
}
