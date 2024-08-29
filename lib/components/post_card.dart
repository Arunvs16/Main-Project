import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:main_project/Providers/firestore_provider.dart';
import 'package:main_project/Providers/theme_provider.dart';
import 'package:main_project/components/like_button.dart';
import 'package:main_project/pages/comment_page.dart';
import 'package:provider/provider.dart';

class PostCard extends StatelessWidget {
  final String timeAgo, caption, imageURL, username, postId;
  final List<String> likes;

  final void Function()? onPressedDlt;
  const PostCard({
    super.key,
    required this.caption,
    required this.username,
    required this.timeAgo,
    required this.imageURL,
    required this.onPressedDlt,
    required this.postId,
    required this.likes,
  });

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser!;
    final isLiked = likes.contains(currentUser.email);
    final postLikeProvider =
        Provider.of<PostLikeProvider>(context, listen: false);
    bool isDarkMode =
        Provider.of<ThemeProvider>(context, listen: false).isDarkMode;

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondary,
        border:
            Border.all(color: Theme.of(context).colorScheme.primary, width: 1),
      ),
      height: MediaQuery.of(context).size.height * 0.75,
      child: Column(
        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      // profile pic
                      Container(
                        margin: EdgeInsets.only(left: 10, top: 10),
                        height: MediaQuery.of(context).size.height * 0.05,
                        width: MediaQuery.of(context).size.height * 0.05,
                        child: CircleAvatar(
                          backgroundImage: AssetImage('images/person.jpg'),
                        ),
                      ),
                      SizedBox(width: 20),
                      Container(
                        margin: EdgeInsets.only(left: 1, top: 10),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // username

                            Text(
                              username,
                              style: TextStyle(
                                // fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                            // post time
                            Text(
                              timeAgo,
                              style: TextStyle(
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  // delete
                  IconButton(
                    onPressed: onPressedDlt,
                    icon: Icon(
                      Icons.more_vert,
                    ),
                  )
                ],
              ),
              Row(
                children: [
                  // caption
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10.0, vertical: 10),
                    child: Text(caption),
                  ),
                ],
              ),

              // image
              Container(
                height: MediaQuery.of(context).size.height * .55,
                width: MediaQuery.of(context).size.width,
                child: Container(
                  height: MediaQuery.of(context).size.height * .50,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(color: Colors.transparent),
                  child: Image.network(
                    imageURL,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    },
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        child: Icon(Icons.error_outline),
                      );
                    },
                  ),
                ),
              ),
              Container(
                color: Colors.transparent,
                height: MediaQuery.of(context).size.height * .084,
                width: MediaQuery.of(context).size.width,
                child: Center(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // like
                          LikeButton(
                              isLiked: isLiked,
                              onTap: () {
                                postLikeProvider.toggleLike(
                                    postId, currentUser.email!, isLiked);
                              }),

                          // like count
                          Text(
                            likes.length.toString(),
                            style: TextStyle(
                              color: isDarkMode
                                  ? Theme.of(context).colorScheme.inversePrimary
                                  : Theme.of(context).colorScheme.primary,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(width: 2),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // comments
                          IconButton(
                            icon: Icon(
                              Icons.comment,
                              color: isDarkMode
                                  ? Theme.of(context).colorScheme.inversePrimary
                                  : Theme.of(context).colorScheme.primary,
                              size: 25,
                            ),
                            onPressed: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => CommentPage(
                                    postId: postId,
                                  ),
                                )),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
