import 'package:flutter/material.dart';
import 'package:main_project/Providers/theme_provider.dart';
import 'package:main_project/components/my_list_tile.dart';
import 'package:provider/provider.dart';

class UserTile extends StatelessWidget {
  final String username;
  final String text;
  final void Function()? onTap;
  const UserTile({
    super.key,
    required this.username,
    required this.text,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    bool isDarkMode =
        Provider.of<ThemeProvider>(context, listen: false).isDarkMode;
    return MyListTile(
      onTap: onTap,
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(100),
        child: Image(
          fit: BoxFit.cover,
          image: AssetImage('images/person.jpg'),
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return Center(
              child: CircularProgressIndicator(),
            );
          },
          errorBuilder: (context, object, stack) {
            return Container(
              child: Icon(Icons.error_outline),
            );
          },
        ),
      ),
      titleText: username,
      subTitleText: text,
      horizontal: 0,
      vertical: 5,
      color1: isDarkMode
          ? Theme.of(context).colorScheme.inversePrimary
          : Theme.of(context).colorScheme.primary,
      color2: Theme.of(context).colorScheme.surface,
    );
  }
}
