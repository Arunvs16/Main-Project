import 'package:firebase_auth/firebase_auth.dart';

class AdminAuthPage {
  // firebase instance
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final String _adminEmail = 'admin@gmail.com';
  final String _adminPassword = '123123123';

  Future<UserCredential> adminSignIn(String email, String password) async {
    try {
      if (email == _adminEmail && password == _adminPassword) {
        UserCredential credential = await _auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
        return credential;
      } else {
        throw FirebaseAuthException(code: 'Inalid', message: 'Invalid');
      }
    } on FirebaseAuthException catch (e) {
      throw Exception('Error: ${e.message}');
    }
  }
}
