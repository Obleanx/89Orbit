import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class CardProvider extends ChangeNotifier {
  final TextEditingController cardNameController = TextEditingController();
  final TextEditingController cardNumberController = TextEditingController();
  final TextEditingController expiryDateController = TextEditingController();
  final TextEditingController cvvController = TextEditingController();

  void dispose() {
    cardNameController.dispose();
    cardNumberController.dispose();
    expiryDateController.dispose();
    cvvController.dispose();
    super.dispose();
  }

  bool validateInputs() {
    if (cardNameController.text.isEmpty ||
        cardNumberController.text.isEmpty ||
        expiryDateController.text.isEmpty ||
        cvvController.text.isEmpty) {
      return false;
    }
    return true;
  }

  void submitForm() {
    if (validateInputs()) {
      // Handle form submission
      if (kDebugMode) {
        print("Form submitted successfully!");
      }
    } else {
      if (kDebugMode) {
        print("Please fill in all fields.");
      }
    }
    notifyListeners();
  }
}
