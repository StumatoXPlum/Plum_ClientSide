import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as supabase;
import 'package:task2/presentation/points_screen/cubit/earned_points_cubit.dart';
import '../authentication_screens/date_of_birth/date_of_birth.dart';
import '../authentication_screens/sign_up_screen/auth_service/auth_service.dart';
import '../authentication_screens/sign_up_screen/view/sign_up_screen.dart';

class UserProfile extends StatefulWidget {
  const UserProfile({super.key});

  @override
  UserProfileState createState() => UserProfileState();
}

class UserProfileState extends State<UserProfile> {
  String name = "Loading...";
  String email = "Not Available";
  String phoneNumber = "Not Available";
  String dateOfBirth = "Not set yet";
  bool isGoogleSignIn = false;
  String avatarUrl = "";

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    final firebase_auth.FirebaseAuth firebaseAuth =
        firebase_auth.FirebaseAuth.instance;
    final supabase.SupabaseClient supabaseClient =
        supabase.Supabase.instance.client;

    firebase_auth.User? firebaseUser = firebaseAuth.currentUser;
    final supabase.User? supabaseUser = supabaseClient.auth.currentUser;

    String userId;
    if (firebaseUser != null) {
      isGoogleSignIn = true;
      email = firebaseUser.email ?? "Not Available";
      userId = firebaseUser.uid;
    } else if (supabaseUser != null) {
      isGoogleSignIn = false;
      email = supabaseUser.email ?? "Not Available";
      userId = supabaseUser.id;
    } else {
      return;
    }

    try {
      DocumentSnapshot userDoc =
          await FirebaseFirestore.instance
              .collection('users')
              .doc(userId)
              .get();

      if (userDoc.exists) {
        print("got firestor Data: ${userDoc.data()}");

        setState(() {
          phoneNumber =
              userDoc.data().toString().contains('phoneNumber')
                  ? userDoc['phoneNumber']
                  : "Not Available";

          dateOfBirth =
              userDoc.data().toString().contains('dateOfBirth') &&
                      userDoc['dateOfBirth'].toString().isNotEmpty
                  ? userDoc['dateOfBirth']
                  : "Not set yet";

          avatarUrl =
              userDoc.data().toString().contains('avatarUrl')
                  ? userDoc['avatarUrl']
                  : AuthService.getRandomAvatarUrl(userId);

          name =
              userDoc.data().toString().contains('name')
                  ? userDoc['name']
                  : (isGoogleSignIn ? email.split('@').first : "Not Available");

          print("got Name: $name");
        });
      } else {
        print("User does not exist");
      }
    } catch (e) {
      print("Error fething user: $e");
    }
  }

  Future<void> _signOut() async {
    final firebase_auth.FirebaseAuth firebaseAuth =
        firebase_auth.FirebaseAuth.instance;
    final supabase.SupabaseClient supabaseClient =
        supabase.Supabase.instance.client;

    final firebase_auth.User? firebaseUser = firebaseAuth.currentUser;
    final supabase.User? supabaseUser = supabaseClient.auth.currentUser;

    if (firebaseUser != null) {
      await firebaseAuth.signOut();
    } else if (supabaseUser != null) {
      await supabaseClient.auth.signOut();
    }

    if (mounted) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => SignUpScreen()),
        (route) => false,
      );
    }
  }

  Future<void> navigateToDateOfBirthScreen() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => DateOfBirth(isFromProfile: true)),
    );
    fetchUserData();
  }

  Widget buildTextField(
    String label,
    String value,
    IconData icon, {
    bool isReadOnly = false,
    VoidCallback? onTap,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.urbanist(fontSize: 16, color: Colors.white),
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: onTap,
          child: AbsorbPointer(
            absorbing: onTap != null,
            child: TextField(
              controller: TextEditingController(text: value),
              readOnly: isReadOnly,
              decoration: InputDecoration(
                prefixIcon: Icon(icon, color: Colors.white70),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                filled: true,
                fillColor: Colors.transparent,
              ),
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    double padding = size.width * 0.03;
    double fontSize = size.width * 0.05;

    return Scaffold(
      backgroundColor: const Color(0xff090D14),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: padding * 1.6),
            child: Column(
              children: [
                Row(
                  children: [
                    Align(
                      alignment: Alignment.topLeft,
                      child: GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: SvgPicture.asset(
                          "assets/sign_up_assets/back.svg",
                        ),
                      ),
                    ),
                    Spacer(),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: padding * 0.4,
                        vertical: padding * 0.3,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.white60, width: 1),
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: Row(
                        children: [
                          SvgPicture.asset(
                            "assets/home_assets/coin.svg",
                            height: size.height * 0.02,
                            width: size.width * 0.02,
                            fit: BoxFit.scaleDown,
                          ),
                          SizedBox(width: size.width * 0.02),
                          BlocBuilder<EarnedPointsCubit, int>(
                            builder: (context, state) {
                              return Text(
                                "$state",
                                style: GoogleFonts.urbanist(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: fontSize * 0.8,
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Center(
                  child: Container(
                    padding: EdgeInsets.all(padding * 1.2),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Color(0xff3579DD), width: 4),
                    ),
                    child: ClipOval(
                      child: Image.network(
                        avatarUrl.isNotEmpty
                            ? avatarUrl
                            : AuthService.getRandomAvatarUrl(email),
                        height: size.height * 0.15,
                        width: size.width * 0.3,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: size.height * 0.02),
                Text(
                  name,
                  style: GoogleFonts.urbanist(
                    color: Colors.white,
                    fontSize: fontSize,
                  ),
                ),
                SizedBox(height: size.height * 0.03),
                buildTextField(
                  "Your Email",
                  email,
                  Icons.mail_outline,
                  isReadOnly: true,
                ),
                SizedBox(height: size.height * 0.02),
                buildTextField(
                  "Phone Number",
                  phoneNumber,
                  Icons.phone,
                  isReadOnly: true,
                ),
                SizedBox(height: size.height * 0.02),
                buildTextField(
                  "Date of Birth",
                  dateOfBirth,
                  Icons.calendar_today,
                  isReadOnly: true,
                  onTap: navigateToDateOfBirthScreen,
                ),
                SizedBox(height: size.height * 0.04),
                GestureDetector(
                  onTap: _signOut,
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: padding * 1.5),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      border: Border.all(color: Color(0xff3579DD)),
                      borderRadius: BorderRadius.circular(42),
                    ),
                    child: Center(
                      child: Text(
                        "Log Out",
                        style: GoogleFonts.urbanist(
                          fontSize: fontSize,
                          color: Color(0xff3579DD),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
