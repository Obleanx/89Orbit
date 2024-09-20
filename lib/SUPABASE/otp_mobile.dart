// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../COMPONENTS/avatar_screens_widget.dart';
import '../../CONSTANTS/constants.dart';

class OtpVerificationScreen extends StatefulWidget {
  const OtpVerificationScreen({Key? key}) : super(key: key);

  @override
  _OtpVerificationScreenState createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  bool _isCodeSent = false;
  bool _isVerifying = false;
  bool _isResending = false;
  final List<TextEditingController> _otpControllers =
      List.generate(6, (index) => TextEditingController());

  @override
  void dispose() {
    for (var controller in _otpControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _handleBackspace(int index) {
    if (_otpControllers[index].text.isEmpty && index > 0) {
      _otpControllers[index - 1].clear();
      FocusScope.of(context).previousFocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Verify your phone number',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 23,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Please enter the OTP sent to your phone number.',
              style: TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 20),
            OtpInputSection(
              onOtpComplete: (String otp) {
                if (_isCodeSent && !_isVerifying) {
                  setState(() {
                    _isVerifying = true;
                  });
                  // Add OTP verification function call here
                }
              },
            ),
            const Spacer(),
            Center(
              child: ElevatedButton(
                onPressed: () async {
                  if (!_isCodeSent) {
                    // Call send OTP function
                    setState(() {
                      _isCodeSent = true;
                    });
                  }
                },
                style: ElevatedButton.styleFrom(
                  elevation: 8.0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                  backgroundColor: TextsInsideButtonColor,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  minimumSize: const Size(100, 30),
                ),
                child: Text(
                  _isCodeSent ? 'Verify Account' : 'Send OTP',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Center(
              child: GestureDetector(
                onTap: () async {
                  setState(() {
                    _isResending = true;
                  });
                  // Add resend OTP function here
                  setState(() {
                    _isResending = false;
                  });
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.refresh,
                      color:
                          _isResending ? Colors.grey : TextsInsideButtonColor,
                    ),
                    const SizedBox(width: 5),
                    Text(
                      _isResending ? 'Resending...' : 'Resend Code',
                      style: TextStyle(
                        color:
                            _isResending ? Colors.grey : TextsInsideButtonColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class OtpInputSection extends StatefulWidget {
  final Function(String) onOtpComplete;

  OtpInputSection({Key? key, required this.onOtpComplete}) : super(key: key);

  @override
  _OtpInputSectionState createState() => _OtpInputSectionState();
}

class _OtpInputSectionState extends State<OtpInputSection> {
  final List<TextEditingController> _otpControllers =
      List.generate(6, (_) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());

  @override
  void initState() {
    super.initState();
    for (int i = 0; i < 6; i++) {
      _otpControllers[i].addListener(() {
        if (_otpControllers[i].text.length == 1 && i < 5) {
          _focusNodes[i + 1].requestFocus();
        }
        _checkOtpComplete();
      });
    }
  }

  void _checkOtpComplete() {
    String otp = _otpControllers.map((controller) => controller.text).join();
    if (otp.length == 6) {
      widget.onOtpComplete(otp);
    }
  }

  void _handleBackspace(int index) {
    if (_otpControllers[index].text.isEmpty && index > 0) {
      _otpControllers[index - 1].clear();
      _focusNodes[index - 1].requestFocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: List.generate(
        6,
        (index) => SizedBox(
          width: 45,
          height: 45,
          child: TextFormField(
            controller: _otpControllers[index],
            focusNode: _focusNodes[index],
            keyboardType: TextInputType.number,
            textAlign: TextAlign.center,
            maxLength: 1,
            decoration: InputDecoration(
              counterText: "",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onChanged: (value) {
              if (value.isEmpty) {
                _handleBackspace(index);
              }
            },
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    for (var controller in _otpControllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }
}
