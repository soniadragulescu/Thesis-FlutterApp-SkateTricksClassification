import 'package:first_flutter_app/widget/button.dart';
import 'package:first_flutter_app/widget/first.dart';
import 'package:first_flutter_app/widget/inputEmail.dart';
import 'package:first_flutter_app/widget/password.dart';
import 'package:first_flutter_app/widget/textLogin.dart';
import 'package:first_flutter_app/widget/verticalText.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SignInPage extends StatelessWidget {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [Colors.blueGrey, Colors.lightBlueAccent]),
        ),
        child: ListView(
          children: <Widget>[
            Column(children: <Widget>[
              Row(children: <Widget>[
                VerticalText(),
                TextLogin(),
              ]),
              InputEmail(emailController),
              PasswordInput(passwordController),
              ButtonLogin(emailController, passwordController),
              FirstTime(),
            ])
          ],
        ),
      ),
    );
  }
}
