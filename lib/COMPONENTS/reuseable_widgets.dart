//Please be careful with this codes in this file becus most of them are used in so many parts of the app.

import 'dart:async';
import 'package:fiander/CONSTANTS/constants.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:intl_phone_field/phone_number.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

// Reusable widgets for the emails and account creation screens
// You can change the text fields and their designs and functions if there is a problem.
class CustomTextFormField extends StatelessWidget {
  final String labelText;
  final String hintText;
  final TextEditingController? controller;
  final bool readOnly;
  final VoidCallback? onTap;
  final FormFieldValidator<String>? validator;
  final Widget? suffixIcon;

  const CustomTextFormField({
    Key? key,
    required this.labelText,
    required this.hintText,
    this.controller,
    this.readOnly = false,
    this.onTap,
    this.validator,
    this.suffixIcon,
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
    );
  }
}

//reuseable widgets for phone number picker
//you can change the design of the textfield for the phonenumber button here.
class CustomPhoneNumberField extends StatelessWidget {
  final TextEditingController? controller;
  final FutureOr<String?> Function(PhoneNumber?)? validator;
  final String initialCountryCode;

  const CustomPhoneNumberField({
    Key? key,
    this.controller,
    this.validator,
    this.initialCountryCode = 'NG', // Nigeria as the default country code
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IntlPhoneField(
      controller: controller,
      decoration: InputDecoration(
        labelText: 'Phone Number',
        hintText: 'Enter your phone number',
        fillColor: Colors.white,
        filled: true,
        contentPadding:
            const EdgeInsets.symmetric(vertical: 10.0, horizontal: 12.0),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: const BorderSide(
            color: Colors.grey,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(7.0),
          borderSide: const BorderSide(
            color: Colors.grey,
            width: 1.0,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(7.0),
        ),
        labelStyle: const TextStyle(
          color: Colors.grey,
          fontSize: 12,
        ),
      ),
      initialCountryCode: initialCountryCode,
      onChanged: (phone) {
        if (kDebugMode) {
          print(phone.completeNumber);
        } // You can handle phone number changes here
      },
      validator: validator,
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
    final double halfHeight = dotHeight / 2;
    final double dotOffsetEnd = dotOffset + dotWidth;
    final double xPos = dotOffset + (dotWidth / 2);
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
//reuseable widget for the email and phonenumber authentication
//this design Holds he UI for the email, phonenumber, forgot password and create password screens.

class VerificationScreen extends StatelessWidget {
  final String title;
  final String subtitle;

  final String buttonText;
  final String phoneNumberButtonText;

  final VoidCallback onButtonPressed;
  final VoidCallback onResendPressed;

  const VerificationScreen({
    Key? key,
    required this.title,
    required this.subtitle,
    required this.buttonText,
    required this.phoneNumberButtonText, // Pass this as a parameter
    // New parameter for phone number button text

    required this.onButtonPressed,
    required this.onResendPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: 20,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 4), // Adjust height as needed for spacing
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(5, (index) {
                return SizedBox(
                  height: 50,
                  width: 54,
                  child: TextField(
                    onChanged: (value) {
                      if (value.length == 1) {
                        FocusScope.of(context).nextFocus();
                      }
                    },
                    style: Theme.of(context).textTheme.titleLarge,
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(1),
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                    onSubmitted: (pin) {},
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                    ),
                  ),
                );
              }),
            ),
            const SizedBox(height: 10),
            InkWell(
              onTap: () {
                // Navigate to another screen or perform action
                // For example:
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(builder: (context) => PhoneNumberVerificationScreen()),
                // );
              },
              child: Text(
                phoneNumberButtonText, // Use the customizable text here
                style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.normal,
                    color: TextsInsideButtonColor),
              ),
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: onButtonPressed,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(50),
                backgroundColor:
                    TextsInsideButtonColor, // Customize button color if needed
              ),
              child: Text(
                buttonText,
                style: const TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: const Icon(
                    Icons.refresh,
                    color: TextsInsideButtonColor,
                  ),
                  onPressed: onResendPressed,
                ),
                TextButton(
                  onPressed: onResendPressed,
                  child: const Text(
                    'Resend Code',
                    style: TextStyle(
                      color: TextsInsideButtonColor,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
