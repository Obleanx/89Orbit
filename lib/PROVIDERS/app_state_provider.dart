import 'package:flutter/material.dart';
import 'dart:async';

class AppStateProvider extends ChangeNotifier {
  bool _shouldNavigate = false;

  bool get shouldNavigate => _shouldNavigate;

  void startTimer() {
    Timer(const Duration(seconds: 5), () {
      _shouldNavigate = true;
      notifyListeners();
    });
  }

  void resetNavigation() {
    _shouldNavigate = false;
    notifyListeners();
  }
}
