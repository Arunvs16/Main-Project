import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:main_project/Providers/firestore_provider.dart';
import 'package:main_project/Providers/theme_provider.dart';
import 'package:main_project/components/like_button.dart';
import 'package:main_project/components/my_drawer.dart';
import 'package:main_project/components/my_text_field.dart';
import 'package:main_project/pages/chat_page.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  //user
  final user = FirebaseAuth.instance.currentUser!;

  // controller

  final postController = TextEditingController();
  void postComment(BuildContext context) {
    if (postController.text.isNotEmpty) {
      Provider.of<PostLikeProvider>(context, listen: false)
          .postLike(postController.text, user.email!);
    }
    postController.clear();
  }

  @override
  Widget build(BuildContext context) {
    final postLikeProvider = Provider.of<PostLikeProvider>(context);
    final commentDataProvider = Provider.of<CommentDataProvider>(context);
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
                MaterialPageRoute(
                  builder: (context) => ChatPage(),
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
          Padding(
            padding: const EdgeInsets.all(25.0),
            child: Row(
              children: [
                Expanded(
                  child: MyTextField(
                    controller: postController,
                    hintText: "Type something to share",
                    obscuretext: false,
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
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: StreamBuilder(
              stream: postLikeProvider.orderedDataStream,
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

                      final List<String> likes =
                          List<String>.from(post['likes'] ?? []);
                      final bool isLiked = likes.contains(user.email);
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // user name
                          Text(
                            post['username'],
                            style: TextStyle(
                              color: isDarkMode
                                  ? Theme.of(context).colorScheme.inversePrimary
                                  : Theme.of(context).colorScheme.primary,
                            ),
                          ),

                          // message
                          Text(
                            post['message'],
                            style: TextStyle(
                              color: isDarkMode
                                  ? Theme.of(context).colorScheme.inversePrimary
                                  : Theme.of(context).colorScheme.primary,
                            ),
                          ),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  // like icon
                                  LikeButton(
                                    isLiked: isLiked,
                                    onTap: () {
                                      postLikeProvider.toggleLike(
                                          post.id, user.email!, !isLiked);
                                    },
                                  ),

                                  // Likes count
                                  Text(
                                    likes.length.toString(),
                                    style: TextStyle(
                                      color: isDarkMode
                                          ? Theme.of(context)
                                              .colorScheme
                                              .inversePrimary
                                          : Theme.of(context)
                                              .colorScheme
                                              .primary,
                                    ),
                                  ),
                                ],
                              ),
                              Column(
                                children: [
                                  // comment icon
                                  IconButton(
                                    onPressed: () {
                                      Navigator.pushNamed(context, '/comments');
                                    },
                                    icon: Icon(
                                      Icons.insert_comment_rounded,
                                      color: isDarkMode
                                          ? Theme.of(context)
                                              .colorScheme
                                              .inversePrimary
                                          : Theme.of(context)
                                              .colorScheme
                                              .primary,
                                    ),
                                  ),
                                  // space
                                  Text(''),
                                ],
                              )
                            ],
                          )
                        ],
                      );
                    },
                  );
                } else {
                  return Center(
                    child: Text("No data found"),
                  );
                }
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

      //  Column(
      //   children: [
      //     // comment icon
      //     IconButton(
      //       onPressed: () {
      //         Navigator.pushNamed(context, '/comments');
      //       },
      //       icon: Icon(Icons.comment),
      //     ),

      //     // comment count
      //     Text("Comment count"),

      //     // like icon
      //     LikeButton(
      //       isLiked: isLiked,
      //       onTap: onTap,
      //     ),

      //     // like count
      //     Text("Comment count"),
      //   ],
      // ),
    );
  }
}
