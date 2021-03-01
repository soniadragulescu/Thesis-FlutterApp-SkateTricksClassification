import 'package:flutter/material.dart';

class NewEmail extends StatefulWidget {
  NewEmail(TextEditingController controller){
    this.emailController = controller;
  }

  TextEditingController emailController;

  @override
  _NewEmailState createState() => _NewEmailState(emailController);
}

class _NewEmailState extends State<NewEmail> {
  _NewEmailState(TextEditingController controller){
    this.emailController = controller;
  }

  TextEditingController emailController;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20, left: 50, right: 50),
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
            labelText: 'E-mail',
            labelStyle: TextStyle(
              color: Colors.white70,
            ),
          ),
        ),
      ),
    );
  }
}