import 'package:cloud_firestore/cloud_firestore.dart' as firebase_auth;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as supabse;

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final firebase_auth.FirebaseFirestore _firestore =
      firebase_auth.FirebaseFirestore.instance;

  static String getRandomAvatarUrl(String userId) {
    return "https://api.dicebear.com/7.x/notionists/png?seed=$userId";
  }

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

  Future<User?> signInWithApple() async {
    try {
      final appleCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );

      final OAuthProvider oAuthProvider = OAuthProvider("apple.com");
      final OAuthCredential credential = oAuthProvider.credential(
        idToken: appleCredential.identityToken,
        accessToken: appleCredential.authorizationCode,
      );

      final UserCredential userCredential = await FirebaseAuth.instance
          .signInWithCredential(credential);
      final User? user = userCredential.user;

      if (user != null) {
        await _saveUserToDatabase(user);
      }

      return user;
    } catch (e) {
      print("Apple Sign-In Error: $e");
      return null;
    }
  }

  Future<void> _saveUserToDatabase(User user) async {
    firebase_auth.DocumentSnapshot doc =
        await _firestore.collection('users').doc(user.uid).get();

    if (!doc.exists) {
      String avatarUrl = getRandomAvatarUrl(user.uid);
      await _firestore.collection('users').doc(user.uid).set({
        'uid': user.uid,
        'name': user.displayName ?? "there",
        'email': user.email,
        'phoneNumber': "",
        'dateOfBirth': "",
        'avatarUrl': avatarUrl,
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
