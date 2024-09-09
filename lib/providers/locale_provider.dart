import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LocaleProvider extends ChangeNotifier {
  static const _localePreferenceKey = 'locale';
  Locale _locale = const Locale('en');
  late SharedPreferences _prefs;

  LocaleProvider() {
    _loadLocale();
  }

  Locale get locale => _locale;

  void toggleLocale() {
    _setLocale(_locale == const Locale('en')
        ? const Locale('de')
        : const Locale('en'));
    notifyListeners();
  }

  void _setLocale(Locale locale) async {
    // return if the locale is not supported
    if (!AppLocalizations.supportedLocales.contains(locale)) {
      return;
    }

    _locale = locale;
    notifyListeners();
    _prefs = await SharedPreferences.getInstance();
    await _prefs.setString(_localePreferenceKey, locale.languageCode);
  }

  void _loadLocale() async {
    _prefs = await SharedPreferences.getInstance();
    final localeString = _prefs.getString(_localePreferenceKey);
    if (localeString != null) {
      _locale = Locale(localeString);
    }
    notifyListeners();
  }
}
