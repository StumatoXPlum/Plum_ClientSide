import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as supabse;
import '../../../../core/bottom_navigation_bar.dart';
import '../../name_screen/enter_name_screen.dart';
import '../../phone_number/phone_number.dart';

class AuthService {
  final firebase_auth.FirebaseAuth _auth = firebase_auth.FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static String getRandomAvatarUrl(String userId) {
    return "https://api.dicebear.com/7.x/notionists/png?seed=$userId";
  }

  Future<User?> signInWithGoogle(BuildContext context) async {
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
      if (user == null) return null;

      QuerySnapshot querySnapshot =
          await _firestore
              .collection('users')
              .where('email', isEqualTo: user.email)
              .get();

      if (querySnapshot.docs.isNotEmpty) {
        DocumentSnapshot existingUserDoc = querySnapshot.docs.first;
        Map<String, dynamic> userData =
            existingUserDoc.data() as Map<String, dynamic>;

        if (existingUserDoc.id != user.uid) {
          await _firestore.collection('users').doc(user.uid).set(userData);
        }

        if (!userData.containsKey('phoneNumber') ||
            userData['phoneNumber'] == "") {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => PhoneNumber()),
          );
        } else if (!userData.containsKey('dateOfBirth') ||
            userData['dateOfBirth'] == "") {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => EnterNameScreen()),
          );
        } else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => BottomNavScreen()),
          );
        }
      } else {
        await _saveUserToDatabase(user);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => PhoneNumber()),
        );
      }
      return user;
    } catch (e) {
      print("Google Sign-In Error: $e");
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
    QuerySnapshot querySnapshot =
        await _firestore
            .collection('users')
            .where('email', isEqualTo: user.email)
            .limit(1)
            .get();
    if (querySnapshot.docs.isNotEmpty) {
      DocumentSnapshot existingUserDoc = querySnapshot.docs.first;
      String existingUid = existingUserDoc.id;
      if (existingUid != user.uid) {
        await _firestore.collection('users').doc(existingUid).update({
          'uid': user.uid,
        });
      }
    } else {
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
      scope: supabse.SignOutScope.global,
    );
  }
}
