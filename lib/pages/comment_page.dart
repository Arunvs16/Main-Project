import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:main_project/Providers/firestore_provider.dart';
import 'package:main_project/Providers/theme_provider.dart';
import 'package:main_project/services/firestore.dart';
import 'package:provider/provider.dart';
import 'package:main_project/components/comment_card.dart';
import 'package:main_project/components/my_text_field.dart';
import 'package:timeago/timeago.dart' as timeago;

class CommentPage extends StatelessWidget {
  final String postId;
  CommentPage({
    super.key,
    required this.postId,
  });

  final _firestore = Firestore();

  // user
  final currentUser = FirebaseAuth.instance.currentUser!;

  // text controller
  final commentController = TextEditingController();

  void postComment(BuildContext context) async {
    if (commentController.text.isNotEmpty) {
      await _firestore.postCommentToFirestore(postId: postId, data: {
        'username': currentUser.email,
        'comment': commentController.text,
        'likes': [],
        'TimeStamp': Timestamp.now(),
      });
    }
    commentController.clear();
  }

  @override
  Widget build(BuildContext context) {
    final commentDataProvider =
        Provider.of<CommentDataProvider>(context, listen: false);
    bool isDarkMode =
        Provider.of<ThemeProvider>(context, listen: false).isDarkMode;

    return Scaffold(
      appBar: AppBar(
        foregroundColor: Theme.of(context).colorScheme.primary,
        backgroundColor: Colors.transparent,
        title: Text("Comments"),
      ),
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Center(
        child: Column(
          children: [
            // comments
            Expanded(
              child: FutureBuilder<Map<String, dynamic>>(
                  future: commentDataProvider.getPostAndCommentData(postId),
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

                    // get post data and comments
                    var postData = snapshot.data!['postData'];
                    var comments = snapshot.data!['cmtData']
                        as List<QueryDocumentSnapshot>;

                    // no posts
                    if (comments.isEmpty) {
                      return Center(
                        child: Text('No Comments'),
                      );
                    }
                    return ListView.builder(
                      itemCount: comments.length,
                      itemBuilder: (context, index) {
                        // get each individual post
                        final DocumentSnapshot comment = comments[index];
                        Timestamp timestamp = comment['TimeStamp'];
                        DateTime dateTime = timestamp.toDate();
                        String timeAgo = timeago.format(dateTime);
                        return CommentCard(
                          time: timeAgo,
                          comment: comment['comment'],
                          username: comment['username'],
                          postID: postId,
                          cmtId: comment.id,
                          likes: List<String>.from(comment['likes'] ?? ['']),
                        );
                      },
                    );
                  }),
            ),

            Padding(
              padding: const EdgeInsets.all(25.0),
              child: Row(
                children: [
                  Expanded(
                    child: MyTextField(
                      controller: commentController,
                      hintText: "Type something",
                      obscureText: false,
                    ),
                  ),
                  // post icon
                  GestureDetector(
                    onTap: () => postComment(context),
                    child: Container(
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.send,
                        color: isDarkMode
                            ? Theme.of(context).colorScheme.inversePrimary
                            : Theme.of(context).colorScheme.secondary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // logged in as
            Text(
              "Logged in as: ${currentUser.email}",
              style: TextStyle(color: Theme.of(context).colorScheme.primary),
            ),
            const SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }
}
