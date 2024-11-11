import 'package:flutter/material.dart';

class HamburgerMenuProvider extends ChangeNotifier {
  bool _isTailoredSelected = false;
  bool _isGeneralSelected = false;

  bool get isTailoredSelected => _isTailoredSelected;
  bool get isGeneralSelected => _isGeneralSelected;

  void toggleTailoredSelected() {
    _isTailoredSelected = !_isTailoredSelected;
    _isGeneralSelected = false; // Ensure only one is selected at a time
    notifyListeners();
  }

  void toggleGeneralSelected() {
    _isGeneralSelected = !_isGeneralSelected;
    _isTailoredSelected = false; // Ensure only one is selected at a time
    notifyListeners();
  }
}
