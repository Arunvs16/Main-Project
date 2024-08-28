import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:main_project/Providers/firestore_provider.dart';
import 'package:main_project/Providers/theme_provider.dart';
import 'package:main_project/components/my_drawer.dart';
import 'package:main_project/components/post_card.dart';
import 'package:main_project/pages/chat_list_page.dart';
import 'package:main_project/pages/open_profile_page.dart';
import 'package:main_project/services/auth_service.dart';
import 'package:main_project/services/firestore.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' as timeago;

class HomePage extends StatelessWidget {
  HomePage({super.key});

  // user
  final user = FirebaseAuth.instance.currentUser!;

  // controller
  final postController = TextEditingController();

  // access firestore

  final _firestore = Firestore();

  void postComment(BuildContext context) {
    // if something in your text field
    if (postController.text.isNotEmpty) {
      Provider.of<PostLikeProvider>(context, listen: false).postLike();
    }
    postController.clear();
  }

  // option for delete post
  void _deleteOptions(BuildContext context, String postId) {
    showModalBottomSheet(
      backgroundColor: Theme.of(context).colorScheme.surface,
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
                    .doc(postId
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

            // cancel
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

  //report
  void _reportOption(BuildContext context) {
    showModalBottomSheet(
      backgroundColor: Theme.of(context).colorScheme.surface,
      context: context,
      builder: (context) {
        return Wrap(
          children: [
            // Report
            ListTile(
              leading: Icon(Icons.report),
              title: Text('Report'),
              onTap: () {
                Navigator.pop(context);
              },
            ),

            // block
            ListTile(
              leading: Icon(Icons.block),
              title: Text('Block'),
              onTap: () {
                Navigator.pop(context);
              },
            ),

            // cancel
            ListTile(
              leading: Icon(Icons.block),
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
    String currentUserEmail = AuthService().getCurrentUserEmail();

    bool isDarkMode =
        Provider.of<ThemeProvider>(context, listen: false).isDarkMode;
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        foregroundColor: Theme.of(context).colorScheme.primary,
        backgroundColor: Colors.transparent,
        centerTitle: true,
        title: Icon(
          Icons.favorite,
          color: Theme.of(context).colorScheme.primary,
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                PageTransition(
                  duration: Durations.medium3,
                  child: ChatListPage(),
                  type: PageTransitionType.rightToLeft,
                ),
              );
            },
            icon: Icon(Icons.message_outlined),
          )
        ],
      ),
      drawer: MyDrawer(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ProfilePage(),
              ));
        },
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _firestore.getUserAndPostData(user.uid),
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
          return Column(
            children: [
              // Display Posts
              Expanded(
                child: ListView.builder(
                  itemCount: posts.length,
                  itemBuilder: (context, index) {
                    // get each individual post
                    final post = posts[index];
                    // get data from each post
                    String caption = post['caption'];
                    String imageURL = post['imageURL'];
                    List<String> likes =
                        List<String>.from(post['likes'] ?? ['']);
                    Timestamp timestamp = post['timestamp'];
                    DateTime dateTime = timestamp.toDate();
                    String timeAgo = timeago.format(dateTime);

                    // return as a container
                    return PostCard(
                      username: "@${post['email']}",
                      caption: caption,
                      timeAgo: timeAgo,
                      imageURL: imageURL,
                      postId: post.id,
                      likes: likes,
                      onPressedDlt: () {
                        bool isOwnPost = post['email'] == userData['email'];
                        if (isOwnPost) {
                          _deleteOptions(context, post.id);
                        } else {
                          _reportOption(context);
                        }
                      },
                    );
                  },
                ),
              ),
              // Display User Info
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surface),
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
