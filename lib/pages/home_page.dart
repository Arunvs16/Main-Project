import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:main_project/Providers/firestore_provider.dart';
import 'package:main_project/Providers/theme_provider.dart';
import 'package:main_project/components/my_drawer.dart';
import 'package:main_project/components/post_card.dart';
import 'package:main_project/model/post.dart';
import 'package:main_project/pages/chat_list_page.dart';
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
      Provider.of<PostLikeProvider>(context, listen: false)
          .postLike(postController.text, user.email!);
    }
    postController.clear();
  }

  // option for delete post
  void _deleteOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Wrap(
          children: [
            // delete
            ListTile(
              leading: Icon(Icons.delete),
              title: Text('Delete'),
              onTap: () {},
            ),

            // cancel
            ListTile(
              leading: Icon(Icons.cancel),
              title: Text('Cancel'),
              onTap: () {},
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
      backgroundColor: Theme.of(context).colorScheme.background,
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
          Navigator.pushNamed(context, '/profilepage');
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
                    Timestamp timestamp = post['timestamp'];
                    DateTime dateTime = timestamp.toDate();
                    String timeAgo = timeago.format(dateTime);

                    // return as a container
                    return PostCard(
                      username: "@${userData['username']}",
                      caption: caption,
                      timeAgo: timeAgo,
                      imageURL: imageURL,
                      onPressed: () {
                        bool isOwnPost = post['email'] == userData['email'];
                        if (isOwnPost) {
                          _deleteOptions(context);
                        }
                      },
                    );
                  },
                ),
              ),
              // Display User Info
              Text(
                "@${userData['username']}",
                style: TextStyle(
                  fontSize: 18,
                  color: Theme.of(context).colorScheme.surface,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
