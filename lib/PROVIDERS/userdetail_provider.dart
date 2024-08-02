import 'package:flutter/material.dart';

// Provider for managing state
class UserPreferencesProvider extends ChangeNotifier {
  Set<String> selectedItems = {};

  void toggleItem(String item) {
    if (selectedItems.contains(item)) {
      selectedItems.remove(item);
    } else {
      selectedItems.add(item);
    }
    notifyListeners();
  }

  bool isSelected(String item) => selectedItems.contains(item);
}
