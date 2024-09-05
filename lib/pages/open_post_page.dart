import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:main_project/Providers/firestore_provider.dart';
import 'package:main_project/Providers/theme_provider.dart';
import 'package:main_project/components/helper_function.dart';
import 'package:main_project/components/open_post_image.dart';
import 'package:main_project/pages/profile_page.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' as timeago;

class OpenPostPage extends StatelessWidget {
  final String imageUrl;
  final String caption;
  final String username;
  final List<String> likes;
  final Timestamp timestamp;
  final String postId;

  OpenPostPage({
    super.key,
    required this.imageUrl,
    required this.caption,
    required this.username,
    required this.likes,
    required this.timestamp,
    required this.postId,
  });

  final user = FirebaseAuth.instance.currentUser!;

  void _deleteOptions(BuildContext context) {
    bool isDarkMode =
        Provider.of<ThemeProvider>(context, listen: false).isDarkMode;
    showModalBottomSheet(
      backgroundColor: Theme.of(context).colorScheme.surface,
      context: context,
      builder: (context) {
        return Wrap(
          children: [
            ListTile(
              leading: Icon(Icons.delete),
              title: Text('Delete'),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    backgroundColor: Theme.of(context).colorScheme.surface,
                    content: Text(
                      'Do you want to delete this post?',
                      style: TextStyle(
                        color: isDarkMode
                            ? Theme.of(context).colorScheme.inversePrimary
                            : Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    actions: [
                      // No button
                      MaterialButton(
                        color: isDarkMode
                            ? Theme.of(context).colorScheme.inversePrimary
                            : Theme.of(context).colorScheme.primary,
                        child: Text(
                          'No',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.inversePrimary,
                          ),
                        ),
                        onPressed: () {
                          close(context);
                        },
                      ),
                      // yes button
                      MaterialButton(
                        color: Theme.of(context).colorScheme.error,
                        child: Text(
                          'Yes',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.inversePrimary,
                          ),
                        ),
                        onPressed: () {
                          FirebaseFirestore.instance
                              .collection("Posts")
                              .doc(postId)
                              .delete()
                              .whenComplete(
                            () {
                              Navigator.pushAndRemoveUntil(
                                context,
                                PageTransition(
                                  child: ProfilePage(),
                                  type: PageTransitionType.fade,
                                ),
                                (route) => false,
                              );
                            },
                          );
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.cancel),
              title: Text('Cancel'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  void _otherOption(BuildContext context) {
    showModalBottomSheet(
      backgroundColor: Theme.of(context).colorScheme.surface,
      context: context,
      builder: (context) {
        return Wrap(
          children: [
            ListTile(
              leading: Icon(Icons.report),
              title: Text('Report'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.block),
              title: Text('Block'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.cancel),
              title: Text('Cancel'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final postLikeProvider =
        Provider.of<PostAndUserDatasProvider>(context, listen: false);
    bool isDarkMode =
        Provider.of<ThemeProvider>(context, listen: false).isDarkMode;
    final currentUser = FirebaseAuth.instance.currentUser!;

    return Scaffold(
      appBar: AppBar(
        foregroundColor: Theme.of(context).colorScheme.primary,
        backgroundColor: Colors.transparent,
        title: Text("Posts"),
      ),
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Column(
        children: [
          // Display Posts
          Expanded(
            child: ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              itemCount: 1, // Displaying only one post
              itemBuilder: (context, index) {
                // Display data from the post
                String timeAgo = timeago.format(timestamp.toDate());

                return OpenPostImage(
                  caption: caption,
                  username: "@$username",
                  timeAgo: timeAgo,
                  imageURL: imageUrl,
                  onPressedDlt: () {
                    bool isOwnPost =
                        user.email == user.email; // Change this as needed
                    if (isOwnPost) {
                      _deleteOptions(context);
                    } else {
                      _otherOption(context);
                    }
                  },
                  postId: postId,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
