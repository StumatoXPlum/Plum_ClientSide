import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/bottom_navigation_bar.dart';
import '../../../../core/custom_snackbar.dart';
import '../auth_service/auth_service.dart';
import '../../email/email_verification.dart';
import '../../phone_number/phone_number.dart';
import '../cubit/auth_cubit.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final AuthService _authService = AuthService();
  final TextEditingController _emailController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _showEmailField = false;
  bool isLoading = false;
  bool isContinuing = false;
  bool isAppleLoading = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
      if (keyboardHeight > 0 && _showEmailField) {
        _scrollToTextField();
      }
    });
  }

  void _scrollToTextField() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (!mounted || !_scrollController.hasClients) return;
      final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
      final scrollAmount =
          _scrollController.position.maxScrollExtent + keyboardHeight;
      _scrollController.animateTo(
        scrollAmount,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return ScaffoldMessenger(
      child: Material(
        child: Stack(
          children: [
            Image.asset(
              "assets/splash/back.png",
              width: size.width,
              height: size.height,
              fit: BoxFit.cover,
            ),
            Image.asset(
              "assets/splash/gradient.png",
              width: size.width,
              height: size.height,
              fit: BoxFit.cover,
            ),
            NotificationListener<OverscrollIndicatorNotification>(
              onNotification: (notification) {
                notification.disallowIndicator();
                return true;
              },
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return SingleChildScrollView(
                    controller: _scrollController,
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minHeight: constraints.maxHeight,
                      ),
                      child: IntrinsicHeight(
                        child: Padding(
                          padding: EdgeInsets.only(
                            bottom:
                                bottomInset > 0
                                    ? bottomInset * 0.5
                                    : size.height * 0.1,
                          ),
                          child: Column(
                            children: [
                              Spacer(),
                              Image.asset(
                                "assets/splash/logo.png",
                                width: size.width * 0.5,
                                height: size.height * 0.12,
                                fit: BoxFit.contain,
                              ),
                              SizedBox(height: size.height * 0.03),
                              Text(
                                "Dubai's award-winning Desi club \nexperience awaits you!",
                                style: GoogleFonts.urbanist(
                                  color: Colors.white70,
                                  fontSize: size.width * 0.045,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(height: size.height * 0.08),
                              _buildButtons(context, size),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildButtons(BuildContext context, Size size) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (_showEmailField) _buildEmailInput(size),
          if (!_showEmailField)
            SignInButton(
              label: "Continue with Email",
              imageUrl: "assets/sign_up_assets/mail.svg",
              onTap: () {
                if (!mounted) return;
                setState(() {
                  _showEmailField = true;
                });
                _scrollToTextField();
              },
            ),
          const SizedBox(height: 12),
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
                    showCustomSnackbar(
                      context,
                      "Sign-in failed. Please try again.",
                      Colors.red.shade600,
                    );
                  }
                  return;
                }

                DocumentSnapshot doc =
                    await FirebaseFirestore.instance
                        .collection('users')
                        .doc(user.uid)
                        .get();
                context.read<AuthCubit>().setUserEmail(user.email ?? "");
                final userData = doc.data() as Map<String, dynamic>?;
                bool isRegistrationComplete =
                    doc.exists && (userData?['registrationComplete'] == true);
                bool hasPhoneNumber =
                    doc.exists && (userData?['phoneNumber'] ?? '').isNotEmpty;

                if (mounted) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) =>
                              (!isRegistrationComplete || !hasPhoneNumber)
                                  ? PhoneNumber()
                                  : BottomNavScreen(),
                    ),
                  );
                }
              } catch (e) {
                if (mounted) {
                  showCustomSnackbar(
                    context,
                    "An error occurred. Please try again.",
                    Colors.red.shade600,
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
          const SizedBox(height: 12),
          SignInButton(
            label: isAppleLoading ? "Signing in..." : "Continue with Apple",
            imageUrl: "assets/sign_up_assets/apple.svg",
            onTap: () async {
              if (isAppleLoading) return;
              setState(() {
                isAppleLoading = true;
              });

              try {
                final user = await _authService.signInWithApple();

                if (user != null) {
                  context.read<AuthCubit>().setUserEmail(user.email ?? "");
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => BottomNavScreen()),
                  );
                } else {
                  showCustomSnackbar(
                    context,
                    "Sign-in failed. Please try again.",
                    Colors.red.shade600,
                  );
                }
              } catch (e) {
                showCustomSnackbar(
                  context,
                  "An error occurred. Please try again.",
                  Colors.red.shade600,
                );
              } finally {
                setState(() {
                  isAppleLoading = false;
                });
              }
            },
            isLoading1: isAppleLoading,
          ),
        ],
      ),
    );
  }

  Widget _buildEmailInput(Size size) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "Please enter your email ",
            style: GoogleFonts.urbanist(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: size.width * 0.035,
            ),
          ),
          SizedBox(height: 8),
          TextField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            onTap: _scrollToTextField,
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.transparent,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Color(0xff3579DD)),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Color(0xff3579DD)),
              ),
            ),
            style: GoogleFonts.urbanist(color: Colors.white),
            cursorColor: Colors.white,
          ),
          SizedBox(height: 12),

          GestureDetector(
            onTap: () async {
              if (isContinuing) return;
              String email = _emailController.text.trim().toLowerCase();

              if (email.isEmpty ||
                  !RegExp(
                    r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$",
                  ).hasMatch(email)) {
                showCustomSnackbar(
                  context,
                  "Enter a valid email",
                  Colors.green.shade600,
                );
                return;
              }

              setState(() => isContinuing = true);

              try {
                final userDoc =
                    await FirebaseFirestore.instance
                        .collection('users')
                        .where('email', isEqualTo: email)
                        .limit(1)
                        .get();
                print("User document found: ${userDoc.docs.isNotEmpty}");
                await Supabase.instance.client.auth.signInWithOtp(
                  email: email,
                  emailRedirectTo: null,
                  shouldCreateUser: userDoc.docs.isEmpty,
                );
                print("OTP sent successfully");
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (context) => EmailVerification(
                          email: email,
                          isExistingUser: userDoc.docs.isNotEmpty,
                        ),
                  ),
                );
              } catch (e) {
                print("Error checking user: $e");
                showCustomSnackbar(
                  context,
                  "Failed to check user. Try again.",
                  Colors.red.shade600,
                );
              }

              setState(() => isContinuing = false);
            },

            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Color(0xff3579DD),
                borderRadius: BorderRadius.circular(6),
              ),
              padding: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width * 0.03,
                vertical: MediaQuery.of(context).size.width * 0.03,
              ),
              child: Center(
                child:
                    isContinuing
                        ? SizedBox(
                          height: 24,
                          width: 24,
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.white,
                            ),
                            strokeWidth: 2.5,
                          ),
                        )
                        : Text(
                          "Continue",
                          style: GoogleFonts.urbanist(
                            fontSize: 18,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _emailController.dispose();
    super.dispose();
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
        padding: EdgeInsets.symmetric(
          vertical: padding,
          horizontal: padding * 2,
        ),
        width: size.width * 0.8,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(size.width * 0.015),
        ),
        child:
            isLoading
                ? Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: iconSize,
                      width: iconSize,
                      child: const CircularProgressIndicator(strokeWidth: 2),
                    ),
                  ],
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
    );
  }
}
