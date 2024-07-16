import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:main_project/model/user_model.dart';
import 'package:main_project/pages/main_page.dart';

class AuthMethods {
  FirebaseAuth _auth = FirebaseAuth.instance;
  CollectionReference users = FirebaseFirestore.instance.collection('users');
  getUserDetails() async {
    User currentUser = _auth.currentUser!;
    DocumentSnapshot documentSnapshot = await users.doc(currentUser.uid).get();
    return UserModel.fromJson(documentSnapshot);
  }

  signUp({
    required String name,
    required String username,
    required String email,
    required String password,
  }) async {
    String res = 'Error';
    try {
      if (email.isNotEmpty ||
          name.isNotEmpty ||
          username.isNotEmpty ||
          password.isNotEmpty) {
        UserCredential userCredential = await _auth
            .createUserWithEmailAndPassword(email: email, password: password);
        UserModel userModel = UserModel(
          uid: userCredential.user!.uid,
          name: name,
          username: username,
          bio: '',
          pic: '',
          followers: [],
          following: [],
          email: email,
        );
        users.doc(userCredential.user!.uid).set(
              userModel.tojson(),
            );

        return res = 'Success';
      } else {
        return res = 'Enter all fields';
      }
    } on Exception catch (e) {
      return res + e.toString();
    }
  }

  signIn(
      {required String email,
      required String password,
      required BuildContext context}) async {
    String res = 'Error';
    try {
      if (email.isNotEmpty || password.isNotEmpty) {
        await _auth.signInWithEmailAndPassword(
            email: email, password: password);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Login Success'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => MainPage(),
            ),
            (route) => false);
        return res = 'Success';
      } else {
        return res = 'Enter all fields';
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Login Failed'),
          backgroundColor: Theme.of(context).colorScheme.error));
      return res = e.toString();
    }
  }

  signOut() async {
    try {
      await _auth.signOut();
      return 'Logout';
    } on Exception catch (e) {
      print(e.toString());
    }
  }
}
