import 'package:flutter/material.dart';
import 'package:main_project/Providers/theme_provider.dart';
import 'package:provider/provider.dart';

class MyTextBox extends StatelessWidget {
  final void Function()? onTap;
  final String bioHeader;
  final String bio;
  final void Function()? onPressed;
  const MyTextBox({
    super.key,
    required this.bioHeader,
    required this.bio,
    required this.onPressed,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    bool isDarkMode =
        Provider.of<ThemeProvider>(context, listen: false).isDarkMode;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Theme.of(context).colorScheme.secondary,
        ),
        margin: EdgeInsets.only(left: 20, top: 20, right: 20),
        padding: EdgeInsets.only(left: 20, bottom: 20, top: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // bio header
                Text(
                  bioHeader,
                  style: TextStyle(
                      color: isDarkMode
                          ? Theme.of(context).colorScheme.inversePrimary
                          : Theme.of(context).colorScheme.primary),
                ),

                // edit icon
                IconButton(
                    onPressed: onPressed,
                    icon: Icon(
                      Icons.edit,
                      color: isDarkMode
                          ? Theme.of(context).colorScheme.inversePrimary
                          : Theme.of(context).colorScheme.primary,
                    ))
              ],
            ),
            // bio
            Text(
              bio,
              style: TextStyle(
                  color: isDarkMode
                      ? Theme.of(context).colorScheme.inversePrimary
                      : Theme.of(context).colorScheme.primary),
            ),
          ],
        ),
      ),
    );
  }
}
