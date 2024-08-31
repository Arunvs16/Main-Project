import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:main_project/Providers/firestore_provider.dart';
import 'package:main_project/components/post_card.dart'; // Ensure this path is correct
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
        Provider.of<PostLikeProvider>(context, listen: false);

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
              itemCount: 1, // Displaying only one post
              itemBuilder: (context, index) {
                // Display data from the post
                String timeAgo = timeago.format(timestamp.toDate());

                return PostCard(
                  username: "@$username", // or you can use userData if needed
                  caption: caption,
                  timeAgo: timeAgo,
                  imageURL: imageUrl,
                  postId: postId,
                  likes: likes,
                  onPressedDlt: () {
                    bool isOwnPost =
                        user.email == user.email; // Change this as needed
                    if (isOwnPost) {
                      _deleteOptions(context);
                    } else {
                      _otherOption(context);
                    }
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
