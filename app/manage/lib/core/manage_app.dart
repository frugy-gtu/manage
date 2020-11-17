import 'package:flutter/material.dart';

import 'manage_theme.dart';

class ManageApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Manage',
      theme: ManageTheme.light,
      darkTheme: ManageTheme.dark,
      home: Scaffold(
        appBar: AppBar(
          title: Text('Manage'),
        ),
        body: Center(
          child: Text('Manage by Frugy'),
        ),
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}
