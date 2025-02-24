import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:task2/presentation/authentication_screens/email_login_screen/email_verification.dart';
import 'package:task2/presentation/authentication_screens/phone_number/phone_number.dart';
import 'package:task2/presentation/authentication_screens/sign_up_screen/auth_service/auth_service.dart';

class EmailLoginScreen extends StatefulWidget {
  final AuthService _authService = AuthService();
  EmailLoginScreen({super.key});

  @override
  State<EmailLoginScreen> createState() => _EmailLoginScreenState();
}

class _EmailLoginScreenState extends State<EmailLoginScreen> {
  final TextEditingController _controller = TextEditingController();
  bool isTextEntered = false;

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      setState(() {
        isTextEntered = _controller.text.isNotEmpty;
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.red.shade600,
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.all(20),
        duration: Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    double padding = size.width * 0.03;
    double iconSize = size.width * 0.05;
    double fontSize = size.width * 0.05;
    return Scaffold(
      backgroundColor: Color(0xff090D14),
      appBar: AppBar(
        backgroundColor: Color(0xff090D14),

        title: Text(
          "Log in or sign up",
          style: GoogleFonts.inter(color: Colors.white70, fontSize: fontSize),
        ),
        centerTitle: true,
        leading: InkWell(
          onTap: () => Navigator.pop(context),
          child: SvgPicture.asset(
            "assets/sign_up_assets/cross.svg",
            height: iconSize,
            width: iconSize,
            fit: BoxFit.scaleDown,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Divider(color: Colors.white70, thickness: 0.1),
            SizedBox(height: size.height * 0.03),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: padding * 1.5),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Email",
                  style: GoogleFonts.inter(color: Colors.white),
                ),
              ),
            ),
            SizedBox(height: size.height * 0.01),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: padding * 1.5),
              child: TextField(
                controller: _controller,
                cursorColor: Colors.white,
                style: TextStyle(color: Colors.white, fontFamily: 'Switzer'),
                decoration: InputDecoration(
                  hintText: "Enter your email",
                  hintStyle: TextStyle(
                    color: Colors.white24,
                    fontFamily: 'Switzer',
                  ),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white70),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xff3579DD)),
                  ),
                ),
              ),
            ),
            SizedBox(height: size.height * 0.04),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: padding * 1.5),
              child: InkWell(
                splashColor: Colors.transparent,
                onTap: () {
                  if (_controller.text.isEmpty) {
                    _showSnackbar("Please enter a valid e-mail");
                  } else {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EmailVerification(),
                      ),
                    );
                  }
                },
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color:
                        isTextEntered ? Color(0xff3579DD) : Color(0xff4D4D4D),
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: padding,
                      vertical: padding * 1.5,
                    ),
                    child: Text(
                      "Continue",
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                        fontFamily: 'Switzer',
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: size.height * 0.06),
            Stack(
              alignment: Alignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: padding * 1.5),
                  child: Divider(color: Color(0xff1E293B), thickness: 2),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Color(0xff1E293B),
                    borderRadius: BorderRadius.circular(42),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12.0,
                    vertical: 6,
                  ),
                  child: Text(
                    "OR",
                    style: GoogleFonts.inter(color: Colors.white),
                  ),
                ),
              ],
            ),
            SizedBox(height: size.height * 0.06),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: padding * 1.5),
              child: Column(
                spacing: 15,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SignInButton(
                    label: "Continue with Apple",
                    imageUrl: "assets/sign_up_assets/apple_white.svg",
                    onTap: () {},
                  ),
                  SignInButton(
                    label: "Continue with Google",
                    imageUrl: "assets/sign_up_assets/google.svg",
                    onTap: () async {
                      final user = await widget._authService.signInWithGoogle();
                      if (user != null) {
                        print("user:${user.displayName}");
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PhoneNumber(),
                          ),
                        );
                      }
                    },
                  ),
                  SignInButton(
                    label: "Continue with Facebook",
                    imageUrl: "assets/sign_up_assets/fb.svg",
                    onTap: () {},
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SignInButton extends StatelessWidget {
  final String label;
  final String imageUrl;
  final VoidCallback? onTap;
  const SignInButton({
    super.key,
    required this.label,
    required this.imageUrl,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    double padding = size.width * 0.03;
    double iconSize = size.width * 0.05;
    double fontSize = size.width * 0.04;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
          vertical: padding * 1.5,
          horizontal: padding * 2,
        ),
        width: double.infinity,
        decoration: BoxDecoration(
          color: Color(0xff1E293B),
          borderRadius: BorderRadius.circular(size.width * 0.2),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(imageUrl, height: iconSize, width: iconSize),
            SizedBox(width: size.width * 0.02),
            Text(
              label,
              style: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.w500,
                color: Colors.white,
                fontFamily: 'Switzer',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
