import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:main_project/Providers/firestore_provider.dart';
import 'package:main_project/components/helper_function.dart';
import 'package:main_project/components/my_list_tile.dart';
import 'package:main_project/Providers/theme_provider.dart';
import 'package:main_project/pages/auth/auth_page.dart';
import 'package:main_project/services/auth_service.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatelessWidget {
  SettingsPage({super.key});

  // user
  final currentUser = FirebaseAuth.instance.currentUser!;

  // access auth
  final _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    final userDataProvider = Provider.of<UserDataProvider>(context);
    bool isDarkMode =
        Provider.of<ThemeProvider>(context, listen: false).isDarkMode;
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Theme.of(context).colorScheme.primary,
        backgroundColor: Colors.transparent,
        title: Text("Settings"),
      ),
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection("Users")
            .doc(currentUser.uid)
            .snapshots(),
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
                    Container(
                      decoration: BoxDecoration(),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          CircleAvatar(
                            backgroundColor: Colors.transparent,
                            radius: 50,
                            child: Image(
                              image: AssetImage(
                                "images/person.jpg",
                              ),
                              loadingBuilder:
                                  (context, child, loadingProgress) {
                                if (loadingProgress == null) return child;
                                return Center(
                                  child: CircularProgressIndicator(),
                                );
                              },
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  child: Icon(Icons.error_outline),
                                );
                              },
                            ),
                          ),
                          SizedBox(width: 10),
                          Text(
                            "@${userData['username']}",
                            style: TextStyle(
                                fontSize: 20,
                                color: isDarkMode
                                    ? Theme.of(context)
                                        .colorScheme
                                        .inversePrimary
                                    : Theme.of(context).colorScheme.primary),
                          ),
                        ],
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
                      color1: Theme.of(context).colorScheme.primary,
                      color2: Theme.of(context).colorScheme.primary,
                    ),
                  ],
                ),

                // logout list tile
                MyListTile(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        backgroundColor:
                            Theme.of(context).colorScheme.background,
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
                              _auth.logout().whenComplete(
                                () {
                                  Navigator.pushAndRemoveUntil(
                                      context,
                                      PageTransition(
                                        child: AuthPage(),
                                        type: PageTransitionType.bottomToTop,
                                        duration: Durations.long1,
                                      ),
                                      (context) => false);
                                },
                              );
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
                  color1: Theme.of(context).colorScheme.primary,
                  color2: Theme.of(context).colorScheme.primary,
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
