import 'package:aloha_funds/core/bottom_navigation_bar.dart';
import 'package:aloha_funds/user_onboarding/sign_up_screen/cubit/auth_cubit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../phone_number/phone_number.dart';

class AuthService {
  final SupabaseClient _supabase = Supabase.instance.client;
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    serverClientId:
        "953137529505-fj6v6tb82pd1m7daof2jdvu05llh8bb4.apps.googleusercontent.com",
  );

  Future<void> _storeUserInSupabase(User user) async {
    try {
      final email = user.email ?? user.userMetadata?['email'] ?? '';
      final name = user.userMetadata?['full_name'] ?? '';
      final avatarUrl =
          "https://api.dicebear.com/9.x/open-peeps/svg?seed=${user.id}";

      if (email.isEmpty) {
        return;
      }

      final existingUser =
          await _supabase
              .from('users')
              .select('id, name, avatar_url, phonenumber')
              .eq('email', email)
              .maybeSingle();

      if (existingUser != null) {
        await _supabase
            .from('users')
            .update({
              if (name.isNotEmpty && existingUser['name'] == null) 'name': name,
              if (existingUser['avatar_url'] == null) 'avatar_url': avatarUrl,
            })
            .eq('id', existingUser['id']);
      } else {
        await _supabase.from('users').insert({
          'id': user.id,
          'email': email,
          'name': name,
          'phonenumber': "",
          'avatar_url': avatarUrl,
          'saved_reports': [],
        });
      }
    } catch (error) {
      print("Supabase User Insert Error: $error");
    }
  }

  Future<User?> signInWithGoogle(BuildContext context) async {
    try {
      await _googleSignIn.signOut();
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        return null;
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      if (googleAuth.idToken == null) {
        _showSnackBar(context, "Google Sign-In failed. Try again.");
        return null;
      }

      final AuthResponse response = await _supabase.auth.signInWithIdToken(
        provider: OAuthProvider.google,
        idToken: googleAuth.idToken!,
      );

      final User? user = response.user;
      if (user == null) return null;

      context.read<AuthCubit>().setUserId(user.id);
      await _storeUserInSupabase(user);
      _navigateBasedOnUser(context, user);

      return user;
    } catch (e) {
      print("Google Sign-In Error: $e");
      _showSnackBar(context, "Google Sign-In Error: $e");
      return null;
    }
  }

  Future<User?> signInWithApple(BuildContext context) async {
    try {
      final bool signInResult = await Supabase.instance.client.auth
          .signInWithOAuth(OAuthProvider.apple, scopes: 'name email');

      if (signInResult) {
        final event =
            await Supabase.instance.client.auth.onAuthStateChange
                .where((event) => event.session != null)
                .first;

        final User? user = event.session?.user;
        if (user != null) {
          context.read<AuthCubit>().setUserId(user.id);
          await _storeUserInSupabase(user);
          _navigateBasedOnUser(context, user);
          return user;
        }
      }
      return null;
    } catch (e) {
      print("Apple Sign-In Error: $e");
      if (e is AuthException) {
        print("Error message: ${e.message}");
        print("Status code: ${e.statusCode}");
      }
      _showSnackBar(context, "Apple Sign-In Error: $e");
      return null;
    }
  }

  void _navigateBasedOnUser(BuildContext context, User user) async {
    try {
      final response =
          await _supabase
              .from('users')
              .select('phonenumber')
              .eq('id', user.id)
              .maybeSingle();

      if (response != null) {
        if (response['phonenumber'] == null ||
            response['phonenumber'].isEmpty) {
          Navigator.push(
            context,
            CupertinoPageRoute(builder: (context) => PhoneNumber()),
          );
        } else {
          Navigator.pushReplacement(
            context,
            CupertinoPageRoute(builder: (context) => BottomNavScreen()),
          );
        }
      }
    } catch (error) {
      print("Navigation Error: $error");
    }
  }

  Future<void> signOut() async {
    await _googleSignIn.signOut();
    await _supabase.auth.signOut();
  }

  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), behavior: SnackBarBehavior.floating),
    );
  }
}
