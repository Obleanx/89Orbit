import 'package:flutter/material.dart';
import '../../COMPONENTS/reuseable_widgets.dart';

class EmailVerificationScreen extends StatelessWidget {
  const EmailVerificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return VerificationScreen(
      title: 'Verify your email', // Customize the title here
      subtitle:
          'Please enter the OTP sent to example@gmail.com', // Customize the subtitle here
      buttonText: 'Verify Account', // Customize the button text here
      phoneNumberButtonText:
          'Verify your phonenumber', // Customize the phone number button text here
      onButtonPressed: () {
        // Add your verification logic here
      },
      onResendPressed: () {
        // Add your resend logic here
      },
    );
  }
}
