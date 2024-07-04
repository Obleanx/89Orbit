// ignore_for_file: use_build_context_synchronously
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fiander/COMPONENTS/reuseable_widgets.dart';
import 'package:fiander/SCREENS/REGISTRATION%20SCREENS/email_veri.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class BsicInfoScreen extends StatefulWidget {
  final User user;

  const BsicInfoScreen({Key? key, required this.user})
      : super(key: key); // Update the constructor

  @override
  _BsicInfoScreenState createState() => _BsicInfoScreenState();
}

class _BsicInfoScreenState extends State<BsicInfoScreen> {
  final _formKey = GlobalKey<FormState>();
  final _dobController = TextEditingController();
  final _phoneController = TextEditingController();
  final _nameController = TextEditingController();
  final _residenceController = TextEditingController();
  String _selectedGender = 'Female';

  @override
  void dispose() {
    _dobController.dispose();
    _phoneController.dispose();
    _nameController.dispose();
    _residenceController.dispose();
    super.dispose();
  }

  Future<void> _saveUserData() async {
    if (_formKey.currentState!.validate()) {
      // Show loading indicator
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Row(
              children: [
                const CircularProgressIndicator(),
                Container(
                    margin: const EdgeInsets.only(left: 7),
                    child: const Text("Loading...")),
              ],
            ),
          );
        },
      );

      try {
        // Add user details to Firestore
        await FirebaseFirestore.instance
            .collection('users')
            .doc(widget.user.uid)
            .set({
          'name': _nameController.text,
          'email': widget.user.email,
          'dob': _dobController.text,
          'gender': _selectedGender,
          'phone': _phoneController.text,
          'residence': _residenceController.text,
          'isVerified': false,
        });
        await widget.user.sendEmailVerification();

        Navigator.pop(context); // Close the loading dialog

        // Navigate to the email verification screen
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => EmailVerificationScreen(
              user: widget.user,
            ),
          ),
        );
      } catch (e) {
        Navigator.pop(context);

        // Show error message
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text("Error"),
              content: Text(
                  "An error occurred while saving your data: $e. Please try again."),
              actions: [
                TextButton(
                  child: const Text("OK"),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            );
          },
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.only(top: 70),
              child: Text(
                'Basic Information',
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
            Form(
              key: _formKey,
              child: Column(
                children: [
                  CustomTextFormField(
                    controller: _nameController,
                    labelText: 'Name',
                    hintText: 'Enter your name',
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
                  CustomTextFormField(
                    controller: _dobController,
                    labelText: 'D.O.B',
                    hintText: 'Enter your date of birth',
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    readOnly: true,
                    suffixIcon: const Icon(Icons.calendar_today),
                    onTap: () async {
                      DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(1900),
                        lastDate: DateTime.now(),
                      );
                      if (pickedDate != null) {
                        setState(() {
                          _dobController.text =
                              DateFormat('MM-dd-yyyy').format(pickedDate);
                        });
                      }
                    },
                    validator: (value) => value?.isEmpty ?? true
                        ? 'Please enter your date of birth'
                        : null,
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
                        items: <String>['Male', 'Female']
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                  const SizedBox(height: 35),
                  CustomPhoneNumberField(
                    controller: _phoneController,
                    validator: (phoneNumber) =>
                        phoneNumber?.number.isEmpty ?? true
                            ? 'Please enter your phone number'
                            : null,
                  ),
                  const SizedBox(height: 90),
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
                          onPressed: _saveUserData,
                          child: const Text(
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
            ),
          ],
        ),
      ),
    );
  }
}
