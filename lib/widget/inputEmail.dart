import 'package:flutter/material.dart';

class InputEmail extends StatefulWidget {
  InputEmail(TextEditingController controller){
    this.emailController = controller;
  }
  TextEditingController emailController;

  @override
  _InputEmailState createState() => _InputEmailState(emailController);
}

class _InputEmailState extends State<InputEmail> {
  _InputEmailState(TextEditingController controller){
    this.emailController = controller;
  }
  TextEditingController emailController;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 50, left: 50, right: 50),
      child: Container(
        height: 60,
        width: MediaQuery.of(context).size.width,
        child: TextField(
          controller: this.emailController,
          style: TextStyle(
            color: Colors.white,
          ),
          decoration: InputDecoration(
            border: InputBorder.none,
            fillColor: Colors.lightBlueAccent,
            labelText: 'Email',
            labelStyle: TextStyle(
              color: Colors.white70,
            ),
          ),
        ),
      ),
    );
  }
}