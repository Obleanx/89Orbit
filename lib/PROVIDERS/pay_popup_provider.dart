import 'package:flutter/material.dart';

class EventAccessNotifier extends ChangeNotifier {
  bool _isUpgradeChecked = false;

  bool get isUpgradeChecked => _isUpgradeChecked;

  void toggleUpgradeChecked(bool value) {
    _isUpgradeChecked = value;
    notifyListeners();
  }
}
