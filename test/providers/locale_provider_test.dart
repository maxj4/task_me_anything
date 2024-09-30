import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
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

    test('should toggle locale', () async {
      localeProvider.toggleLocale();
      expect(localeProvider.locale.languageCode, 'de');
      localeProvider.toggleLocale();
      expect(localeProvider.locale.languageCode, 'en');
    });

    test('should set locale', () async {
      await localeProvider._setLocale(const Locale('de'));
      expect(localeProvider.locale.languageCode, 'de');
      expect(prefs.getString('locale'), 'de');
    });

    test('should load locale', () async {
      await prefs.setString('locale', 'de');
      await localeProvider._loadLocale();
      expect(localeProvider.locale.languageCode, 'de');
    });
  });
}
