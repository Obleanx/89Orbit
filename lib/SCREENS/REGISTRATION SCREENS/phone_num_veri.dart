import 'package:flutter/material.dart';
import 'package:fiander/COMPONENTS/reuseable_widgets.dart';
import 'package:fiander/providers/email_verification_provider.dart';
import 'package:provider/provider.dart';

class PhoneVerificationScreen extends StatelessWidget {
  const PhoneVerificationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<EmailVerificationProvider>(context);

    return VerificationScreen(
      title: 'Verify your Phone Number', // Customize the title here
      subtitle:
          'Please enter the OTP sent to +23480000008', // Customize the subtitle here
      buttonText: 'Verify Account', // Customize the button text here
      phoneNumberButtonText:
          'Verify your email', // Customize the phone number button text here
      onButtonPressed: () {
        // Add your verification logic here
      },
      onResendPressed: () {
        // Add your resend logic here
      },
    );
  }
}
