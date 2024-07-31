import 'package:flutter/material.dart';
import 'package:main_project/Providers/theme_provider.dart';
import 'package:main_project/admin/auth_page.dart';
import 'package:main_project/admin/main_page.dart';
import 'package:main_project/components/helper_function.dart';
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

  // text controllers
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  // admin auth instance
  final AdminAuthPage _adminAuthPage = AdminAuthPage();

  // sign user in method
  Future<void> signInUser(BuildContext context) async {
    String email = 'avs4164@gmail.com';
    String password = '12345678';

    showDialog(
      context: context,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );

    if (emailController.text == email && passwordController.text == password) {
      await _adminAuthPage.adminSignIn(
        emailController.text,
        passwordController.text,
      );
      // pop the circle-572
      if (context.mounted) Navigator.pop(context);
    }
    // if not same
    else if (emailController.text != email &&
        passwordController.text != password) {
      // pop the circle
      Navigator.pop(context);

      // go back to login page
      Navigator.pop(context);

      // show error message to user
      displayMessageToUser('Something went wrong', context);
    } else if (emailController.text.isEmpty &&
        passwordController.text.isEmpty) {
      displayMessageToUser('Fill all the fields', context);
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
                  signInUser(context).whenComplete(
                    () {
                      Navigator.pushAndRemoveUntil(
                        context,
                        PageTransition(
                          child: AdminMainPage(),
                          type: PageTransitionType.bottomToTop,
                        ),
                        (context) => false,
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
