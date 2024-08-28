import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  // get instance of the auth
  final _auth = FirebaseAuth.instance;

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

  // delete

//---------------------------------------------------------------
  // Google Sign in

  final GoogleSignIn googleSignIn = GoogleSignIn();

  // Google sign In
  signInWithGoogle() async {
    //begin interactivesign in process
    final GoogleSignInAccount? gUser = await GoogleSignIn().signIn();

    //obtain auth details from request
    final GoogleSignInAuthentication gAuth = await gUser!.authentication;

    //create a new credntial for user
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
