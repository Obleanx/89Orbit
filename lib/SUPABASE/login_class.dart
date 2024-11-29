import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> login({
    required BuildContext context,
    required String email,
    required String password,
    required VoidCallback onSuccess,
  }) async {
    // Validate email and password fields
    if (email.trim().isEmpty || password.trim().isEmpty) {
      _showSnackBar(context, 'Please enter both email and password', isError: true);
      return;
    }

    // Show loading dialog
    _showLoadingDialog(context);

    try {
      // Attempt to sign in with Firebase
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );

      // Close loading dialog
      Navigator.of(context).pop();

      // Check if email is verified
      if (userCredential.user != null && userCredential.user!.emailVerified) {
        // Call success callback
        onSuccess();
      } else {
        // Email not verified
        await userCredential.user?.reload();
        
        _showEmailVerificationDialog(context, userCredential.user);
      }
    } on FirebaseAuthException catch (e) {
      // Close loading dialog
      Navigator.of(context).pop();

      // Handle specific Firebase authentication errors
      String errorMessage = _getErrorMessage(e);
      _showSnackBar(context, errorMessage, isError: true);
    } catch (e) {
      // Close loading dialog
      Navigator.of(context).pop();

      // Show generic error message
      _showSnackBar(context, 'An unexpected error occurred', isError: true);
    }
  }

  void _showLoadingDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const Center(
          child: CircularProgressIndicator(
            color: Colors.blue, // Replace with your app's color
          ),
        );
      },
    );
  }

  void _showSnackBar(BuildContext context, String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
      ),
    );
  }

  void _showEmailVerificationDialog(BuildContext context, User? user) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Email Not Verified'),
          content: const Text('Please verify your email before logging in. Check your inbox or spam folder.'),
          actions: <Widget>[
            TextButton(
              child: const Text('Resend Verification'),
              onPressed: () async {
                try {
                  await user?.sendEmailVerification();
                  Navigator.of(context).pop();
                  _showSnackBar(context, 'Verification email sent');
                } catch (e) {
                  Navigator.of(context).pop();
                  _showSnackBar(context, 'Failed to send verification email', isError: true);
                }
              },
            ),
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

  String _getErrorMessage(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return 'No user found with this email.';
      case 'wrong-password':
        return 'Incorrect password.';
      case 'invalid-email':
        return 'Invalid email address.';
      case 'user-disabled':
        return 'This account has been disabled.';
      default:
        return e.message ?? 'Login failed';
    }
  }
}