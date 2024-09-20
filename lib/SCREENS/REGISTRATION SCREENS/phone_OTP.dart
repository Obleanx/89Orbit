// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fiander/SCREENS/REGISTRATION%20SCREENS/avatar_profile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../COMPONENTS/avatar_screens_widget.dart';
import '../../CONSTANTS/constants.dart';

class PhoneVerificationScreen extends StatefulWidget {
  final User user;

  const PhoneVerificationScreen({Key? key, required this.user})
      : super(key: key);

  @override
  _PhoneVerificationScreenState createState() =>
      _PhoneVerificationScreenState();
}

class _PhoneVerificationScreenState extends State<PhoneVerificationScreen> {
  String? _phoneNumber;
  bool _isLoading = true;
  bool _isCodeSent = false;
  bool _isVerifying = false;
  bool _isResending = false;
  int? _resendToken;

  String _verificationId = "";

  final List<TextEditingController> _otpControllers =
      List.generate(6, (index) => TextEditingController());

  @override
  void initState() {
    super.initState();
    // _fetchAndVerifyPhoneNumber();
  }

  void clearOtpFields() {
    for (var controller in _otpControllers) {
      controller.clear();
    }
    if (_otpControllers.isNotEmpty) {
      FocusScope.of(context).requestFocus(FocusNode());
      FocusScope.of(context).focusInDirection(TraversalDirection.down);
    }
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
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
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
                  //  Text(
                  //_phoneNumber != null
                  //   ? 'Please enter the OTP sent to ${formatPhoneNumberForDisplay(_phoneNumber!)}'
                  //   : 'No phone number found. Please update your profile.',
                  // style: const TextStyle(fontSize: 14),
                  //     ),
                  const SizedBox(height: 20),
                  OtpInputSection(
                    onOtpComplete: (String otp) {
                      if (kDebugMode) {
                        print('OTP Entered: $otp');
                      }
                      // Call your verification method here
                    },
                  ),
                  const Spacer(),
                  Center(
                    child: ElevatedButton(
                      onPressed: () async {
                        if (!_isCodeSent) {
                          // Perform Send OTP function
                          //await _verifyPhoneNumber();
                        } else if (!_isVerifying) {
                          // Perform Verify Account function
                          setState(() {
                            _isVerifying = true;
                          });
                          showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (BuildContext context) {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            },
                          );
                          try {
                            //      await _submitOTP();
                          } finally {
                            Navigator.of(context)
                                .pop(); // Dismiss the loading indicator
                            setState(() {
                              _isVerifying = false;
                            });
                          }
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        elevation: 8.0,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15)),
                        backgroundColor: TextsInsideButtonColor,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 12),
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

                        try {
                          // await _resendOTP();
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text("OTP resent successfully")),
                          );
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Failed to resend OTP: $e")),
                          );
                        } finally {
                          setState(() {
                            _isResending = false;
                          });
                        }
                      },
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.refresh,
                            color: _isResending
                                ? Colors.grey
                                : TextsInsideButtonColor,
                          ),
                          const SizedBox(width: 5),
                          Text(
                            _isResending ? 'Resending...' : 'Resend Code',
                            style: TextStyle(
                              color: _isResending
                                  ? Colors.grey
                                  : TextsInsideButtonColor,
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
  List<TextEditingController> _otpControllers =
      List.generate(6, (_) => TextEditingController());
  List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());

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

  void clearOtpFields() {
    for (var controller in _otpControllers) {
      controller.clear();
    }
    _focusNodes.first.requestFocus();
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
