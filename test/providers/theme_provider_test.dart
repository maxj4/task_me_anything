import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task_me_anything/providers/theme_provider.dart';
import 'package:task_me_anything/shared/themes.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  group('ThemeProvider Tests', () {
    // TODO fix google_fonts issues
    late ThemeProvider themeProvider;

    setUp(() {
      SharedPreferences.setMockInitialValues({});
      themeProvider = ThemeProvider();
    });

    test('should initialize with default theme', () {
      expect(themeProvider.currentTheme, themes[0]);
    });

    test('should toggle theme', () {
      themeProvider.toggleTheme();
      expect(themeProvider.currentTheme, themes[1]);
      themeProvider.toggleTheme();
      expect(themeProvider.currentTheme, themes[0]);
    });
  });
}
