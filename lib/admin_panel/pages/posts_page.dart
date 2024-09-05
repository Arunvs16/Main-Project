import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:main_project/Providers/firestore_provider.dart';
import 'package:main_project/admin_panel/components/admin_post_card.dart';
import 'package:main_project/components/helper_function.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' as timeago;

class PostsPage extends StatelessWidget {
  PostsPage({super.key});

  final User user = FirebaseAuth.instance.currentUser!;

  // Function to delete a post
  void _deletePost(BuildContext context, String postId) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Wrap(
          children: [
            // delete
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
                    // pop
                    close(context);
                  },
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.close),
              title: Text('Cancel'),
              onTap: () {
                // pop
                close(context);
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final postAndUserDatasProvider =
        Provider.of<PostAndUserDatasProvider>(context, listen: false);
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        foregroundColor: Theme.of(context).colorScheme.primary,
        backgroundColor: Colors.transparent,
        title: Text("All Posts"),
      ),
      body: StreamBuilder<Map<String, dynamic>>(
        stream: postAndUserDatasProvider.getUserAndPostDataStream(user.uid),
        builder: (context, snapshot) {
          // errors
          if (snapshot.hasError) {
            return Center(child: Text(snapshot.error.toString()));
          }

          // loading
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(
                color: Theme.of(context).colorScheme.onPrimary,
              ),
            );
          }

          // get data
          var userData = snapshot.data!['userData'];
          var posts = snapshot.data!['postData'] as List<QueryDocumentSnapshot>;

          // no post
          if (posts.isEmpty) {
            return Center(
              child: Text(
                'No Posts',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            );
          }

          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: posts.length,
                  itemBuilder: (context, index) {
                    // exracting data
                    final post = posts[index];
                    String caption = post['caption'];
                    String imageURL = post['imageURL'];
                    String username = post['username'];
                    List<String> likes = List<String>.from(post['likes'] ?? []);
                    Timestamp timestamp = post['timestamp'];
                    DateTime dateTime = timestamp.toDate();
                    String timeAgo = timeago.format(dateTime);

                    return AdminPostCard(
                      username: "@$username",
                      caption: caption,
                      timeAgo: timeAgo,
                      imageURL: imageURL,
                      postId: post.id,
                      onPressedDlt: () {
                        _deletePost(context, post.id);
                      },
                    );
                  },
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surface,
                    ),
                    child: Center(
                      child: Text(
                        "@${userData['username']}",
                        style: TextStyle(
                          fontSize: 16,
                          color: Theme.of(context).colorScheme.onPrimary,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}
