import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:main_project/admin_panel/auth/login_page.dart';
import 'package:main_project/components/google_button.dart';
import 'package:main_project/components/helper_function.dart';
import 'package:main_project/components/my_button.dart';
import 'package:main_project/components/my_text_field.dart';
import 'package:main_project/services/auth_service.dart';
import 'package:main_project/services/firestore.dart';
import 'package:page_transition/page_transition.dart';

class RegisterPage extends StatelessWidget {
  final Function()? onTap;
  RegisterPage({
    super.key,
    required this.onTap,
  });

  // access auth & firestore
  final _auth = AuthService();

  final _firestore = Firestore();

  // text controllers
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  // sign up user method
  void signUp(BuildContext context) async {
    showLoadingCircle(context);

    if (nameController.text.isEmpty ||
        emailController.text.isEmpty ||
        passwordController.text.isEmpty ||
        confirmPasswordController.text.isEmpty) {
      close(context);
      displayMessageToUser('Fill all the fields', context);
      return; // Ensuring early exit on error
    }

    if (passwordController.text != confirmPasswordController.text) {
      close(context);
      displayMessageToUser("Passwords don't match", context);
      return; // Ensuring early exit on error
    }

    try {
      UserCredential userCredential = await _auth.registerEmailPassword(
        emailController.text,
        passwordController.text,
      );

      String uid = userCredential.user!.uid;

      await _firestore.saveUserInfoInFirestore(
          email: emailController.text, name: nameController.text);

      close(context);
    } on FirebaseAuthException catch (error) {
      close(context);
      displayMessageToUser(
          error.message ?? "An unknown error occurred", context);
    } catch (e) {
      close(context);
      displayMessageToUser('Something went wrong: $e', context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              // icon
              Icon(
                Icons.person,
                size: 60,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(height: 10),
              // Welcome text
              Text(
                "Let's create an account for you!",
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 30),
              // user name text field
              MyTextField(
                controller: nameController,
                hintText: 'Name',
                obscureText: false,
              ),
              const SizedBox(height: 20),

              // email text field
              MyTextField(
                controller: emailController,
                hintText: 'Email',
                obscureText: false,
              ),
              const SizedBox(height: 20),

              // password Text field
              MyTextField(
                controller: passwordController,
                hintText: 'Password',
                obscureText: true,
              ),
              const SizedBox(height: 20),
              // confirm password Text field
              MyTextField(
                controller: confirmPasswordController,
                hintText: 'Confirm Password',
                obscureText: true,
              ),
              const SizedBox(height: 30),

              // sign up button
              MyButton(
                text: "Sign Up",
                onTap: () => signUp(context),
              ),
              const SizedBox(height: 20),
              // or continue with
              Text(
                'Or Continue With',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              const SizedBox(height: 20),
              // google Sign In
              GButton(
                onTap: () => _auth.signInWithGoogle(),
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
                    onTap: onTap,
                    child: Text(
                      'Login Now',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              Divider(
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(height: 30),

              // Login as Admin
              MaterialButton(
                color: Theme.of(context).colorScheme.primary,
                child: Text(
                  'Login as Admin',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.inversePrimary,
                  ),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    PageTransition(
                      child: AdminLoginPage(onTap: onTap),
                      type: PageTransitionType.rightToLeft,
                    ),
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
