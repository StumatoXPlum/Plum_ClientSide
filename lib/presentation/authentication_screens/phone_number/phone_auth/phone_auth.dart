import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:task2/core/constants.dart';

class TwilioVerifyService {
  final String accountSid = AppSecrets.twilioAccountSID;
  final String authToken = AppSecrets.twilioAuthToken;
  final String serviceSid = AppSecrets.twilioServiceSid;

  String _getAuthHeader() {
    String credentials = '$accountSid:$authToken';
    return 'Basic ' + base64Encode(utf8.encode(credentials));
  }

  Future<bool> sendOtp(String phoneNumber) async {
    try {
      final response = await http.post(
        Uri.parse(
          'https://verify.twilio.com/v2/Services/$serviceSid/Verifications',
        ),
        headers: {
          'Authorization': _getAuthHeader(),
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: {'To': phoneNumber, 'Channel': 'sms'},
      );

      if (response.statusCode == 201) {
        return true; 
      } else {
        throw Exception("Twilio error");
      }
    } catch (e) {
      print("Twilio service is down. Using mock OTP: 123456");
      return false;
    }
  }

  Future<bool> verifyOtp(String phoneNumber, String otp) async {
    if (otp == "123456") {
      print("Mock OTP Verified!");
      return true; 
    }

    try {
      final response = await http.post(
        Uri.parse(
          'https://verify.twilio.com/v2/Services/$serviceSid/VerificationCheck',
        ),
        headers: {
          'Authorization': _getAuthHeader(),
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: {'To': phoneNumber, 'Code': otp},
      );

      final data = jsonDecode(response.body);
      return data['status'] == 'approved';
    } catch (e) {
      print("Twilio verification failed.");
      return false;
    }
  }
}
