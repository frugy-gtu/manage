import 'package:flutter/material.dart';
import 'package:manage/core/controller/login_controller.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ChangeNotifierProvider(
            create: (_) => LoginController(),
            child: LoginForm()
          ),
        ),
      ),
    );
  }
}

class LoginForm extends StatelessWidget {
  const LoginForm({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<LoginController>(
      builder: (context, controller, child) => Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            height: 40.0,
          ),
          TextField(
            controller: controller.email,
            cursorColor: Theme.of(context).colorScheme.secondaryVariant,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'email',
              errorText: controller.emailError,
            ),
          ),
          SizedBox(
            height: 10.0,
          ),
          TextField(
            obscureText: true,
            controller: controller.password,
            cursorColor: Theme.of(context).colorScheme.secondaryVariant,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'password',
              errorText: controller.passwordError,
            ),
          ),
          SizedBox(
            height: 5.0,
          ),
          Center(
            child: Text(
              controller.credentialsError,
              style: TextStyle(color: Colors.red),
            ),
          ),
          SizedBox(
            height: 5.0,
          ),
          Column(
            children: [
              RaisedButton(
                  child: Text('Login'),
                  onPressed: () {
                    controller.onLogin(context);
                  }
                ),
              SizedBox(
                width: 5.0,
              ),
              RaisedButton(
                child: Text('Sign up'),
                onPressed: () {
                  controller.onSignUp(context);
                },
              )
            ],
          )
        ],
      ),
    );
  }
}
