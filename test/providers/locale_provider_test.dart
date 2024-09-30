import 'dart:ui';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task_me_anything/providers/locale_provider.dart';

void main() {
  group('LocaleProvider Tests', () {
    late LocaleProvider localeProvider;
    late SharedPreferences prefs;

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      prefs = await SharedPreferences.getInstance();
      localeProvider = LocaleProvider();
    });

    test('should initialize with default locale', () async {
      expect(localeProvider.locale.languageCode, 'en');
    });

    test('should toggle locale', () async {
      localeProvider.toggleLocale();
      expect(localeProvider.locale.languageCode, 'de');
      localeProvider.toggleLocale();
      expect(localeProvider.locale.languageCode, 'en');
    });
  });
}
