import 'package:flutter/material.dart';

class OtpProvider extends ChangeNotifier {
  bool isCodeSent = false;
  bool isVerifying = false;

  Future<void> sendOtp() async {
    // Implement OTP sending logic here
    isCodeSent = true;
    notifyListeners();
  }

  Future<void> verifyOtp(String otp) async {
    isVerifying = true;
    notifyListeners();
    // Implement OTP verification logic here
    isVerifying = false;
    notifyListeners();
  }

  Future<void> resendOtp() async {
    // Implement OTP resending logic here
  }
}
