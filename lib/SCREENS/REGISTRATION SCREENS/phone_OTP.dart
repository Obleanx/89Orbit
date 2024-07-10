// ignore_for_file: library_private_types_in_public_api
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

  String _verificationId = "";

  final FirebaseAuth _auth = FirebaseAuth.instance;

  final List<TextEditingController> _otpControllers =
      List.generate(6, (index) => TextEditingController());

  @override
  void initState() {
    super.initState();
    _fetchPhoneNumber();
  }

  Future<void> _fetchPhoneNumber() async {
    try {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.user.uid)
          .get();

      if (userDoc.exists) {
        setState(() {
          _phoneNumber = userDoc.get('phone') as String?;
          _isLoading = false;
        });
        if (_phoneNumber != null) {
          _verifyPhoneNumber();
        }
      } else {
        setState(() {
          _isLoading = false;
        });
        // Handle the case where user document doesn't exist
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error fetching phone number: $e");
      }
      setState(() {
        _isLoading = false;
      });
      // Handle the error (show a message to the user, etc.)
    }
  }

  Future<void> _verifyPhoneNumber() async {
    if (_phoneNumber == null) return;

    await _auth.verifyPhoneNumber(
      phoneNumber: _phoneNumber!,
      verificationCompleted: (PhoneAuthCredential credential) async {
        await _auth.currentUser?.updatePhoneNumber(credential);
        // Navigate to next screen or show success message
      },
      verificationFailed: (FirebaseAuthException e) {
        // Show error message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Verification Failed: ${e.message}")),
        );
      },
      codeSent: (String verificationId, int? resendToken) {
        setState(() {
          _verificationId = verificationId;
          _isCodeSent = true;
          _isLoading = false;
        });
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        setState(() {
          _verificationId = verificationId;
          _isLoading = false;
        });
      },
    );
  }

  Future<void> _submitOTP() async {
    String otp = _otpControllers.map((controller) => controller.text).join();
    if (otp.length != 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter a valid 6-digit OTP")),
      );
      return;
    }

    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: _verificationId,
        smsCode: otp,
      );
      await _auth.currentUser?.updatePhoneNumber(credential);
      // Navigate to next screen or show success message
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Verification Failed: $e")),
      );
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
                  Text(
                    _phoneNumber != null
                        ? 'Please enter the OTP sent to $_phoneNumber'
                        : 'No phone number found. Please update your profile.',
                    style: const TextStyle(fontSize: 14),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: List.generate(6, (index) {
                      return Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          border: Border.all(color: Colors.grey),
                        ),
                        child: SizedBox(
                          height: 45,
                          width: 45,
                          child: TextFormField(
                            controller: _otpControllers[index],
                            onChanged: (value) {
                              if (value.length == 1 && index < 5) {
                                FocusScope.of(context).nextFocus();
                              }
                            },
                            onSaved: (pin1) {},
                            keyboardType: TextInputType.number,
                            textAlign: TextAlign.center,
                            inputFormatters: [
                              LengthLimitingTextInputFormatter(1),
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                  const Spacer(),
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        onPressed:
                        _isCodeSent ? _submitOTP : null;
                      },
                      style: elevatedButtonDesign,
                      child: const Text(
                        'Verify Account',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  if (!_isCodeSent) ...[
                    SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: _verifyPhoneNumber,
                      child: Text('Send OTP'),
                    ),
                  ],
                  const SizedBox(height: 10),
                  Center(
                    child: GestureDetector(
                      onTap: () {
                        onTap:
                        _verifyPhoneNumber;
                      },
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.refresh,
                            color: TextsInsideButtonColor,
                          ),
                          SizedBox(width: 5),
                          Text(
                            'Resend Code',
                            style: TextStyle(
                              color: TextsInsideButtonColor,
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
