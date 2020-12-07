import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class TeamHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Center(child: const Text('Teams'))),
      body: Center(
        child: GridView.count(
          primary: false,
          padding: const EdgeInsets.all(20),
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          crossAxisCount: 3,
          children: <Widget>[
            Container(
              padding: const EdgeInsets.all(20),
              child: const Text("Heeyyy"),
              color: Colors.blue,
            ),
          ],
        ),
      ),
    );
  }
}
