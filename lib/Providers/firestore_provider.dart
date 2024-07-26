import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:main_project/Providers/theme_provider.dart';
import 'package:provider/provider.dart';

class UserDataProvider with ChangeNotifier {
  // user
  final currentUser = FirebaseAuth.instance.currentUser!;

  // firestore instance
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // all users
  final userCollection = FirebaseFirestore.instance.collection("Users");

  // stream of data from firestore document
  Stream<DocumentSnapshot> get documentStream {
    return _firestore.collection("Users").doc(currentUser.uid).snapshots();
  }

  void editField(BuildContext context, String field) async {
    String newValue = "";
    bool isDarkMode =
        Provider.of<ThemeProvider>(context, listen: false).isDarkMode;
    bool saveClicked = false; // Flag to check if save button is clicked

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Theme.of(context).colorScheme.secondary,
        title: Text(
          "Edit $field",
          style: TextStyle(
              color: isDarkMode
                  ? Theme.of(context).colorScheme.inversePrimary
                  : Theme.of(context).colorScheme.primary),
        ),
        content: TextField(
          autofocus: true,
          style: TextStyle(
              color: isDarkMode
                  ? Theme.of(context).colorScheme.inversePrimary
                  : Theme.of(context).colorScheme.primary),
          decoration: InputDecoration(
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: isDarkMode
                    ? Theme.of(context).colorScheme.inversePrimary
                    : Theme.of(context).colorScheme.primary,
              ),
            ),
            fillColor: isDarkMode
                ? Theme.of(context).colorScheme.secondary
                : Theme.of(context).colorScheme.tertiary,
            hintText: "Add new $field",
            hintStyle: TextStyle(
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          onChanged: (value) {
            newValue = value;
          },
        ),
        actions: [
          // cancel button
          MaterialButton(
            color: Theme.of(context).colorScheme.secondary,
            onPressed: () => Navigator.pop(context),
            child: Text(
              "Cancel",
              style: TextStyle(
                  color: isDarkMode
                      ? Theme.of(context).colorScheme.inversePrimary
                      : Theme.of(context).colorScheme.primary),
            ),
          ),

          // save button
          MaterialButton(
            color: Theme.of(context).colorScheme.primary,
            onPressed: () {
              saveClicked = true; // Set the flag when save button is clicked
              Navigator.of(context).pop();
              print('Bio updated => ${newValue}');
            },
            child: Text(
              "Save",
              style: TextStyle(
                  color: Theme.of(context).colorScheme.inversePrimary),
            ),
          ),
        ],
      ),
    );

    // update in firestore only if save button was clicked
    if (saveClicked && newValue.trim().isNotEmpty) {
      await userCollection.doc(currentUser.uid).update(
        {
          field: newValue,
        },
      );
    }
  }
}

class CommentDataProvider with ChangeNotifier {
  final CollectionReference commentsCollection =
      FirebaseFirestore.instance.collection("comments");

  // Stream to get ordered comments from Firestore
  Stream<QuerySnapshot> get orderedDataStream {
    return commentsCollection
        .orderBy('Timestamp', descending: true)
        .snapshots();
  }

  // Method to post a new comment
  void postComment(String comment, String username) {
    commentsCollection.add({
      'username': username,
      'comment': comment,
      'likes': [],
      'Timestamp': Timestamp.now(),
    });
    notifyListeners();
  }

  // Method to like or unlike a comment
  Future<void> toggleLike(String postId, String userEmail, bool isLiked) async {
    DocumentReference postRef = commentsCollection.doc(postId);

    if (isLiked) {
      await postRef.update({
        'likes': FieldValue.arrayUnion([userEmail])
      });
    } else {
      await postRef.update({
        'likes': FieldValue.arrayRemove([userEmail])
      });
    }
    notifyListeners();
  }
}

class PostLikeProvider extends ChangeNotifier {
  final CollectionReference likeCollection =
      FirebaseFirestore.instance.collection("post");

  // Stream to get ordered likes from Firestore
  Stream<QuerySnapshot> get orderedDataStream {
    return likeCollection.orderBy('Timestamp', descending: true).snapshots();
  }

  void postLike(String message, String username) {
    likeCollection.add({
      'username': username,
      'message': message,
      'likes': [],
      'Timestamp': Timestamp.now(),
    });
    notifyListeners();
  }

  // Method to like or unlike a comment
  Future<void> toggleLike(String postId, String userEmail, bool isLiked) async {
    DocumentReference postRef = likeCollection.doc(postId);

    if (isLiked) {
      await postRef.update({
        'likes': FieldValue.arrayUnion([userEmail])
      });
    } else {
      await postRef.update({
        'likes': FieldValue.arrayRemove([userEmail])
      });
    }
    notifyListeners();
  }
}
