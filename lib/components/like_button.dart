import 'package:flutter/material.dart';
import 'package:main_project/Providers/theme_provider.dart';
import 'package:provider/provider.dart';

class LikeButton extends StatelessWidget {
  final bool isLiked;
  final void Function()? onTap;
  const LikeButton({
    super.key,
    required this.isLiked,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    bool isDarkMode =
        Provider.of<ThemeProvider>(context, listen: false).isDarkMode;
    return GestureDetector(
      onTap: onTap,
      child: Icon(
        isLiked ? Icons.favorite : Icons.favorite_border,
        color: isLiked
            ? Theme.of(context).colorScheme.error
            : isDarkMode
                ? Theme.of(context).colorScheme.inversePrimary
                : Theme.of(context).colorScheme.primary,
      ),
    );
  }
}
