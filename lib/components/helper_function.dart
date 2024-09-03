import 'package:flutter/material.dart';

void displayMessageToUser(String message, BuildContext context) {
  // display error message to user
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      backgroundColor: Theme.of(context).colorScheme.surface,
      title: Text(
        message,
        textAlign: TextAlign.center,
      ),
    ),
  );
}

// show loading circle
void showLoadingCircle(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      backgroundColor: Colors.transparent,
      content: Center(
        child: CircularProgressIndicator(
          color: Theme.of(context).colorScheme.onPrimary,
        ),
      ),
    ),
  );
}

// hide loading circle
void close(BuildContext context) {
  Navigator.pop(context);
}
