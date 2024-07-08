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
