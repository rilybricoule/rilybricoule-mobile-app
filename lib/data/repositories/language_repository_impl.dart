import 'dart:ui';
import '../../domain/repositories/language_repository.dart';
import '../datasources/local_language_datasource.dart';

/// Concrete implementation of LanguageRepository using local persistence.
/// Backend-ready: swap LocalLanguageDataSource with an API data source later.
class LanguageRepositoryImpl implements LanguageRepository {
  final LocalLanguageDataSource _dataSource;
  static const Locale _defaultLocale = Locale('fr');

  LanguageRepositoryImpl({LocalLanguageDataSource? dataSource})
      : _dataSource = dataSource ?? LocalLanguageDataSource();

  @override
  Future<Locale> getSavedLocale() async {
    final locale = await _dataSource.getSavedLocale();
    return locale ?? _defaultLocale;
  }

  @override
  Future<void> saveLocale(Locale locale) async {
    await _dataSource.saveLocale(locale);
  }
}
