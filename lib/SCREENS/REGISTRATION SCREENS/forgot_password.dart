import 'package:fiander/COMPONENTS/reuseablewidgets2.dart';
import 'package:flutter/material.dart';

import '../login_screen.dart';

class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PasswordCreationScreen(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => const LoginWithPhonenumber()),
            ); // Adjust route as needed
          },
        ),
      ),
      title: 'Reset your Password',
      subtitle: 'Secure your account',
      passwordHint: 'Enter your new password',
      confirmPasswordHint: 'Confirm your password',
      submitButtonText: 'Submit',
      onSubmitPressed: () {
        // Add your submit logic here
      },
    );
  }
}
