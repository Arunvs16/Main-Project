import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:main_project/components/post_card.dart';
import 'package:main_project/services/firestore.dart';
import 'package:timeago/timeago.dart' as timeago;

class OpenPostPage extends StatelessWidget {
  OpenPostPage({super.key});

  // user
  final user = FirebaseAuth.instance.currentUser!;

  // access firestore
  final _firestore = Firestore();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Theme.of(context).colorScheme.primary,
        backgroundColor: Colors.transparent,
        title: Text("Posts"),
      ),
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: // my posts
          FutureBuilder<Map<String, dynamic>>(
        future: _firestore.getCurrentUserAndPostData(user.uid),
        builder: (context, snapshot) {
          // show errors
          if (snapshot.hasError) {
            return Center(
              child: Text(
                snapshot.error.toString(),
              ),
            );
          }
          // show loading circle
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(
                color: Theme.of(context).colorScheme.primary,
              ),
            );
          }

          // get user data and posts
          var userData = snapshot.data!['userData'];
          var posts = snapshot.data!['postData'] as List<QueryDocumentSnapshot>;

          // no posts
          if (posts.isEmpty) {
            return Center(
              child: Text('No posts'),
            );
          }

          // return as a list
          return ListView.builder(
            itemCount: posts.length,
            itemBuilder: (context, index) {
              // get each individual post
              final post = posts[index];
              // get data from each post
              String caption = post['caption'];
              String imageUrl = post['imageURL'];
              Timestamp timestamp = post['timestamp'];
              DateTime dateTime = timestamp.toDate();
              String timeAgo = timeago.format(dateTime);

              // return as a container
              return PostCard(
                username: "@${post['username']}",
                caption: caption,
                timeAgo: timeAgo,
                imageURL: imageUrl,
                postId: post.id,
                likes: ['likes'],
                onPressedDlt: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      content: Text(
                        'Do you want to delete this post?',
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
                            'Delete',
                            style: TextStyle(
                                color: Theme.of(context).colorScheme.error),
                          ),
                          onPressed: () {
                            FirebaseFirestore.instance
                                .collection("Posts")
                                .doc(user.uid
                                    // add post id
                                    )
                                .delete()
                                .whenComplete(
                              () {
                                Navigator.pop(context);
                              },
                            );
                          },
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
