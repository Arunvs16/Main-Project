import 'package:flutter/material.dart';
import 'package:main_project/admin/auth_page.dart';
import 'package:main_project/pages/auth/login_or_register.dart';
import 'package:page_transition/page_transition.dart';

class AdminMainPage extends StatelessWidget {
  AdminMainPage({super.key});

  // intsance of auth page
  final AdminAuthPage _authPage = AdminAuthPage();

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
              _authPage.signOut();
              Navigator.pushReplacement(
                context,
                PageTransition(
                  child: LoginOrRegister(),
                  type: PageTransitionType.topToBottom,
                ),
                // (context) => false,
              );
            },
            icon: Icon(Icons.logout),
          ),
        ],
      ),
    );
  }
}
