import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:manage/core/router/manage_route.dart';
import 'package:manage/core/router/manage_route_state.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  TextEditingController _fNameCont;
  TextEditingController _lNameCont;
  TextEditingController _mailCont;
  TextEditingController _passCont;
  bool _validFName = true;
  bool _validLName = true;
  bool _validMail = true;
  bool _validPass = true;
  bool _registered = true;

  void initState() {
    super.initState();
    _fNameCont = TextEditingController();
    _lNameCont = TextEditingController();
    _mailCont = TextEditingController();
    _passCont = TextEditingController();
  }

  void dispose() {
    _fNameCont.dispose();
    _lNameCont.dispose();
    _mailCont.dispose();
    _passCont.dispose();
    super.dispose();
  }

  Future<void> register(String mail, String password) async {
    setState(() {
      _registered = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text('Sign up'),
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
                controller: _fNameCont,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'first name',
                  errorText: _validFName ? null : 'You must fill here',
                ),
              ),
              SizedBox(
                height: 10.0,
              ),
              TextField(
                controller: _lNameCont,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'last name',
                  errorText: _validLName ? null : 'You must fill here',
                ),
              ),
              SizedBox(
                height: 10.0,
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
                controller: _passCont,
                obscureText: true,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'password',
                  errorText: _validPass ? null : 'You must fill here',
                ),
              ),
              SizedBox(
                height: 10.0,
              ),
              Center(
                child: Text(
                  _registered ? '' : 'Mail address is already used',
                  style: TextStyle(color: Colors.red),
                ),
              ),
              RaisedButton(
                child: Text('Sign up'),
                onPressed: () {
                  setState(() {
                    _fNameCont.text.isEmpty
                        ? _validFName = false
                        : _validFName = true;
                    _lNameCont.text.isEmpty
                        ? _validLName = false
                        : _validLName = true;
                    _mailCont.text.isEmpty
                        ? _validMail = false
                        : _validMail = true;
                    _passCont.text.isEmpty
                        ? _validPass = false
                        : _validPass = true;
                  });
                  if (_validFName == true &&
                      _validLName == true &&
                      _validMail == true &&
                      _validPass == true) {
                    register(_mailCont.text, _passCont.text);
                    if(_registered) {
                      context.read<ManageRouteState>().update(ManageRoute.login);
                    }
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
