import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:main_project/Providers/firestore_provider.dart';
import 'package:main_project/Providers/theme_provider.dart';
import 'package:main_project/Providers/user_provider.dart';
import 'package:main_project/components/helper_function.dart';
import 'package:main_project/components/my_text_box.dart';
import 'package:main_project/model/user_model.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatelessWidget {
  ProfilePage({super.key});

  // user
  final currentUser = FirebaseAuth.instance.currentUser!;

  @override
  Widget build(BuildContext context) {
    final userDataProvider = Provider.of<UserDataProvider>(context);
    UserModel userModel = Provider.of<UserProvider>(context).userModel!;
    bool isDarkMode =
        Provider.of<ThemeProvider>(context, listen: false).isDarkMode;
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Theme.of(context).colorScheme.primary,
        backgroundColor: Colors.transparent,
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: userDataProvider.documentStream,
        builder: (context, snapshot) {
          // get user data
          if (snapshot.hasData) {
            final userData = snapshot.data!.data() as Map<String, dynamic>;
            return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                // User Profile pic
                Container(
                  height: 100,
                  width: 100,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                        width: 5,
                        color: isDarkMode
                            ? Theme.of(context).colorScheme.inversePrimary
                            : Theme.of(context).colorScheme.primary),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(100),
                    child: Image(
                      fit: BoxFit.cover,
                      image: NetworkImage(
                          "https://miro.medium.com/v2/resize:fit:828/format:webp/1*QO-IfkIhADgSyiXkIUvJRQ.jpeg"),
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      },
                      errorBuilder: (context, object, stack) {
                        return Container(
                          child: Icon(Icons.error_outline),
                        );
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 10),

                // username
                Text(
                  '@' + userData['username'],
                  style: TextStyle(
                    fontSize: 25,
                  ),
                ),
                const SizedBox(height: 20),

                // Edit profile button
                InkWell(
                  child: Center(
                    child: Container(
                      height: 30,
                      width: 80,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(7),
                          color: Theme.of(context).colorScheme.primary),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Edit Profile",
                            style: TextStyle(
                                fontSize: 12,
                                color: Theme.of(context)
                                    .colorScheme
                                    .inversePrimary),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                // bio
                MyTextBox(
                  bioHeader: "Bio :",
                  bio: userData['bio'],
                  onPressed: () {
                    userDataProvider.editField(context, "bio");
                  },
                  onTap: () {
                    userDataProvider.editField(context, "bio");
                  },
                ),
                // My posts

                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('My posts'),
                )
              ],
            );
          } else if (snapshot.hasError) {
            displayMessageToUser("Error+ ${snapshot.error}", context);
          }
          return Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
