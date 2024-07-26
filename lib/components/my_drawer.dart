import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:main_project/Providers/firestore_provider.dart';
import 'package:main_project/components/helper_function.dart';
import 'package:main_project/components/my_list_tile.dart';
import 'package:provider/provider.dart';

class MyDrawer extends StatelessWidget {
  void Function()? onTap;
  MyDrawer({super.key, required this.onTap});

  // user
  final currentUser = FirebaseAuth.instance.currentUser!;

  @override
  Widget build(BuildContext context) {
    final userDataProvider =
        Provider.of<UserDataProvider>(context, listen: false);
    return StreamBuilder<DocumentSnapshot>(
      stream: userDataProvider.documentStream,
      builder: (context, snapshot) {
        // get user data
        if (snapshot.hasData) {
          final userData = snapshot.data!.data() as Map<String, dynamic>;
          return Drawer(
            backgroundColor: Theme.of(context).colorScheme.background,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    // drawer header
                    //logo
                    InkWell(
                      onTap: onTap,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          DrawerHeader(
                            child: Container(
                              decoration: BoxDecoration(),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  CircleAvatar(
                                    backgroundImage:
                                        AssetImage('images/person.jpg'),
                                    backgroundColor: Colors.transparent,
                                    radius: 40,
                                  ),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "@" + userData['username'],
                                        style: TextStyle(
                                            fontSize: 20,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .primary),
                                      ),
                                      const SizedBox(
                                        height: 8,
                                      ),
                                      // email id
                                      Text(
                                        currentUser.email.toString(),
                                        style: TextStyle(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .primary,
                                            fontSize: 16),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // home list tile
                    MyListTile(
                      onTap: () {
                        Navigator.pushNamed(context, '/comments');
                      },
                      horizontal: 25,
                      vertical: 0,
                      leading: Icon(
                        Icons.comment,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      titleText: "Comments",
                      subTitleText: "Go to Comments",
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ],
                ),
                // settings list tile
                MyListTile(
                  onTap: () {
                    Navigator.pushNamed(context, '/settings');
                  },
                  horizontal: 25,
                  vertical: 20,
                  leading: Icon(
                    Icons.settings,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  titleText: "SETTINGS",
                  subTitleText: "Dark mode, Profile",
                  color: Theme.of(context).colorScheme.primary,
                ),
              ],
            ),
          );
        } else if (snapshot.hasError) {
          displayMessageToUser("Error ${snapshot.error}", context);
        }
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}
