// ignore_for_file: use_build_context_synchronously
import 'package:fiander/SCREENS/REGISTRATION%20SCREENS/phone_OTP.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../../COMPONENTS/reuseable_widgets.dart';

class EmailVerificationScreen extends StatefulWidget {
  final User user;

  const EmailVerificationScreen(
      {Key? key,
      required this.user,
      required void Function(User? user) setCurrentUser})
      : super(key: key);

  @override
  _EmailVerificationScreenState createState() =>
      _EmailVerificationScreenState();
}

class _EmailVerificationScreenState extends State<EmailVerificationScreen> {
  bool isEmailVerified = false;

  @override
  void initState() {
    super.initState();
    sendVerificationEmail();
  }

  Future<void> sendVerificationEmail() async {
    try {
      await widget.user.sendEmailVerification();
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Email Sent'),
            content:
                const Text('Verification email sent. Please check your inbox.'),
            actions: <Widget>[
              TextButton(
                child: const Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    } catch (e) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Error'),
            content: Text('Error sending verification email: $e'),
            actions: <Widget>[
              TextButton(
                child: const Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }

  Future<void> checkEmailVerification() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        // Force refresh the user
        await user.reload();

        // Get the refreshed user
        user = FirebaseAuth.instance.currentUser;

        if (kDebugMode) {
          print('User email: ${user?.email}');
        }
        if (kDebugMode) {
          print('Is email verified: ${user?.emailVerified}');
        }

        if (user?.emailVerified == true) {
          if (kDebugMode) {
            print('Email is verified');
          }
          // Update the  app state and it navigates to the appropriate screen
          setState(() {
            isEmailVerified = true;
          });

          // Show a success message to the user
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('Success'),
                content: const Text('Email verified successfully!'),
                actions: <Widget>[
                  TextButton(
                    child: const Text('OK'),
                    onPressed: () {
                      Navigator.of(context).pop();
                      // Navigate to PhoneVerificationScreen
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (context) =>
                              PhoneVerificationScreen(user: user!),
                        ),
                      );
                    },
                  ),
                ],
              );
            },
          );
        } else {
          if (kDebugMode) {
            print('Email is not verified yet');
          }
          setState(() {
            isEmailVerified = false;
          });

          // Show a message to the user
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('Verification Pending'),
                content: const Text(
                    'Email is not verified yet. Please check your inbox and verify your email.'),
                actions: <Widget>[
                  TextButton(
                    child: const Text('OK'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            },
          );
        }
      } else {
        if (kDebugMode) {
          print('No user is currently signed in.');
        }

        // Show a message to the user
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('No User'),
              content: const Text('No user is currently signed in.'),
              actions: <Widget>[
                TextButton(
                  child: const Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error checking email verification: $e');
      }

      // Show error message to the user
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Error'),
            content: Text('Error checking email verification: $e'),
            actions: <Widget>[
              TextButton(
                child: const Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return VerificationScreen(
      title: 'Verify your email',
      subtitle:
          'A verification link has been sent to ${widget.user.email}. Please check your email and click the link to verify.',
      buttonText: 'Check Verification Status',
      // phoneNumberButtonText: 'Verify Phone Number',
      onButtonPressed: checkEmailVerification,
      onResendPressed: sendVerificationEmail,
      //onPhoneVerificationPressed: onPhoneVerificationPressed,
      isEmailVerified: isEmailVerified,
    );
  }
}
