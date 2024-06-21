import 'package:fiander/COMPONENTS/reuseablewidgets2.dart';
import 'package:flutter/material.dart';

class YourPasswordScreen extends StatelessWidget {
  const YourPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PasswordCreationScreen(
      title: 'Create Password',
      subtitle: 'Secure your account',
      passwordHint: 'Enter your password',
      confirmPasswordHint: 'Confirm your password',
      submitButtonText: 'Submit',
      onSubmitPressed: () {
        // Add your submit logic here
      },
    );
  }
}
