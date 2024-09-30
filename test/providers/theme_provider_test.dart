import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task_me_anything/providers/theme_provider.dart';
import 'package:task_me_anything/shared/themes.dart';

void main() {
  group('ThemeProvider Tests', () {
    late ThemeProvider themeProvider;
    late SharedPreferences prefs;

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      prefs = await SharedPreferences.getInstance();
      themeProvider = ThemeProvider();
    });

    test('should toggle theme', () async {
      themeProvider.toggleTheme();
      expect(themeProvider.currentTheme, themes[1]);
      themeProvider.toggleTheme();
      expect(themeProvider.currentTheme, themes[0]);
    });

    test('should set theme', () async {
      await themeProvider._setTheme(1);
      expect(themeProvider.currentTheme, themes[1]);
      expect(prefs.getInt('theme'), 1);
    });

    test('should load theme', () async {
      await prefs.setInt('theme', 1);
      await themeProvider._loadTheme();
      expect(themeProvider.currentTheme, themes[1]);
    });
  });
}
