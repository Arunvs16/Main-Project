import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:main_project/Providers/firestore_provider.dart';
import 'package:main_project/components/comment_card.dart';
// import 'package:main_project/components/helper_function.dart';
import 'package:main_project/components/my_text_field.dart';
import 'package:provider/provider.dart';

class CommentPage extends StatelessWidget {
  // final postId;
  CommentPage({
    super.key,
    // required this.postId,
  });

  // user
  final currentUser = FirebaseAuth.instance.currentUser!;

  // text controller
  final textController = TextEditingController();

  // CollectionReference posts = FirebaseFirestore.instance.collection("posts");
  void postMessage() {
    if (textController.text.isNotEmpty) {
      FirebaseFirestore.instance.collection("comments").add({
        'username': currentUser.email,
        'comment': textController.text,
        'likes': [],
        'Timestamp': Timestamp.now(),
      });
    }
    textController.clear();
  }

  @override
  Widget build(BuildContext context) {
    final commentDataProvider = Provider.of<CommentDataProvider>(context);
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
                stream: commentDataProvider.oderedDataStream,
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
                      itemCount: snapshot.data!.docs.length,
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
            // post method
            Padding(
              padding: const EdgeInsets.all(25.0),
              child: Row(
                children: [
                  Expanded(
                    child: MyTextField(
                      controller: textController,
                      hintText: "Type somthimg",
                      obscuretext: false,
                    ),
                  ),
                  // post icon
                  GestureDetector(
                    onTap: postMessage,
                    child: Container(
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.secondary,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Icons.send),
                    ),
                  ),
                ],
              ),
            ),
            // logged in as
            Text("Logged in as: ${currentUser.email}"),
            const SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }
}
