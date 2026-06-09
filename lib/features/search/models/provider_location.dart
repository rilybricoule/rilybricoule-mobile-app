import 'package:google_maps_flutter/google_maps_flutter.dart';

enum ProviderStatus {
  available,
  busy,
  offline,
}

class ProviderLocation {
  final String id;
  final String name;
  final String category;
  final String imageUrl;
  final double rating;
  final int reviewCount;
  double distance;
  final String price;
  final LatLng position;
  final bool isVerified;
  final ProviderStatus status;
  final String categoryId;
  final String? subCategoryId;
  final int activeJobsCount;
  final DateTime? lastAssignedAt;

  double get distanceKm => distance;
  bool get isAvailableNow => status == ProviderStatus.available;

  ProviderLocation({
    required this.id,
    required this.name,
    required this.category,
    required this.imageUrl,
    required this.rating,
    required this.reviewCount,
    required this.distance,
    required this.price,
    required this.position,
    required this.categoryId,
    this.subCategoryId,
    this.isVerified = false,
    this.status = ProviderStatus.available,
    this.activeJobsCount = 0,
    this.lastAssignedAt,
  });
}
