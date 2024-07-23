import 'package:flutter/foundation.dart';

class HomeScreenProvider with ChangeNotifier {
  // Example state variable
  String _exampleData = 'Initial data';

  String get exampleData => _exampleData;

  void updateExampleData(String newData) {
    _exampleData = newData;
    notifyListeners();
  }
}
