import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pinput/pinput.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as supabase;
import '../../../core/custom_snackbar.dart';
import '../date_of_birth/date_of_birth.dart';
import 'phone_auth/phone_auth.dart';

class PhoneVerification extends StatefulWidget {
  final String phoneNumber;
  final bool isMockOtp;
  const PhoneVerification({
    super.key,
    required this.phoneNumber,
    this.isMockOtp = false,
  });

  @override
  State<PhoneVerification> createState() => _PhoneVerificationState();
}

class _PhoneVerificationState extends State<PhoneVerification> {
  final TextEditingController otpController = TextEditingController();
  bool isOtpEntered = false;
  bool isVerifying = false;

  @override
  void initState() {
    super.initState();
    otpController.addListener(() {
      setState(() {
        isOtpEntered = otpController.text.isNotEmpty;
      });
    });

    if (widget.isMockOtp) {
      Future.delayed(Duration(milliseconds: 300), () {
        showCustomSnackbar(
          context,
          "We're having some issues. Try this temporary OTP: 123456",
          Colors.orange,
        );
      });

      Future.delayed(Duration(seconds: 10), () {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
      });
    }
  }

  Future<void> _storePhoneNumber(String phoneNumber) async {
    final firebaseAuth = FirebaseAuth.instance;
    final supabaseUser = supabase.Supabase.instance.client.auth.currentUser;

    String? uid;
    String? email;

    if (firebaseAuth.currentUser != null) {
      uid = firebaseAuth.currentUser!.uid;
      email = firebaseAuth.currentUser!.email;
    } else if (supabaseUser != null) {
      uid = supabaseUser.id;
      email = supabaseUser.email;
    }

    if (uid != null) {
      try {
        await FirebaseFirestore.instance.collection('users').doc(uid).set({
          'phoneNumber': phoneNumber,
          'email': email,
        }, SetOptions(merge: true));
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => DateOfBirth()),
        );
      } catch (e) {
        print("Error: $e");
      }
    } else {
      print("No user found!");
    }
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
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: size.height * 0.1),
              Text(
                "Verify your phone number",
                style: GoogleFonts.urbanist(
                  fontSize: fontSize * 1.8,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: size.height * 0.02),
              Text(
                "We've sent an SMS with an activation code to your phone ${widget.phoneNumber}",
                style: GoogleFonts.urbanist(
                  fontSize: fontSize * 1,
                  color: Colors.white70,
                ),
                textAlign: TextAlign.center,
              ),

              SizedBox(height: size.height * 0.1),
              Pinput(
                controller: otpController,
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
                            bool success = await TwilioVerifyService().sendOtp(
                              widget.phoneNumber,
                            );
                            if (success) {
                              showCustomSnackbar(
                                context,
                                "New OTP has been sent",
                                Colors.green.shade600,
                              );
                            } else {
                              showCustomSnackbar(
                                context,
                                "Failed to resend OTP try again!",
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
              GestureDetector(
                onTap: () async {
                  if (isOtpEntered && !isVerifying) {
                    setState(() {
                      isVerifying = true;
                    });
                    bool isValid = await TwilioVerifyService().verifyOtp(
                      widget.phoneNumber,
                      otpController.text,
                    );
                    if (isValid) {
                      print('OTP Verified');
                      await _storePhoneNumber(widget.phoneNumber);
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => DateOfBirth()),
                      );
                    } else {
                      showCustomSnackbar(
                        context,
                        "Invalid OTP, Please try again!",
                        Colors.red.shade600,
                      );
                    }
                    setState(() {
                      isVerifying = false;
                    });
                  }
                },
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(padding * 1.5),
                  decoration: BoxDecoration(
                    color: isOtpEntered ? Color(0xff3579DD) : Color(0xff4D4D4D),
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child:
                      isVerifying
                          ? const Center(
                            child: SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            ),
                          )
                          : Text(
                            "Verify",
                            style: GoogleFonts.urbanist(
                              fontSize: fontSize,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
