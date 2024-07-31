import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:main_project/components/google_button.dart';
import 'package:main_project/components/helper_function.dart';
import 'package:main_project/components/my_button.dart';
import 'package:main_project/components/my_text_field.dart';
import 'package:main_project/services/google_sign_in.dart';

class RegisterPage extends StatelessWidget {
  final Function()? onTap;
  RegisterPage({
    super.key,
    required this.onTap,
  });

  // text controllers
  final userNameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  // sign up user method
  void signUp(BuildContext context) async {
    // show loading circle
    showDialog(
      context: context,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );

    //password don't match -> tell user to fix
    if (passwordController.text != confirmPasswordController.text) {
      // pop loading circle
      Navigator.pop(context);

      // show error message to user
      displayMessageToUser("Passwords don't match", context);
    } else {
      //password match -> create user
      try {
        UserCredential userCredential =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailController.text,
          password: passwordController.text,
        );

        // Get user UID
        String uid = userCredential.user!.uid;

        // after creating the user, create a new document in the cloud firestore called users
        await FirebaseFirestore.instance.collection("Users").doc(uid).set({
          'username': userNameController.text,
          'uid': uid,
          'email': emailController.text,
          'profilePicUrl': '',
          'bio': "Add bio",
        });

        // pop loading circle
        Navigator.pop(context);
      } on FirebaseAuthException catch (error) {
        // pop loading circle
        Navigator.pop(context);

        // display error message
        displayMessageToUser(
            error.message ?? "An unknown error occurred", context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
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
                controller: userNameController,
                hintText: 'Username',
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
                onTap: () => GService().signInWithGoogle(),
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
            ],
          ),
        ),
      ),
    );
  }
}
