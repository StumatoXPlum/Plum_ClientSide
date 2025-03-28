import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:task2/core/custom_widgets/neopop_button.dart';
import '../authentication_screens/sign_up_screen/auth_service/auth_service.dart';
import '../points_screen/cubit/earned_points_cubit.dart';
import '../authentication_screens/date_of_birth/date_of_birth.dart';
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
  String avatarUrl = "";
  bool _isLoading = false;

  final SupabaseClient _supabase = Supabase.instance.client;

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    final user = _supabase.auth.currentUser;
    if (user == null) return;

    try {
      final response =
          await _supabase
              .from('users')
              .select('email, name, phonenumber, dateofbirth, avatarurl')
              .eq('id', user.id)
              .single();

      setState(() {
        email = response['email'] ?? user.email ?? "Not Available";
        name = response['name'] ?? email.split('@').first;
        phoneNumber = response['phonenumber'] ?? "Not Available";
        dateOfBirth = response['dateofbirth'] ?? "Not set yet";

        avatarUrl =
            response['avatarurl']?.isNotEmpty == true
                ? response['avatarurl']
                : AuthService.getRandomAvatarUrl(user.id);
      });
    } catch (e) {
      print("Error fetching user data: $e");
    }
  }

  Future<void> _signOut() async {
    if (mounted) {
      setState(() {
        _isLoading = true;
      });
    }

    try {
      await _supabase.auth.signOut();
    } catch (e) {
      print("Error during sign out: $e");
    }

    if (mounted) {
      Future.delayed(Duration(milliseconds: 300), () {
        Navigator.pushAndRemoveUntil(
          context,
          CupertinoPageRoute(builder: (context) => const SignUpScreen()),
          (route) => false,
        );
      });
    }
  }

  Future<void> navigateToDateOfBirthScreen() async {
    await Navigator.push(
      context,
      CupertinoPageRoute(
        builder: (context) => const DateOfBirth(isFromProfile: true),
      ),
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
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: padding * 1.6),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () => Navigator.pop(context),
                            child: SvgPicture.asset(
                              "assets/sign_up_assets/back.svg",
                            ),
                          ),
                          const Spacer(),
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: padding * 0.4,
                              vertical: padding * 0.3,
                            ),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.white60,
                                width: 1,
                              ),
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
                      SizedBox(height: size.height * 0.01),
                      Center(
                        child: Container(
                          padding: EdgeInsets.all(padding * 1.2),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: const Color(0xff3579DD),
                              width: size.width * 0.01,
                            ),
                          ),
                          child: ClipOval(
                            child: Image.network(
                              avatarUrl,
                              height: size.height * 0.15,
                              width: size.width * 0.3,
                              fit: BoxFit.cover,
                              errorBuilder:
                                  (context, error, stackTrace) => Icon(
                                    Icons.person,
                                    size: size.height * 0.15,
                                    color: Colors.white,
                                  ),
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
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                bottom: size.height * 0.04,
                left: padding * 1.6,
                right: padding * 1.6,
              ),
              child: NeopopButton(
                buttonText: "Log Out",
                onTap: _signOut,
                isLoading: _isLoading,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
