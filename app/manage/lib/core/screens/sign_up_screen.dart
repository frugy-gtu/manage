import 'package:flutter/material.dart';
import 'package:manage/core/controller/sign_up_controller.dart';
import 'package:provider/provider.dart';
class SignUpScreen extends StatelessWidget {
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
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            height: 40.0,
          ),
          TextField(
            controller: controller.uName,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'username',
              errorText: controller.uNameError,
            ),
          ),
          SizedBox(
            height: 10.0,
          ),
          TextField(
            controller: controller.email,
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
            controller: controller.password,
            obscureText: true,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'password',
              errorText: controller.passwordError,
            ),
          ),
          SizedBox(
            height: 10.0,
          ),
          Center(
            child: Text(
              controller.credentialsError,
              style: TextStyle(color: Colors.red),
            ),
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
