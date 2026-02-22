import 'package:flutter/material.dart';
import '../../home/models/provider_model.dart';
import '../domain/search_repository.dart';

class SearchViewModel extends ChangeNotifier {
  final SearchRepository _searchRepository;

  SearchViewModel(this._searchRepository);

  List<ProviderModel> _providers = [];
  List<ProviderModel> get providers => _providers;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String _currentQuery = '';
  String get currentQuery => _currentQuery;

  // Filter values
  double _minPrice = 0;
  double _maxPrice = 2000;
  double? _minRating;
  double _maxDistance = 50;
  bool _availableNow = false;

  double get minPrice => _minPrice;
  double get maxPrice => _maxPrice;
  double? get minRating => _minRating;
  double get maxDistance => _maxDistance;
  bool get availableNow => _availableNow;

  void setQuery(String query) {
    _currentQuery = query;
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
    notifyListeners();
  }

  Future<void> search([String? query]) async {
    if (query != null) {
      _currentQuery = query;
    }
    
    _isLoading = true;
    notifyListeners();

    try {
      _providers = await _searchRepository.searchProviders(
        query: _currentQuery,
        minPrice: _minPrice,
        maxPrice: _maxPrice,
        minRating: _minRating,
        maxDistance: _maxDistance,
        availableNow: _availableNow,
      );
    } catch (e) {
      _providers = [];
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> initialSearch() async {
    _currentQuery = '';
    await search();
  }
}
