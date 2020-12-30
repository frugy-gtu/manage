import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:manage/core/model/user_profile_model.dart';

class UserPage extends StatelessWidget {
  
  final UserProfileModel user;

  UserPage({@required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
        actions: [
          IconButton(
            icon: Icon(Icons.do_not_disturb),
            onPressed: (){
              //logout
            }
          ),
        ],
      ),
      body: ProfileInfos(user: user,),
      drawer: ThisDrawer(),
    );
  }
}

class ProfileInfos extends StatelessWidget {
  final UserProfileModel user;

  ProfileInfos({this.user});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 150.0, 
              width: 150.0, 
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.black,
                  width: 3.0,
                ),
              ),
              child: user.profilePhoto,
            ),
            SizedBox(height: 5.0,),
            Text(user.userName, style: TextStyle(fontSize: 30.0)),
            SizedBox(height: 5.0,),
            Text(user.name + ' ' + user.surname, style: TextStyle(fontSize: 30.0)),
          ],
        ),
      ),
    );
  }      
}

class ThisDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Theme(
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
    );
  }
}