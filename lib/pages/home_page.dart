import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:main_project/Providers/firestore_provider.dart';
import 'package:main_project/Providers/theme_provider.dart';
import 'package:main_project/components/my_drawer.dart';
import 'package:main_project/components/post_card.dart';
import 'package:main_project/pages/chat_page.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' as timeago;

class HomePage extends StatelessWidget {
  HomePage({super.key});

  // user
  final user = FirebaseAuth.instance.currentUser!;

  // controller
  final postController = TextEditingController();

  void postComment(BuildContext context) {
    // if something in your text field
    if (postController.text.isNotEmpty) {
      Provider.of<PostLikeProvider>(context, listen: false)
          .postLike(postController.text, user.email!);
    }
    postController.clear();
  }

  @override
  Widget build(BuildContext context) {
    final postLikeProvider = Provider.of<PostLikeProvider>(context);
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
                  child: ChatPage(),
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
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection("Posts")
                  .orderBy('timestamp', descending: true)
                  // .doc(user.email)
                  // .collection("Users")
                  .snapshots(),
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
                // get all posts
                final posts = snapshot.data!.docs;
                // no data
                if (snapshot.data == null || posts.isEmpty) {
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
                    String imageUrl = post['imageUrl'];
                    Timestamp timestamp = post['timestamp'];
                    DateTime dateTime = timestamp.toDate();
                    String timeAgo = timeago.format(dateTime);

                    // return as a container
                    return PostCard(
                      caption: caption,
                      timeAgo: timeAgo,
                      imageUrl: imageUrl,
                    );
                  },
                );
              },
            ),
          ),
          // logged in as
          Text(
            "Logged in as: ${user.email}",
            style: TextStyle(color: Theme.of(context).colorScheme.primary),
          ),
          const SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }
}
