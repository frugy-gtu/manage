import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:manage/core/model/general_user_model.dart';


class ProfileScreen extends StatelessWidget {

  final GeneralUserModel user;

  ProfileScreen(this.user);

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
      body: ProfileInfos(user: user),
    );
  }
}

class ProfileInfos extends StatelessWidget {
  final GeneralUserModel user;

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
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.black,
                  width: 3.0,
                ),
                image: DecorationImage(image: Image.asset('assets/default-profile.png').image),
              ),
            ),
            SizedBox(height: 5.0,),
            Text(user.username, style: TextStyle(fontSize: 30.0)),
            SizedBox(height: 5.0,),
            Text(user.email, style: TextStyle(fontSize: 30.0)),
          ],
        ),
      ),
    );
  }
}

