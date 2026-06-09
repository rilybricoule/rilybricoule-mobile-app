import 'dart:ui';
import 'package:shared_preferences/shared_preferences.dart';

/// Local data source for language persistence using SharedPreferences.
class LocalLanguageDataSource {
  static const _key = 'app_language_code';

  Future<Locale?> getSavedLocale() async {
    final prefs = await SharedPreferences.getInstance();
    final code = prefs.getString(_key);
    if (code == null) return null;
    return Locale(code);
  }

  Future<void> saveLocale(Locale locale) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, locale.languageCode);
  }
}
