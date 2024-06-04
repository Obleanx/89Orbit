import 'package:flutter/material.dart';
import 'dart:async';

class AppStateProvider extends ChangeNotifier {
  bool _shouldNavigate = false;

  bool get shouldNavigate => _shouldNavigate;

  void startTimer() {
    Timer(const Duration(minutes: 30), () {
      _shouldNavigate = true;
      notifyListeners();
    });
  }
}
