import 'package:flutter/material.dart';
import 'package:main_project/components/my_text_field.dart';

class SearchPage extends StatelessWidget {
  SearchPage({super.key});
  // text controller
  final controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Theme.of(context).colorScheme.primary,
        backgroundColor: Colors.transparent,
        title: Text("Search Profile"),
      ),
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Column(
        children: [
          const SizedBox(
            height: 50,
          ),
          MyTextField(
            controller: controller,
            hintText: "Search",
            obscureText: false,
          ),
        ],
      ),
    );
  }
}
