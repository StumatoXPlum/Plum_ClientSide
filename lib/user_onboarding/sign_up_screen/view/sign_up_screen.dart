import 'package:aloha_funds/user_onboarding/email/email_verification.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../auth_service/auth_service.dart';
import '../cubit/auth_cubit.dart';
import 'package:aloha_funds/core/bottom_navigation_bar.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final AuthService _authService = AuthService();
  final TextEditingController _emailController = TextEditingController();
  bool _showEmailField = false;
  bool isLoading = false;
  bool isContinuing = false;
  bool isAppleLoading = false;

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Color(0xff1F265E),
      body: Stack(
        children: [
          Positioned.fill(
            child: SvgPicture.asset(
              "assets/start_screen_assets/start.svg",
              fit: BoxFit.cover,
            ),
          ),
          Column(
            children: [
              Expanded(child: Container()),
              _buildButtons(context, size),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildButtons(BuildContext context, Size size) {
    final Size size = MediaQuery.of(context).size;
    double padding = size.width * 0.04;
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: padding * 1.6,
        vertical: padding * 2,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (_showEmailField) _buildEmailInput(),
          if (!_showEmailField)
            SignInButton(
              label: "Continue with Email",
              imageUrl: "assets/sign_up_assets/mail.svg",
              onTap: () {
                setState(() => _showEmailField = true);
              },
            ),
          SizedBox(height: size.height * 0.02),
          SignInButton(
            label: isLoading ? "Signing in..." : "Continue with Google",
            imageUrl: "assets/sign_up_assets/google.svg",
            onTap: () async {
              if (isLoading || !mounted) return;
              setState(() => isLoading = true);

              try {
                final user = await _authService.signInWithGoogle(context);
                if (user == null) {
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("Sign in failed. Try again."),
                        backgroundColor: Colors.red.shade600,
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  }
                  return;
                }
              } catch (e) {
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("An error occured. Please Try again."),
                      backgroundColor: Colors.red.shade600,
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                }
              } finally {
                if (mounted) {
                  setState(() => isLoading = false);
                }
              }
            },
            isLoading: isLoading,
          ),
          SizedBox(height: size.height * 0.02),

          SignInButton(
            label: isAppleLoading ? "Signing in..." : "Continue with Apple",
            imageUrl: "assets/sign_up_assets/apple.svg",
            onTap: () async {
              if (isAppleLoading) return;
              setState(() => isAppleLoading = true);
              try {
                final user = await _authService.signInWithApple(context);
                if (user != null) {
                  context.read<AuthCubit>().setUserEmail(user.email ?? "");
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => BottomNavScreen()),
                  );
                }
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Sign in failed. Try again.")),
                );
              } finally {
                setState(() => isAppleLoading = false);
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildEmailInput() {
    final Size size = MediaQuery.of(context).size;
    double padding = size.width * 0.04;
    return Column(
      children: [
        TextField(
          controller: _emailController,
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
            hintText: "Enter your email address",
            hintStyle: GoogleFonts.poppins(color: Colors.white70),
            filled: true,
            fillColor: Colors.black38,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Color(0xff8E97FD)),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Color(0xff8E97FD)),
            ),
          ),
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
          cursorColor: Colors.white,
        ),
        SizedBox(height: size.height * 0.03),
        GestureDetector(
          onTap: () async {
            if (isContinuing) return;
            String email = _emailController.text.trim().toLowerCase();

            if (email.isEmpty ||
                !RegExp(
                  r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$",
                ).hasMatch(email)) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  behavior: SnackBarBehavior.floating,
                  backgroundColor: Colors.red.shade600,
                  content: Text("Please Enter a valid email address."),
                ),
              );
              return;
            }

            setState(() => isContinuing = true);

            try {
              final supabase = Supabase.instance.client;
              final existingUser =
                  await supabase
                      .from('users')
                      .select('id')
                      .eq('email', email)
                      .maybeSingle();

              bool isExistingUser = existingUser != null;
              await supabase.auth.signInWithOtp(email: email);

              Navigator.push(
                context,
                MaterialPageRoute(
                  builder:
                      (context) => EmailVerification(
                        email: email,
                        isExistingUser: isExistingUser,
                      ),
                ),
              );
            } catch (e) {
              print("Error checking user: $e");
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  behavior: SnackBarBehavior.floating,
                  backgroundColor: Colors.red.shade600,
                  content: Text("Sign in failed. Try again."),
                ),
              );
            }

            setState(() => isContinuing = false);
          },
          child: SizedBox(
            width: double.infinity,
            child: Container(
              decoration: BoxDecoration(
                color: Color(0xff8E97FD),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: padding),
                child:
                    isContinuing
                        ? Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              height: 24,
                              width: 24,
                              child: CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.white,
                                ),
                                strokeWidth: 2.5,
                              ),
                            ),
                          ],
                        )
                        : Text(
                          "Continue",
                          style: GoogleFonts.poppins(
                            fontSize: 18,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class SignInButton extends StatelessWidget {
  final String label;
  final String imageUrl;
  final VoidCallback onTap;
  final bool isLoading;
  final bool isLoading1;
  const SignInButton({
    super.key,
    required this.label,
    required this.imageUrl,
    required this.onTap,
    this.isLoading = false,
    this.isLoading1 = false,
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
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: padding),
          child:
              isLoading
                  ? SizedBox(
                    height: iconSize,
                    child: Center(
                      child: SizedBox(
                        height: iconSize,
                        width: iconSize,
                        child: const CircularProgressIndicator(strokeWidth: 2),
                      ),
                    ),
                  )
                  : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset(
                        imageUrl,
                        height: iconSize,
                        width: iconSize,
                      ),
                      SizedBox(width: size.width * 0.02),
                      Text(
                        label,
                        style: GoogleFonts.urbanist(
                          fontSize: fontSize,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
        ),
      ),
    );
  }
}
