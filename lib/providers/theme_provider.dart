import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

final themes = [
  ThemeData.light(),
  ThemeData.dark(),
];

class ThemeProvider extends ChangeNotifier {
  static const String _themePreferenceKey = 'theme';
  ThemeData _currentTheme = themes[0];
  late SharedPreferences _prefs;

  ThemeProvider() {
    _loadTheme();
  }

  ThemeData get currentTheme => _currentTheme;

  void toggleTheme() async {
    final currentIndex = themes.indexOf(_currentTheme);
    final newIndex = currentIndex == 0 ? 1 : 0;
    _setTheme(newIndex);
  }

  void _setTheme(int index) async {
    _currentTheme = themes[index];
    notifyListeners();
    _prefs = await SharedPreferences.getInstance();
    await _prefs.setInt(_themePreferenceKey, index);
  }

  void _loadTheme() async {
    _prefs = await SharedPreferences.getInstance();
    final themeIndex = _prefs.getInt(_themePreferenceKey) ?? 0;
    _currentTheme = themes[themeIndex];
    notifyListeners();
  }
}
