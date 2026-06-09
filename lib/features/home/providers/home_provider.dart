import 'package:flutter/material.dart';
import '../../../core/models/provider_filter.dart';
import '../../../core/models/provider_sort_mode.dart';
import '../../../core/models/user_search_context.dart';
import '../../../core/services/provider_ranking_engine.dart';
import '../models/provider_model.dart';
import '../models/sort_option.dart';

class HomeProvider extends ChangeNotifier {
  bool _disposed = false;
  List<ProviderModel> _originalProviders = [];
  List<ProviderModel> _sortedProviders = [];
  SortOption? _currentSortOption;
  SortOption? _selectedSortOption;
  final _rankingEngine = ProviderRankingEngine();

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
    _sortedProviders = _rankingEngine.filterAndRank(
      providers: providers,
      context: const UserSearchContext(),
      filter: const ProviderFilter(),
      sortMode: ProviderSortMode.bestMatch,
    );
    notifyListeners();
  }

  void setSelectedSortOption(SortOption? option) {
    _selectedSortOption = option;
    notifyListeners();
  }

  void applySortOption() {
    _currentSortOption = _selectedSortOption;
    final sortMode = _mapSortOption(_currentSortOption);
    _sortedProviders = _rankingEngine.filterAndRank(
      providers: _originalProviders,
      context: const UserSearchContext(),
      filter: const ProviderFilter(),
      sortMode: sortMode,
    );
    notifyListeners();
  }

  void resetSort() {
    _currentSortOption = null;
    _selectedSortOption = null;
    _sortedProviders = _rankingEngine.filterAndRank(
      providers: _originalProviders,
      context: const UserSearchContext(),
      filter: const ProviderFilter(),
      sortMode: ProviderSortMode.bestMatch,
    );
    notifyListeners();
  }

  ProviderSortMode _mapSortOption(SortOption? option) {
    switch (option) {
      case SortOption.bestRated:
        return ProviderSortMode.bestRated;
      case SortOption.priceLowToHigh:
        return ProviderSortMode.priceLowToHigh;
      case SortOption.priceHighToLow:
        return ProviderSortMode.priceHighToLow;
      case SortOption.nearest:
        return ProviderSortMode.nearest;
      case SortOption.availableNow:
        return ProviderSortMode.availableFirst;
      default:
        return ProviderSortMode.bestMatch;
    }
  }
}