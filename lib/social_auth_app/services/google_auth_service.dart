import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    clientId:
        '194181182615-r0jmmonviioh9r77fk4k99ot01n4ir55.apps.googleusercontent.com',
    scopes: ["email"],
  );

  Future<User?> signinwithGoogle() async {
    try {
      //  Open Google login popup,googleUser contains the Google account the user selected
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return null; // cancel the popup.
      //Get authentication tokens (idToken and accessToken) for the selected Google user."
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      //  Create Firebase credential because firebase didnot understand google tokens
      final credentials = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      //  Sign in to Firebase(Verifies credentials, create firebase user and login to your app.)
      final UserCredential userCredential = await _auth.signInWithCredential(
        credentials,
      );
      final user = userCredential.user;
      //  Store user in Firestore
      await _firestore.collection("users").doc(user!.uid).set(
        {
          "name": user.displayName,
          "email": user.email,
          "photo": user.photoURL,
          "uid": user.uid,
          "last login": DateTime.now(),
        },
        SetOptions(merge: true),
      ); // update only the fields you provide, keep the rest of the document unchanged.
      return user;
    } catch (e) {
      print("Google Sign Error:$e");
      rethrow;
    }
  }

  Future<void> signOut() async {
    _auth.signOut();
    _googleSignIn.signOut();
  }
}
