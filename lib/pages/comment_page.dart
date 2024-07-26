import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:main_project/Providers/firestore_provider.dart';
import 'package:main_project/Providers/theme_provider.dart';
import 'package:provider/provider.dart';
import 'package:main_project/components/comment_card.dart';
import 'package:main_project/components/my_text_field.dart';

class CommentPage extends StatelessWidget {
  CommentPage({super.key});

  // user
  final currentUser = FirebaseAuth.instance.currentUser!;

  // text controller
  final textController = TextEditingController();

  void postComment(BuildContext context) {
    if (textController.text.isNotEmpty) {
      Provider.of<CommentDataProvider>(context, listen: false)
          .postComment(textController.text, currentUser.email!);
    }
    textController.clear();
  }

  @override
  Widget build(BuildContext context) {
    final commentDataProvider = Provider.of<CommentDataProvider>(context);
    bool isDarkMode =
        Provider.of<ThemeProvider>(context, listen: false).isDarkMode;

    return Scaffold(
      appBar: AppBar(
        foregroundColor: Theme.of(context).colorScheme.primary,
        backgroundColor: Colors.transparent,
        title: Text("Comments"),
      ),
      body: Center(
        child: Column(
          children: [
            // comments
            Expanded(
              child: StreamBuilder(
                stream: commentDataProvider.orderedDataStream,
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return Center(
                      child: Text(
                        "Error: ${snapshot.error}",
                      ),
                    );
                  } else if (snapshot.connectionState ==
                      ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    );
                  } else if (snapshot.hasData) {
                    final List<DocumentSnapshot> docs = snapshot.data!.docs;
                    return ListView.builder(
                      itemCount: docs.length,
                      itemBuilder: (context, index) {
                        final DocumentSnapshot post = docs[index];
                        return CommentCard(
                          comment: post['comment'],
                          username: post['username'],
                          postID: post.id,
                          likes: List<String>.from(post['likes'] ?? []),
                        );
                      },
                    );
                  } else {
                    // no data
                    return Center(
                      child: Text("No comments found"),
                    );
                  }
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(25.0),
              child: Row(
                children: [
                  Expanded(
                    child: MyTextField(
                      controller: textController,
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
