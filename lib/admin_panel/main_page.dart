import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:main_project/Providers/authentication.dart';
import 'package:main_project/admin_panel/auth_page.dart';
import 'package:main_project/pages/auth/auth_page.dart';
import 'package:main_project/pages/auth/login_or_register.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

class AdminMainPage extends StatelessWidget {
  AdminMainPage({super.key});

  // intsance of auth page
  // final AdminAuthPage _authPage = AdminAuthPage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Theme.of(context).colorScheme.primary,
        backgroundColor: Colors.transparent,
        title: Text("Welcome Admin"),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              Provider.of<Authentication>(context, listen: false)
                  .signOut()
                  .whenComplete(
                () {
                  Navigator.pushAndRemoveUntil(
                      context,
                      PageTransition(
                        child: AuthPage(),
                        type: PageTransitionType.bottomToTop,
                        duration: Durations.long1,
                      ),
                      (context) => false);
                },
              );
            },
            icon: Icon(Icons.logout),
          ),
        ],
      ),
    );
  }
}
