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
      body: Center(
        child: Padding(
          //TODO: Do dynamic padding here where each pads accordingly
          //to the number of teams. It is not necessarily to use Padding
          //widget. Should take care of crossAxisSpacing too.
          padding: EdgeInsets.symmetric(vertical: 50, horizontal: 10),
          child: GridView.count(
            primary: false,
            padding: const EdgeInsets.all(20),
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            //TODO: Do dynamic crossAxisCount here where cross axis
            //determined by number of teams.
            crossAxisCount: 2,
            children: [
              _teamWidget(context,
                child: Text(
                  'User Team',
                  style: Theme.of(context).textTheme.button,
                ),
              ),
              _teamWidget(context,
                child: Text(
                  'Other Team',
                  style: Theme.of(context).textTheme.button,
                ),
              ),
              _teamWidget(context,
                child: Icon(
                  Icons.add_circle,
                  size: 28,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _teamWidget(BuildContext context, {@required Widget child}) {
    return InkWell(
      onTap: () {},
      customBorder: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5),
      ),
      child: Container(
        decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(5)),
        margin: const EdgeInsets.all(10),
        child: Center(
          child: child,
        ),
      ),
    );
  }
}
