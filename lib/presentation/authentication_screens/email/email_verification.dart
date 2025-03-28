import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pinput/pinput.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../core/custom_widgets/bottom_navigation_bar.dart';
import '../../../core/custom_widgets/neopop_button.dart';
import '../name_screen/enter_name_screen.dart';

class EmailVerification extends StatefulWidget {
  final String email;
  final bool isExistingUser;
  const EmailVerification({
    super.key,
    required this.email,
    required this.isExistingUser,
  });

  @override
  State<EmailVerification> createState() => _EmailVerificationState();
}

class _EmailVerificationState extends State<EmailVerification> {
  final TextEditingController _otpController = TextEditingController();

  bool isOtpEntered = false;
  bool isVerifying = false;

  @override
  void initState() {
    super.initState();
    _otpController.addListener(_otpListener);
  }

  void _otpListener() {
    if (!mounted) {
      return;
    }
    setState(() {
      isOtpEntered = _otpController.text.length == 6;
    });
  }

  void showCustomSnackbar(BuildContext context, String message, Color color) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        Future.delayed(const Duration(seconds: 2), () {
          if (Navigator.of(context).canPop()) {
            Navigator.of(context).pop();
          }
        });

        return Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 30, left: 20, right: 20),
            child: Material(
              color: Colors.transparent,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  message,
                  style: GoogleFonts.urbanist(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> verifyOtp() async {
    if (isVerifying) return;
    String otp = _otpController.text.trim();
    if (otp.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Please Enter OTP',
            style: GoogleFonts.urbanist(fontWeight: FontWeight.bold),
          ),
          backgroundColor: Colors.red.shade600,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    setState(() => isVerifying = true);
    try {
      final response = await Supabase.instance.client.auth.verifyOTP(
        email: widget.email,
        token: otp,
        type: OtpType.email,
      );

      if (response.session != null) {
        if (widget.isExistingUser) {
          Navigator.pushReplacement(
            context,
            CupertinoPageRoute(builder: (context) => BottomNavScreen()),
          );
        } else {
          Navigator.pushReplacement(
            context,
            CupertinoPageRoute(builder: (context) => EnterNameScreen()),
          );
        }
      } else {
        showCustomSnackbar(context, "Error, Try Again", Colors.red.shade600);
      }
    } catch (e) {
      showCustomSnackbar(
        context,
        "Invalid OTP. Try again.",
        Colors.red.shade600,
      );
    }
    setState(() => isVerifying = false);
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    double padding = size.width * 0.03;
    double iconSize = size.width * 0.05;
    double fontSize = size.width * 0.05;
    return Scaffold(
      backgroundColor: const Color(0xff090D14),
      appBar: AppBar(
        backgroundColor: const Color(0xff090D14),
        leading: Padding(
          padding: EdgeInsets.only(left: padding * 1.5),
          child: InkWell(
            onTap: () => Navigator.pop(context),
            child: SvgPicture.asset(
              "assets/sign_up_assets/back.svg",
              height: iconSize,
              width: iconSize,
              fit: BoxFit.scaleDown,
            ),
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: padding * 1.5),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: size.height * 0.1),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Please check your email",
                  style: GoogleFonts.urbanist(
                    fontSize: fontSize * 1.6,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              SizedBox(height: size.height * 0.02),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "We've sent a code to ${widget.email}",
                  style: GoogleFonts.urbanist(
                    fontSize: fontSize * 1,
                    color: Colors.white70,
                  ),
                ),
              ),
              SizedBox(height: size.height * 0.1),
              Pinput(
                controller: _otpController,
                length: 6,
                defaultPinTheme: PinTheme(
                  width: 50,
                  height: 60,
                  textStyle: GoogleFonts.urbanist(
                    fontSize: fontSize,
                    color: Colors.white,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xff090D14),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xff3579DD)),
                  ),
                ),
                focusedPinTheme: PinTheme(
                  width: 50,
                  height: 60,
                  textStyle: GoogleFonts.urbanist(
                    fontSize: fontSize,
                    color: Colors.white,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xff090D14),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.blueAccent),
                  ),
                ),
                onChanged: (value) {
                  setState(() {
                    isOtpEntered = value.length == 6;
                  });
                },
              ),
              SizedBox(height: size.height * 0.05),
              Align(
                alignment: Alignment.center,
                child: Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: "I didn't receive the code ",
                        style: GoogleFonts.urbanist(
                          fontSize: fontSize * 0.8,
                          color: Colors.white70,
                        ),
                      ),
                      WidgetSpan(
                        alignment: PlaceholderAlignment.baseline,
                        baseline: TextBaseline.alphabetic,
                        child: GestureDetector(
                          onTap: () async {
                            try {
                              await Supabase.instance.client.auth.signInWithOtp(
                                shouldCreateUser: false,
                                email: widget.email,
                                emailRedirectTo: null,
                              );
                              showCustomSnackbar(
                                context,
                                "OTP resent to ${widget.email}",
                                Colors.green.shade600,
                              );
                            } catch (e) {
                              showCustomSnackbar(
                                context,
                                "Failed to resend OTP. try again.",
                                Colors.red.shade600,
                              );
                            }
                          },

                          child: Text(
                            "Resend",
                            style: GoogleFonts.urbanist(
                              color: Colors.white,
                              fontSize: fontSize * 0.8,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: size.height * 0.04),
              NeopopButton(
                buttonText: "Verify",
                onTap: verifyOtp,
               
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _otpController.removeListener(_otpListener);
    super.dispose();
  }
}
