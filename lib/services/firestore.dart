import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:main_project/model/user.dart';
// import 'package:main_project/services/auth_service.dart';

class Firestore {
  // get intance of auth & Firestore
  final _auth = FirebaseAuth.instance;

  final _firestore = FirebaseFirestore.instance;

  // final _authenticaton = AuthService();

  // User details
  CollectionReference usersRef = FirebaseFirestore.instance.collection('Users');
  getUserDetails() async {
    User currentUser = _auth.currentUser!;
    DocumentSnapshot documentSnapshot =
        await usersRef.doc(currentUser.uid).get();
    return UserProfile.fromMap(documentSnapshot);
  }

  // USER PROFILE---------------------------------------------------------------

  // save user info-------------------------------------------------------------
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

  //  get user & Post info -----------------------------------------------------
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

  // get current user and posts
  Future<Map<String, dynamic>> getCurrentUserAndPostData(String uid) async {
    try {
      var userRef = _firestore.collection("Users").doc(uid);
      var postRef = _firestore
          .collection("Posts")
          .where('email', isEqualTo: _auth.currentUser!.uid)
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

  // LIKE-----------------------------------------------------------------------

  // COMMENTS-------------------------------------------------------------------
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
    } catch (e) {
      print(e.toString());
    }
  }

  // ACCOUNT STUFF
}
