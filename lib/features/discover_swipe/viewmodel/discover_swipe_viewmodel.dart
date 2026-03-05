import 'package:flutter/material.dart';
import '../../../core/models/provider_filter.dart';
import '../../../core/models/provider_sort_mode.dart';
import '../../../core/models/user_search_context.dart';
import '../../../core/services/provider_ranking_engine.dart';
import '../../home/models/provider_model.dart';
import '../../search/domain/search_repository.dart';
import '../models/search_context_bundle.dart';
import '../repository/mock_swipe_repository.dart';

class DiscoverSwipeViewModel extends ChangeNotifier {
  final SearchRepository _searchRepository;
  final MockSwipeRepository _swipeRepository;
  final _rankingEngine = ProviderRankingEngine();

  DiscoverSwipeViewModel(this._searchRepository, this._swipeRepository);

  List<ProviderModel> _providers = [];
  List<ProviderModel> get providers => _providers;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  SearchContextBundle? _context;
  SearchContextBundle? get context => _context;

  Future<void> loadProviders(SearchContextBundle bundle) async {
    _context = bundle;
    _isLoading = true;
    notifyListeners();

    try {
      final rawProviders = await _searchRepository.searchProviders(
        query: bundle.query ?? '',
        minPrice: bundle.minPrice,
        maxPrice: bundle.maxPrice,
        minRating: bundle.minRating,
        maxDistance: bundle.maxDistanceKm,
        availableNow: bundle.availableNow,
      );

      _providers = _rankingEngine.filterAndRank(
        providers: rawProviders,
        context: UserSearchContext(
          latitude: bundle.userLatitude,
          longitude: bundle.userLongitude,
          query: bundle.query,
        ),
        filter: ProviderFilter(
          categoryId: bundle.categoryId,
          subCategoryId: bundle.subCategoryId,
          minRating: bundle.minRating,
          maxDistanceKm: bundle.maxDistanceKm,
          availableNow: bundle.availableNow,
          minPrice: bundle.minPrice,
          maxPrice: bundle.maxPrice,
        ),
        sortMode: ProviderSortMode.bestMatch,
      );

      _providers = _providers
          .where((p) => !_swipeRepository.isSkipped(p.id))
          .toList();
    } catch (e) {
      _providers = [];
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> likeProvider(String providerId) async {
    await _swipeRepository.likeProvider(providerId);
    _removeProvider(providerId);
  }

  Future<void> skipProvider(String providerId) async {
    await _swipeRepository.skipProvider(providerId);
    _removeProvider(providerId);
  }

  void _removeProvider(String providerId) {
    _providers = _providers.where((p) => p.id != providerId).toList();
    notifyListeners();
  }

  Future<void> resetFilters() async {
    if (_context != null) {
      await loadProviders(SearchContextBundle(
        userLatitude: _context!.userLatitude,
        userLongitude: _context!.userLongitude,
      ));
    }
  }
}
