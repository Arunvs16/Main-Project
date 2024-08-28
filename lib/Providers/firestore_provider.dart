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
            color: Theme.of(context).colorScheme.secondary,
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
            color: Theme.of(context).colorScheme.primary,
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
  Future<void> editUsernameField(String newValue, String field) async {
    if (newValue.isNotEmpty) {
      await firestore.collection("Users").doc(currentUser.uid).update({
        field: newValue,
      });
      notifyListeners();
    }
  }

  // name
  Future<void> editNameField(String newValue, String field) async {
    if (newValue.isNotEmpty) {
      await firestore.collection("Users").doc(currentUser.uid).update({
        field: newValue,
      });
      notifyListeners();
    }
  }
}

class CommentDataProvider with ChangeNotifier {
  // COMMENTS-------------------------------------------------------------------
  final _firestore = FirebaseFirestore.instance;
  //  get post & comment info -----------------------------------------------------
  Future<Map<String, dynamic>> getPostAndCommentData(String postId) async {
    try {
      var postRef = _firestore.collection("Posts").doc(postId);
      var cmtRef = postRef
          .collection("Comments")
          .orderBy('TimeStamp', descending: true)
          .get();

      // Get both user data and post data in parallel
      DocumentSnapshot postSnapshot = await postRef.get();
      QuerySnapshot cmtSnapshot = await cmtRef;

      var postData = postSnapshot.data();
      var cmtData = cmtSnapshot.docs; // This is a list of QueryDocumentSnapshot

      return {
        'postData': postData,
        'cmtData': cmtData,
      };
    } catch (e) {
      throw Exception("Error fetching data: $e");
    }
  }

  // save comments to firetore
  Future<void> postCommentToFirestore(
      {required String postId, required dynamic data}) async {
    try {
      await FirebaseFirestore.instance
          .collection("Posts")
          .doc(postId)
          .collection("Comments")
          .add(data);
      notifyListeners();
    } catch (e) {
      print(e.toString());
    }
  }

  // Method to like or unlike a comment
  Future<void> toggleLike(
      String postId, String cmtId, String userEmail, bool isLiked) async {
    final CollectionReference commentCollection =
        _firestore.collection("Posts").doc(postId).collection("Comments");

    DocumentReference postRef = commentCollection.doc(cmtId);

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
      FirebaseFirestore.instance.collection("Posts");

  // Stream to get ordered likes from Firestore
  Stream<QuerySnapshot> get orderedDataStream {
    return likeCollection.orderBy('Timestamp', descending: true).snapshots();
  }

  void postLike() {
    likeCollection.add({
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

class FollowFollowing {
  Future<int> followsNum(String userId) async {
    QuerySnapshot followersSnapshot = await FirebaseFirestore.instance
        .collection("Followers")
        .doc(userId)
        .collection("userFollowers")
        .get();
    return followersSnapshot.docs.length;
  }

  Future<int> followingNum(String userId) async {
    QuerySnapshot followingSnapshot = await FirebaseFirestore.instance
        .collection("Following")
        .doc(userId)
        .collection("userFollowing")
        .get();
    return followingSnapshot.docs.length;
  }
}
