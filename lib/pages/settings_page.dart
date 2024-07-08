import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:main_project/components/my_list_tile.dart';
import 'package:main_project/Providers/theme_provider.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Theme.of(context).colorScheme.primary,
        backgroundColor: Colors.transparent,
        title: Text("Settings"),
      ),
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              // display profile
              Padding(
                padding: EdgeInsets.only(left: 5.0),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.transparent,
                    child: Image.network(
                      "https://cdn1.iconfinder.com/data/icons/google-s-logo/150/Google_Icons-09-512.png",
                    ),
                    radius: 50,
                  ),
                  title: Text(
                    "Arun V S",
                    style:
                        TextStyle(color: Theme.of(context).colorScheme.primary),
                  ),
                  onTap: () {
                    Navigator.pushNamed(context, '/profilepage');
                  },
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              // dark mode
              GestureDetector(
                onTap: () => Provider.of<ThemeProvider>(context, listen: false)
                    .toggleTheme(),
                child: Container(
                  decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.secondary,
                      borderRadius: BorderRadius.circular(12)),
                  margin: EdgeInsets.all(25),
                  padding: EdgeInsets.all(16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // dark mode text
                      Text("Dark Mode"),

                      //cupertino switch
                      CupertinoSwitch(
                        activeColor: Theme.of(context).colorScheme.error,
                        value:
                            Provider.of<ThemeProvider>(context, listen: false)
                                .isDarkMode,
                        onChanged: (value) =>
                            Provider.of<ThemeProvider>(context, listen: false)
                                .toggleTheme(),
                      ),
                    ],
                  ),
                ),
              ),
              // help-> terms and privacy ,app info
              MyListTile(
                onTap: () {
                  Navigator.pushNamed(context, '/helpPage');
                },
                horizontal: 10,
                vertical: 0,
                leading: Icon(
                  Icons.help,
                  color: Theme.of(context).colorScheme.primary,
                ),
                titleText: "Help",
                subTitleText: "Term and Conditons, Privacy policy, App info",
                color: Theme.of(context).colorScheme.primary,
              ),
            ],
          ),

          // logout list tile
          MyListTile(
            onTap: () {
              FirebaseAuth.instance.signOut();
              Navigator.pop(context);
            },
            horizontal: 70,
            vertical: 20,
            leading: Icon(
              Icons.logout,
              color: Theme.of(context).colorScheme.primary,
            ),
            titleText: "LOGOUT",
            subTitleText: "Logout from your account",
            color: Theme.of(context).colorScheme.primary,
          ),
        ],
      ),
    );
  }
}
