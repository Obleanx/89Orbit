import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../CONSTANTS/constants.dart';

class SubmitPreferencesButton extends StatefulWidget {
  const SubmitPreferencesButton({Key? key}) : super(key: key);

  @override
  _SubmitPreferencesButtonState createState() =>
      _SubmitPreferencesButtonState();
}

class _SubmitPreferencesButtonState extends State<SubmitPreferencesButton> {
  bool _isLoading = false;

  void _submitPreferences() async {
    // Simulate a network request or long task
    setState(() {
      _isLoading = true;
    });

    // Simulate a delay for the network request
    await Future.delayed(const Duration(seconds: 3));

    setState(() {
      _isLoading = false;
    });

    // Handle the completion of the task here (e.g., show a success message)
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: _isLoading
          ? null // Disable button if loading
          : _submitPreferences,
      style: ElevatedButton.styleFrom(
        elevation: 8.0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        backgroundColor: _isLoading
            ? Colors.grey
            : TextsInsideButtonColor, // Adjust background color
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        minimumSize: const Size(140, 40),
      ),
      child: _isLoading
          ? const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                strokeWidth: 2,
              ),
            )
          : const Text(
              'Continue',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
    );
  }
}
