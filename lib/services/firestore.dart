import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:main_project/model/user.dart';

class Firestore {
  // get intance of auth & Firestore
  final _auth = FirebaseAuth.instance;

  final _firestore = FirebaseFirestore.instance;

  // USER PROFILE

  // save user info---------------------------------------------------------------
  Future<void> saveUserInfoInFirestore(
      {required String name, required String email}) async {
    // get current user uid
    String uid = _auth.currentUser!.uid;

    // extract username from email
    String username = email.split('@')[0];

    // create a user profile
    UserProfile user = UserProfile.UserData(
      uid: uid,
      name: name,
      username: username,
      email: email,
      bio: '',
      profilePic: '',
    );

    // convert user into a map so that we can store in firestore
    final userMap = user.toMap();

    // save user into info in firestore
    await _firestore.collection("Users").doc(uid).set(userMap);
  }

  //  get user & Post info -------------------------------------------------------
  Future<Map<String, dynamic>> getUserAndPostData(String uid) async {
    try {
      var userRef = _firestore.collection("Users").doc(uid);
      var postRef = _firestore
          .collection("Posts")
          .orderBy('timestamp', descending: true)
          .get();

      // Get both user data and post data in parallel
      DocumentSnapshot userSnapshot = await userRef.get();
      QuerySnapshot postSnapshot = await postRef;

      var userData = userSnapshot.data();
      var postData =
          postSnapshot.docs; // This is a list of QueryDocumentSnapshot

      return {
        'userData': userData,
        'postData': postData,
      };
    } catch (e) {
      throw Exception("Error fetching data: $e");
    }
  }

  // LIKE

  // COMMENTS

  // ACCOUNT STUFF
}
