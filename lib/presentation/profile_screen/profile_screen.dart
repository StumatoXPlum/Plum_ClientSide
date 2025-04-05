import 'package:aloha_funds/admin/authentication/admin_login.dart';
import 'package:aloha_funds/core/custom_widgets/button_widget.dart';
import 'package:aloha_funds/presentation/start_screen/start_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final SupabaseClient _supabase = Supabase.instance.client;
  bool isLoading = false;
  Map<String, dynamic>? userData;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    final user = _supabase.auth.currentUser;
    if (user == null) return;

    final response =
        await _supabase
            .from('users')
            .select('name, email, phonenumber, avatar_url')
            .eq('id', user.id)
            .maybeSingle();

    if (mounted) {
      setState(() {
        userData = response;
      });
    }
  }

  Future<void> _signOut() async {
    if (mounted) {
      setState(() {
        isLoading = true;
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
          MaterialPageRoute(builder: (context) => const StartScreen()),
          (route) => false,
        );
      });
    }
  }

  Widget buildAvatar(String avatarUrl) {
    return ClipOval(
      child: Container(
        width: 120,
        height: 120,
        color: const Color(0xff8E97FD),
        child: SvgPicture.network(
          avatarUrl,
          placeholderBuilder: (context) => const CircularProgressIndicator(),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    double padding = size.width * 0.04;
    double fontSize = size.width * 0.045;
    final avatarUrl =
        userData?['avatar_url'] ??
        'https://api.dicebear.com/9.x/open-peeps/svg?seed=default';
    final name = userData?['name'] ?? 'User';
    final email = userData?['email'] ?? 'Not Available';
    final phoneNumber = userData?['phonenumber'] ?? 'Not Available';

    return Scaffold(
      backgroundColor: const Color(0xff1F265E),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: padding * 1.6),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(height: size.height * 0.05),
            buildAvatar(avatarUrl),
            SizedBox(height: size.height * 0.02),
            Text(
              name,
              style: GoogleFonts.poppins(
                fontSize: fontSize,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
            SizedBox(height: size.height * 0.06),
            _buildInfoField("Email", email),
            SizedBox(height: size.height * 0.04),
            _buildInfoField("Mobile Number", phoneNumber),
            Spacer(),
            ButtonWidget(
              buttonText: "Log Out",
              onTap: _signOut,
              isLoading: isLoading,
            ),
            SizedBox(height: size.height * 0.02),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AdminLoginScreen()),
                );
              },
              child: Text(
                "Login as Admin",
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: fontSize,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoField(String label, String value) {
    final Size size = MediaQuery.of(context).size;
    double padding = size.width * 0.04;
    double fontSize = size.width * 0.045;
    return Container(
      padding: EdgeInsets.symmetric(vertical: padding, horizontal: padding),
      decoration: BoxDecoration(
        color: Colors.white10,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: GoogleFonts.poppins(
              color: Colors.white70,
              fontSize: fontSize,
            ),
          ),
          Text(
            value,
            style: GoogleFonts.poppins(color: Colors.white, fontSize: fontSize),
          ),
        ],
      ),
    );
  }
}
