import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as supabase;
import 'package:task2/core/custom_button.dart';
import '../phone_number/phone_number.dart';
import '../sign_up_screen/auth_service/auth_service.dart';

class EnterNameScreen extends StatefulWidget {
  const EnterNameScreen({super.key});

  @override
  State<EnterNameScreen> createState() => _EnterNameScreenState();
}

class _EnterNameScreenState extends State<EnterNameScreen> {
  final TextEditingController _nameController = TextEditingController();
  bool isNameEntered = false;
  bool isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> saveUserToFirestore() async {
    if (!mounted) return;
    String name = _nameController.text.trim();
    if (name.isEmpty) return;

    setState(() {
      isLoading = true;
    });

    try {
      firebase_auth.User? firebaseUser =
          firebase_auth.FirebaseAuth.instance.currentUser;
      final supabase.User? supabaseUser =
          supabase.Supabase.instance.client.auth.currentUser;

      if (firebaseUser == null && supabaseUser == null) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Sign in first')));
        return;
      }

      String uid = firebaseUser?.uid ?? supabaseUser!.id;
      String email = firebaseUser?.email ?? supabaseUser!.email ?? "";
      String avatarUrl = AuthService.getRandomAvatarUrl(uid);

      await FirebaseFirestore.instance.collection('users').doc(uid).set({
        'name': name,
        'email': email,
        'avatarUrl': avatarUrl,
      }, SetOptions(merge: true));

      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const PhoneNumber()),
      );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: $e')));
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    double padding = size.width * 0.03;
    double fontSize = size.width * 0.05;

    return Scaffold(
      backgroundColor: const Color(0xff090D14),
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: padding * 1.6,
          vertical: padding * 2,
        ),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: size.height * 0.04),
              Text(
                "Hi!",
                style: GoogleFonts.urbanist(
                  fontSize: fontSize * 2,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                "Please enter your name",
                style: GoogleFonts.urbanist(
                  fontSize: fontSize,
                  color: Colors.white70,
                ),
              ),
              SizedBox(height: size.height * 0.04),
              TextField(
                controller: _nameController,
                keyboardType: TextInputType.name,
                onChanged: (value) {
                  setState(() {
                    isNameEntered = value.trim().isNotEmpty;
                  });
                },
                decoration: InputDecoration(
                  filled: true,
                  hintText: "Enter your name",
                  hintStyle: GoogleFonts.urbanist(color: Colors.white70),
                  fillColor: Colors.transparent,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Color(0xff3579DD)),
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xff3579DD)),
                  ),
                ),
                style: const TextStyle(color: Colors.white),
                cursorColor: Colors.white,
              ),
              SizedBox(height: size.height * 0.04),
              CustomButton(
                buttonText: "Continue",
                onTap:
                    isNameEntered && !isLoading ? saveUserToFirestore : () {},
              ),
            ],
          ),
        ),
      ),
    );
  }
}
