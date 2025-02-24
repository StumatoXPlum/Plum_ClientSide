import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:task2/presentation/authentication_screens/sign_up_screen/auth_service/auth_service.dart';
import 'package:task2/presentation/authentication_screens/sign_up_screen/view/sign_up_screen.dart';

class UserProfile extends StatefulWidget {
  const UserProfile({super.key});

  @override
  UserProfileState createState() => UserProfileState();
}

class UserProfileState extends State<UserProfile> {
  String name = "Loading...";
  String email = "Not Available";
  String phoneNumber = "Not Available";
  String dateOfBirth = "Not Available";

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentSnapshot userDoc =
          await FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .get();

      if (userDoc.exists) {
        String fetchedEmail = userDoc['email'] ?? "Not Available";
        setState(() {
          email = fetchedEmail;
          String extractedName =
              fetchedEmail.contains("@")
                  ? fetchedEmail.split("@").first
                  : "Unknown";
          name =
              extractedName.contains(".") || extractedName.contains("_")
                  ? extractedName.split(RegExp(r'[._]')).first
                  : extractedName;

          phoneNumber = userDoc['phoneNumber'] ?? "Not Available";
          dateOfBirth = userDoc['dateOfBirth'] ?? "Not Available";
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
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: padding * 1.6),
            child: Column(
              children: [
                Align(
                  alignment: Alignment.topLeft,
                  child: GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: SvgPicture.asset("assets/sign_up_assets/back.svg"),
                  ),
                ),
                Center(
                  child: Image.asset(
                    'assets/home_assets/pfp.png',
                    height: size.height * 0.15,
                    width: size.width * 0.3,
                    fit: BoxFit.contain,
                  ),
                ),
                SizedBox(height: size.height * 0.02),
                Text(
                  name,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: fontSize,
                    fontFamily: 'Switzer',
                  ),
                ),
                SizedBox(height: size.height * 0.03),
                buildTextField("Your Email", email, Icons.mail_outline),
                SizedBox(height: size.height * 0.02),
                buildTextField("Phone Number", phoneNumber, Icons.phone),
                SizedBox(height: size.height * 0.02),
                buildTextField(
                  "Date of Birth",
                  dateOfBirth,
                  Icons.calendar_today,
                  isReadOnly: true,
                ),
                SizedBox(height: size.height * 0.02),
                buildTextField("Password", "********", Icons.lock),
                SizedBox(height: size.height * 0.04),
                GestureDetector(
                  onTap: () async {
                    await AuthService().signOut();
                    if (mounted) {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => SignUpScreen()),
                        (route) => false,
                      );
                    }
                  },
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
                        style: TextStyle(
                          fontSize: fontSize,
                          color: Color(0xff3579DD),
                          fontFamily: 'Switzer',
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

  Widget buildTextField(
    String label,
    String value,
    IconData icon, {
    bool isReadOnly = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            color: Colors.white,
            fontFamily: 'Switzer',
          ),
        ),
        const SizedBox(height: 8),
        TextField(
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
      ],
    );
  }
}
