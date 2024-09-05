import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:main_project/Providers/firestore_provider.dart';
import 'package:main_project/Providers/theme_provider.dart';
import 'package:main_project/admin_panel/components/admin_comment_card.dart';
import 'package:main_project/components/helper_function.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' as timeago;

class CommentsPage extends StatelessWidget {
  final String postId;
  CommentsPage({
    super.key,
    required this.postId,
  });

  final _firestore = FirebaseFirestore.instance;
  void _deleteComment(BuildContext context, String cmtId) {
    bool isDarkMode =
        Provider.of<ThemeProvider>(context, listen: false).isDarkMode;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Theme.of(context).colorScheme.secondary,
        content: Text(
          'Do you want to delete the comment?',
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
              _firestore
                  .collection("Posts")
                  .doc(postId)
                  .collection("Comments")
                  .doc(cmtId)
                  .delete()
                  .whenComplete(
                () {
                  // pop
                  close(context);
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
    bool isDarkMode =
        Provider.of<ThemeProvider>(context, listen: false).isDarkMode;
    final postAndCommentDataProvider =
        Provider.of<PostAndCommentDataProvider>(context);
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Theme.of(context).colorScheme.primary,
        backgroundColor: Colors.transparent,
        title: Text("Comments"),
      ),
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: StreamBuilder<Map<String, dynamic>>(
        stream: postAndCommentDataProvider.getPostAndCommentData(postId),
        builder: (context, snapshot) {
          // Show errors
          if (snapshot.hasError) {
            return Center(
              child: Text(
                snapshot.error.toString(),
              ),
            );
          }

          // Show loading circle while waiting for data
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(
                color: Theme.of(context).colorScheme.primary,
              ),
            );
          }

          // If snapshot has data
          if (snapshot.hasData) {
            var postData = snapshot.data!['postData'];
            var comments =
                snapshot.data!['cmtData'] as List<QueryDocumentSnapshot>;

            // No comments
            if (comments.isEmpty) {
              return Center(
                child: Text('No Comments'),
              );
            }

            return ListView.builder(
              itemCount: comments.length,
              itemBuilder: (context, index) {
                // Get each individual comment
                final DocumentSnapshot comment = comments[index];
                Timestamp timestamp = comment['TimeStamp'];
                DateTime dateTime = timestamp.toDate();
                String timeAgo = timeago.format(dateTime);

                return AdminCommentCard(
                  time: timeAgo,
                  comment: comment['comment'],
                  username: comment['username'],
                  postID: postId,
                  cmtId: comment.id,
                  onPressed: () {
                    _deleteComment(context, comment.id);
                  },
                );
              },
            );
          }

          // Handle case when snapshot has no data
          return Center(
            child: Text('No Data Available'),
          );
        },
      ),
    );
  }
}
