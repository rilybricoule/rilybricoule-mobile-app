import 'package:flutter/material.dart';
import '../../../core/models/provider_filter.dart';
import '../../../core/models/provider_sort_mode.dart';
import '../../../core/models/user_search_context.dart';
import '../../../core/services/provider_ranking_engine.dart';
import '../../home/models/provider_model.dart';
import '../domain/search_repository.dart';

class SearchViewModel extends ChangeNotifier {
  final SearchRepository _searchRepository;
  final _rankingEngine = ProviderRankingEngine();
  bool _disposed = false;

  SearchViewModel(this._searchRepository);

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }

  @override
  void notifyListeners() {
    if (!_disposed) {
      super.notifyListeners();
    }
  }

  List<ProviderModel> _providers = [];
  List<ProviderModel> get providers => _providers;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String _currentQuery = '';
  String get currentQuery => _currentQuery;

  String _viewMode = 'list';
  String get viewMode => _viewMode;

  void setViewMode(String mode) {
    _viewMode = mode;
    notifyListeners();
  }

  double _minPrice = 0;
  double _maxPrice = 2000;
  double? _minRating;
  double _maxDistance = 50;
  bool _availableNow = false;
  String? _categoryId;

  double get minPrice => _minPrice;
  double get maxPrice => _maxPrice;
  double? get minRating => _minRating;
  double get maxDistance => _maxDistance;
  bool get availableNow => _availableNow;
  String? get categoryId => _categoryId;

  void setQuery(String query) {
    _currentQuery = query;
    notifyListeners();
  }

  void setCategoryId(String? id) {
    _categoryId = id;
    notifyListeners();
  }

  void setPriceRange(double min, double max) {
    _minPrice = min;
    _maxPrice = max;
    notifyListeners();
  }

  void setRating(double? rating) {
    _minRating = rating;
    notifyListeners();
  }

  void setDistance(double distance) {
    _maxDistance = distance;
    notifyListeners();
  }

  void setAvailableNow(bool value) {
    _availableNow = value;
    notifyListeners();
  }

  void resetFilters() {
    _minPrice = 0;
    _maxPrice = 2000;
    _minRating = null;
    _maxDistance = 50;
    _availableNow = false;
    _categoryId = null;
    notifyListeners();
  }

  Future<void> search([String? query, BuildContext? context]) async {
    if (query != null) {
      _currentQuery = query;
    }
    
    _isLoading = true;
    notifyListeners();

    try {
      final String? langCode = context != null ? Localizations.localeOf(context).languageCode : null;
      final rawProviders = await _searchRepository.searchProviders(
        query: _currentQuery,
        minPrice: _minPrice,
        maxPrice: _maxPrice,
        minRating: _minRating,
        maxDistance: _maxDistance,
        availableNow: _availableNow,
        langCode: langCode,
      );

      _providers = _rankingEngine.filterAndRank(
        providers: rawProviders,
        context: UserSearchContext(query: _currentQuery),
        filter: ProviderFilter(
          categoryId: _categoryId,
          minRating: _minRating,
          maxDistanceKm: _maxDistance,
          availableNow: _availableNow,
          minPrice: _minPrice,
          maxPrice: _maxPrice,
        ),
        sortMode: ProviderSortMode.bestMatch,
      );
    } catch (e) {
      _providers = [];
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> initialSearch([BuildContext? context]) async {
    _currentQuery = '';
    await search(null, context);
  }
}
