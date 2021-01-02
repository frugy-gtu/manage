// Widget that contains the AdaptiveNavigationScaffold
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
    _routerDelegate = ManageInnerRouterDelegate(widget.state);
  }

  @override
  void didUpdateWidget(covariant AppShell oldWidget) {
    super.didUpdateWidget(oldWidget);
    _routerDelegate.state = widget.state;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Defer back button dispatching to the child router
    _backButtonDispatcher = Router.of(context)
        .backButtonDispatcher
        .createChildBackButtonDispatcher();
  }

  @override
  Widget build(BuildContext context) {
    var appState = widget.state;

    // Claim priority, If there are parallel sub router, you will need
    // to pick which one should take priority;
    _backButtonDispatcher.takePriority();

    return Scaffold(
      body: Router(
        routerDelegate: _routerDelegate,
        backButtonDispatcher: _backButtonDispatcher,
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Teams'),
          BottomNavigationBarItem(
              icon: Icon(Icons.settings), label: 'Profile'),
        ],
        currentIndex: appState.tab.index,
        onTap: (newIndex) {
          appState.tab = BottomBarTab.values[newIndex];
        },
      ),
    );
  }
}
