import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:main_project/model/user.dart';

class Firestore {
  // get intance of auth & Firestore
  final _auth = FirebaseAuth.instance;

  final _firestore = FirebaseFirestore.instance;

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

}
