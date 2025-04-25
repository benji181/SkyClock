import 'package:flutter/material.dart';

class SettingsProvider extends ChangeNotifier {
  bool _isCelsius = true;
  bool _isDarkMode = false;

  bool get isCelsius => _isCelsius;
  bool get isDarkMode => _isDarkMode;

  void toggleTemperatureUnit() {
    _isCelsius = !_isCelsius;
    notifyListeners();
  }

  void toggleTheme() {
    _isDarkMode = !_isDarkMode;
    notifyListeners();
  }
}
