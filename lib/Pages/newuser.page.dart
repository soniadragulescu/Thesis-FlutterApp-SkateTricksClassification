import 'package:first_flutter_app/Setup/constants.dart';
import 'package:first_flutter_app/widget/buttonNewUser.dart';
import 'package:first_flutter_app/widget/newEmail.dart';
import 'package:first_flutter_app/widget/password.dart';
import 'package:first_flutter_app/widget/singup.dart';
import 'package:first_flutter_app/widget/textNew.dart';
import 'package:first_flutter_app/widget/userOld.dart';
import 'package:flutter/material.dart';

class NewUser extends StatefulWidget {
  @override
  _NewUserState createState() => _NewUserState();
}

class _NewUserState extends State<NewUser> {
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
              colors: [violet, lightGreen]),
        ),
        child: ListView(
          children: <Widget>[
            Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    SingUp(),
                    TextNew(),
                  ],
                ),
                //NewNome(),
                NewEmail(this.emailController),
                PasswordInput(this.passwordController),
                ButtonNewUser(emailController, passwordController),
                UserOld(),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
