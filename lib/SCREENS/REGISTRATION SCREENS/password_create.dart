import 'package:fiander/COMPONENTS/reuseablewidgets2.dart';
import 'package:fiander/SCREENS/onboarding_state.dart';
import 'package:flutter/material.dart';

class YourPasswordScreen extends StatelessWidget {
  const YourPasswordScreen({super.key});

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
              MaterialPageRoute(builder: (context) => const slider()),
            ); // Adjust route as needed
          },
        ),
      ),
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
