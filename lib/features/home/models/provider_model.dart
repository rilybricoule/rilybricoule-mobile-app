class ProviderModel {
  final String id;
  final String name;
  final String service;
  final String imageUrl;
  final double rating;
  final int reviewCount;
  final double distance;
  final String priceLabel;
  final String price;
  final bool isVerified;
  final double priceValue;
  final bool isAvailable;
  final String categoryId;
  final String? subCategoryId;
  final int activeJobsCount;
  final DateTime? lastAssignedAt;

  double get distanceKm => distance;
  bool get isAvailableNow => isAvailable;

  ProviderModel({
    required this.id,
    required this.name,
    required this.service,
    required this.imageUrl,
    required this.rating,
    required this.reviewCount,
    required this.distance,
    required this.priceLabel,
    required this.price,
    required this.priceValue,
    required this.categoryId,
    this.subCategoryId,
    this.isVerified = false,
    this.isAvailable = true,
    this.activeJobsCount = 0,
    this.lastAssignedAt,
  });
}
