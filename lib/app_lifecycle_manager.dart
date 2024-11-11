import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppLifecycleManager extends ChangeNotifier {
  final Map<String, dynamic> _appState = {};

  Map<String, dynamic> get appState => _appState;

  Future<void> saveAppState() async {
    final prefs = await SharedPreferences.getInstance();

    // Save the current route
    final currentRoute = ModalRoute.of(NavigatorState().context)?.settings.name;
    _appState['currentRoute'] = currentRoute;

    // Save any other relevant state, like form data or scroll positions
    _appState['formData'] = {
      // Add your form data here
    };
    _appState['scrollPositions'] = {
      // Add your scroll positions here
    };

    // Save the state to SharedPreferences
    await prefs.setString('appState', _appState.toString());
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
  void dispose() {
    saveAppState();
    super.dispose();
  }
}
