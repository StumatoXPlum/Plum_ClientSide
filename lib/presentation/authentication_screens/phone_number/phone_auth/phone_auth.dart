import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:async';

class PhoneAuthService {
  final SupabaseClient _supabase;
  PhoneAuthService(this._supabase);
  Future<bool> updateUserPhoneNumber(String phoneNumber, String userId) async {
    try {
      if (userId.isEmpty) {
        return false;
      }
      await _supabase.from('users').upsert({
        'id': userId,
        'phonenumber': phoneNumber,
      }, onConflict: 'id');
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> sendPhoneOtpForVerification(String phoneNumber) async {
    try {
      final currentUser = _supabase.auth.currentUser;
      if (currentUser == null) {
        return false;
      }

      await _supabase.auth.signInWithOtp(
        phone: phoneNumber,
        shouldCreateUser: false,
      );
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> verifyPhoneOtpWithoutSignIn(
    String phoneNumber,
    String otp,
  ) async {
    try {
      final currentUser = _supabase.auth.currentUser;
      if (currentUser == null || currentUser.email == null) {
        return false;
      }

      await _supabase.auth.verifyOTP(
        phone: phoneNumber,
        token: otp,
        type: OtpType.sms,
      );

      await _supabase.from('users').upsert({
        'id': currentUser.id,
        'email': currentUser.email!,
        'phonenumber': phoneNumber,
      }, onConflict: 'email');

      return true;
    } catch (e) {
      return false;
    }
  }
}
