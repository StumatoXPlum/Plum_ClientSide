import 'package:cloud_firestore/cloud_firestore.dart' as firebase_auth;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as supabse;

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final firebase_auth.FirebaseFirestore _firestore =
      firebase_auth.FirebaseFirestore.instance;

  Future<User?> signInWithGoogle() async {
    try {
      await _googleSignIn.signOut();
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return null;

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential = await _auth.signInWithCredential(
        credential,
      );
      final User? user = userCredential.user;

      if (user != null) {
        await _saveUserToDatabase(user);
      }

      return user;
    } catch (e) {
      print("Sign in Error: $e");
      return null;
    }
  }

  Future<void> _saveUserToDatabase(User user) async {
    firebase_auth.DocumentSnapshot doc =
        await _firestore.collection('users').doc(user.uid).get();

    if (!doc.exists) {
      await _firestore.collection('users').doc(user.uid).set({
        'name': user.displayName ?? "there",
        'email': user.email,
        'phoneNumber': "",
        'dateOfBirth': "",
      });
    }
  }

  Future<void> signOut() async {
    await _googleSignIn.signOut();
    await _auth.signOut();
    await supabse.Supabase.instance.client.auth.signOut(
      scope: supabse.SignOutScope.local,
    );
  }
}
