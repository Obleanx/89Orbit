import 'package:fiander/CONSTANTS/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:supabase_flutter/supabase_flutter.dart'; // Import Supabase package
import 'package:supabase/supabase.dart';
import 'female_dp.dart'; // Import for Postgrest integration

class OtpVerificationScreen extends StatefulWidget {
  const OtpVerificationScreen({Key? key}) : super(key: key);

  @override
  _OtpVerificationScreenState createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  bool _isCodeSent = false;
  bool _isVerifying = false;
  bool _isResending = false;
  String? _phoneNumber;
  final List<TextEditingController> _otpControllers =
      List.generate(6, (index) => TextEditingController());

  @override
  void dispose() {
    for (var controller in _otpControllers) {
      controller.dispose();
    }
    super.dispose();
  }

// Fetch phone number from Supabase
  Future<void> _fetchPhoneNumber() async {
    try {
      final user = Supabase.instance.client.auth.currentUser;

      if (user != null && user.email != null) {
        final response = await Supabase.instance.client
            .from('verified_user_details')
            .select('phone')
            .eq('email', user.email as Object)
            .single();

        String? phoneNumber = response['phone'];

        setState(() {
          _phoneNumber = phoneNumber;
        });
      }
    } catch (e) {
      _showErrorDialog('Failed to fetch phone number: $e');
    }
  }

// Send OTP using Supabase's Twilio integration
  Future<void> _sendOtp() async {
    try {
      if (_phoneNumber != null) {
        await Supabase.instance.client.auth.signInWithOtp(
          phone: _phoneNumber!,
        );

        setState(() {
          _isCodeSent = true;
        });
      }
    } catch (e) {
      _showErrorDialog('Error sending OTP: $e');
    }
  }

//verify otp method
  Future<void> _verifyOtp(String otp) async {
    setState(() {
      _isVerifying = true;
    });

    try {
      final response = await Supabase.instance.client.auth.verifyOTP(
        phone: _phoneNumber!,
        token: otp,
        type: OtpType.sms,
      );

      if (response.session == null) {
        _showErrorDialog('OTP verification failed');
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (BuildContext context) => const FemaleProfilePicture()),
        );
      }
    } catch (e) {
      _showErrorDialog('Error verifying OTP: $e');
    } finally {
      setState(() {
        _isVerifying = false;
      });
    }
  }

  // Show error dialog
  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _fetchPhoneNumber(); // Fetch the phone number on screen load
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
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 23),
            ),
            const SizedBox(height: 10),
            Text(
              _phoneNumber != null
                  ? 'Please enter the OTP sent to $_phoneNumber.'
                  : 'Fetching phone number...',
              style: const TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 20),
            OtpInputSection(
              onOtpComplete: (String otp) {
                if (_isCodeSent && !_isVerifying) {
                  _verifyOtp(otp);
                }
              },
            ),
            const Spacer(),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  if (!_isCodeSent) {
                    _sendOtp(); // Send OTP
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
                  _isCodeSent ? 'Verify phone number' : 'Send OTP',
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
                onTap: () {
                  if (!_isResending) {
                    setState(() {
                      _isResending = true;
                    });
                    _sendOtp(); // Resend OTP
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
                      color: _isResending ? Colors.grey : Colors.blue,
                    ),
                    const SizedBox(width: 5),
                    Text(
                      _isResending ? 'Resending...' : 'Resend Code',
                      style: TextStyle(
                        color: _isResending ? Colors.grey : Colors.blue,
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
