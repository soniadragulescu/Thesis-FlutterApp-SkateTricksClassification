/*
import 'package:first_flutter_app/Pages/home.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String _email, _password;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign in'),
        ),
      body: Form(
        key: _formKey,
        //TODO implement key
        child: Column(
          children: <Widget>[
            //TODO: Implement fields
            TextFormField(
              // ignore: missing_return
              validator: (input){
                if(input.isEmpty){
                  return'Please enter the email!';
                }
              },
              onSaved: (input) => _email = input,
              decoration: InputDecoration(
                labelText: 'Email'
              ),
            ),
            TextFormField(
              // ignore: missing_return
                validator: (input){
                  if(input.length < 6){
                    return'Your password needs to be at least 6 characters!';
                  }
                },
                onSaved: (input) => _password = input,
                decoration: InputDecoration(
                    labelText: 'Password'
                ),
              obscureText: true,
            ),
            RaisedButton(
              onPressed: signIn,
              child: Text('Sign in')
            )
          ],
        )
      )
    );
  }

  Future<void> signIn() async{
    //validate fields
    final formState = _formKey.currentState;
    await Firebase.initializeApp();
    if(formState.validate()){
      formState.save();
      try{
        //login to firebase
        UserCredential credentials = await FirebaseAuth.instance.signInWithEmailAndPassword(email: _email, password: _password);
        //navigate to home
        Navigator.push(context, MaterialPageRoute(builder: (context) => Home(credentials: credentials)));
      }catch(e){
        print(e.toString());
      }
    }
  }
}*/
