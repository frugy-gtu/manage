import 'package:flutter/material.dart';

class ManageApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Manage',
      theme: ThemeData.dark(),
      home: Scaffold(
        appBar: AppBar(
          title: Text('Manage'),
        ),
        body: Center(
          child: Text('Manage by Frugy'),
        ),
      ),
    );
  }
}
