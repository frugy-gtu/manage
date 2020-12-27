import 'package:flutter/material.dart';
import 'package:manage/core/model/user.dart';
import 'package:manage/core/router/manage_route.dart';
import 'package:manage/core/router/manage_route_state.dart';
import 'package:provider/provider.dart';
import 'package:manage/core/service/user_service.dart' as service;

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController _mailCont;
  TextEditingController _passCont;
  bool _validMail = true;
  bool _validPass = true;
  bool _userExist = true;

  void initState() {
    super.initState();
    _mailCont = TextEditingController();
    _passCont = TextEditingController();
  }

  void dispose() {
    _mailCont.dispose();
    _passCont.dispose();
    super.dispose();
  }

  Future<void> login(String mail, String password) async {
    _userExist = await service.login(User(email: mail, password: password));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(
                height: 40.0,
              ),
              TextField(
                controller: _mailCont,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'email',
                  errorText: _validMail ? null : 'You must fill here',
                ),
              ),
              SizedBox(
                height: 10.0,
              ),
              TextField(
                obscureText: true,
                controller: _passCont,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'password',
                  errorText: _validPass ? null : 'You must fill here',
                ),
              ),
              SizedBox(
                height: 5.0,
              ),
              Center(
                child: Text(
                  _userExist ? '' : 'Wrong information',
                  style: TextStyle(color: Colors.red),
                ),
              ),
              SizedBox(
                height: 5.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  RaisedButton(
                      child: Text('Login'),
                      onPressed: () {
                        setState(() {
                          _mailCont.text.isEmpty
                              ? _validMail = false
                              : _validMail = true;
                          _passCont.text.isEmpty
                              ? _validPass = false
                              : _validPass = true;
                        });
                        if (_validMail == true && _validPass == true) {
                          login(_mailCont.text, _passCont.text);
                          if (_userExist) {
                            context
                                .read<ManageRouteState>()
                                .update(ManageRoute.teams);
                          }
                        }
                      }),
                  SizedBox(
                    width: 5.0,
                  ),
                  RaisedButton(
                    child: Text('Sign up'),
                    onPressed: () {
                      setState(() {
                        _mailCont.clear();
                        _passCont.clear();
                      });
                      context
                          .read<ManageRouteState>()
                          .update(ManageRoute.signup);
                    },
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
