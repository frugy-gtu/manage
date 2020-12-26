import 'package:flutter/material.dart' hide Theme;
import 'package:manage/core/router/manage_route_information_parser.dart';
import 'package:manage/core/router/manage_router_delegate.dart';
import 'package:provider/provider.dart';

import 'settings.dart';
import 'theme.dart';

class App extends StatelessWidget {
  final ManageRouterDelegate _manageRouterDelegate = ManageRouterDelegate();
  final ManageRouteInformationParser _manageRouteInformationParser =
      ManageRouteInformationParser();

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: Settings.listenable(['themeMode']),
        builder: (context, box, widget) {
          return ChangeNotifierProvider.value(
            value: _manageRouterDelegate.state,
            child: MaterialApp.router(
              title: 'Manage',
              theme: Theme.light,
              darkTheme: Theme.dark,
              debugShowCheckedModeBanner: false,
              routerDelegate: _manageRouterDelegate,
              routeInformationParser: _manageRouteInformationParser,
            ),
          );
        });
  }
}