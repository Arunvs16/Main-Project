import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:main_project/Providers/firestore_provider.dart';
import 'package:main_project/Providers/theme_provider.dart';
import 'package:main_project/components/helper_function.dart';
import 'package:main_project/components/my_text_box.dart';
import 'package:main_project/pages/auth/auth_page.dart';
import 'package:main_project/pages/open_post_page.dart';
import 'package:main_project/services/auth_service.dart';
import 'package:main_project/utils/edit_profile_page.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatelessWidget {
  final String uid;
  ProfilePage({
    super.key,
    required this.uid,
  });

  // user
  final currentUser = FirebaseAuth.instance.currentUser!;

  final _auth = AuthService();

  void logOut(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Theme.of(context).colorScheme.background,
        content: Text(
          'Do you want to logout of your account?',
          style: TextStyle(
              fontSize: 24, color: Theme.of(context).colorScheme.primary),
        ),
        actions: [
          MaterialButton(
            child: Text(
              'Cancel',
              style: TextStyle(color: Theme.of(context).colorScheme.primary),
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          MaterialButton(
            child: Text(
              'Logout',
              style: TextStyle(color: Theme.of(context).colorScheme.error),
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
  }

  @override
  Widget build(BuildContext context) {
    final userDataProvider =
        Provider.of<UserDataProvider>(context, listen: false);

    bool isDarkMode =
        Provider.of<ThemeProvider>(context, listen: false).isDarkMode;

    return Scaffold(
      appBar: AppBar(
        foregroundColor: Theme.of(context).colorScheme.primary,
        backgroundColor: Colors.transparent,
      ),
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Column(
        children: [
          StreamBuilder<DocumentSnapshot>(
            stream: FirebaseFirestore.instance
                .collection("Users")
                .doc(currentUser.uid)
                .snapshots(),
            builder: (context, snapshot) {
              // get user data
              if (snapshot.hasData) {
                final userData = snapshot.data!.data() as Map<String, dynamic>;
                return Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        IconButton(
                          onPressed: () => logOut(context),
                          icon: Icon(Icons.arrow_drop_down),
                        ),
                        GestureDetector(
                          onTap: () => logOut(context),
                          child: Text(
                            "@${userData['username']}",
                            style: TextStyle(
                              fontSize: 20,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                        ),
                      ],
                    ),
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
                          image: AssetImage('images/person.jpg'),
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
                    const SizedBox(height: 5),

                    // username
                    Text(
                      userData['name'],
                      style: TextStyle(
                        fontSize: 25,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    const SizedBox(height: 10),

                    // Edit profile button
                    Center(
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            PageTransition(
                              child: EditProfile(),
                              type: PageTransitionType.fade,
                            ),
                          );
                        },
                        child: Container(
                          height: 30,
                          width: 80,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(7),
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Edit Profile",
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .inversePrimary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    // bio
                    MyTextBox(
                      onTap: () {
                        userDataProvider.editBioField(context, "bio");
                      },
                      bioHeader: "Bio :",
                      bio: userData['bio'],
                      onPressed: () {
                        userDataProvider.editBioField(context, "bio");
                      },
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
          // my post header
          Container(
            padding: EdgeInsets.all(25),
            child: Text(
              'Uploads',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ),
          // my posts
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection("Posts")
                .where(
                  'email',
                  isEqualTo: _auth.getCurrentUserEmail(),
                ) // Filter by current user's UID
                .snapshots(),
            builder: (context, snapshot) {
              // show errors
              if (snapshot.hasError) {
                return Center(child: Text(snapshot.error.toString()));
              }
              // show loading circle
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
                );
              }
              // get all posts
              final posts = snapshot.data!.docs;
              // no data
              if (snapshot.data == null || posts.isEmpty) {
                return Container(
                  padding: EdgeInsets.symmetric(vertical: 20),
                  child: Text(
                    'No uploads yet.',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                );
              }
              // return as a Grid view
              return GridView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  mainAxisSpacing: 5,
                  crossAxisSpacing: 5,
                  crossAxisCount: 3,
                ),
                itemCount: posts.length,
                itemBuilder: (context, index) {
                  // get each individual post
                  final post = posts[index];
                  // get data from each post
                  String imageUrl = post['imageURL'];

                  // return as a container
                  return InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        PageTransition(
                          child: OpenPostPage(),
                          type: PageTransitionType.fade,
                        ),
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                      child: Image.network(
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Center(
                            child: CircularProgressIndicator(
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          );
                        },
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            child: Icon(Icons.error_outline),
                          );
                        },
                        imageUrl,
                        fit: BoxFit.fill,
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
