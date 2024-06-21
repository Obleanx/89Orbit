import 'package:fiander/COMPONENTS/reuseable_widgets.dart';
import 'package:fiander/SCREENS/REGISTRATION%20SCREENS/email_veri.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class BsicInfoScreen extends StatefulWidget {
  const BsicInfoScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _BsicInfoScreenState createState() => _BsicInfoScreenState();
}

class _BsicInfoScreenState extends State<BsicInfoScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _phoneController =
      TextEditingController(); // Phone controller

  String _selectedGender = 'Female';

  @override
  void dispose() {
    _dobController.dispose();
    _phoneController.dispose(); // Dispose the phone controller

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
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
                  Icon(
                    Icons.lock,
                    color: Color(0xfffb40ad),
                    size: 12,
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'We wont share this information with anyone and it wont show on your profile.',
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
                      labelText: 'Name',
                      hintText: 'Enter your name',
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your name';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 30),
                    CustomTextFormField(
                      labelText: 'Email address',
                      hintText: 'Enter your email',
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your name';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 30),
                    CustomTextFormField(
                      controller: _dobController,
                      labelText: 'D.O.B',
                      hintText: 'Enter your date of birth',
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
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your date of birth';
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
                          borderSide: const BorderSide(
                            color: Colors.grey,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: const BorderSide(
                            color: Colors.grey,
                            width: 1.0,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        labelStyle: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
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
                      validator: (phoneNumber) {
                        if (phoneNumber == null || phoneNumber.number.isEmpty) {
                          return 'Please enter your phone number';
                        }
                        return null;
                      },
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
                              backgroundColor: Color(0xfffb40ad),
                            ),
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        EmailVerificationScreen(),
                                  ),
                                );
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
    });
  }
}
