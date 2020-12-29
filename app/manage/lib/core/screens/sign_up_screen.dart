import 'package:flutter/material.dart';
import 'package:manage/core/controller/sign_up_controller.dart';
import 'package:provider/provider.dart';

class SignUpScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Manage'),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) => Padding(
          padding: EdgeInsets.symmetric(
            horizontal: constraints.maxWidth / 9,
          ),
          child: ChangeNotifierProvider(
            create: (_) => SignUpScreenController(),
            child: SignUpForm(),
          ),
        ),
      ),
    );
  }
}

class SignUpForm extends StatelessWidget {
  const SignUpForm({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<SignUpScreenController>(
      builder: (context, controller, child) => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              Icon(Icons.person),
              SizedBox(
                width: 10,
              ),
              Expanded(
                child: TextField(
                  controller: controller.uName,
                  cursorColor: Theme.of(context).colorScheme.secondaryVariant,
                  decoration: InputDecoration(
                    labelText: 'username',
                    errorText: controller.uNameError,
                  ),
                ),
              ),
            ],
          ),
          Row(
            children: [
              Icon(Icons.mail),
              SizedBox(
                width: 10,
              ),
              Expanded(
                child: TextField(
                  controller: controller.email,
                  cursorColor: Theme.of(context).colorScheme.secondaryVariant,
                  decoration: InputDecoration(
                    labelText: 'email',
                    errorText: controller.emailError,
                  ),
                ),
              ),
            ],
          ),
          Row(
            children: [
            Icon(Icons.lock),
            SizedBox(
              width: 10,
            ),
              Expanded(
                child: TextField(
                  controller: controller.password,
                  cursorColor: Theme.of(context).colorScheme.secondaryVariant,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'password',
                    errorText: controller.passwordError,
                  ),
                ),
              ),
            ],
          ),
          Text(
            controller.credentialsError,
            style: TextStyle(color: Colors.red),
          ),
          RaisedButton(
            child: Text('Sign up'),
            onPressed: () {
              controller.onSignUp(context);
            },
          ),
        ],
      ),
    );
  }
}
