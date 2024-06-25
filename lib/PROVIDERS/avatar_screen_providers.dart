import 'package:flutter/material.dart';

class AvatarSelectionProvider with ChangeNotifier {
  String? _selectedAvatar;

  String? get selectedAvatar => _selectedAvatar;

  void selectAvatar(String avatar) {
    _selectedAvatar = avatar;
    notifyListeners();
  }
}
