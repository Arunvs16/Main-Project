import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:main_project/components/helper_function.dart';
import 'package:main_project/components/my_list_tile.dart';

class MyDrawer extends StatefulWidget {
  MyDrawer({super.key});

  @override
  State<MyDrawer> createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  void Function()? onTap;
  // user
  final currentUser = FirebaseAuth.instance.currentUser!;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection("Users")
          .doc(currentUser.email)
          .snapshots(),
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
                    GestureDetector(
                      onTap: onTap,
                      child: Row(
                        children: [
                          DrawerHeader(
                            decoration: BoxDecoration(),
                            child: CircleAvatar(
                              backgroundColor: Colors.transparent,
                              radius: 40,
                              child: Image.network(
                                "https://cdn1.iconfinder.com/data/icons/google-s-logo/150/Google_Icons-09-512.png",
                              ),
                            ),
                          ),
                          Column(
                            children: [
                              // username
                              Text(
                                '@' + userData["username"],
                                style: TextStyle(
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                    fontSize: 20),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              // email id
                              Text(
                                currentUser.email.toString(),
                                style: TextStyle(
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                    fontSize: 16),
                              ),
                            ],
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
