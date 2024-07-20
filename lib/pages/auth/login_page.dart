import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:main_project/Providers/authentication.dart';
import 'package:main_project/components/google_button.dart';
import 'package:main_project/components/helper_function.dart';
import 'package:main_project/components/my_button.dart';
import 'package:main_project/components/my_text_field.dart';
import 'package:main_project/pages/auth/forgot_pw_page.dart';
import 'package:main_project/services/google_sign_in.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatelessWidget {
  final Function()? onTap;
  LoginPage({
    super.key,
    required this.onTap,
  });

  // text controllers
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  // sign user in method
  void signInUser(BuildContext context) async {
    showDialog(
      context: context,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );

    try {
      await Provider.of<Authentication>(context, listen: false)
          .logIntoAccount(emailController.text, passwordController.text);

      // pop loading circle
      Navigator.pop(context);
    } on FirebaseAuthException catch (error) {
      // pop loading circle
      Navigator.pop(context);

      // show error message to user
      displayMessageToUser(error.code, context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 20),
              // icon
              Icon(
                Icons.person,
                size: 60,
                color: Theme.of(context).colorScheme.primary,
              ),
              // Image.asset(''),
              const SizedBox(height: 10),
              // app name
              const Text(
                'Myapp',
                style: TextStyle(fontSize: 20),
              ),
              const SizedBox(height: 10),
              // Welcome text
              Text(
                'Welcome back you have been missed!',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 50),

              // email text field
              MyTextField(
                controller: emailController,
                hintText: 'Email',
                obscuretext: false,
              ),
              const SizedBox(height: 10),

              // password Text field
              MyTextField(
                controller: passwordController,
                hintText: 'Password',
                obscuretext: true,
              ),
              const SizedBox(height: 20),

              // forgot password
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            // ignore: prefer_const_constructors
                            builder: (context) => ForgotPasswordPage(),
                          ),
                        );
                      },
                      child: Text(
                        'Forgot Password?',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.error,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),

              // login button
              MyButton(
                text: "Login",
                onTap: () => signInUser(context),
              ),

              const SizedBox(height: 20),
              // or continue with
              Text(
                'Or Continue With',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),

              const SizedBox(
                height: 20,
              ),
              // google Sign In
              GButton(
                onTap: () => GService().signInWithGoogle(),
              ),
              const SizedBox(height: 50),

              // Not a member
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Not a Member?',
                    style:
                        TextStyle(color: Theme.of(context).colorScheme.primary),
                  ),

                  const SizedBox(width: 10),

                  // Register now
                  GestureDetector(
                    onTap: onTap,
                    child: Text(
                      'Register Now',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
