import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class TeamHomePage extends StatelessWidget {
  final teamCount = 1;

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
        toolbarHeight: MediaQuery.of(context).size.height / 5,
      ),
      body: LayoutBuilder(
        builder: (context, constraints) => Padding(
          padding: EdgeInsets.symmetric(
            vertical: constraints.maxHeight / 9,
          ),
          child: GridView.count(
            primary: true,
            padding: _teamGridTilePadding(constraints.maxWidth,
                constraints.maxHeight - constraints.maxHeight / 4.5),
            crossAxisCount: _teamAxisCount(teamCount),
            children: [
              TeamGridTile(
                child: Text(
                  'User Team',
                  style: Theme.of(context).textTheme.button,
                ),
              ),
              TeamGridTile(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Scaffold()),
                  );
                },
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

  EdgeInsetsGeometry _teamGridTilePadding(double maxWidth, double maxHeight) {
    if (teamCount == 1) {
      return EdgeInsets.symmetric(horizontal: (maxWidth - (maxHeight / 2)) / 2);
    } else {
      return EdgeInsets.all(10);
    }
  }

  int _teamAxisCount(int teamCount) {
    if (teamCount < 2)
      return 1;
    else if (teamCount < 4)
      return 2;
    else
      return 3;
  }
}

class TeamGridTile extends GridTile {
  final Function onTap;

  const TeamGridTile({
    @required Widget child,
    Key key,
    this.onTap,
    Widget header,
    Widget footer,
  })  : assert(child != null),
        super(key: key, child: child, header: header, footer: footer);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap ?? () {},
      customBorder: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5),
      ),
      child: Container(
        decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(5)),
        margin: const EdgeInsets.all(5),
        child: Center(
          child: super.build(context),
        ),
      ),
    );
  }
}
