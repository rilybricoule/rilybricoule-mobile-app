import 'dart:ui';

/// Abstract repository for language management.
/// Backend-ready: swap the local implementation with an API-based one later.
abstract class LanguageRepository {
  Future<Locale> getSavedLocale();
  Future<void> saveLocale(Locale locale);
}
