import 'package:flutter/material.dart';
import 'package:main_project/pages/auth/auth_page.dart';
import 'package:main_project/services/auth_service.dart';
import 'package:page_transition/page_transition.dart';

class AdminMainPage extends StatelessWidget {
  AdminMainPage({super.key});

  // intsance of auth page
  // final AdminAuthPage _authPage = AdminAuthPage();

  final _auth = AuthService();

  void logOut(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Theme.of(context).colorScheme.background,
        content: Text(
          'Do you want to logout of your account?',
          style: TextStyle(
              fontSize: 24, color: Theme.of(context).colorScheme.primary),
        ),
        actions: [
          MaterialButton(
            child: Text(
              'Cancel',
              style: TextStyle(color: Theme.of(context).colorScheme.primary),
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          MaterialButton(
            child: Text(
              'Logout',
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
            onPressed: () {
              _auth.logout().whenComplete(
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
          ),
        ],
      ),
    );
  }

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
              logOut(context);
            },
            icon: Icon(Icons.logout),
          ),
        ],
      ),
    );
  }
}
