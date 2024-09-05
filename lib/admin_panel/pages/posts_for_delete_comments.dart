import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:main_project/Providers/firestore_provider.dart';
import 'package:main_project/admin_panel/pages/comments_page.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

class PostForDeleteComments extends StatelessWidget {
  PostForDeleteComments({super.key});

  final user = FirebaseAuth.instance.currentUser!;

  @override
  Widget build(BuildContext context) {
    final postAndUserDatasProvider =
        Provider.of<PostAndUserDatasProvider>(context, listen: false);
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        foregroundColor: Theme.of(context).colorScheme.primary,
        backgroundColor: Colors.transparent,
        title: Text("Select a post"),
      ),
      body: StreamBuilder(
        stream: postAndUserDatasProvider.getUserAndPostDataStream(user.uid),
        builder: (context, snapshot) {
          // errors
          if (snapshot.hasError) {
            return Center(
              child: Text(
                snapshot.error.toString(),
              ),
            );
          }
          // loading
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(
                color: Theme.of(context).colorScheme.onPrimary,
              ),
            );
          }

          // get datas
          var userData = snapshot.data!['userData'];
          var postData =
              snapshot.data!['postData'] as List<QueryDocumentSnapshot>;

          // empty posts
          if (postData.isEmpty) {
            return Center(
              child: Text('No Comments'),
            );
          }

          // has data
          return ListView.builder(
            itemCount: postData.length,
            itemBuilder: (context, index) {
              // get each individual post
              final post = postData[index];

              // get data from each post
              String username = post['username'];
              String caption = post['caption'];
              String imageURL = post['imageURL'];

              return InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    PageTransition(
                      child: CommentsPage(postId: post.id),
                      type: PageTransitionType.rightToLeft,
                    ),
                  );
                },
                child: Container(
                  margin: EdgeInsets.all(5),
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: Theme.of(context).colorScheme.primary,
                      width: 2,
                    ),
                  ),
                  height: 100,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // profile pic
                      Container(
                        padding: EdgeInsets.only(left: 10),
                        height: MediaQuery.of(context).size.height * 0.06,
                        width: MediaQuery.of(context).size.height * 0.06,
                        child: CircleAvatar(
                          backgroundImage: AssetImage('images/person.jpg'),
                        ),
                      ),
                      SizedBox(width: 10),

                      Column(
                        children: [
                          // username
                          Text(username),

                          SizedBox(height: 16),

                          // caption
                          Text(caption),
                        ],
                      ),

                      Spacer(),

                      Container(
                        height: 100,
                        width: 100,
                        child: Image.network(imageURL),
                      )
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
