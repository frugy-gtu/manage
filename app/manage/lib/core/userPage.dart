import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:sw_project/temps/userProfile.dart';
import 'temps/team.dart';
import 'temps/project.dart';
import 'package:provider/provider.dart';

class UserPage extends StatefulWidget {
  @override
  _UserPageState createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  
  List<Team> teams = [
    Team(name: 'Frugy', icon: Icon(Icons.account_box, size: 50.0)),
    Team(name: 'Ale', icon: Icon(Icons.ac_unit, size: 50.0)),
    ];
  List<Project> projects = [
    Project(name: 'Manage', icon: Icon(Icons.accessible, size: 50.0)),
    Project(name: 'Rat', icon: Icon(Icons.pages, size: 50.0)),
    Project(name: 'Phone', icon: Icon(Icons.phone, size: 50.0)),
    Project(name: 'XD', icon: Icon(Icons.save, size: 50.0)),
    Project(name: 'Text', icon: Icon(Icons.text_fields, size: 50.0)),
    Project(name: 'SAD', icon: Icon(Icons.aspect_ratio, size: 50.0)),
    Project(name: 'DASD', icon: Icon(Icons.dashboard, size: 50.0))
  ];

  UserProfile user;

  void initState(){
    super.initState();
    user = UserProfile(name:'Ali', lName: 'Asa', photo: Icon(Icons.account_circle, size: 100.0), teams: teams, projects: projects);
  }

  void dispose(){
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: ChangeNotifierProvider(
            create: (context) => UserProfile.cp(user),
            child: Consumer<UserProfile>(
              builder: (context, user, child) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ProfileInfos(user: user),
                    SizedBox(height: 20.0),
                    Text('Projects:'),
                    ProjectsList(user: user),
                    Text('Teams:'),
                    TeamsList(user: user),
                    RaisedButton(
                      onPressed: (){
                        Team tm = new Team(icon: Icon(Icons.backspace), name: "new team");
                        user.addTeam(tm);
                      }
                    ),
                  ],
                );
              },  
            ),
          ),
        ),
      ),
      drawer: Theme(
        data: Theme.of(context).copyWith(
          canvasColor: Colors.black,
        ),
        child: SizedBox(
          width: 150.0,
          child: Drawer(
            child: ListView(
              children: [
                ListTile(
                  title: Text('Back', style: TextStyle(color: Colors.white)),
                  onTap: (){
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  title: Text('Agenda', style: TextStyle(color: Colors.white)),
                  onTap: (){
                    //Navigator.popAndPushNamed(context, '/agendaPage');
                  },
                ),
                ListTile(
                  title: Text('Settings', style: TextStyle(color: Colors.white)),
                  onTap: (){
                    //Navigator.popAndPushNamed(context, '/settingsPage');
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ProfileInfos extends StatelessWidget {
  final UserProfile user;

  ProfileInfos({this.user});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          FutureBuilder<Icon>(
            future: user.getPhoto(),
            builder: (context, snapshot){
              if(snapshot.hasData){
                return snapshot.data;
              }else{
                return Center(
                  child: Text('No Photo', style: TextStyle(fontSize: 30))
                );
              }
            }
          ),
          FutureBuilder<String>(
            future: user.getName(),
            builder: (context, snapshot) {
              if(snapshot.hasData){
                return Center(
                  child: Text(snapshot.data, style: TextStyle(fontSize: 30))
                );
              }else{
                return Center(
                  child: Text('No First Name', style: TextStyle(fontSize: 30))
                );
              }
            }
          ),
          FutureBuilder<String>(
            future: user.getLName(),
            builder: (context, snapshot) {
              if(snapshot.hasData){
                return Center(
                  child: Text(snapshot.data, style: TextStyle(fontSize: 30))
                );
              }else{
                return Center(
                  child: Text('No Last Name', style: TextStyle(fontSize: 30))
                );
              }
            }
          )
        ],
      )
    );
  }
}

class TeamsList extends StatelessWidget {
  final UserProfile user;

  TeamsList({this.user});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100.0,
      child: FutureBuilder<List<Team>>(
        future: user.getTeams(),
        builder: (context, snapshot){
          if(snapshot.hasData){
            return ListView.builder(
              shrinkWrap: true,
              itemCount: snapshot.data.length,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, int position){
                final item = snapshot.data[position];
                return GestureDetector(
                  onTap: () {
                        //go to team page
                  },
                  child: Card(
                    margin: EdgeInsets.all(5),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(item.getName()),
                        item.getIcon(),
                      ],
                    ),
                  ),
                );
              }
            );
          }else{
            return Center(
              child: Text('No Teams', style: TextStyle(fontSize: 30),),
            );
          }
        }
      )  
    );
  }
}

class ProjectsList extends StatelessWidget {
  final UserProfile user;

  ProjectsList({this.user});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100.0,
      child: FutureBuilder<List<Project>>(
        future: user.getProjects(),
        builder: (context, snapshot){
          if(snapshot.hasData){
            return ListView.builder(
              shrinkWrap: true,
              itemCount: snapshot.data.length,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, int position){
                final item = snapshot.data[position];
                return GestureDetector(
                  onTap: () {
                    //go to project page
                  },
                  child: Card(
                    margin: EdgeInsets.all(5),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(item.getName()),
                        item.getIcon(),
                      ],
                    ),
                  ),
                );
              }
            );
          }else{
            return Center(
              child: Text('No Projects', style: TextStyle(fontSize: 30),),
            );
          }
        }
      )  
    );
  }
}