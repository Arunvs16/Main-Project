import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:main_project/components/my_text_field.dart';

class ForgotPasswordPage extends StatelessWidget {
  ForgotPasswordPage({Key? key}) : super(key: key);

  final emailController = TextEditingController();

  // reset password method
  void passwordReset(BuildContext context) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(
        email: emailController.text.trim(),
      );
      // pop
      if (context.mounted) Navigator.pop(context);

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(
            'Password reset link sent to ${emailController.text}',
          ),
        ),
      );
    } on FirebaseAuthException catch (e) {
      print(e);
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(
            'Error occurred!',
            textAlign: TextAlign.center,
          ),
          content: Text(
            e.message ?? 'Unknown error',
            textAlign: TextAlign.center,
          ),
        ),
      );
    }
    emailController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        foregroundColor: Theme.of(context).colorScheme.primary,
        backgroundColor: Colors.transparent,
        centerTitle: true,
        title: Text(
          "Forgot Password",
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // hint text
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: Text(
                "Enter your email and we will send you a password reset link",
                style: TextStyle(
                  fontSize: 15,
                  color: Theme.of(context).colorScheme.primary,
                ),
                textAlign: TextAlign.center,
              ),
            ),

            // email textfield
            SizedBox(height: 30),
            MyTextField(
              controller: emailController,
              hintText: 'Email',
              obscuretext: false,
            ),
            SizedBox(height: 10),

            // send button
            MaterialButton(
              onPressed: () => passwordReset(context), // Pass context here
              color: Theme.of(context).colorScheme.primary,
              child: Text(
                'Reset Password',
                style: TextStyle(
                    color: Theme.of(context).colorScheme.inversePrimary),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
