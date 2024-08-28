import 'package:flutter/material.dart';
import 'package:main_project/Providers/firestore_provider.dart';
import 'package:main_project/Providers/theme_provider.dart';
import 'package:main_project/components/my_text_field.dart';
import 'package:provider/provider.dart';

class EditProfile extends StatelessWidget {
  // final UserProfile user;

  EditProfile({
    super.key,
    // required this.user,
  });

  // controller
  final usernameEditingController = TextEditingController();
  final nameEditingController = TextEditingController();

  void updateUsernameAndName(BuildContext context) async {
    final userDataProvider =
        Provider.of<UserDataProvider>(context, listen: false);
    if (usernameEditingController.text.isNotEmpty) {
      await userDataProvider.editUsernameField(
          usernameEditingController.text, "username");
    }
    if (nameEditingController.text.isNotEmpty) {
      await userDataProvider.editNameField(nameEditingController.text, "name");
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isDarkMode =
        Provider.of<ThemeProvider>(context, listen: false).isDarkMode;
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: Theme.of(context).colorScheme.primary,
        title: Text(
          'Edit Profile',
          style: TextStyle(
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        actions: [
          // update button
          IconButton(
            onPressed: () {
              updateUsernameAndName(context);
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.done,
              color: Theme.of(context).colorScheme.surface,
              size: 30,
            ),
          )
        ],
      ),
      body: ListView(
        physics: BouncingScrollPhysics(
          parent: AlwaysScrollableScrollPhysics(),
        ),
        children: [
          // profile photo

          SizedBox(height: 20),

          // username
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: TextField(
              controller: usernameEditingController,
              obscureText: false,
              decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: isDarkMode
                        ? Theme.of(context).colorScheme.tertiary
                        : Theme.of(context).colorScheme.inversePrimary,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: isDarkMode
                        ? Theme.of(context).colorScheme.inversePrimary
                        : Theme.of(context).colorScheme.tertiary,
                  ),
                ),
                fillColor: Theme.of(context).colorScheme.secondary,
                filled: true,
                hintText: "Username",
                hintStyle: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
          ),

          SizedBox(height: 20),

          // name
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: TextField(
              controller: nameEditingController,
              obscureText: false,
              decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: isDarkMode
                        ? Theme.of(context).colorScheme.tertiary
                        : Theme.of(context).colorScheme.inversePrimary,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: isDarkMode
                        ? Theme.of(context).colorScheme.inversePrimary
                        : Theme.of(context).colorScheme.tertiary,
                  ),
                ),
                fillColor: Theme.of(context).colorScheme.secondary,
                filled: true,
                hintText: "Name",
                hintStyle: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
