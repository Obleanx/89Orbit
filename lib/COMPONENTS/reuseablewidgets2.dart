import 'package:flutter/material.dart';

class PasswordCreationScreen extends StatefulWidget {
  final String title;
  final String subtitle;
  final String passwordHint;
  final String confirmPasswordHint;
  final String submitButtonText;
  final VoidCallback onSubmitPressed;

  const PasswordCreationScreen({
    Key? key,
    required this.title,
    required this.subtitle,
    required this.passwordHint,
    required this.confirmPasswordHint,
    required this.submitButtonText,
    required this.onSubmitPressed,
  }) : super(key: key);

  @override
  _PasswordCreationScreenState createState() => _PasswordCreationScreenState();
}

class _PasswordCreationScreenState extends State<PasswordCreationScreen> {
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  String _password = '';
  String _confirmPassword = '';

  bool _isPasswordValid() {
    // Password must be at least 8 characters long, have at least 1 uppercase, 1 lowercase, and 1 special character
    if (_password.length >= 8 &&
        _password.contains(RegExp(r'[A-Z]')) &&
        _password.contains(RegExp(r'[a-z]')) &&
        _password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0, // No elevation
        backgroundColor: Colors.transparent, // Transparent app bar
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 24,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              widget.subtitle,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Enter your password',
              style: TextStyle(
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 8),
            Stack(
              children: [
                TextField(
                  obscureText: !_isPasswordVisible,
                  onChanged: (value) {
                    setState(() {
                      _password = value;
                    });
                  },
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                    hintText: widget.passwordHint,
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isPasswordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(() {
                          _isPasswordVisible = !_isPasswordVisible;
                        });
                      },
                    ),
                  ),
                ),
                Positioned(
                  top: 0,
                  right: 0,
                  bottom: 0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      _password.isNotEmpty
                          ? Icon(
                              _isPasswordValid()
                                  ? Icons.check_circle
                                  : Icons.radio_button_unchecked,
                              color: _isPasswordValid()
                                  ? Colors.green
                                  : Colors.grey,
                            )
                          : const SizedBox(),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Text(
              'Confirm password',
              style: TextStyle(
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 8),
            Stack(
              children: [
                TextField(
                  obscureText: !_isConfirmPasswordVisible,
                  onChanged: (value) {
                    setState(() {
                      _confirmPassword = value;
                    });
                  },
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                    hintText: widget.confirmPasswordHint,
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isConfirmPasswordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(() {
                          _isConfirmPasswordVisible =
                              !_isConfirmPasswordVisible;
                        });
                      },
                    ),
                  ),
                ),
                Positioned(
                  top: 0,
                  right: 0,
                  bottom: 0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      _confirmPassword.isNotEmpty
                          ? Icon(
                              _password == _confirmPassword
                                  ? Icons.check_circle
                                  : Icons.radio_button_unchecked,
                              color: _password == _confirmPassword
                                  ? Colors.green
                                  : Colors.grey,
                            )
                          : const SizedBox(),
                    ],
                  ),
                ),
              ],
            ),
            const Spacer(),
            Center(
              child: ElevatedButton(
                onPressed: widget.onSubmitPressed,
                child: Text(widget.submitButtonText),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
