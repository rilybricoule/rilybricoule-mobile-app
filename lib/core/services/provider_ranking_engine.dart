import '../../features/home/models/provider_model.dart';
import '../models/provider_filter.dart';
import '../models/provider_sort_mode.dart';
import '../models/user_search_context.dart';

class ProviderRankingEngine {
  static const double _maxDistanceRef = 50.0;
  static const int _fairnessMaxJobs = 10;
  static const int _heavyLoadThreshold = 5;
  static const double _heavyLoadPenalty = 0.7;
  
  static const double _ratingWeight = 0.40;
  static const double _distanceWeight = 0.30;
  static const double _fairnessWeight = 0.20;
  static const double _availabilityWeight = 0.10;

  List<ProviderModel> filterAndRank({
    required List<ProviderModel> providers,
    required UserSearchContext context,
    required ProviderFilter filter,
    ProviderSortMode sortMode = ProviderSortMode.bestMatch,
  }) {
    List<ProviderModel> filtered = _applyFilters(providers, filter, context);
    
    if (sortMode == ProviderSortMode.bestMatch) {
      return _rankByCompositeScore(filtered);
    } else {
      return _sortByMode(filtered, sortMode);
    }
  }

  List<ProviderModel> _applyFilters(
    List<ProviderModel> providers,
    ProviderFilter filter,
    UserSearchContext context,
  ) {
    return providers.where((p) {
      if (filter.categoryId != null && p.categoryId != filter.categoryId) return false;
      if (filter.subCategoryId != null && p.subCategoryId != filter.subCategoryId) return false;
      if (filter.minRating != null && p.rating < filter.minRating!) return false;
      if (filter.maxDistanceKm != null && p.distanceKm > filter.maxDistanceKm!) return false;
      if (filter.availableNow == true && !p.isAvailableNow) return false;
      if (filter.minPrice != null && p.priceValue < filter.minPrice!) return false;
      if (filter.maxPrice != null && p.priceValue > filter.maxPrice!) return false;
      if (context.query != null && context.query!.isNotEmpty) {
        final query = context.query!.toLowerCase();
        if (!p.name.toLowerCase().contains(query) &&
            !p.service.toLowerCase().contains(query)) {
          return false;
        }
      }
      return true;
    }).toList();
  }

  List<ProviderModel> _rankByCompositeScore(List<ProviderModel> providers) {
    final scored = providers.map((p) {
      final ratingScore = p.rating / 5.0;
      final distanceScore = (1 - (p.distanceKm / _maxDistanceRef)).clamp(0.0, 1.0);
      final availabilityScore = p.isAvailableNow ? 1.0 : 0.0;
      final fairnessScore = (1 - (p.activeJobsCount / _fairnessMaxJobs)).clamp(0.0, 1.0);

      double score = _ratingWeight * ratingScore +
          _distanceWeight * distanceScore +
          _fairnessWeight * fairnessScore +
          _availabilityWeight * availabilityScore;

      if (p.activeJobsCount > _heavyLoadThreshold) {
        score *= _heavyLoadPenalty;
      }

      return _ScoredProvider(p, score);
    }).toList();

    scored.sort((a, b) {
      final scoreDiff = b.score.compareTo(a.score);
      if ((b.score - a.score).abs() < 0.05) {
        final jobDiff = a.provider.activeJobsCount.compareTo(b.provider.activeJobsCount);
        if (jobDiff != 0) return jobDiff;
        
        if (a.provider.lastAssignedAt != null && b.provider.lastAssignedAt != null) {
          return a.provider.lastAssignedAt!.compareTo(b.provider.lastAssignedAt!);
        }
      }
      return scoreDiff;
    });

    return scored.map((s) => s.provider).toList();
  }

  List<ProviderModel> _sortByMode(List<ProviderModel> providers, ProviderSortMode mode) {
    final sorted = List<ProviderModel>.from(providers);
    
    switch (mode) {
      case ProviderSortMode.nearest:
        sorted.sort((a, b) => a.distanceKm.compareTo(b.distanceKm));
        break;
      case ProviderSortMode.bestRated:
        sorted.sort((a, b) => b.rating.compareTo(a.rating));
        break;
      case ProviderSortMode.priceLowToHigh:
        sorted.sort((a, b) => a.priceValue.compareTo(b.priceValue));
        break;
      case ProviderSortMode.priceHighToLow:
        sorted.sort((a, b) => b.priceValue.compareTo(a.priceValue));
        break;
      case ProviderSortMode.availableFirst:
        sorted.sort((a, b) {
          if (a.isAvailableNow && !b.isAvailableNow) return -1;
          if (!a.isAvailableNow && b.isAvailableNow) return 1;
          return a.distanceKm.compareTo(b.distanceKm);
        });
        break;
      case ProviderSortMode.bestMatch:
        break;
    }
    
    return sorted;
  }
}

class _ScoredProvider {
  final ProviderModel provider;
  final double score;
  _ScoredProvider(this.provider, this.score);
}
