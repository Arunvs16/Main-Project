import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:main_project/Providers/authentication.dart';
import 'package:main_project/Providers/firestore_provider.dart';
import 'package:main_project/components/helper_function.dart';
import 'package:main_project/components/my_list_tile.dart';
import 'package:main_project/Providers/theme_provider.dart';
import 'package:main_project/pages/auth/auth_page.dart';
import 'package:main_project/pages/auth/login_or_register.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatelessWidget {
  SettingsPage({super.key});

  // user
  final currentUser = FirebaseAuth.instance.currentUser!;

  @override
  Widget build(BuildContext context) {
    final userDataProvider = Provider.of<UserDataProvider>(context);
    // bool isDarkMode =
    //     Provider.of<ThemeProvider>(context, listen: false).isDarkMode;
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Theme.of(context).colorScheme.primary,
        backgroundColor: Colors.transparent,
        title: Text("Settings"),
      ),
      backgroundColor: Theme.of(context).colorScheme.background,
      body: StreamBuilder<DocumentSnapshot>(
        stream: userDataProvider.documentStream,
        builder: (context, snapshot) {
          // get user data
          if (snapshot.hasData) {
            final userData = snapshot.data!.data() as Map<String, dynamic>;
            return Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    // display profile
                    InkWell(
                      onTap: () {
                        Navigator.pushNamed(context, '/profilepage');
                      },
                      child: Container(
                        decoration: BoxDecoration(),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            CircleAvatar(
                              backgroundColor: Colors.transparent,
                              radius: 50,
                              child: Image.network(
                                "https://cdn1.iconfinder.com/data/icons/google-s-logo/150/Google_Icons-09-512.png",
                              ),
                            ),
                            Text(
                              "@" + userData['username'],
                              style: TextStyle(
                                  fontSize: 20,
                                  color: Theme.of(context).colorScheme.primary),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    // dark mode
                    GestureDetector(
                      onTap: () =>
                          Provider.of<ThemeProvider>(context, listen: false)
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
                              value: Provider.of<ThemeProvider>(context,
                                      listen: false)
                                  .isDarkMode,
                              onChanged: (value) => Provider.of<ThemeProvider>(
                                      context,
                                      listen: false)
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
                      subTitleText:
                          "Term and Conditons, Privacy policy, App info",
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ],
                ),

                // logout list tile
                MyListTile(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        content: Text(
                          'Do you want to logout of your account?',
                          style: TextStyle(
                              fontSize: 24,
                              color: Theme.of(context).colorScheme.primary),
                        ),
                        actions: [
                          MaterialButton(
                            child: Text(
                              'Cancel',
                              style: TextStyle(
                                  color: Theme.of(context).colorScheme.primary),
                            ),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                          MaterialButton(
                            child: Text(
                              'Logout',
                              style: TextStyle(
                                  color: Theme.of(context).colorScheme.error),
                            ),
                            onPressed: () {
                              Provider.of<Authentication>(context,
                                      listen: false)
                                  .signOut()
                                  .whenComplete(() {
                                Navigator.pushReplacement(
                                  context,
                                  PageTransition(
                                      child: AuthPage(),
                                      type: PageTransitionType.topToBottom),
                                );
                              });
                            },
                          ),
                        ],
                      ),
                    );
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
            );
          } else if (snapshot.hasError) {
            displayMessageToUser("Error ${snapshot.error}", context);
          }
          return Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
