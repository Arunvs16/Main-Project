import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:main_project/components/helper_function.dart';

class AdminAuthPage {
  // firebase instance
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<UserCredential> adminSignIn(BuildContext context, String email,
      String password, adminEmail, adminPassword) async {
    if (email != adminEmail) {
      // pop
      close(context);
      // error mesage
      displayMessageToUser('Enter the correct Email', context);
    }

    try {
      if (email == adminEmail && password == adminPassword) {
        UserCredential credential = await _auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Theme.of(context).colorScheme.onPrimary,
            content: Text(
              'Login Successfull',
              style: TextStyle(
                color: Theme.of(context).colorScheme.inversePrimary,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        );
        return credential;
      } else {
        throw FirebaseAuthException(code: 'Invalid', message: 'Invalid');
      }
    } on FirebaseAuthException catch (e) {
      throw Exception('Error: ${e.message}');
    }
  }
}
