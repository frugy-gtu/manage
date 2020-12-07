import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class TeamHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Ink(
          padding: EdgeInsets.symmetric(
            vertical: 30,
            horizontal: 10,
          ),
          child: InkWell(
            onTap: () {},
            customBorder: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
            ),
            child: Icon(Icons.menu_rounded),
          ),
        ),
        title: const Text('Teams'),
        actions: [
          IconButton(
            icon: Icon(Icons.person_pin_circle_rounded),
            onPressed: () {},
            splashRadius: 20,
          ),
        ],
        toolbarHeight: 100,
      ),
        ),
      ),
    );
  }
}
