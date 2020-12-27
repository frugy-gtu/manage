import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:sw_project/temps/userProfile.dart';
import 'temps/team.dart';
import 'temps/project.dart';

class UserPage extends StatelessWidget {
  
  final UserProfile user;

  UserPage({@required this.user});

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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ProfileInfos(user: user),
              SizedBox(height: 20.0),
              Text('Projects:'),
              ProjectsList(user: user),
              Text('Teams:'),
              TeamsList(user: user),
            ],
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
      child: Center(
        child: FutureBuilder(
          future: Future.wait([user.getPhoto(), user.getName(), user.getLName()]),
          builder: (context, user){
            if(user.hasData){
              Icon photo = Icon(user.data[0], size:100.0);
              String name = user.data[1];
              String lName = user.data[2];
              return Column(
                children: [
                  photo,
                  Center(child: Text(name, style: TextStyle(fontSize: 30.0))),
                  Center(child: Text(lName, style: TextStyle(fontSize: 30.0))),
                ],
              );
            }else{
              return Center(
                child: Text('Could not access user infos', style: TextStyle(fontSize: 30))
              );
            }
          }
        ),
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
        builder: (context, teams){
          if(teams.hasData){
            return ListView.builder(
              shrinkWrap: true,
              itemCount: teams.data.length,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, int position){
                final currentTeam = teams.data[position];
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
                        Text(currentTeam.getName()),
                        currentTeam.getIcon(),
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
        builder: (context, projects){
          if(projects.hasData){
            return ListView.builder(
              shrinkWrap: true,
              itemCount: projects.data.length,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, int position){
                final currentProject = projects.data[position];
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
                        Text(currentProject.getName()),
                        currentProject.getIcon(),
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