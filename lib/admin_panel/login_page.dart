import 'package:flutter/material.dart';
import 'package:main_project/Providers/theme_provider.dart';
import 'package:main_project/admin_panel/auth_page.dart';
import 'package:main_project/admin_panel/main_page.dart';
import 'package:main_project/components/my_button.dart';
import 'package:main_project/components/my_text_field.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

class AdminLoginPage extends StatelessWidget {
  final Function()? onTap;
  AdminLoginPage({
    super.key,
    required this.onTap,
  });

  // admin auth
  final AdminAuthPage adminAuth = AdminAuthPage();

  // text controllers
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  // sign user in method
  Future<void> signInUser(BuildContext context) async {
    showDialog(
      context: context,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );

    try {
      await adminAuth.adminSignIn(
          emailController.text, passwordController.text);

      Navigator.pushAndRemoveUntil(
        context,
        PageTransition(
            child: AdminMainPage(), type: PageTransitionType.rightToLeft),
        (route) => false,
      );
    } catch (e) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            e.toString(),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isDarkMode =
        Provider.of<ThemeProvider>(context, listen: false).isDarkMode;
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Theme.of(context).colorScheme.primary,
        backgroundColor: Colors.transparent,
        title: Text("Admin"),
        centerTitle: true,
      ),
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              const SizedBox(height: 20),
              // icon
              Icon(
                Icons.person_pin_circle_sharp,
                size: 100,
                color: isDarkMode
                    ? Theme.of(context).colorScheme.error
                    : Theme.of(context).colorScheme.inversePrimary,
              ),

              const SizedBox(height: 30),

              // email text field
              MyTextField(
                controller: emailController,
                hintText: 'Email',
                obscureText: false,
              ),
              const SizedBox(height: 10),

              // password Text field
              MyTextField(
                controller: passwordController,
                hintText: 'Password',
                obscureText: true,
              ),
              const SizedBox(height: 20),

              // login button
              MyButton(
                text: "Login",
                onTap: () {
                  signInUser(context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}