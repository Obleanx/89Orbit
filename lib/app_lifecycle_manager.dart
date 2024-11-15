import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppLifecycleManager extends ChangeNotifier with WidgetsBindingObserver {
  final Map<String, dynamic> _appState = {};

  Map<String, dynamic> get appState => _appState;

  AppLifecycleManager() {
    WidgetsBinding.instance.addObserver(this); // Register observer
    loadAppState(); // Load app state on initialization
  }

  Future<void> saveAppState() async {
    final prefs = await SharedPreferences.getInstance();

    // Save any relevant state (adjust as needed)
    _appState['formData'] = {
      // Add form data
    };
    _appState['scrollPositions'] = {
      // Add scroll position data
    };

    // Save the state as a JSON string to SharedPreferences
    await prefs.setString('appState', jsonEncode(_appState));
    notifyListeners();
  }

  Future<void> loadAppState() async {
    final prefs = await SharedPreferences.getInstance();
    final appStateString = prefs.getString('appState');
    if (appStateString != null) {
      _appState.clear();
      _appState.addAll(Map<String, dynamic>.from(jsonDecode(appStateString)));
      notifyListeners();
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.inactive) {
      saveAppState(); // Save state when app goes to the background
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this); // Remove observer
    super.dispose();
  }
}
