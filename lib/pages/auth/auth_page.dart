import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:main_project/pages/main_page.dart';
import 'package:main_project/pages/auth/login_or_register.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          // user is logged in
          if (snapshot.hasData) {
            return MainPage();
          } else {
            return const LoginOrRegister();
          }
        },
      ),
    );
  }
}
class AuthService{
  
}
