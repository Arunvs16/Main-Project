import 'package:flutter/material.dart';

class TermsOfServices extends StatelessWidget {
  const TermsOfServices({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Theme.of(context).colorScheme.primary,
        backgroundColor: Colors.transparent,
        title: Text("Terms of Services"),
      ),
      backgroundColor: Theme.of(context).colorScheme.background,
    );
  }
}
