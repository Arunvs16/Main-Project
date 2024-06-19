import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  signUp(String email, String password) async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

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
}
