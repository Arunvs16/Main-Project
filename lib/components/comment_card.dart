import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:main_project/components/like_button.dart';

class CommentCard extends StatefulWidget {
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
  State<CommentCard> createState() => _CommentCardState();
}

class _CommentCardState extends State<CommentCard> {
  final currentUser = FirebaseAuth.instance.currentUser!;
  bool isLiked = false;

  @override
  void initState() {
    super.initState();
    isLiked = widget.likes.contains(currentUser.email);
  }

  // Toggle like
  void toggleLike() {
    setState(() {
      isLiked = !isLiked;
    });

    // Update likes in Firestore
    DocumentReference postRef =
        FirebaseFirestore.instance.collection("comments").doc(widget.postID);

    if (isLiked) {
      // if the post is now liked, add the user's email to "likes" field
      postRef.update({
        'likes': FieldValue.arrayUnion([currentUser.email])
      });
    } else {
      // if the post is now unliked, remove the user's email from the "likes" field
      postRef.update({
        'likes': FieldValue.arrayRemove([currentUser.email])
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.tertiary,
        borderRadius: BorderRadius.circular(8),
      ),
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      margin: EdgeInsets.all(20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              // Profile pic
              CircleAvatar(
                backgroundColor: Colors.transparent,
                backgroundImage: NetworkImage(
                  "https://cdn1.iconfinder.com/data/icons/google-s-logo/150/Google_Icons-09-512.png",
                ),
                radius: 25,
              ),
              const SizedBox(width: 10),
              // Comment and username
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Username
                  Text(
                    widget.username,
                    style:
                        TextStyle(color: Theme.of(context).colorScheme.primary),
                  ),
                  const SizedBox(height: 10),
                  // Comment
                  Text(widget.comment),
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
                    onTap: toggleLike,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  // Likes count
                  Text(widget.likes.length.toString()),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
