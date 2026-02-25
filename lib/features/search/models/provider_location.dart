import 'package:google_maps_flutter/google_maps_flutter.dart';

class ProviderLocation {
  final String id;
  final String name;
  final String category;
  final String imageUrl;
  final double rating;
  final int reviewCount;
  final double distance;
  final String price;
  final LatLng position;
  final bool isVerified;

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
    this.isVerified = false,
  });
}
