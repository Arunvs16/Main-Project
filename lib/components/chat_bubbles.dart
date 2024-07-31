import 'package:flutter/material.dart';
import 'package:main_project/Providers/theme_provider.dart';
import 'package:provider/provider.dart';

class ChatBubbles extends StatelessWidget {
  final String message;
  final bool isCurrentUser;
  const ChatBubbles({
    super.key,
    required this.message,
    required this.isCurrentUser,
  });

  @override
  Widget build(BuildContext context) {
    bool isDarkMode =
        Provider.of<ThemeProvider>(context, listen: false).isDarkMode;
    return Container(
      decoration: BoxDecoration(
        color: isCurrentUser
            ? Theme.of(context).colorScheme.surface
            : isDarkMode
                ? Theme.of(context).colorScheme.secondary
                : Theme.of(context).colorScheme.tertiary,
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.symmetric(vertical: 2.5, horizontal: 25),
      child: Text(
        message,
        style: const TextStyle(color: Colors.white),
      ),
    );
  }
}
