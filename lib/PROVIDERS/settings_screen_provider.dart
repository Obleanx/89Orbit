import 'package:flutter/material.dart';

class SettingsProvider with ChangeNotifier {
  bool _pushNotificationsEnabled = false;
  bool _emailNotificationsEnabled = false;
  String? _userLocation;

  String? get userLocation => _userLocation;

  bool get pushNotificationsEnabled => _pushNotificationsEnabled;
  bool get emailNotificationsEnabled => _emailNotificationsEnabled;

  void setPushNotifications(bool value) {
    _pushNotificationsEnabled = value;
    notifyListeners();
  }

  void setEmailNotifications(bool value) {
    _emailNotificationsEnabled = value;
    notifyListeners();
  }

  void updateUserLocation(String location) {
    _userLocation = location;
    notifyListeners();
  }
}
