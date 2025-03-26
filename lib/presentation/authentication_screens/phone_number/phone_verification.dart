import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:pinput/pinput.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:task2/core/constants.dart';
import 'package:task2/core/custom_widgets/custom_button.dart';
import 'package:task2/presentation/authentication_screens/date_of_birth/date_of_birth.dart';

class PhoneVerification extends StatefulWidget {
  final String phoneNumber;

  const PhoneVerification({super.key, required this.phoneNumber});

  @override
  State<PhoneVerification> createState() => _PhoneVerificationState();
}

class _PhoneVerificationState extends State<PhoneVerification> {
  final TextEditingController otpController = TextEditingController();

  Future<void> verifyOtp(String phoneNumber, String otpCode) async {
    const String twilioAccountSID = AppSecrets.twilioAccountSID;
    const String twilioAuthToken = AppSecrets.twilioAuthToken;
    const String twilioServiceSid = AppSecrets.twilioServiceSid;

    final Uri url = Uri.parse(
      "https://verify.twilio.com/v2/Services/$twilioServiceSid/VerificationCheck",
    );

    final String basicAuth =
        'Basic ${base64Encode(utf8.encode('$twilioAccountSID:$twilioAuthToken'))}';

    final response = await http.post(
      url,
      headers: {
        'Authorization': basicAuth,
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: {'To': phoneNumber, 'Code': otpCode},
    );

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      if (responseData['status'] == 'approved' &&
          responseData['valid'] == true) {
        final supabase = Supabase.instance.client;
        final user = supabase.auth.currentUser;

        if (user == null) {
          return;
        }
        await supabase
            .from('users')
            .update({'phonenumber': phoneNumber})
            .eq('email', user.email!);

        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => DateOfBirth()),
          );
        }
      }
    } else {
      print("Failed to verify OTP: ${response.body}");
    }
  }

  Future<void> resendOtp() async {
    const String twilioAccountSID = AppSecrets.twilioAccountSID;
    const String twilioAuthToken = AppSecrets.twilioAuthToken;
    const String twilioServiceSid = AppSecrets.twilioServiceSid;

    final Uri url = Uri.parse(
      "https://verify.twilio.com/v2/Services/$twilioServiceSid/Verifications",
    );

    final String basicAuth =
        'Basic ${base64Encode(utf8.encode('$twilioAccountSID:$twilioAuthToken'))}';

    final response = await http.post(
      url,
      headers: {
        'Authorization': basicAuth,
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: {'To': widget.phoneNumber, 'Channel': 'sms'},
    );

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("New OTP Sent"),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.green,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Failed to send new OTP"),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.red,
        ),
      );
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
              SizedBox(height: size.height * 0.03),

              TextButton(
                onPressed: resendOtp,
                child: Text(
                  "Didn't receive code? Resend",
                  style: GoogleFonts.urbanist(
                    fontSize: fontSize * 0.8,
                    color: Colors.white,
                  ),
                ),
              ),
              SizedBox(height: size.height * 0.03),
              CustomButton(
                buttonText: "Verify",
                onTap: () async {
                  String otp = otpController.text.trim();
                  if (otp.isEmpty || otp.length < 6) {
                    return;
                  }
                  await verifyOtp(widget.phoneNumber, otp);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
