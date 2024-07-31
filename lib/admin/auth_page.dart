import 'package:firebase_auth/firebase_auth.dart';

class AdminAuthPage {
  // firebase instance
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<UserCredential> adminSignIn(String email, String password) async {
    try {
      UserCredential credential = await adminSignIn(
        email,
        password,
      );
      return credential;
    } on FirebaseAuthException catch (e) {
      print(e.toString());
      throw (e.code);
    }
  }

  Future signOut() async {
    try {
      await _auth.signOut();
    } on FirebaseAuth catch (e) {
      print(e.toString());
      return e;
    }
  }
}
