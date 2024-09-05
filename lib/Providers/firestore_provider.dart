import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:main_project/Providers/theme_provider.dart';
import 'package:provider/provider.dart';

class UserDataProvider with ChangeNotifier {
  // User
  final User currentUser = FirebaseAuth.instance.currentUser!;

  // Firestore instance
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  // Collection reference
  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection("Users");

  Future<void> editBioField(BuildContext context, String field) async {
    String newValue = "";
    bool isDarkMode =
        Provider.of<ThemeProvider>(context, listen: false).isDarkMode;
    bool saveClicked = false; // Flag to check if save button is clicked

    // Bio----------------------------------------------------------------------
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Theme.of(context).colorScheme.secondary,
        title: Text(
          "Edit $field",
          style: TextStyle(
            color: isDarkMode
                ? Theme.of(context).colorScheme.inversePrimary
                : Theme.of(context).colorScheme.primary,
          ),
        ),
        content: TextField(
          autofocus: true,
          style: TextStyle(
            color: isDarkMode
                ? Theme.of(context).colorScheme.inversePrimary
                : Theme.of(context).colorScheme.primary,
          ),
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
          // Cancel button
          MaterialButton(
            color: isDarkMode
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).colorScheme.secondary,
            onPressed: () => Navigator.pop(context),
            child: Text(
              "Cancel",
              style: TextStyle(
                color: isDarkMode
                    ? Theme.of(context).colorScheme.inversePrimary
                    : Theme.of(context).colorScheme.primary,
              ),
            ),
          ),

          // Save button
          MaterialButton(
            color: Theme.of(context).colorScheme.onPrimary,
            onPressed: () {
              saveClicked = true; // Set the flag when save button is clicked
              Navigator.of(context).pop();
              print("$field changed to -> $newValue");
            },
            child: Text(
              "Save",
              style: TextStyle(
                color: Theme.of(context).colorScheme.inversePrimary,
              ),
            ),
          ),
        ],
      ),
    );

    // Update in Firestore only if save button was clicked and newValue is not empty
    if (saveClicked && newValue.trim().isNotEmpty) {
      await firestore.collection("Users").doc(currentUser.uid).update(
        {
          field: newValue,
        },
      );

      notifyListeners();
    }
  }

  // username
  Future<void> editUsernameField(
      String newValue, String field, String postId) async {
    // in user collection
    if (newValue.isNotEmpty) {
      await firestore.collection("Users").doc(currentUser.uid).update({
        field: newValue,
      });
      notifyListeners();
    }
    // in post collection
    if (newValue.isNotEmpty) {
      await firestore.collection("Posts").doc(postId).update({
        field: newValue,
      });
      notifyListeners();
    }
  }

  // name
  Future<void> editNameField(String newValue, field) async {
    // in user collection
    if (newValue.isNotEmpty) {
      await firestore.collection("Users").doc(currentUser.uid).update({
        field: newValue,
      });
      notifyListeners();
    }
  }
}

class PostAndCommentDataProvider with ChangeNotifier {
  final _firestore = FirebaseFirestore.instance;

  // Stream to get post & comment info
  Stream<Map<String, dynamic>> getPostAndCommentData(String postId) {
    try {
      var postRef = _firestore.collection("Posts").doc(postId);
      var cmtRef =
          postRef.collection("Comments").orderBy('TimeStamp', descending: true);

      // Stream both post data and comments
      return postRef.snapshots().asyncMap((postSnapshot) async {
        var cmtSnapshot = await cmtRef.get();
        var postData = postSnapshot.data();
        var cmtData =
            cmtSnapshot.docs; // This is a list of QueryDocumentSnapshot

        return {
          'postData': postData,
          'cmtData': cmtData,
        };
      });
    } catch (e) {
      print("Error fetching data: $e");
      return Stream.error("Error fetching data: $e");
    }
  }

  // Save comments to Firestore
  Future<void> postCommentToFirestore({
    required String postId,
    required dynamic data,
  }) async {
    try {
      await _firestore
          .collection("Posts")
          .doc(postId)
          .collection("Comments")
          .add(data);
      notifyListeners();
    } catch (e) {
      print("Error posting comment: ${e.toString()}");
    }
  }

  // Method to like or unlike a comment
  Future<void> toggleLike(
    String postId,
    String cmtId,
    String userEmail,
    bool isLiked,
  ) async {
    final CollectionReference commentCollection =
        _firestore.collection("Posts").doc(postId).collection("Comments");

    DocumentReference postRef = commentCollection.doc(cmtId);

    try {
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
    } catch (e) {
      print("Error toggling like: ${e.toString()}");
    }
  }
}

class PostAndUserDatasProvider extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Stream to get user and post data in real-time
  Stream<Map<String, dynamic>> getUserAndPostDataStream(String uid) {
    try {
      var userRef = _firestore.collection("Users").doc(uid);
      var postRef =
          _firestore.collection("Posts").orderBy('timestamp', descending: true);
      // Stream both user and post datas
      return userRef.snapshots().asyncMap((userSnapshot) async {
        var postSnapShot = await postRef.get();
        var userData = userSnapshot.data();
        var postData = postSnapShot.docs;

        return {
          'userData': userData,
          'postData': postData,
        };
      });
    } catch (e) {
      return Stream.error("Error fetching data: $e");
    }
  }

  // Method to like or unlike a post
  Future<void> toggleLike(String postId, String userEmail, bool isLiked) async {
    final CollectionReference postCollection = _firestore.collection("Posts");
    DocumentReference postRef = postCollection.doc(postId);

    try {
      if (isLiked) {
        print("?????????????????????????");
        await postRef.update({
          'likes': FieldValue.arrayUnion([userEmail])
        });
        notifyListeners();
      } else {
        await postRef.update({
          'likes': FieldValue.arrayRemove([userEmail])
        });
      }
      notifyListeners();
    } catch (e) {
      print("Error toggling like: ${e.toString()}");
    }
  }
}
