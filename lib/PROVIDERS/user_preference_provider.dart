import 'package:flutter/foundation.dart';

class UserPreferencesProvider with ChangeNotifier {
  Set<String> selectedItems = {};

  String? _selectedReligion;
  String? _selectedEthnicity;
  List<String> _selectedEducationLevels = [];
  List<String> _selectedHobbies = [];
  String? _selectedAgeRange;
  String? _selectedGender;

  String? get selectedReligion => _selectedReligion;
  String? get selectedEthnicity => _selectedEthnicity;
  List<String> get selectedEducationLevels => _selectedEducationLevels;
  List<String> get selectedHobbies => _selectedHobbies;
  String? get selectedAgeRange => _selectedAgeRange;
  String? get selectedGender => _selectedGender;

  void setReligion(String religion) {
    _selectedReligion = religion;
    notifyListeners();
  }

  void setEthnicity(String ethnicity) {
    _selectedEthnicity = ethnicity;
    notifyListeners();
  }

  void setEducationLevels(List<String> educationLevels) {
    _selectedEducationLevels = educationLevels;
    notifyListeners();
  }

  void setHobbies(List<String> hobbies) {
    _selectedHobbies = hobbies;
    notifyListeners();
  }

  void setAgeRange(String ageRange) {
    _selectedAgeRange = ageRange;
    notifyListeners();
  }

  void setGender(String gender) {
    _selectedGender = gender;
    notifyListeners();
  }

  void toggleItem(String item) {
    if (selectedItems.contains(item)) {
      selectedItems.remove(item);
    } else {
      selectedItems.add(item);
    }
    notifyListeners();
  }

  void clearSelection(String preferenceType) {
    if (preferenceType == 'religion') {
      _selectedReligion = null;
    } else if (preferenceType == 'ethnicity') {
      _selectedEthnicity = null;
    }
    // Handle other preference types as needed
    notifyListeners();
  }

  void clearAll() {
    _selectedReligion = null;
    _selectedEthnicity = null;
    _selectedEducationLevels = [];
    _selectedHobbies = [];
    _selectedAgeRange = null;
    _selectedGender = null;
    notifyListeners();
  }

  bool isSelected(String item) => selectedItems.contains(item);
}
