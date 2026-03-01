import 'package:flutter/material.dart';
import '../models/provider_model.dart';
import '../models/sort_option.dart';

class HomeProvider extends ChangeNotifier {
  bool _disposed = false;
  List<ProviderModel> _originalProviders = [];
  List<ProviderModel> _sortedProviders = [];
  SortOption? _currentSortOption;
  SortOption? _selectedSortOption;

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

  List<ProviderModel> get providers => _sortedProviders;
  SortOption? get currentSortOption => _currentSortOption;
  SortOption? get selectedSortOption => _selectedSortOption;

  void setProviders(List<ProviderModel> providers) {
    _originalProviders = List.from(providers);
    _sortedProviders = List.from(providers);
    notifyListeners();
  }

  void setSelectedSortOption(SortOption? option) {
    _selectedSortOption = option;
    notifyListeners();
  }

  void applySortOption() {
    _currentSortOption = _selectedSortOption;
    if (_currentSortOption == null) {
      _sortedProviders = List.from(_originalProviders);
    } else {
      _sortedProviders = _sortProviders(_originalProviders, _currentSortOption!);
    }
    notifyListeners();
  }

  void resetSort() {
    _currentSortOption = null;
    _selectedSortOption = null;
    _sortedProviders = List.from(_originalProviders);
    notifyListeners();
  }

  List<ProviderModel> _sortProviders(List<ProviderModel> providers, SortOption sortOption) {
    final List<ProviderModel> sorted = List.from(providers);

    switch (sortOption) {
      case SortOption.bestRated:
        sorted.sort((a, b) => b.rating.compareTo(a.rating));
        break;
      case SortOption.priceLowToHigh:
        sorted.sort((a, b) => a.priceValue.compareTo(b.priceValue));
        break;
      case SortOption.priceHighToLow:
        sorted.sort((a, b) => b.priceValue.compareTo(a.priceValue));
        break;
      case SortOption.nearest:
        sorted.sort((a, b) => a.distance.compareTo(b.distance));
        break;
      case SortOption.availableNow:
        sorted.sort((a, b) {
          if (a.isAvailable && !b.isAvailable) return -1;
          if (!a.isAvailable && b.isAvailable) return 1;
          return a.distance.compareTo(b.distance);
        });
        break;
    }

    return sorted;
  }
}