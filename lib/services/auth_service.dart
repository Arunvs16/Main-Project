import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  // get instance of the auth
  final _auth = FirebaseAuth.instance;

  final _firestore = FirebaseFirestore.instance;

  // get the current user & uid
  User? getCurrentUser() => _auth.currentUser;
  String getCurrentUserUid() => _auth.currentUser!.uid;
  String getCurrentUserEmail() => _auth.currentUser!.email.toString();
  String getCurrentUserUsername() => _auth.currentUser!.displayName.toString();

  // login
  Future<UserCredential> loginEmailPassword(String email, password) async {
    // attempt login
    try {
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential;
    }
    // catch any errors
    on FirebaseAuthException catch (e) {
      throw Exception(e.code);
    }
  }

  // register
  Future<UserCredential> registerEmailPassword(String email, password) async {
    // attempt register
    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential;
    }
    // catch any errors
    on FirebaseAuthException catch (e) {
      throw Exception(e.code);
    }
  }

  // logout
  Future<void> logout() async {
    await _auth.signOut();
  }

  // -------------------------------------------------------------------------------

  // delete user from firebase authentication
  Future<void> deleteUserAuth(String email, String password) async {
    WriteBatch batch = _firestore.batch();

    User? user = _auth.currentUser;

    if (user != null) {
      // Re-authenticate the user
      AuthCredential credential =
          EmailAuthProvider.credential(email: email, password: password);

      try {
        await user.reauthenticateWithCredential(credential);

        // Delete user data in Firestore
        DocumentReference userDoc =
            _firestore.collection("Users").doc(user.uid);
        batch.delete(userDoc);

        // Delete user posts
        QuerySnapshot userPosts = await _firestore
            .collection("Posts")
            .where('uid', isEqualTo: user.uid)
            .get();

        for (var post in userPosts.docs) {
          batch.delete(post.reference);
        }

        // Delete user comments
        QuerySnapshot userComments = await _firestore
            .collection("Comments")
            .where('uid', isEqualTo: user.uid)
            .get();

        for (var comment in userComments.docs) {
          batch.delete(comment.reference);
        }

        // Commit the batch
        await batch.commit();

        // Delete the user's authentication data
        await user.delete();
      } on FirebaseAuthException catch (e) {
        throw Exception("Failed to delete user: ${e.code}");
      }
    } else {
      throw Exception("No user is currently signed in.");
    }
  }

  // delete user details
  Future<void> deleteUser(String uid) async {
    WriteBatch batch = _firestore.batch();

    try {
      // Delete user data in Firestore
      DocumentReference userDoc = _firestore.collection("Users").doc(uid);
      batch.delete(userDoc);

      // Delete user posts
      QuerySnapshot userPosts = await _firestore
          .collection("Posts")
          .where('uid', isEqualTo: uid)
          .get();

      for (var post in userPosts.docs) {
        batch.delete(post.reference);
      }

      // Delete user comments
      QuerySnapshot userComments = await _firestore
          .collection("Comments")
          .where('uid', isEqualTo: uid)
          .get();

      for (var comment in userComments.docs) {
        batch.delete(comment.reference);
      }

      // Commit the batch
      await batch.commit();
    } on FirebaseAuthException catch (e) {
      throw Exception("Failed to delete: ${e.code}");
    }
  }

  //---------------------------------------------------------------

  // Google Sign in

  final GoogleSignIn googleSignIn = GoogleSignIn();

  // Google sign In
  signInWithGoogle() async {
    //begin interactive sign in process
    final GoogleSignInAccount? gUser = await GoogleSignIn().signIn();

    //obtain auth details from request
    final GoogleSignInAuthentication gAuth = await gUser!.authentication;

    //create a new credential for user
    final credential = GoogleAuthProvider.credential(
      accessToken: gAuth.accessToken,
      idToken: gAuth.idToken,
    );

    //finally, lets sign in
    return FirebaseAuth.instance.signInWithCredential(credential);
  }

  // Google sign out
  Future signOutWithGoogle() async {
    return googleSignIn.signOut();
  }
}
