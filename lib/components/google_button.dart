import 'package:flutter/material.dart';
import 'package:main_project/Providers/theme_provider.dart';
import 'package:provider/provider.dart';

class GButton extends StatelessWidget {
  final Function()? onTap;
  const GButton({
    super.key,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // light vs dark mode for correct text color
    bool isDarkMode =
        Provider.of<ThemeProvider>(context, listen: false).isDarkMode;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.only(top: 15, bottom: 15),
        margin: const EdgeInsets.symmetric(horizontal: 25),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.network(
              'https://cdn1.iconfinder.com/data/icons/google-s-logo/150/Google_Icons-09-512.png',
              scale: 20,
            ),
            Text(
              "Google",
              style: TextStyle(
                color: Theme.of(context).colorScheme.inversePrimary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
