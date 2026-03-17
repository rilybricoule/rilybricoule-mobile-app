import 'dart:math';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../models/provider_location.dart';

class ProvidersRepository {
  static final ProvidersRepository _instance = ProvidersRepository._internal();
  factory ProvidersRepository() => _instance;
  ProvidersRepository._internal();

  List<ProviderLocation> _getMockProviders(String lang) {
    return [
    ProviderLocation(
      id: '1',
      name: lang == 'ar' ? 'أحمد المنصوري' : 'Ahmed El Mansouri',
      category: lang == 'en' ? 'Expert Handyman' : lang == 'ar' ? 'خبير أعمال يدوية' : 'Bricoleur Expert',
      imageUrl: 'assets/images/provider.png',
      rating: 4.9,
      reviewCount: 42,
      distance: 0.8,
      price: '150 MAD/hr',
      position: const LatLng(33.5731, -7.5898),
      isVerified: true,
      status: ProviderStatus.available,
      categoryId: '5',
      activeJobsCount: 2,
    ),
    ProviderLocation(
      id: '2',
      name: lang == 'ar' ? 'ياسين العمراني' : 'Yassine Amrani',
      category: lang == 'en' ? 'Plumber' : lang == 'ar' ? 'سباك' : 'Plombier',
      imageUrl: 'assets/images/provider.png',
      rating: 4.7,
      reviewCount: 38,
      distance: 1.2,
      price: '220 MAD/hr',
      position: const LatLng(33.5850, -7.6050),
      isVerified: true,
      status: ProviderStatus.available,
      categoryId: '1',
      activeJobsCount: 1,
    ),
    ProviderLocation(
      id: '3',
      name: lang == 'ar' ? 'عمر حسن' : 'Omar Hassan',
      category: lang == 'en' ? 'Electrician' : lang == 'ar' ? 'كهربائي' : 'Électricien',
      imageUrl: 'assets/images/provider.png',
      rating: 4.8,
      reviewCount: 56,
      distance: 1.5,
      price: '180 MAD/hr',
      position: const LatLng(33.5650, -7.5750),
      isVerified: true,
      status: ProviderStatus.busy,
      categoryId: '2',
      activeJobsCount: 6,
    ),
    ProviderLocation(
      id: '4',
      name: lang == 'ar' ? 'كريم بنجلون' : 'Karim Benjelloun',
      category: lang == 'en' ? 'Carpenter' : lang == 'ar' ? 'نجار' : 'Menuisier',
      imageUrl: 'assets/images/provider.png',
      rating: 4.6,
      reviewCount: 29,
      distance: 2.1,
      price: '305 MAD/hr',
      position: const LatLng(33.5800, -7.5700),
      isVerified: false,
      status: ProviderStatus.available,
      categoryId: '6',
      activeJobsCount: 0,
    ),
    ProviderLocation(
      id: '5',
      name: lang == 'ar' ? 'رشيد العلمي' : 'Rachid Alami',
      category: lang == 'en' ? 'Painter' : lang == 'ar' ? 'صباغ' : 'Peintre',
      imageUrl: 'assets/images/provider.png',
      rating: 4.5,
      reviewCount: 33,
      distance: 2.8,
      price: '200 MAD/hr',
      position: const LatLng(33.5900, -7.5950),
      isVerified: true,
      status: ProviderStatus.available,
      categoryId: '4',
      activeJobsCount: 3,
    ),
  ];
  }

  // TODO: Replace with actual API call
  Future<List<ProviderLocation>> fetchProvidersAround({
    required double lat,
    required double lng,
    double radiusKm = 10,
    String? category,
    double? minRating,
    double? maxPrice,
    String? langCode,
  }) async {
    await Future.delayed(const Duration(milliseconds: 500));

    final lang = langCode ?? 'fr';
    List<ProviderLocation> filtered = List.from(_getMockProviders(lang));

    // Calculate distance and filter
    filtered = filtered.where((provider) {
      final distance = _calculateDistance(
        lat,
        lng,
        provider.position.latitude,
        provider.position.longitude,
      );
      return distance <= radiusKm;
    }).toList();

    // Apply filters
    if (category != null && category.isNotEmpty) {
      filtered = filtered
          .where((p) => p.category.toLowerCase().contains(category.toLowerCase()))
          .toList();
    }

    if (minRating != null) {
      filtered = filtered.where((p) => p.rating >= minRating).toList();
    }

    if (maxPrice != null) {
      filtered = filtered.where((p) {
        final priceValue = double.tryParse(p.price.split(' ')[0]) ?? 0;
        return priceValue <= maxPrice;
      }).toList();
    }

    // Update distances
    for (var provider in filtered) {
      provider.distance = _calculateDistance(
        lat,
        lng,
        provider.position.latitude,
        provider.position.longitude,
      );
    }

    // Sort by distance
    filtered.sort((a, b) => a.distance.compareTo(b.distance));

    return filtered;
  }

  double _calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    const double earthRadius = 6371; // km
    final dLat = _toRadians(lat2 - lat1);
    final dLon = _toRadians(lon2 - lon1);

    final a = sin(dLat / 2) * sin(dLat / 2) +
        cos(_toRadians(lat1)) *
            cos(_toRadians(lat2)) *
            sin(dLon / 2) *
            sin(dLon / 2);

    final c = 2 * atan2(sqrt(a), sqrt(1 - a));
    return earthRadius * c;
  }

  double _toRadians(double degree) {
    return degree * pi / 180;
  }
}
