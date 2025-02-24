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

    return response.statusCode == 201;
  }

  Future<bool> verifyOtp(String phoneNumber, String otp) async {
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
  }
}
