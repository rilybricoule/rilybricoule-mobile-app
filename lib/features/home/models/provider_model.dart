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
    this.isVerified = false,
    this.isAvailable = true,
  });
}
