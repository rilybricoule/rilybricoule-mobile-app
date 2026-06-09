import 'package:flutter_test/flutter_test.dart';
import 'package:rilybricoule_mobile_app/core/models/provider_filter.dart';
import 'package:rilybricoule_mobile_app/core/models/provider_sort_mode.dart';
import 'package:rilybricoule_mobile_app/core/models/user_search_context.dart';
import 'package:rilybricoule_mobile_app/core/services/provider_ranking_engine.dart';
import 'package:rilybricoule_mobile_app/features/home/models/provider_model.dart';

void main() {
  late ProviderRankingEngine engine;

  setUp(() {
    engine = ProviderRankingEngine();
  });

  group('ProviderRankingEngine - Filtering', () {
    test('filters by categoryId', () {
      final providers = [
        _createProvider(id: '1', categoryId: '1'),
        _createProvider(id: '2', categoryId: '2'),
        _createProvider(id: '3', categoryId: '1'),
      ];

      final result = engine.filterAndRank(
        providers: providers,
        context: const UserSearchContext(),
        filter: const ProviderFilter(categoryId: '1'),
      );

      expect(result.length, 2);
      expect(result.every((p) => p.categoryId == '1'), true);
    });

    test('filters by minRating', () {
      final providers = [
        _createProvider(id: '1', rating: 4.9),
        _createProvider(id: '2', rating: 4.2),
        _createProvider(id: '3', rating: 4.7),
      ];

      final result = engine.filterAndRank(
        providers: providers,
        context: const UserSearchContext(),
        filter: const ProviderFilter(minRating: 4.5),
      );

      expect(result.length, 2);
      expect(result.every((p) => p.rating >= 4.5), true);
    });

    test('filters by maxDistanceKm', () {
      final providers = [
        _createProvider(id: '1', distance: 1.5),
        _createProvider(id: '2', distance: 5.0),
        _createProvider(id: '3', distance: 2.0),
      ];

      final result = engine.filterAndRank(
        providers: providers,
        context: const UserSearchContext(),
        filter: const ProviderFilter(maxDistanceKm: 3.0),
      );

      expect(result.length, 2);
      expect(result.every((p) => p.distanceKm <= 3.0), true);
    });

    test('filters by availableNow', () {
      final providers = [
        _createProvider(id: '1', isAvailable: true),
        _createProvider(id: '2', isAvailable: false),
        _createProvider(id: '3', isAvailable: true),
      ];

      final result = engine.filterAndRank(
        providers: providers,
        context: const UserSearchContext(),
        filter: const ProviderFilter(availableNow: true),
      );

      expect(result.length, 2);
      expect(result.every((p) => p.isAvailableNow), true);
    });
  });

  group('ProviderRankingEngine - Composite Scoring', () {
    test('penalizes high activeJobsCount', () {
      final providers = [
        _createProvider(
          id: '1',
          rating: 4.9,
          distance: 1.0,
          activeJobsCount: 8,
        ),
        _createProvider(
          id: '2',
          rating: 4.7,
          distance: 1.5,
          activeJobsCount: 1,
        ),
      ];

      final result = engine.filterAndRank(
        providers: providers,
        context: const UserSearchContext(),
        filter: const ProviderFilter(),
        sortMode: ProviderSortMode.bestMatch,
      );

      expect(result[0].id, '2');
    });

    test('tie-breaker uses activeJobsCount', () {
      final providers = [
        _createProvider(
          id: '1',
          rating: 4.8,
          distance: 2.0,
          activeJobsCount: 5,
        ),
        _createProvider(
          id: '2',
          rating: 4.8,
          distance: 2.0,
          activeJobsCount: 1,
        ),
      ];

      final result = engine.filterAndRank(
        providers: providers,
        context: const UserSearchContext(),
        filter: const ProviderFilter(),
        sortMode: ProviderSortMode.bestMatch,
      );

      expect(result[0].id, '2');
    });
  });

  group('ProviderRankingEngine - Sort Modes', () {
    test('sorts by nearest', () {
      final providers = [
        _createProvider(id: '1', distance: 5.0),
        _createProvider(id: '2', distance: 1.0),
        _createProvider(id: '3', distance: 3.0),
      ];

      final result = engine.filterAndRank(
        providers: providers,
        context: const UserSearchContext(),
        filter: const ProviderFilter(),
        sortMode: ProviderSortMode.nearest,
      );

      expect(result[0].id, '2');
      expect(result[1].id, '3');
      expect(result[2].id, '1');
    });

    test('sorts by bestRated', () {
      final providers = [
        _createProvider(id: '1', rating: 4.5),
        _createProvider(id: '2', rating: 4.9),
        _createProvider(id: '3', rating: 4.7),
      ];

      final result = engine.filterAndRank(
        providers: providers,
        context: const UserSearchContext(),
        filter: const ProviderFilter(),
        sortMode: ProviderSortMode.bestRated,
      );

      expect(result[0].id, '2');
      expect(result[1].id, '3');
      expect(result[2].id, '1');
    });

    test('sorts by priceLowToHigh', () {
      final providers = [
        _createProvider(id: '1', priceValue: 200.0),
        _createProvider(id: '2', priceValue: 100.0),
        _createProvider(id: '3', priceValue: 150.0),
      ];

      final result = engine.filterAndRank(
        providers: providers,
        context: const UserSearchContext(),
        filter: const ProviderFilter(),
        sortMode: ProviderSortMode.priceLowToHigh,
      );

      expect(result[0].id, '2');
      expect(result[1].id, '3');
      expect(result[2].id, '1');
    });
  });
}

ProviderModel _createProvider({
  required String id,
  String categoryId = '1',
  double rating = 4.5,
  double distance = 2.0,
  bool isAvailable = true,
  int activeJobsCount = 0,
  double priceValue = 150.0,
}) {
  return ProviderModel(
    id: id,
    name: 'Provider $id',
    service: 'Service',
    imageUrl: 'assets/images/provider.png',
    rating: rating,
    reviewCount: 100,
    distance: distance,
    priceLabel: '',
    price: '$priceValue MAD',
    priceValue: priceValue,
    categoryId: categoryId,
    isAvailable: isAvailable,
    activeJobsCount: activeJobsCount,
  );
}
