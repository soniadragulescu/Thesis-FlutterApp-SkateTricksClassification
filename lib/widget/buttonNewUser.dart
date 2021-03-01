import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:first_flutter_app/authentication_services.dart';

class ButtonNewUser extends StatefulWidget {
  ButtonNewUser(TextEditingController emailController, TextEditingController passwordController) {
    this.emailController = emailController;
    this.passwordController = passwordController;
  }

  TextEditingController emailController;
  TextEditingController passwordController;

  @override
  _ButtonNewUserState createState() => _ButtonNewUserState(emailController,  passwordController);
}

class _ButtonNewUserState extends State<ButtonNewUser> {
  _ButtonNewUserState(TextEditingController emailController, TextEditingController passwordController){
    this.emailController = emailController;
    this.passwordController = passwordController;
  }

  TextEditingController emailController;
  TextEditingController passwordController;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 40, right: 50, left: 200),
      child: Container(
        alignment: Alignment.bottomRight,
        height: 50,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.blue[300],
              blurRadius: 10.0, // has the effect of softening the shadow
              spreadRadius: 1.0, // has the effect of extending the shadow
              offset: Offset(
                5.0, // horizontal, move right 10
                5.0, // vertical, move down 10
              ),
            ),
          ],
            color: Colors.white, borderRadius: BorderRadius.circular(30)),
        child: FlatButton(
          onPressed: (){
            print('the email is ${this.emailController.text}');
            context.read<AuthenticationService>().signUp(
                email: this.emailController.text.trim(),
                password: this.passwordController.text.trim()
            );
            Navigator.pop(context);
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'OK',
                style: TextStyle(
                  color: Colors.lightBlueAccent,
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Icon(
                Icons.arrow_forward,
                color: Colors.lightBlueAccent,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
