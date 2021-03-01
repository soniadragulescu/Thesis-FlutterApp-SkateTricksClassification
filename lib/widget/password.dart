import 'package:flutter/material.dart';

class PasswordInput extends StatefulWidget {
  PasswordInput(TextEditingController controller){
    this.passwordController = controller;
  }
  TextEditingController passwordController;

  @override
  _PasswordInputState createState() => _PasswordInputState(passwordController);
}

class _PasswordInputState extends State<PasswordInput> {
  _PasswordInputState(TextEditingController controller){
    this.passwordController = controller;
  }

  TextEditingController passwordController;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20, left: 50, right: 50),
      child: Container(
        height: 60,
        width: MediaQuery.of(context).size.width,
        child: TextField(
          controller: this.passwordController,
          style: TextStyle(
            color: Colors.white,
          ),
          obscureText: true,
          decoration: InputDecoration(
            border: InputBorder.none,
            labelText: 'Password',
            labelStyle: TextStyle(
              color: Colors.white70,
            ),
          ),
        ),
      ),
    );
  }
}