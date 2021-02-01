import 'package:flutter/material.dart';
import 'package:manage/core/controller/sign_up_controller.dart';
import 'package:manage/extra/widgets/wide_card_button.dart';
import 'package:provider/provider.dart';

class SignUpScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Manage',
          style: TextStyle(color: Theme.of(context).colorScheme.secondary),
        ),
        iconTheme:
            IconThemeData(color: Theme.of(context).colorScheme.secondary),
      ),
      body: ChangeNotifierProvider(
        create: (_) => SignUpScreenController(),
        child: SingleChildScrollView(
          child: SignUpForm(),
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
      builder: (context, controller, child) => Padding(
        padding: EdgeInsets.symmetric(
          vertical: 50,
          horizontal: 50,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
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
                Icon(Icons.text_fields),
                SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: TextField(
                    controller: controller.fName,
                    cursorColor: Theme.of(context).colorScheme.secondaryVariant,
                    decoration: InputDecoration(
                      labelText: 'name',
                      errorText: controller.fNameError,
                    ),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Icon(Icons.text_fields),
                SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: TextField(
                    controller: controller.lName,
                    cursorColor: Theme.of(context).colorScheme.secondaryVariant,
                    decoration: InputDecoration(
                      labelText: 'surname',
                      errorText: controller.lNameError,
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
            WideCardButton(
              child: Text(
                'Sign Up',
                style: Theme.of(context).textTheme.button,
              ),
              onTap: () {
                controller.onSignUp(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
