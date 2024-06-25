import 'package:flutter/material.dart';
import '../CONSTANTS/constants.dart';

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
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  String _password = '';
  String _confirmPassword = '';

  bool _passwordsMatch() {
    return _password == _confirmPassword;
  }

  bool _hasEightCharacters(String password) => password.length >= 8;
  bool _hasUpperCase(String password) => password.contains(RegExp(r'[A-Z]'));
  bool _hasLowerCase(String password) => password.contains(RegExp(r'[a-z]'));
  bool _hasSpecialCharacter(String password) =>
      password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset:
          true, // Ensures the body resizes when keyboard appears

      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis
            .vertical, //enables the screen to scroll up and prevent crashing from the top
        child: Padding(
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
              Text(
                widget.subtitle,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Enter your password',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
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
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 12.0),
                      isDense:
                          true, // Reduces the vertical padding and height of the TextField
                      // Adjust vertical padding

                      border: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                      hintText: widget.passwordHint,
                      hintStyle: const TextStyle(fontSize: 12),
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
                ],
              ),
              const SizedBox(height: 20),

              // Validation indicators with text
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildValidationIndicator(
                    isValid: _hasEightCharacters(_password),
                    text: '8 characters password',
                  ),
                  const SizedBox(height: 10),
                  _buildValidationIndicator(
                    isValid: _hasUpperCase(_password),
                    text: '1 upper case letter',
                  ),
                  const SizedBox(height: 10),
                  _buildValidationIndicator(
                    isValid: _hasLowerCase(_password),
                    text: '1 lower case letter',
                  ),
                  const SizedBox(height: 10),
                  _buildValidationIndicator(
                    isValid: _hasSpecialCharacter(_password),
                    text: '1 special character',
                  ),
                ],
              ),

              const SizedBox(height: 19),
              const Text(
                'Confirm password',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Stack(
                children: [
                  TextField(
                    controller: _confirmPasswordController,
                    obscureText: !_isConfirmPasswordVisible,
                    onChanged: (value) {
                      setState(() {
                        _confirmPassword = value;
                      });
                    },
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 12.0),
                      isDense: true,
                      border: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                      hintText: widget.confirmPasswordHint,
                      hintStyle: const TextStyle(fontSize: 12),
                      errorText:
                          !_passwordsMatch() ? 'Passwords do not match' : null,
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
                ],
              ),

              const SizedBox(height: 200),

              Align(
                alignment: Alignment.bottomCenter,
                child: ElevatedButton(
                  onPressed: widget.onSubmitPressed,
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(50),
                    backgroundColor:
                        TextsInsideButtonColor, // Customize button color as needed
                  ),
                  child: Text(
                    widget.submitButtonText,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildValidationIndicator(
      {required bool isValid, required String text}) {
    return Row(
      children: [
        Container(
          width: 20,
          height: 20,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isValid ? Colors.green : Colors.red,
          ),
          child: Center(
            child: Icon(
              isValid ? Icons.check : Icons.close,
              color: Colors.white,
              size: 20,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          text,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 14,
            color: isValid ? Colors.green : Colors.red,
          ),
        ),
      ],
    );
  }
}
