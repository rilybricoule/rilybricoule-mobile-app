import 'package:flutter/material.dart';
import '../../../domain/repositories/language_repository.dart';

/// ChangeNotifier that manages the app's current locale.
/// Integrates with Provider and MaterialApp for reactive locale changes.
class LanguageViewModel extends ChangeNotifier {
  final LanguageRepository _repository;
  Locale _currentLocale = const Locale('fr');
  bool _isLoading = true;

  static const List<Locale> supportedLocales = [
    Locale('fr'),
    Locale('en'),
    Locale('ar'),
  ];

  LanguageViewModel(this._repository);

  Locale get currentLocale => _currentLocale;
  bool get isLoading => _isLoading;

  /// Load saved locale from repository on app startup.
  Future<void> loadSavedLocale() async {
    _isLoading = true;
    try {
      _currentLocale = await _repository.getSavedLocale();
      if (_currentLocale.languageCode == 'ar') {
        _currentLocale = const Locale('ar', 'MA');
      }
    } catch (_) {
      _currentLocale = const Locale('fr');
    }
    _isLoading = false;
    notifyListeners();
  }

  /// Change the app locale and persist the choice.
  Future<void> changeLocale(Locale locale) async {
    if (locale.languageCode == 'ar') {
      locale = const Locale('ar', 'MA');
    }
    if (_currentLocale == locale) return;
    _currentLocale = locale;
    notifyListeners();
    await _repository.saveLocale(locale);
  }

  /// Get the display name for a locale (in its own language).
  String getDisplayName(Locale locale) {
    switch (locale.languageCode) {
      case 'fr':
        return 'Français';
      case 'en':
        return 'English';
      case 'ar':
        return 'العربية';
      default:
        return locale.languageCode;
    }
  }

  /// Get the flag emoji for a locale.
  String getFlag(Locale locale) {
    switch (locale.languageCode) {
      case 'fr':
        return '🇫🇷';
      case 'en':
        return '🇬🇧';
      case 'ar':
        return '🇲🇦';
      default:
        return '🌐';
    }
  }
}
