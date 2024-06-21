import 'package:flutter/material.dart';

class EmailVerificationProvider extends ChangeNotifier {
  String _email = '';
  String _verificationCode = '';
  bool _isEmailSent = false;
  bool _isVerified = false;

  String get email => _email;
  String get verificationCode => _verificationCode;
  bool get isEmailSent => _isEmailSent;
  bool get isVerified => _isVerified;

  void setEmail(String email) {
    _email = email;
    notifyListeners();
  }

  void setVerificationCode(String code) {
    _verificationCode = code;
    notifyListeners();
  }

  void setEmailSent(bool isSent) {
    _isEmailSent = isSent;
    notifyListeners();
  }

  void setVerified(bool isVerified) {
    _isVerified = isVerified;
    notifyListeners();
  }
}
