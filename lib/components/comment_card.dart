import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:main_project/Providers/firestore_provider.dart';
import 'package:main_project/Providers/theme_provider.dart';
import 'package:main_project/components/like_button.dart';
import 'package:provider/provider.dart';

class CommentCard extends StatelessWidget {
  final String comment;
  final String username;
  final String postID;
  final List<String> likes;

  const CommentCard({
    super.key,
    required this.comment,
    required this.username,
    required this.postID,
    required this.likes,
  });

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser!;
    final isLiked = likes.contains(currentUser.email);
    final commentDataProvider =
        Provider.of<CommentDataProvider>(context, listen: false);
    bool isDarkMode =
        Provider.of<ThemeProvider>(context, listen: false).isDarkMode;

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondary,
        borderRadius: BorderRadius.circular(8),
      ),
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      margin: EdgeInsets.all(10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              // Profile pic
              Container(
                // margin: EdgeInsets.only(left: 10, top: 10),
                height: MediaQuery.of(context).size.height * 0.06,
                width: MediaQuery.of(context).size.height * 0.06,
                child: CircleAvatar(
                  backgroundImage: AssetImage('images/person.jpg'),
                ),
              ),
              const SizedBox(width: 20),
              // Comment and username
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Username
                  Text(
                    username,
                    style: TextStyle(
                      color: isDarkMode
                          ? Theme.of(context).colorScheme.inversePrimary
                          : Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  // Comment
                  Text(
                    comment,
                    style: TextStyle(
                      color: isDarkMode
                          ? Theme.of(context).colorScheme.inversePrimary
                          : Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ],
              ),
            ],
          ),
          Row(
            children: [
              Column(
                children: [
                  // Likes
                  LikeButton(
                    isLiked: isLiked,
                    onTap: () {
                      commentDataProvider.toggleLike(
                          postID, currentUser.email!, !isLiked);
                    },
                  ),
                  // Likes count
                  Text(
                    likes.length.toString(),
                    style: TextStyle(
                        color: isDarkMode
                            ? Theme.of(context).colorScheme.inversePrimary
                            : Theme.of(context).colorScheme.primary),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
