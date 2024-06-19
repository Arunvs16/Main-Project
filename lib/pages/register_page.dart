import 'package:flutter/material.dart';
import 'package:main_project/components/google_button.dart';
import 'package:main_project/components/my_button.dart';
import 'package:main_project/components/my_text_field.dart';
import 'package:main_project/services/google_sign_in.dart';

class RegisterPage extends StatefulWidget {
  final Function()? onTap;
  RegisterPage({
    super.key,
    required this.onTap,
  });

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  // text controllers
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  // sign up user method
  void signUp() {
    final auth = AuthService();
    //password match -> create user
    if (passwordController.text == confirmPasswordController.text) {
      try {
        auth.signUp(emailController.text, passwordController.text);
      } catch (error) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            content: Text(
              error.toString(),
            ),
          ),
        );
      }
    }
    //password dont match -> tell user to fix
    else {
      showDialog(
        context: context,
        builder: (context) => const AlertDialog(
          content: Text(
            "Password doesn't match",
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
                "Let's make a account for you!",
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
              // confirm password Text field
              MyTextField(
                controller: confirmPasswordController,
                hintText: 'Confirm Password',
                obscuretext: true,
              ),
              const SizedBox(height: 40),

              // sign up button
              MyButton(
                text: "Sign Up",
                onTap: signUp,
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
              const SizedBox(height: 20),

              // Already a member
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Already a Member?'),

                  const SizedBox(width: 10),

                  // Register now
                  GestureDetector(
                    onTap: widget.onTap,
                    child: const Text(
                      'Login Now',
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
