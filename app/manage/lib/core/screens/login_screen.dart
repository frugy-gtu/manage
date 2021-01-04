import 'package:flutter/material.dart';
import 'package:manage/core/controller/login_controller.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Manage'),
        automaticallyImplyLeading: false,
      ),
      body: LayoutBuilder(
        builder: (context, constraints) => Padding(
          padding: EdgeInsets.symmetric(
            horizontal: constraints.maxWidth / 9,
          ),
          child: ChangeNotifierProvider(
            create: (_) => LoginController(),
            child: LoginForm(),
          ),
        ),
      ),
    );
  }
}

class LoginForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<LoginController>(
      builder: (context, controller, child) => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              Icon(Icons.mail),
              SizedBox(
                width: 10,
              ),
              Expanded(
                child: TextField(
                  controller: controller.emailOrUName,
                  cursorColor: Theme.of(context).colorScheme.secondaryVariant,
                  decoration: InputDecoration(
                    labelText: 'username or email',
                    errorText: controller.emailOrUNameError,
                  ),
                ),
              ),
            ],
          ),
          Row(
            children: [
              Icon(
                Icons.lock,
              ),
              SizedBox(
                width: 10,
              ),
              Expanded(
                child: TextField(
                  obscureText: true,
                  controller: controller.password,
                  cursorColor: Theme.of(context).colorScheme.secondaryVariant,
                  decoration: InputDecoration(
                    labelText: 'password',
                    errorText: controller.passwordError,
                  ),
                ),
              ),
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                controller.credentialsError,
                style: TextStyle(color: Colors.red),
              ),
              SizedBox(
                height: 10,
              ),
              RaisedButton(
                  child: Text('Login'),
                  onPressed: () {
                    controller.onLogin(context);
                  }),
              SizedBox(height: 10),
              Row(children: [
                Expanded(
                  child: Divider(
                    color: Theme.of(context).colorScheme.secondary,
                    endIndent: 10,
                  ),
                ),
                Text(
                  "Don't have an account?",
                  style: Theme.of(context)
                      .textTheme
                      .caption
                      .copyWith(color: Theme.of(context).colorScheme.secondary),
                ),
                Expanded(
                  child: Divider(
                    color: Theme.of(context).colorScheme.secondary,
                    indent: 10,
                  ),
                ),
              ]),
              SizedBox(height: 10),
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
