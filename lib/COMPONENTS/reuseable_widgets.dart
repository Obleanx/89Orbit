//Please be careful with this codes in this file becus most of them are used in so many parts of the app.
import 'package:fiander/CONSTANTS/constants.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

// You can change the text fields and their designs and functions if there is a problem.
class CustomTextFormField extends StatelessWidget {
  final String labelText;
  final String hintText;
  final TextEditingController? controller;
  final bool readOnly;
  final VoidCallback? onTap;
  final FormFieldValidator<String>? validator;
  final AutovalidateMode autovalidateMode;

  final Widget? suffixIcon;

  const CustomTextFormField({
    Key? key,
    required this.labelText,
    required this.hintText,
    this.controller,
    this.readOnly = false,
    this.onTap,
    this.suffixIcon,
    required this.validator,
    this.autovalidateMode = AutovalidateMode.disabled,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      readOnly: readOnly,
      decoration: InputDecoration(
        labelText: labelText,
        hintText: hintText,
        floatingLabelBehavior: FloatingLabelBehavior.always,
        fillColor: Colors.white,
        filled: true,
        suffixIcon: suffixIcon,
        contentPadding:
            const EdgeInsets.symmetric(vertical: 10.0, horizontal: 12.0),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(7.0),
          borderSide: const BorderSide(
            color: Colors.grey,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(7.0),
          borderSide: const BorderSide(
            color: Colors.grey,
            width: 1,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(7.0),
          //  borderSide: BorderSide(
          // color: Colors.blue,
          //  width: 2.0,
          //  ),
        ),
        hintStyle: const TextStyle(
          color: Colors.grey,
          fontSize: 11.0,
        ),
        labelStyle:
            const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
      ),
      onTap: onTap,
      validator: validator,
      autovalidateMode: autovalidateMode,
    );
  }
}

//Reuseable widgets for the dot indicator at the top of the screens for swiping.

class CustomTickEffect extends WormEffect {
  final IconData tickIcon;
  final Color tickColor;

  CustomTickEffect({
    required this.tickIcon,
    required this.tickColor,
    double dotWidth = 10.0,
    double dotHeight = 4.0,
    Color dotColor = const Color(0xff5c6972),
    Color activeDotColor = Colors.black,
    double spacing = 8.0,
    double radius = 8.0,
  }) : super(
          dotWidth: dotWidth,
          dotHeight: dotHeight,
          dotColor: dotColor,
          activeDotColor: activeDotColor,
          spacing: spacing,
          radius: radius,
        );

  void draw(Canvas canvas, Size size, double progress, double dotOffset) {
    final Paint paint = Paint()..color = dotColor;

    for (int i = 0; i < size.width / (dotWidth + spacing); i++) {
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(i * (dotWidth + spacing), 0, dotWidth, dotHeight),
          Radius.circular(radius),
        ),
        paint,
      );
    }

    // Calculate the active dot position
    final activeIndex = (progress + 0.5).floor();
    final double activeXPos = activeIndex * (dotWidth + spacing);

    // Draw the active dot background
    final Paint activePaint = Paint()..color = activeDotColor;
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(activeXPos, 0, dotWidth, dotHeight),
        Radius.circular(radius),
      ),
      activePaint,
    );

    // Draw tick icon for the active dot
    final tickTextPainter = TextPainter(
      text: TextSpan(
        text: String.fromCharCode(tickIcon.codePoint),
        style: TextStyle(
          fontSize: dotHeight * 1.5,
          fontFamily: tickIcon.fontFamily,
          color: tickColor,
        ),
      ),
      textDirection: TextDirection.ltr,
    );

    tickTextPainter.layout();
    final offset = Offset(
      activeXPos + (dotWidth / 2) - (tickTextPainter.width / 2),
      (size.height - tickTextPainter.height) / 2,
    );
    tickTextPainter.paint(canvas, offset);
  }
}

//reuseable widget for the email authentication/verification
class VerificationScreen extends StatelessWidget {
  final String title;
  final String subtitle;
  final String buttonText;
  // final String phoneNumberButtonText;
  final VoidCallback onButtonPressed;
  final VoidCallback onResendPressed;
  // final VoidCallback onPhoneVerificationPressed;
  final bool isEmailVerified;

  const VerificationScreen({
    Key? key,
    required this.title,
    required this.subtitle,
    required this.buttonText,
    // required this.phoneNumberButtonText,
    required this.onButtonPressed,
    required this.onResendPressed,
    //required this.onPhoneVerificationPressed,
    required this.isEmailVerified,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(subtitle, textAlign: TextAlign.center),
            const SizedBox(height: 20),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: onButtonPressed,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: TextsInsideButtonColor,
                        foregroundColor: Colors.white,
                        disabledBackgroundColor:
                            TextsInsideButtonColor.withOpacity(0.9),
                        padding: const EdgeInsets.symmetric(vertical: 15),
                      ),
                      child: Text(
                        isEmailVerified
                            ? 'Email Verified'
                            : 'Check Email Verification',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  GestureDetector(
                    onTap: onResendPressed,
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.refresh, color: TextsInsideButtonColor),
                        SizedBox(width: 5),
                        Text(
                          'Resend link',
                          style: TextStyle(
                            color: TextsInsideButtonColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
