import 'dart:async';
import 'dart:math';
import '../domain/dispatch_repository.dart';
import '../domain/models/dispatch_request.dart';
import '../domain/models/provider_offer.dart';

/// Mock implementation of [DispatchRepository].
/// Simulates provider dispatch with fairness-weighted first-accept-wins.
/// Stores everything in memory — ready to be replaced by API datasource.
class MockDispatchDatasource implements DispatchRepository {
  final Map<String, DispatchRequest> _requests = {};
  final Map<String, StreamController<DispatchRequest>> _watchers = {};
  final _random = Random();

  // ─── Mock provider pool (reuses existing provider IDs) ───
  static const List<Map<String, dynamic>> _mockProviders = [
    {'id': '1', 'name': 'Ahmed El Mansouri', 'nameAr': 'أحمد المنصوري', 'rating': 4.9, 'distance': 1.2, 'price': 150.0, 'categoryId': '1', 'activeJobs': 2, 'available': true, 'service': 'Plomberie', 'serviceEn': 'Plumbing', 'serviceAr': 'سباكة'},
    {'id': '2', 'name': 'Yassine Amrani', 'nameAr': 'ياسين العمراني', 'rating': 4.7, 'distance': 2.5, 'price': 120.0, 'categoryId': '1', 'activeJobs': 1, 'available': true, 'service': 'Plomberie', 'serviceEn': 'Plumbing', 'serviceAr': 'سباكة'},
    {'id': '4', 'name': 'Omar Hassan', 'nameAr': 'عمر حسن', 'rating': 4.8, 'distance': 4.1, 'price': 180.0, 'categoryId': '1', 'activeJobs': 0, 'available': true, 'service': 'Plomberie', 'serviceEn': 'Plumbing', 'serviceAr': 'سباكة'},
    {'id': '5', 'name': 'Sarah Benjelloun', 'nameAr': 'سارة بنجلون', 'rating': 4.9, 'distance': 1.1, 'price': 100.0, 'categoryId': '3', 'activeJobs': 3, 'available': true, 'service': 'Ménage', 'serviceEn': 'Cleaning', 'serviceAr': 'تنظيف'},
    {'id': '6', 'name': 'Fatima Zahra', 'nameAr': 'فاطمة الزهراء', 'rating': 4.6, 'distance': 3.2, 'price': 160.0, 'categoryId': '2', 'activeJobs': 4, 'available': true, 'service': 'Électricité', 'serviceEn': 'Electricity', 'serviceAr': 'كهرباء'},
    {'id': '7', 'name': 'Rachid Bennani', 'nameAr': 'رشيد بناني', 'rating': 4.4, 'distance': 5.0, 'price': 130.0, 'categoryId': '2', 'activeJobs': 0, 'available': true, 'service': 'Électricité', 'serviceEn': 'Electricity', 'serviceAr': 'كهرباء'},
    {'id': '8', 'name': 'Nadia El Fassi', 'nameAr': 'نادية الفاسي', 'rating': 4.8, 'distance': 2.0, 'price': 110.0, 'categoryId': '3', 'activeJobs': 1, 'available': true, 'service': 'Ménage', 'serviceEn': 'Cleaning', 'serviceAr': 'تنظيف'},
    {'id': '9', 'name': 'Hamid Tazi', 'nameAr': 'حميد التازي', 'rating': 4.3, 'distance': 6.5, 'price': 140.0, 'categoryId': '4', 'activeJobs': 2, 'available': true, 'service': 'Peinture', 'serviceEn': 'Painting', 'serviceAr': 'دهان'},
    {'id': '10', 'name': 'Laila Bouazza', 'nameAr': 'ليلى بوعزة', 'rating': 4.7, 'distance': 3.5, 'price': 170.0, 'categoryId': '5', 'activeJobs': 0, 'available': true, 'service': 'Bricolage', 'serviceEn': 'Handyman', 'serviceAr': 'أعمال يدوية'},
    {'id': '11', 'name': 'Mehdi Alaoui', 'nameAr': 'مهدي العلوي', 'rating': 4.5, 'distance': 7.0, 'price': 190.0, 'categoryId': '1', 'activeJobs': 5, 'available': true, 'service': 'Plomberie', 'serviceEn': 'Plumbing', 'serviceAr': 'سباكة'},
  ];

  // ─── Fairness scoring ───
  double _computeScore(Map<String, dynamic> provider, double maxDist) {
    final rating = (provider['rating'] as num).toDouble();
    final distance = (provider['distance'] as num).toDouble();
    final activeJobs = provider['activeJobs'] as int;

    final ratingNorm = rating / 5.0;
    final distanceScore = 1.0 - (distance / maxDist).clamp(0.0, 1.0);
    final fairnessScore = (1.0 - activeJobs / 5.0).clamp(0.0, 1.0);

    return 0.35 * ratingNorm + 0.35 * distanceScore + 0.30 * fairnessScore;
  }

  List<Map<String, dynamic>> _getEligibleProviders(
    String categoryId, {
    String? subCategoryId,
    double maxDistance = 10.0,
    Set<String> blockedIds = const {},
  }) {
    return _mockProviders.where((p) {
      if (p['categoryId'] != categoryId) return false;
      if (p['available'] != true) return false;
      if ((p['distance'] as num).toDouble() > maxDistance) return false;
      if (blockedIds.contains(p['id'])) return false;
      return true;
    }).toList();
  }

  @override
  Future<DispatchRequest> createRequest(DispatchRequest request) async {
    await Future.delayed(const Duration(milliseconds: 300));
    _requests[request.id] = request;
    _getOrCreateWatcher(request.id).add(request);
    return request;
  }

  @override
  Stream<DispatchRequest> watchRequest(String requestId) {
    return _getOrCreateWatcher(requestId).stream;
  }

  @override
  Future<void> cancelRequest(String requestId) async {
    final request = _requests[requestId];
    if (request != null) {
      final updated = request.copyWith(status: DispatchRequestStatus.cancelled);
      _requests[requestId] = updated;
      _getOrCreateWatcher(requestId).add(updated);
    }
  }

  @override
  Future<ProviderOffer?> waitForFirstAcceptance(
    String requestId, {
    Set<String> blockedProviderIds = const {},
  }) async {
    final request = _requests[requestId];
    if (request == null) return null;

    // Get eligible providers with fairness scoring
    final eligible = _getEligibleProviders(
      request.categoryId,
      subCategoryId: request.subCategoryId,
      blockedIds: blockedProviderIds,
    );

    if (eligible.isEmpty) return null;

    // Sort by fairness score (highest first)
    eligible.sort((a, b) => _computeScore(b, 10.0).compareTo(_computeScore(a, 10.0)));

    // Take top N candidates (max 10)
    final candidates = eligible.take(10).toList();

    // Simulate acceptance: higher score → shorter delay
    // Delay range: 2-15 seconds, weighted by score
    Map<String, double> delays = {};
    for (final c in candidates) {
      final score = _computeScore(c, 10.0);
      // Higher score = shorter delay (inverted)
      final baseDelay = 2.0 + (1.0 - score) * 13.0;
      // Add small random jitter
      final jitter = _random.nextDouble() * 2.0;
      delays[c['id'] as String] = baseDelay + jitter;
    }

    // Find the fastest responder
    String? fastestId;
    double fastestDelay = double.infinity;
    for (final entry in delays.entries) {
      if (entry.value < fastestDelay) {
        fastestDelay = entry.value;
        fastestId = entry.key;
      }
    }

    if (fastestId == null) return null;

    final winner = candidates.firstWhere((c) => c['id'] == fastestId);

    // Simulate the wait
    final waitSeconds = fastestDelay.clamp(2.0, 15.0);
    await Future.delayed(Duration(milliseconds: (waitSeconds * 1000).toInt()));

    // Check if request was cancelled during wait
    final currentRequest = _requests[requestId];
    if (currentRequest == null ||
        currentRequest.status == DispatchRequestStatus.cancelled) {
      return null;
    }

    // Update request status
    final updated = currentRequest.copyWith(
      status: DispatchRequestStatus.matched,
      matchedProviderId: fastestId,
    );
    _requests[requestId] = updated;
    _getOrCreateWatcher(requestId).add(updated);

    return ProviderOffer(
      requestId: requestId,
      providerId: fastestId,
      providerName: winner['name'] as String,
      providerRating: (winner['rating'] as num).toDouble(),
      providerReviewCount: 50 + _random.nextInt(200),
      distanceKm: (winner['distance'] as num).toDouble(),
      priceFrom: (winner['price'] as num).toDouble(),
      imageUrl: 'assets/images/provider.png',
      acceptedAt: DateTime.now(),
      serviceName: winner['service'] as String,
    );
  }

  @override
  Future<void> confirmProvider(String requestId, String providerId) async {
    await Future.delayed(const Duration(milliseconds: 200));
    final request = _requests[requestId];
    if (request != null) {
      final updated = request.copyWith(
        matchedProviderId: providerId,
      );
      _requests[requestId] = updated;
      _getOrCreateWatcher(requestId).add(updated);
    }
  }

  @override
  Future<void> markPaid(String requestId) async {
    await Future.delayed(const Duration(milliseconds: 200));
    final request = _requests[requestId];
    if (request != null) {
      final updated = request.copyWith(status: DispatchRequestStatus.paid);
      _requests[requestId] = updated;
      _getOrCreateWatcher(requestId).add(updated);
    }
  }

  @override
  List<Map<String, dynamic>> getCategories(String langCode) {
    final isAr = langCode == 'ar';
    final isEn = langCode == 'en';
    return [
      {'id': '1', 'name': isAr ? 'سباكة' : isEn ? 'Plumbing' : 'Plomberie', 'icon': 'plumbing'},
      {'id': '2', 'name': isAr ? 'كهرباء' : isEn ? 'Electricity' : 'Électricité', 'icon': 'electrical_services'},
      {'id': '3', 'name': isAr ? 'تنظيف' : isEn ? 'Cleaning' : 'Ménage', 'icon': 'cleaning_services'},
      {'id': '4', 'name': isAr ? 'دهان' : isEn ? 'Painting' : 'Peinture', 'icon': 'format_paint'},
      {'id': '5', 'name': isAr ? 'أعمال يدوية' : isEn ? 'Handyman' : 'Bricolage', 'icon': 'handyman'},
      {'id': '6', 'name': isAr ? 'بستنة' : isEn ? 'Gardening' : 'Jardinage', 'icon': 'yard'},
      {'id': '7', 'name': isAr ? 'تكييف' : isEn ? 'Air Conditioning' : 'Climatisation', 'icon': 'ac_unit'},
      {'id': '8', 'name': isAr ? 'نجارة' : isEn ? 'Carpentry' : 'Menuiserie', 'icon': 'carpenter'},
      {'id': '9', 'name': isAr ? 'أقفال' : isEn ? 'Locksmith' : 'Serrurerie', 'icon': 'lock'},
      {'id': '10', 'name': isAr ? 'نقل' : isEn ? 'Moving' : 'Déménagement', 'icon': 'local_shipping'},
      {'id': '11', 'name': isAr ? 'إصلاح' : isEn ? 'Repair' : 'Réparation', 'icon': 'build'},
      {'id': '12', 'name': isAr ? 'أخرى' : isEn ? 'Other' : 'Autre', 'icon': 'more_horiz'},
    ];
  }

  // ─── Internal helpers ───
  StreamController<DispatchRequest> _getOrCreateWatcher(String requestId) {
    if (!_watchers.containsKey(requestId)) {
      _watchers[requestId] = StreamController<DispatchRequest>.broadcast();
    }
    return _watchers[requestId]!;
  }

  /// Clean up watchers for a request.
  void dispose(String requestId) {
    _watchers[requestId]?.close();
    _watchers.remove(requestId);
  }
}
