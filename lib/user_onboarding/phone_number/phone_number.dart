import 'dart:convert';
import 'package:aloha_funds/core/custom_widgets/button_widget.dart';
import 'package:aloha_funds/core/custom_widgets/custom_back_button.dart';
import 'package:aloha_funds/user_onboarding/phone_number/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:country_picker/country_picker.dart';
import 'package:http/http.dart' as http;
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../core/constants.dart';
import 'phone_verification.dart';

class PhoneNumber extends StatefulWidget {
  const PhoneNumber({super.key});

  @override
  State<PhoneNumber> createState() => _PhoneNumberState();
}

class _PhoneNumberState extends State<PhoneNumber> {
  final supabase = Supabase.instance.client;
  String userName = "there";
  Country selectedCountry = Country(
    phoneCode: "91",
    countryCode: "IN",
    e164Sc: 0,
    geographic: true,
    level: 1,
    name: "India",
    example: "2012345678",
    displayName: "India (IN) [+91]",
    displayNameNoCountryCode: "India",
    e164Key: "",
  );

  final TextEditingController phoneController = TextEditingController();
  bool isPhoneEnter = false;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    fetchUserName();
    phoneController.addListener(() {
      setState(() => isPhoneEnter = phoneController.text.isNotEmpty);
    });
  }

  void _pickCountry() async {
    final selected = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ChooseCountryScreen()),
    );

    if (selected != null && selected is Country) {
      setState(() => selectedCountry = selected);
    }
  }

  Future<void> fetchUserName() async {
    final user = supabase.auth.currentUser;
    if (user == null) return;
    final userData =
        await supabase
            .from('users')
            .select('name')
            .eq('id', user.id)
            .maybeSingle();

    if (!mounted) return;
    setState(() => userName = userData?['name'] ?? "there");
  }

  Future<void> sendOtp(String phoneNumber) async {
    try {
      const String twilioAccountSID = AppSecrets.twilioAccountSID;
      const String twilioAuthToken = AppSecrets.twilioAuthToken;
      const String twilioServiceSid = AppSecrets.twilioServiceSid;

      final Uri url = Uri.parse(
        "https://verify.twilio.com/v2/Services/$twilioServiceSid/Verifications",
      );

      final response = await http.post(
        url,
        headers: {
          'Authorization':
              'Basic ${base64Encode(utf8.encode('$twilioAccountSID:$twilioAuthToken'))}',
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: {'To': phoneNumber, 'Channel': 'sms'},
      );

      if (response.statusCode == 201) {
        if (context.mounted) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PhoneVerification(phoneNumber: phoneNumber),
            ),
          );
        }
      } else {
        print("Failed to send OTP: ${response.body}");
      }
    } catch (e) {
      print("Error sending OTP: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    double padding = size.width * 0.03;
    double iconSize = size.width * 0.05;
    double fontSize = size.width * 0.05;

    return Scaffold(
      backgroundColor: Color(0xff1F265E),
      appBar: AppBar(
        backgroundColor: Color(0xff1F265E),
        leading: Padding(
          padding: EdgeInsets.only(left: padding * 1.5),
          child: CustomBackButton(),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: padding * 1.6),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: size.height * 0.03),
            Text(
              "Hi $userName",
              style: GoogleFonts.urbanist(
                color: Colors.white,
                fontSize: fontSize * 1.6,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: size.height * 0.01),
            Text(
              "Please enter your phone number",
              style: GoogleFonts.urbanist(
                color: Colors.white70,
                fontSize: fontSize,
              ),
            ),
            SizedBox(height: size.height * 0.04),
            Row(
              children: [
                InkWell(
                  onTap: _pickCountry,
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: padding,
                      vertical: padding * 1.3,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          selectedCountry.flagEmoji,
                          style: GoogleFonts.urbanist(fontSize: fontSize),
                        ),
                        SizedBox(width: size.width * 0.04),
                        Text(
                          "+${selectedCountry.phoneCode}",
                          style: GoogleFonts.urbanist(
                            color: Colors.black,
                            fontSize: fontSize * 0.9,
                          ),
                        ),
                        SizedBox(width: size.width * 0.02),
                        Icon(
                          Icons.arrow_drop_down,
                          color: Colors.white,
                          size: iconSize * 1.2,
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(width: size.width * 0.02),
                Expanded(
                  child: TextField(
                    cursorColor: Colors.black,
                    controller: phoneController,
                    keyboardType: TextInputType.phone,
                    style: GoogleFonts.urbanist(color: Colors.black),
                    decoration: InputDecoration(
                      hintText: "Enter phone number",
                      hintStyle: GoogleFonts.urbanist(color: Colors.black87),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: size.height * 0.07),
            ButtonWidget(
              onTap: () async {
                setState(() {
                  isLoading = true;
                });

                String phone =
                    "+${selectedCountry.phoneCode}${phoneController.text.trim()}";
                await sendOtp(phone);
                setState(() {
                  isLoading = false;
                });
              },
              buttonText: "Send OTP",
              isLoading: isLoading,
            ),
          ],
        ),
      ),
    );
  }
}
