import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:main_project/Providers/firestore_provider.dart';
import 'package:main_project/components/helper_function.dart';
import 'package:main_project/components/my_list_tile.dart';
import 'package:provider/provider.dart';

class MyDrawer extends StatelessWidget {
  final void Function()? onTap;
  MyDrawer({
    super.key,
    required this.onTap,
  });

  // user
  final currentUser = FirebaseAuth.instance.currentUser!;

  @override
  Widget build(BuildContext context) {
    final userDataProvider =
        Provider.of<UserDataProvider>(context, listen: false);
    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection("Users")
          .doc(currentUser.uid)
          .snapshots(),
      builder: (context, snapshot) {
        // get user data
        if (snapshot.hasData) {
          var userData = snapshot.data!.data() as Map<String, dynamic>;
          return Drawer(
            backgroundColor: Theme.of(context).colorScheme.surface,
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
                                  SizedBox(
                                    width: 10,
                                  ),

                                  // user name
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "${userData['name']}",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontSize: 16,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .primary),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        "@${userData['username']}",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontSize: 16,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .primary),
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
                        Navigator.pop(context);
                      },
                      horizontal: 25,
                      vertical: 0,
                      leading: Icon(
                        Icons.home,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      titleText: "Home",
                      subTitleText: "Go back to Home Page",
                      color1: Theme.of(context).colorScheme.primary,
                      color2: Theme.of(context).colorScheme.primary,
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
                  subTitleText: "Dark mode, Help",
                  color1: Theme.of(context).colorScheme.primary,
                  color2: Theme.of(context).colorScheme.primary,
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
