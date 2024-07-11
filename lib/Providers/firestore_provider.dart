import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UserDataProvider {
  // user
  final currentUser = FirebaseAuth.instance.currentUser!;

  // firestore instance
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // stream of data from firestore document
  Stream<DocumentSnapshot> get documentStream {
    return _firestore.collection("Users").doc(currentUser.email).snapshots();
  }
}

class CommentDataProvider with ChangeNotifier {
  final CollectionReference commentsCollection =
      FirebaseFirestore.instance.collection("comments");

  // Stream to get ordered comments from Firestore
  Stream<QuerySnapshot> get orderedDataStream {
    return commentsCollection.orderBy('Timestamp', descending: true).snapshots();
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
