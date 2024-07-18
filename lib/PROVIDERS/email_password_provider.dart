import 'package:flutter/material.dart';

class EmailPasswordProvider extends ChangeNotifier {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  String _password = '';
  String _confirmPassword = '';

  bool get isPasswordVisible => _isPasswordVisible;
  bool get isConfirmPasswordVisible => _isConfirmPasswordVisible;
  String get password => _password;
  String get confirmPassword => _confirmPassword;

  get phoneNumberController => null;

  void togglePasswordVisibility() {
    _isPasswordVisible = !_isPasswordVisible;
    notifyListeners();
  }

  void toggleConfirmPasswordVisibility() {
    _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
    notifyListeners();
  }

  void setPassword(String value) {
    _password = value;
    notifyListeners();
  }

  void setConfirmPassword(String value) {
    _confirmPassword = value;
    notifyListeners();
  }

  bool passwordsMatch() {
    return _password == _confirmPassword;
  }

  bool hasEightCharacters() => _password.length >= 8;
  bool hasUpperCase() => _password.contains(RegExp(r'[A-Z]'));
  bool hasLowerCase() => _password.contains(RegExp(r'[a-z]'));
  bool hasSpecialCharacter() =>
      _password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'));
  bool isPasswordTyped = false;
  bool isConfirmPasswordTyped = false;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  bool isFormValid() {
    return emailController.text.isNotEmpty &&
        isValidEmail() &&
        _password.isNotEmpty &&
        _confirmPassword.isNotEmpty &&
        passwordsMatch() &&
        hasEightCharacters() &&
        hasUpperCase() &&
        hasLowerCase() &&
        hasSpecialCharacter();
  }

  bool isValidEmail() {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
        .hasMatch(emailController.text);
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password cannot be empty';
    }
    return null;
  }

  String? validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Confirm password cannot be empty';
    }
    if (value != passwordController.text) {
      return 'Passwords do not match';
    }
    return null;
  }
}
