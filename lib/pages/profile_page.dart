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
import 'package:timeago/timeago.dart' as timeago;

class ProfilePage extends StatelessWidget {
  ProfilePage({
    super.key,
  });

  // user
  final currentUser = FirebaseAuth.instance.currentUser!;

  final _auth = AuthService();

  void logOut(BuildContext context) {
    bool isDarkMode =
        Provider.of<ThemeProvider>(context, listen: false).isDarkMode;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Theme.of(context).colorScheme.secondary,
        content: Text(
          'Do you want to logout of your account?',
          style: TextStyle(
            fontSize: 24,
            color: isDarkMode
                ? Theme.of(context).colorScheme.inversePrimary
                : Theme.of(context).colorScheme.primary,
          ),
        ),
        actions: [
          MaterialButton(
            color: isDarkMode
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).colorScheme.secondary,
            child: Text(
              'Cancel',
              style: TextStyle(
                color: isDarkMode
                    ? Theme.of(context).colorScheme.inversePrimary
                    : Theme.of(context).colorScheme.primary,
              ),
            ),
            onPressed: () {
              // pop
              close(context);
            },
          ),
          MaterialButton(
            color: Theme.of(context).colorScheme.error,
            child: Text(
              'Logout',
              style: TextStyle(
                color: Theme.of(context).colorScheme.inversePrimary,
              ),
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
                    (context) => false,
                  );
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
    final postAndUserDatasProvider =
        Provider.of<PostAndUserDatasProvider>(context, listen: false);

    bool isDarkMode =
        Provider.of<ThemeProvider>(context, listen: false).isDarkMode;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SafeArea(
        child: Column(
          children: [
            // Separate StreamBuilder for User Data
            StreamBuilder<DocumentSnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('Users')
                  .doc(currentUser.uid)
                  .snapshots(),
              builder: (context, userSnapshot) {
                if (userSnapshot.hasError) {
                  return Center(
                    child: Text('Error: ${userSnapshot.error}'),
                  );
                }

                if (userSnapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
                  );
                }

                if (userSnapshot.hasData && userSnapshot.data!.exists) {
                  var userData =
                      userSnapshot.data!.data() as Map<String, dynamic>;

                  // Display user data
                  return Column(
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
                      // User Profile Picture
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
                          child: Image.asset(
                            'images/person.jpg',
                            fit: BoxFit.cover,
                            errorBuilder: (context, object, stack) {
                              return Container(
                                child: Icon(
                                  Icons.error_outline,
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: 5),

                      // Username
                      Text(
                        userData['name'],
                        style: TextStyle(
                          fontSize: 18,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                      const SizedBox(height: 10),

                      // Edit Profile Button
                      Center(
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              PageTransition(
                                child: EditProfile(postId: 'postId'),
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
                            child: Center(
                              child: Text(
                                "Edit Profile",
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .inversePrimary,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      // Bio
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
                      const SizedBox(height: 20),
                      Text(
                        'Uploads',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ],
                  );
                }

                return Container();
              },
            ),
            // Separate StreamBuilder for Posts
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection("Posts")
                    .where('email', isEqualTo: _auth.getCurrentUserEmail())
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Center(
                      child: Text(snapshot.error.toString()),
                    );
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(
                        color: Theme.of(context).colorScheme.onPrimary,
                      ),
                    );
                  }

                  final posts = snapshot.data!.docs;

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

                  // Display Posts
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
                      final post = posts[index];
                      String imageUrl = post['imageURL'];
                      String caption = post['caption'];
                      String username = post['username'];
                      List<String> likes =
                          List<String>.from(post['likes'] ?? []);
                      Timestamp timestamp = post['timestamp'];
                      DateTime dateTime = timestamp.toDate();
                      String timeAgo = timeago.format(dateTime);

                      return InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            PageTransition(
                              child: OpenPostPage(
                                username: username,
                                imageUrl: imageUrl,
                                caption: caption,
                                likes: likes,
                                timestamp: timestamp,
                                postId: post.id,
                              ),
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
                            imageUrl,
                            fit: BoxFit.fitWidth,
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) return child;
                              return Center(
                                child: CircularProgressIndicator(
                                  color:
                                      Theme.of(context).colorScheme.onPrimary,
                                ),
                              );
                            },
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                child: Icon(Icons.error_outline),
                              );
                            },
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
