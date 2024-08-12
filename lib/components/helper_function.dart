import 'package:flutter/material.dart';

void displayMessageToUser(String message, BuildContext context) {
  // display error message to user
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
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
        child: CircularProgressIndicator(),
      ),
    ),
  );
}

// hide loading circle
void hideLoadingCircle(BuildContext context) {
  Navigator.pop(context);
}
