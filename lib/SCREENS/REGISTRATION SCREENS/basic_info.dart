// ignore_for_file: use_build_context_synchronously
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fiander/COMPONENTS/phone_number.dart';
import 'package:fiander/COMPONENTS/reuseable_widgets.dart';
import 'package:fiander/SCREENS/REGISTRATION%20SCREENS/email_veri.dart';
import 'package:fiander/SCREENS/onboarding_state.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class BsicInfoScreen extends StatefulWidget {
  //final User? user; // Nullable User object
  final Function(User?) setCurrentUser; // Function to set the current user

  BsicInfoScreen({Key? key, required this.setCurrentUser})
      : super(key: key); // Accept the user and setCurrentUser

  @override
  _BsicInfoScreenState createState() => _BsicInfoScreenState();
}

class _BsicInfoScreenState extends State<BsicInfoScreen> {
  final _dobController = TextEditingController();
  final _nameController = TextEditingController();
  final _residenceController = TextEditingController();
  final _phonenumberController = TextEditingController();
  String _selectedGender = 'Female';

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
              child: Column(
                children: [
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
                      DateTime? dob = DateFormat('MM-dd-yyyy').tryParse(value!);
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
                          onPressed: () {
                            try {
                              // _saveUserData();
                            } catch (e, stackTrace) {
                              if (kDebugMode) {
                                print('Network error');
                              }
                              if (kDebugMode) {
                                print('Stack trace: $stackTrace');
                              }
                              // Handle the error (show a dialog, etc.)
                            }
                          },
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
