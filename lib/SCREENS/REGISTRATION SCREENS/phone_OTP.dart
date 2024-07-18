// ignore_for_file: library_private_types_in_public_api
import 'package:cloud_firestore/cloud_firestore.dart';
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

  String _verificationId = "";

  final FirebaseAuth _auth = FirebaseAuth.instance;

  final List<TextEditingController> _otpControllers =
      List.generate(6, (index) => TextEditingController());

  @override
  void initState() {
    super.initState();
    _fetchAndVerifyPhoneNumber();
  }

  Future<void> _fetchAndVerifyPhoneNumber() async {
    setState(() {
      _isLoading = true;
    });

    try {
      print("Fetching user document for UID: ${widget.user.uid}");
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.user.uid)
          .get();

      print("User document exists: ${userDoc.exists}");
      if (userDoc.exists) {
        print("Raw data from Firestore: ${userDoc.data()}");
        String? phoneNumber = userDoc.get('phone') as String?;
        print("Retrieved phone number: $phoneNumber");

        if (phoneNumber != null && phoneNumber.isNotEmpty) {
          phoneNumber = formatToE164(phoneNumber);
          print("Formatted phone number: $phoneNumber");
          setState(() {
            _phoneNumber = phoneNumber;
          });
          print("_phoneNumber set to: $_phoneNumber");
        } else {
          print("Phone number is null or empty");
        }
      } else {
        print("User document does not exist");
      }
    } catch (e) {
      print("Error fetching phone number: $e");
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _verifyPhoneNumber() async {
    if (_phoneNumber == null || _phoneNumber!.isEmpty) {
      print("Error: Phone number is null or empty");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Phone number is missing")),
      );
      return;
    }

    print("Attempting to verify phone number: $_phoneNumber");

    int retryCount = 0;
    const int maxRetries = 3;
    const Duration retryDelay = Duration(seconds: 5);

    while (retryCount < maxRetries) {
      try {
        await FirebaseAuth.instance.verifyPhoneNumber(
          phoneNumber: _phoneNumber!,
          verificationCompleted: (PhoneAuthCredential credential) async {
            print("Verification completed automatically");
            await _updateUserPhoneNumber(credential);
          },
          verificationFailed: (FirebaseAuthException e) {
            print("Verification failed: ${e.message}");
            throw e; // Rethrow to be caught in the outer try-catch
          },
          codeSent: (String verificationId, int? resendToken) {
            print("Verification code sent");
            setState(() {
              _verificationId = verificationId;
              _isCodeSent = true;
            });
          },
          codeAutoRetrievalTimeout: (String verificationId) {
            print("Auto retrieval timeout");
            setState(() {
              _verificationId = verificationId;
            });
          },
          timeout: const Duration(seconds: 60),
          forceResendingToken: null,
        );

        // If we reach here, it means the operation was successful
        break;
      } catch (e) {
        print("Error in verifyPhoneNumber: $e");
        retryCount++;
        if (retryCount >= maxRetries) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text(
                    "Failed to verify phone number after $maxRetries attempts")),
          );
        } else {
          print("Retrying in $retryDelay...");
          await Future.delayed(retryDelay);
        }
      }
    }
  }

  Future<void> _updateUserPhoneNumber(PhoneAuthCredential credential) async {
    try {
      await FirebaseAuth.instance.currentUser?.updatePhoneNumber(credential);
      print("Phone number updated successfully in Firebase Auth");

      // Update Firestore to indicate the number is verified
      await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.user.uid)
          .update({
        'phoneVerified': true,
        'phone': _phoneNumber,
      });
      print("Phone number updated and marked as verified in Firestore");

      // Navigate to next screen or show success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Phone number verified successfully")),
      );
    } catch (e) {
      print("Error updating phone number: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to update phone number: $e")),
      );
    }
  }

  //this function allows the inputed phone number to be only in the E.164 format required by the cloud service for phone OTP. abeg the careful here!!!
  String formatToE164(String phoneNumber) {
    // Remove any non-digit characters
    phoneNumber = phoneNumber.replaceAll(RegExp(r'\D'), '');

    // Check if the number already starts with +234
    if (phoneNumber.startsWith('+234')) {
      return phoneNumber;
    }

    // If it starts with 234, just add the +
    if (phoneNumber.startsWith('234')) {
      return '+$phoneNumber';
    }

    // If it starts with 0, replace it with +234
    if (phoneNumber.startsWith('0')) {
      return '+234${phoneNumber.substring(1)}';
    }

    // If none of the above, assume it's a local number and add +234
    return '+234$phoneNumber';
  }

// Your existing formatToE164 function remains unchanged

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

  String formatPhoneNumberForDisplay(String phoneNumber) {
    // Remove any non-digit characters
    String digitsOnly = phoneNumber.replaceAll(RegExp(r'\D'), '');

    // If it doesn't start with the country code, add it
    if (!digitsOnly.startsWith('234')) {
      digitsOnly = '234' +
          (digitsOnly.startsWith('0') ? digitsOnly.substring(1) : digitsOnly);
    }

    // Format the number for display without space after country code
    return '+$digitsOnly';
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
                        ? 'Please enter the OTP sent to ${formatPhoneNumberForDisplay(_phoneNumber!)}'
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
                        // Navigator.pushReplacement(
                        //  context,
                        // MaterialPageRoute(
                        // builder: (context) => AvatarSelectionScreen(avatarImages: [],),
                        //  ),
                        // );
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
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: _verifyPhoneNumber,
                      child: const Text('Send OTP'),
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
