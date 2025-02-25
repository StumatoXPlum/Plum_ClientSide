import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:task2/presentation/authentication_screens/name_screen/enter_name_screen.dart';

class EmailVerification extends StatefulWidget {
  final String email;
  const EmailVerification({super.key, required this.email});

  @override
  State<EmailVerification> createState() => _EmailVerificationState();
}

class _EmailVerificationState extends State<EmailVerification> {
  final TextEditingController _otpController = TextEditingController();
  bool isOtpEntered = false;

  void _otpListener() {
    setState(() {
      isOtpEntered = _otpController.text.length == 6;
    });
  }

  @override
  void initState() {
    super.initState();
    _otpController.addListener(_otpListener);
  }

  @override
  void dispose() {
    _otpController.removeListener(_otpListener);
    _otpController.dispose();
    super.dispose();
  }

  void showCustomSnackbar(BuildContext context, String message) {
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
                  color: Colors.green.shade600,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  message,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontFamily: 'Switzer',
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
    String otp = _otpController.text.trim();
    if (otp.isEmpty) {
      showCustomSnackbar(context, "Enter OTP");
      return;
    }

    try {
      final response = await Supabase.instance.client.auth.verifyOTP(
        email: widget.email,
        token: otp,

        type: OtpType.email,
      );

      if (response.session != null) {
        showCustomSnackbar(context, "Email Verified!");

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => EnterNameScreen()),
        );
      } else {
        showCustomSnackbar(context, "Invalid OTP. Try again.");
      }
    } catch (e) {
      showCustomSnackbar(context, "OTP verification failed.");
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
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: size.height * 0.1),
              Text(
                "Please check your email",
                style: TextStyle(
                  fontSize: fontSize * 1.6,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Switzer',
                  color: Colors.white,
                ),
              ),
              SizedBox(height: size.height * 0.02),
              Text(
                "We've sent a code to ${widget.email}",
                style: TextStyle(
                  fontSize: fontSize * 1,
                  color: Colors.white70,
                  fontFamily: 'Switzer',
                ),
              ),

              SizedBox(height: size.height * 0.1),
              PinCodeTextField(
                cursorColor: Colors.white,
                appContext: context,
                length: 6,
                keyboardType: TextInputType.number,
                controller: _otpController,
                autoFocus: true,
                textStyle: TextStyle(fontSize: 18, color: Colors.white),
                pinTheme: PinTheme(
                  shape: PinCodeFieldShape.box,
                  borderRadius: BorderRadius.circular(12.0),
                  fieldHeight: 60,
                  fieldWidth: 50,
                  activeFillColor: Color(0xff090D14),
                  selectedFillColor: Color(0xff090D14),
                  inactiveFillColor: Color(0xff090D14),
                  activeColor: Color(0xff3579DD),
                  selectedColor: Color(0xff3579DD),
                  inactiveColor: Color(0xff3579DD),
                ),
                onChanged: (value) {},
                enableActiveFill: true,
              ),
              SizedBox(height: size.height * 0.05),
              Align(
                alignment: Alignment.center,
                child: Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: "I didn't receive the code ",
                        style: TextStyle(
                          fontSize: fontSize * 0.8,
                          color: Colors.white70,
                          fontFamily: 'Switzer',
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
                              );
                            } catch (e) {
                              showCustomSnackbar(
                                context,
                                "Failed to resend OTP. try again.",
                              );
                            }
                          },

                          child: Text(
                            "Resend",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: fontSize * 0.8,
                              fontFamily: 'Switzer',
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
                onTap: verifyOtp,
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: isOtpEntered ? Color(0xff3579DD) : Color(0xff4D4D4D),
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: padding,
                      vertical: padding * 1.5,
                    ),
                    child: Text(
                      "Verify",
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
            ],
          ),
        ),
      ),
    );
  }
}
