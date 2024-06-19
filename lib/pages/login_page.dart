import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:main_project/components/google_button.dart';
import 'package:main_project/components/my_button.dart';
import 'package:main_project/components/my_text_field.dart';
import 'package:main_project/pages/forgot_pw_page.dart';
import 'package:main_project/services/google_sign_in.dart';

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
  void signUserIn(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );
    } catch (e) {
      showDialog(
        context: context,
        builder: (context) => const AlertDialog(
          content: Text(
            'Invalid',
            textAlign: TextAlign.center,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade100,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        centerTitle: true,
        title: const Text(
          "SnapTalks",
          style: TextStyle(
            color: Colors.blue,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // icon
              // Image.asset(''),
              const SizedBox(height: 30),
              // Welcome text
              const Text(
                'Welcome back you have been missed!',
                style: TextStyle(
                  color: Colors.blue,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 150),

              // email text field
              MyTextField(
                controller: emailController,
                hintText: 'Email',
                obscuretext: false,
              ),
              const SizedBox(height: 20),

              // password Text field
              MyTextField(
                controller: passwordController,
                hintText: 'Password',
                obscuretext: true,
              ),
              const SizedBox(height: 20),

              // forgot password
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ForgotPasswordPage(),
                          ),
                        );
                      },
                      child: const Text(
                        'Forgot Password?',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.red),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),

              // sign in button
              MyButton(
                text: "Sign In",
                onTap: () => signUserIn(context),
              ),

              const SizedBox(height: 20),
              // or continue with
              Text(
                'Or Continue With',
                style: TextStyle(
                  color: Colors.grey.shade700,
                ),
              ),

              const SizedBox(height: 20),
              // google Sign In
              GButton(
                onTap: () => AuthService().signInWithGoogle(),
              ),
              const SizedBox(height: 50),

              // Not a member
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Not a Member?'),

                  const SizedBox(width: 10),

                  // Register now
                  GestureDetector(
                    onTap: onTap,
                    child: const Text(
                      'Register Now',
                      style: TextStyle(
                        color: Colors.blue,
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
