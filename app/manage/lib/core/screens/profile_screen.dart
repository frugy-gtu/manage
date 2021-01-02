import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:manage/core/controller/profile_screen_controller.dart';
import 'package:manage/core/model/general_user_model.dart';

//TODO: Use LayoutBuilder
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
      ),
      body: ProfileInfos(user: user),
    );
  }
}

class ProfileInfos extends StatefulWidget {
  final GeneralUserModel user;

  ProfileInfos({this.user});

  @override
  _ProfileInfosState createState() => _ProfileInfosState();
}

class _ProfileInfosState extends State<ProfileInfos> {
  final _controller = ProfileScreenController();
  bool isUserProfile = false;

  @override
  void initState() {
    super.initState();
    isUserProfile = _controller.isUserProfile(context);
  }

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
                image: DecorationImage(
                    image: Image.asset('assets/default-profile.png').image),
              ),
            ),
            SizedBox(
              height: 5.0,
            ),
            Text(widget.user.username, style: TextStyle(fontSize: 20.0)),
            SizedBox(
              height: 5.0,
            ),
            Text(widget.user.email, style: TextStyle(fontSize: 15.0)),
            SizedBox(
              height: 80.0,
            ),
            if (isUserProfile)
              ElevatedButton(
                onPressed: () =>
                  _controller.onLogout(context),
                child: Text('Logout'),
              ),
          ],
        ),
      ),
    );
  }
}
