// ignore_for_file: use_build_context_synchronously
import 'package:fiander/COMPONENTS/phone_number.dart';
import 'package:fiander/COMPONENTS/reuseable_widgets.dart';
import 'package:fiander/PROVIDERS/user_info_provider.dart';
import 'package:fiander/SUPABASE/otp_mobile.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'fetch_email.dart';

class UserInformationScreen extends StatefulWidget {
  const UserInformationScreen({
    Key? key,
  }) : super(key: key);

  @override
  _UserInformationScreenState createState() => _UserInformationScreenState();
}

class _UserInformationScreenState extends State<UserInformationScreen> {
  final _dobController = TextEditingController();
  final _nameController = TextEditingController();
  final _residenceController = TextEditingController();
  final _phonenumberController = TextEditingController();
  final TextEditingController _emailController =
      TextEditingController(); // Add email controller

  String _selectedGender = 'Female';
  bool _isLoading = false; // Add loading state

  String? _phoneNumber;
  @override
  void dispose() {
    _dobController.dispose();
    _nameController.dispose();
    _residenceController.dispose();
    _phonenumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => UserInformationProvider(),
      child: Scaffold(
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.only(top: 70),
                child: Text(
                  'User Information',
                  style: TextStyle(fontWeight: FontWeight.w900, fontSize: 22),
                ),
              ),
              const SizedBox(height: 4),
              const Row(
                children: [
                  Icon(Icons.lock, color: Color(0xfffb40ad), size: 12),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'We won’t share this information with anyone and it won’t show on your profile.',
                      style: TextStyle(fontSize: 12),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 26),
              Consumer<UserInformationProvider>(
                builder: (context, provider, child) {
                  return Form(
                    child: Column(
                      children: [
                        // Use custom email text form field here
                        CustomEmailTextFormField(controller: _emailController),
                        const SizedBox(height: 30),

                        CustomTextFormField(
                          controller: _nameController,
                          labelText: 'Name',
                          hintText: 'Enter your name and Surname',
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (value) => value?.isEmpty ?? true
                              ? 'Please enter your name'
                              : null,
                        ),
                        const SizedBox(height: 30),
                        CustomTextFormField(
                          controller: _residenceController,
                          labelText: 'Location',
                          hintText: 'City / region',
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (value) => value?.isEmpty ?? true
                              ? 'Please enter your location'
                              : null,
                        ),
                        const SizedBox(height: 30),
                        PhoneNumberInput(
                          initialValue: '+234',
                          onChanged: (phoneNumber) {
                            setState(() {
                              _phoneNumber = phoneNumber;
                            });
                          },
                          controller: _phonenumberController,
                        ),
                        const SizedBox(height: 30),
                        CustomTextFormField(
                          controller: _dobController,
                          labelText: 'D.O.B',
                          hintText: 'Enter your date of birth',
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          readOnly: true,
                          suffixIcon: const Icon(Icons.calendar_today),
                          onTap: () async {
                            DateTime now = DateTime.now();
                            DateTime maxDate = now.subtract(const Duration(
                                days: 365 * 24 +
                                    6)); // 24 years ago, accounting for leap years
                            DateTime? pickedDate = await showDatePicker(
                              context: context,
                              initialDate: maxDate,
                              firstDate: DateTime(1900),
                              lastDate: maxDate,
                            );
                            if (pickedDate != null) {
                              setState(() {
                                _dobController.text =
                                    DateFormat('MM-dd-yyyy').format(pickedDate);
                              });
                            }
                          },
                          validator: (value) {
                            if (value?.isEmpty ?? true) {
                              return 'Please enter your date of birth';
                            }
                            DateTime? dob =
                                DateFormat('MM-dd-yyyy').tryParse(value!);
                            if (dob == null) {
                              return 'Invalid date format';
                            }
                            DateTime now = DateTime.now();
                            int age = now.year - dob.year;
                            if (now.month < dob.month ||
                                (now.month == dob.month && now.day < dob.day)) {
                              age--;
                            }
                            if (age < 24) {
                              return 'You must be at least 24 years old';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 30),
                        InputDecorator(
                          decoration: InputDecoration(
                            labelText: 'Gender',
                            fillColor: Colors.white,
                            filled: true,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            contentPadding:
                                const EdgeInsets.symmetric(horizontal: 12.0),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: _selectedGender,
                              onChanged: (String? newValue) {
                                setState(() {
                                  _selectedGender = newValue!;
                                });
                              },
                              items: <String>[
                                'Male',
                                'Female'
                              ].map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                        const SizedBox(height: 80),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: SizedBox(
                              height: 45,
                              width: 300,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xfffb40ad),
                                ),
                                onPressed: _isLoading
                                    ? null // Disable button when loading
                                    : _saveUserData,
                                child: _isLoading
                                    ? const CircularProgressIndicator(
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                                Colors.white),
                                      )
                                    : const Text(
                                        'N e x t',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _saveUserData() async {
    // Validate form inputs
    if (_nameController.text.isEmpty ||
        _residenceController.text.isEmpty ||
        _phoneNumber == null ||
        _dobController.text.isEmpty ||
        _emailController.text.isEmpty) {
      _showErrorDialog('Please fill in all the required fields.');
      return;
    }

    setState(() {
      _isLoading = true; // Show loading indicator
    });

    try {
      // Check if the email already exists in the 'verified_user_details' table
      final existingUserResponse = await Supabase.instance.client
          .from('verified_user_details')
          .select()
          .eq('email', _emailController.text.trim());

      if (existingUserResponse.isNotEmpty) {
        // Email already exists
        await _showSuccessDialog('Your details have been successfully saved!');
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (BuildContext context) => const OtpVerificationScreen(),
          ),
        );
        return; // Skip the insertion since the email already exists
      }

      // Insert data into the 'verified_user_details' table if the email does not exist
      final insertResponse =
          await Supabase.instance.client.from('verified_user_details').insert({
        'email': _emailController.text.trim(),
        'name': _nameController.text.trim(),
        'location': _residenceController.text.trim(),
        'phone': _phoneNumber,
        'dob': _dobController.text.trim(),
        'gender': _selectedGender,
      });

      if (insertResponse.isEmpty) {
        _showErrorDialog('Failed to save user details.');
        return;
      }

      // Successfully added to Supabase, navigate to the next screen
      await _showSuccessDialog('Your details have been successfully saved!');
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) => const OtpVerificationScreen(),
        ),
      );
    } catch (e) {
      if (kDebugMode) {
        print('Error occurred: $e');
      }
      _showErrorDialog('An unexpected error occurred: $e');
    } finally {
      setState(() {
        _isLoading = false; // Hide loading indicator
      });
    }
  }

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

  Future<void> _showSuccessDialog(String message) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // Prevent dismissing by tapping outside
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Success'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
