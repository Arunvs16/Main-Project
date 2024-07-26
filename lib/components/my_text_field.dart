import 'package:flutter/material.dart';
import 'package:main_project/Providers/theme_provider.dart';
import 'package:provider/provider.dart';

class MyTextField extends StatelessWidget {
  final controller;
  final String hintText;
  final bool obscureText;
  const MyTextField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.obscureText,
  });

  @override
  Widget build(BuildContext context) {
    bool isDarkMode =
        Provider.of<ThemeProvider>(context, listen: false).isDarkMode;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: isDarkMode
                  ? Theme.of(context).colorScheme.tertiary
                  : Theme.of(context).colorScheme.inversePrimary,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: isDarkMode
                  ? Theme.of(context).colorScheme.inversePrimary
                  : Theme.of(context).colorScheme.tertiary,
            ),
          ),
          fillColor: Theme.of(context).colorScheme.secondary,
          filled: true,
          hintText: hintText,
          hintStyle: TextStyle(
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
      ),
    );
  }
}
