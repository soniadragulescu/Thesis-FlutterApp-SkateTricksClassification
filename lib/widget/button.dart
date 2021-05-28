import 'package:first_flutter_app/Setup/constants.dart';
import 'package:first_flutter_app/core/showAlertDialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:first_flutter_app/authentication_services.dart';

class ButtonLogin extends StatefulWidget {
  ButtonLogin(TextEditingController emailController, TextEditingController passwordController) {
    this.emailController = emailController;
    this.passwordController = passwordController;
}
  TextEditingController emailController;
  TextEditingController passwordController;

  @override
  _ButtonLoginState createState() => _ButtonLoginState(emailController,  passwordController);
}

class _ButtonLoginState extends State<ButtonLogin> {
  _ButtonLoginState(TextEditingController emailController, TextEditingController passwordController){
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
              color: Colors.blueGrey[200],
              blurRadius: 10.0, // has the effect of softening the shadow
              spreadRadius: 1.0, // has the effect of extending the shadow
              offset: Offset(
                5.0, // horizontal, move right 10
                5.0, // vertical, move down 10
              ),
            ),
          ],
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
        ),
        child: TextButton(
          onPressed: () async {
            print('the email is ${this.emailController.text}');
            var response = await context.read<AuthenticationService>().signIn(
                email: this.emailController.text.trim(),
                password: this.passwordController.text.trim()
            );

            if(response != 'Signed in!'){
              showAlertDialog(context, response);
            }else{
              await context.read<AuthenticationService>().subscribeTopic(TOPIC);
            }

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
