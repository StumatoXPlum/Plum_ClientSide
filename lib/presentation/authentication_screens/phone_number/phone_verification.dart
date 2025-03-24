import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pinput/pinput.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:task2/core/custom_widgets/custom_button.dart';
import '../date_of_birth/date_of_birth.dart';

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
  final supabase = Supabase.instance.client;

  @override
  void initState() {
    super.initState();

    otpController.addListener(() {
      setState(() => isOtpEntered = otpController.text.length == 6);
    });

    if (widget.isMockOtp) {
      Future.delayed(const Duration(milliseconds: 300), () {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text(
                "We're having some issues. Try this OTP: 123456",
              ),
              backgroundColor: Colors.orange,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      });
    }
  }

  void _showError(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red.shade600),
    );
  }

  Future<void> _verifyOtp() async {
    if (!isOtpEntered || isVerifying) return;

    setState(() => isVerifying = true);
    final supabase = Supabase.instance.client;

    try {
      final existingUser = supabase.auth.currentUser;
      if (existingUser == null) {
        throw AuthException("No authenticated user found.");
      }

      final existingUserId = existingUser.id;
      print("Existing user ID: $existingUserId");

      if (widget.isMockOtp && otpController.text == "123456") {
        print("Mock OTP verified successfully.");

        await supabase
            .from('users')
            .update({'phonenumber': widget.phoneNumber})
            .eq('id', existingUserId);

      } else {
        final otpResponse = await supabase.auth.verifyOTP(
          token: otpController.text,
          type: OtpType.sms, 
        );

        final verifiedUser = otpResponse.user;
        if (verifiedUser == null || verifiedUser.id != existingUserId) {
          throw AuthException("OTP verified, but user session changed.");
        }
        await supabase.auth.updateUser(
          UserAttributes(phone: widget.phoneNumber),
        );
        await supabase
            .from('users')
            .update({'phonenumber': widget.phoneNumber})
            .eq('id', existingUserId);

      }
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        CupertinoPageRoute(builder: (context) => const DateOfBirth()),
      );
    } on AuthException catch (e) {
      print("Auth Error: ${e.message}");
      _showError(e.message);
    } catch (e) {
      _showError("Something went wrong. Please try again.");
    } finally {
      if (mounted) {
        setState(() => isVerifying = false);
      }
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
                "We've sent an SMS with an activation code to ${widget.phoneNumber}",
                style: GoogleFonts.urbanist(
                  fontSize: fontSize,
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
              ),
              SizedBox(height: size.height * 0.05),
              CustomButton(buttonText: "Verify", onTap: _verifyOtp),
            ],
          ),
        ),
      ),
    );
  }
}
