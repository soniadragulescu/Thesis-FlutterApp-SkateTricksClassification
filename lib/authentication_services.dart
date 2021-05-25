import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthenticationService {
  final FirebaseAuth _firebaseAuth;
  AuthenticationService(this._firebaseAuth);

  Stream<User> get authStateChanges => _firebaseAuth.authStateChanges();

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  Future<String> signIn({String email, String password}) async{
    try{
      var msg = await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
      print('signed in!!!!!!!!!!!!!!!!');
      print(msg);
      return 'Signed in!';
    }on FirebaseAuthException catch(e){
      print(e.code);
      return e.message;
    }
  }

  Future<String> signUp({String email, String password}) async{
    try{
      UserCredential result = await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
      print(result.user);
      print('signed up with email $email and the password $password');
      return 'Signed up!';
    }on FirebaseAuthException catch(e){
      return e.message;
    }
  }
}