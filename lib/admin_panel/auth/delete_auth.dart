import 'package:flutter/material.dart';
import 'package:main_project/components/helper_function.dart';
import 'package:main_project/components/my_text_field.dart';
import 'package:main_project/services/auth_service.dart';

class DeleteAuth extends StatelessWidget {
  final String userId;
  final String username;
  DeleteAuth({
    super.key,
    required this.userId,
    required this.username,
  });

  // controllers
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  void deleteUser(BuildContext context) async {
    await AuthService().deleteUser(userId);
    if (emailController.text.isNotEmpty && passwordController.text.isNotEmpty) {
      await AuthService()
          .deleteUserAuth(emailController.text, passwordController.text)
          .whenComplete(() {
        //pop
        close(context);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        foregroundColor: Theme.of(context).colorScheme.primary,
        backgroundColor: Colors.transparent,
        centerTitle: true,
        title: Text('Delete user'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // hint text
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Text(
                "Do you want to delete this account? ",
                style: TextStyle(
                  fontSize: 15,
                  color: Theme.of(context).colorScheme.primary,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Text(
                "Enter your email and password we will deactivate your account",
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
              obscureText: false,
            ),
            SizedBox(height: 10),
            MyTextField(
              controller: passwordController,
              hintText: 'Password',
              obscureText: false,
            ),
            SizedBox(height: 10),

            // send button
            MaterialButton(
              onPressed: () {
                deleteUser(context);
              },
              color: Theme.of(context).colorScheme.primary,
              child: Text(
                'Delete',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.inversePrimary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
