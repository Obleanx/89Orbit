import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class UserInformationProvider with ChangeNotifier {
  TextEditingController nameController = TextEditingController();
  TextEditingController residenceController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController dobController = TextEditingController();

  String selectedGender = 'Female';

  void setSelectedGender(String gender) {
    selectedGender = gender;
    notifyListeners();
  }

  void setDOB(String dob) {
    dobController.text = dob;
    notifyListeners();
  }

  void saveUserData() {
    // Add logic to save user data to backend or database
    String name = nameController.text;
    String residence = residenceController.text;
    String phoneNumber = phoneNumberController.text;
    String dob = dobController.text;
    String gender = selectedGender;

    // Example print statements for debugging
    if (kDebugMode) {
      print('Name: $name');
    }
    if (kDebugMode) {
      print('Residence: $residence');
    }
    if (kDebugMode) {
      print('Phone Number: $phoneNumber');
    }
    if (kDebugMode) {
      print('DOB: $dob');
    }
    if (kDebugMode) {
      print('Gender: $gender');
    }
  }
}
