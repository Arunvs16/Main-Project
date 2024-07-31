import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Authentication with ChangeNotifier {
  // firebase authentication
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  // google sign in
  final GoogleSignIn googleSignIn = GoogleSignIn();

  // firebase sign in
  String? userUID;
  String? get getUserUID => userUID;
  Future logIntoAccount(String email, String password) async {
    UserCredential userCredential = await firebaseAuth
        .signInWithEmailAndPassword(email: email, password: password);
    User? user = userCredential.user!;
    userUID = user.uid;
    print('user unique => $userUID');
    notifyListeners();
  }

  // firebase sign up
  Future createAccount(String email, String password) async {
    UserCredential userCredential = await firebaseAuth
        .createUserWithEmailAndPassword(email: email, password: password);
    User? user = userCredential.user!;
    userUID = user.uid;
    print(userUID);
    notifyListeners();
  }

  //Firebase Sign Out
  Future signOut() async {
    return firebaseAuth.signOut();
  }

  // Google Sign in
  Future signInWithGoogle() async {
    //begin interactivesign in process
    final GoogleSignInAccount? googleSignInAccount =
        await GoogleSignIn().signIn();

    //obtain auth details from request
    final GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount!.authentication;

    //create a new credntial for user
    final AuthCredential authCredential = GoogleAuthProvider.credential(
      accessToken: googleSignInAuthentication.accessToken,
      idToken: googleSignInAuthentication.idToken,
    );
    final UserCredential userCredential =
        await firebaseAuth.signInWithCredential(authCredential);
    final User? user = userCredential.user;
    assert(user!.uid != null);

    userUID = user!.uid;
    print("Google user uid => $userUID");
    notifyListeners();
  }

  // Google sign out
  Future signOutWithGoogle() async {
    return googleSignIn.signOut();
  }
}
