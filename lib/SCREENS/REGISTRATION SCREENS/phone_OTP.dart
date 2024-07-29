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
      if (kDebugMode) {
        print("Fetching user document for UID: ${widget.user.uid}");
      }
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.user.uid)
          .get();

      if (kDebugMode) {
        print("User document exists: ${userDoc.exists}");
      }
      if (userDoc.exists) {
        if (kDebugMode) {
          print("Raw data from Firestore: ${userDoc.data()}");
        }
        String? phoneNumber = userDoc.get('phone') as String?;
        if (kDebugMode) {
          print("Retrieved phone number: $phoneNumber");
        }

        if (phoneNumber != null && phoneNumber.isNotEmpty) {
          phoneNumber = formatToE164(phoneNumber);
          if (kDebugMode) {
            print("Formatted phone number: $phoneNumber");
          }
          setState(() {
            _phoneNumber = phoneNumber;
          });
          if (kDebugMode) {
            print("_phoneNumber set to: $_phoneNumber");
          }

          // Automatically start phone verification after fetching the number
          await _verifyPhoneNumber();
        } else {
          if (kDebugMode) {
            print("Phone number is null or empty");
          }
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Phone number is missing or invalid")),
          );
        }
      } else {
        if (kDebugMode) {
          print("User document does not exist");
        }
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("User data not found")),
        );
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error fetching phone number: $e");
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _verifyPhoneNumber() async {
    if (_phoneNumber == null || _phoneNumber!.isEmpty) {
      if (kDebugMode) {
        print("Error: Phone number is null or empty");
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Phone number is missing")),
      );
      return;
    }

    if (kDebugMode) {
      print("Attempting to verify phone number: $_phoneNumber");
    }

    setState(() {
      _isLoading = true;
    });

    int retryCount = 0;
    const int maxRetries = 4;
    const Duration retryDelay = Duration(seconds: 5);

    while (retryCount < maxRetries) {
      try {
        // Show message about potential reCAPTCHA
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            Future.delayed(const Duration(seconds: 5), () {
              Navigator.of(context).pop(true);
            });
            return AlertDialog(
              title: const Text('reCAPTCHA Verification'),
              content: const Text(
                  'You may be prompted to complete a reCAPTCHA verification.'),
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
        await FirebaseAuth.instance.verifyPhoneNumber(
          phoneNumber: _phoneNumber!,
          verificationCompleted: (PhoneAuthCredential credential) async {
            if (kDebugMode) {
              print("Verification completed automatically");
            }
            await _updateUserPhoneNumber(credential);
            _navigateToNewScreen();
          },
          verificationFailed: (FirebaseAuthException e) {
            if (kDebugMode) {
              print("Verification failed: ${e.message}");
            }
            throw e;
          },
          codeSent: (String verificationId, int? resendToken) {
            if (kDebugMode) {
              print("Verification code sent");
            }
            setState(() {
              _verificationId = verificationId;
              _isCodeSent = true;
              _isLoading = false;
            });
          },
          codeAutoRetrievalTimeout: (String verificationId) {
            if (kDebugMode) {
              print("Auto retrieval timeout");
            }
            setState(() {
              _verificationId = verificationId;
              _isLoading = false;
            });
          },
          timeout: const Duration(seconds: 60),
          forceResendingToken: null,
        );

        break;
      } catch (e) {
        if (kDebugMode) {
          print("Error in verifyPhoneNumber: $e");
        }
        retryCount++;
        if (retryCount >= maxRetries) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                  "Failed to verify phone number after $maxRetries attempts"),
            ),
          );
        } else {
          if (kDebugMode) {
            print("Retrying in $retryDelay...");
          }
          await Future.delayed(retryDelay);
        }
      }
    }

    setState(() {
      _isLoading = false;
    });
  }

  void _navigateToNewScreen() {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => FemaleAvatarSelectionScreen(user: currentUser),
        ),
      );
    } else {
      // Handle the case where there is no current user
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No user is currently signed in')),
      );
    }
  }

  Future<void> _updateUserPhoneNumber(PhoneAuthCredential credential) async {
    try {
      await FirebaseAuth.instance.currentUser?.updatePhoneNumber(credential);
      if (kDebugMode) {
        print("Phone number updated successfully in Firebase Auth");
      }

      // Update Firestore to indicate the number is verified
      await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.user.uid)
          .update({
        'phoneVerified': true,
        'phone': _phoneNumber,
      });
      if (kDebugMode) {
        print("Phone number updated and marked as verified in Firestore");
      }

      // Navigate to next screen or show success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Phone number verified successfully")),
      );
    } catch (e) {
      if (kDebugMode) {
        print("Error updating phone number: $e");
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to update phone number: $e")),
      );
    }
  }

  //this function allows the inputed phone number to be only in the E.164 format required by the cloud service for phone OTP. I took me two weeks to make this work abeg the careful here!!!
  String formatToE164(String phoneNumber) {
    // Remove any non-digit characters is what this code does
    phoneNumber = phoneNumber.replaceAll(RegExp(r'\D'), '');

    // Check if the number already starts with +234 na this one the do.
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

  String formatPhoneNumberForDisplay(String phoneNumber) {
    // Remove any non-digit characters
    String digitsOnly = phoneNumber.replaceAll(RegExp(r'\D'), '');

    // If it doesn't start with the country code, add it
    if (!digitsOnly.startsWith('234')) {
      // ignore: prefer_interpolation_to_compose_strings
      digitsOnly = '234' +
          (digitsOnly.startsWith('0') ? digitsOnly.substring(1) : digitsOnly);
    }

    // Format the number for display without space after country code
    return '+$digitsOnly';
  }

//this function submits the otp back to the cloud
  Future<void> _submitOTP() async {
    String otp = _otpControllers.map((controller) => controller.text).join();
    if (otp.length != 6) {
      _showCenterDialog("Error", "Please enter a valid 6-digit OTP");
      return;
    }

    try {
      if (kDebugMode) {
        print("Submitting OTP: $otp");
      }
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: _verificationId,
        smsCode: otp,
      );
      if (kDebugMode) {
        print("Credential created");
      }

      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        throw Exception("No current user found");
      }

      if (kDebugMode) {
        print("Updating phone number for user: ${user.uid}");
      }
      await user.updatePhoneNumber(credential);
      if (kDebugMode) {
        print("Phone number updated successfully");
      }

      // Show success message
      await _showCenterDialog("Success", "Phone number verified successfully!");

      // Navigate to the FemaleAvatarSelectionScreen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => FemaleAvatarSelectionScreen(user: user),
        ),
      );
    } catch (e) {
      if (kDebugMode) {
        print("Error in _submitOTP: $e");
      }
      _showCenterDialog("Error", "Verification Failed: $e");
    }
  }

// Helper function to show dialog in the center
  Future<void> _showCenterDialog(String title, String message) async {
    return showDialog(
      context: context,
      barrierDismissible: false, // User must tap button to close dialog
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
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

  Future<void> _resendOTP() async {
    if (_phoneNumber == null || _phoneNumber!.isEmpty) {
      throw Exception("Phone number is missing");
    }

    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: _phoneNumber!,
      verificationCompleted: (PhoneAuthCredential credential) async {
        // This callback will be triggered automatically on some devices
        await _updateUserPhoneNumber(credential);
      },
      verificationFailed: (FirebaseAuthException e) {
        throw e;
      },
      codeSent: (String verificationId, int? resendToken) {
        setState(() {
          _verificationId = verificationId;
          _isCodeSent = true;
        });
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        setState(() {
          _verificationId = verificationId;
        });
      },
      forceResendingToken: _resendToken, // Use the resend token if available
      timeout: const Duration(seconds: 60),
    );
    codeSent:
    (String verificationId, int? resendToken) {
      setState(() {
        _verificationId = verificationId;
        _isCodeSent = true;
        _resendToken = resendToken;
      });
      clearOtpFields(); // Clear OTP fields when a new OTP is sent
    };
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
                  Text(
                    _phoneNumber != null
                        ? 'Please enter the OTP sent to ${formatPhoneNumberForDisplay(_phoneNumber!)}'
                        : 'No phone number found. Please update your profile.',
                    style: const TextStyle(fontSize: 14),
                  ),
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
                          await _verifyPhoneNumber();
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
                            await _submitOTP();
                          } finally {
                            Navigator.of(context)
                                .pop(); // Dismiss the loading indicator
                            setState(() {
                              _isVerifying = false;
                            });
                          }
                        }
                      },
                      style: elevatedButtonDesign,
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
                          await _resendOTP();
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
