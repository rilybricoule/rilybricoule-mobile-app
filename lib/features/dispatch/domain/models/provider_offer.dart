/// Snapshot of a provider who accepted a dispatch request.
class ProviderOffer {
  final String requestId;
  final String providerId;
  final String providerName;
  final double providerRating;
  final int providerReviewCount;
  final double distanceKm;
  final double? priceFrom;
  final String imageUrl;
  final DateTime acceptedAt;
  final String serviceName;

  const ProviderOffer({
    required this.requestId,
    required this.providerId,
    required this.providerName,
    required this.providerRating,
    required this.providerReviewCount,
    required this.distanceKm,
    this.priceFrom,
    required this.imageUrl,
    required this.acceptedAt,
    required this.serviceName,
  });

  Map<String, dynamic> toJson() => {
    'requestId': requestId,
    'providerId': providerId,
    'providerName': providerName,
    'providerRating': providerRating,
    'providerReviewCount': providerReviewCount,
    'distanceKm': distanceKm,
    'priceFrom': priceFrom,
    'imageUrl': imageUrl,
    'acceptedAt': acceptedAt.toIso8601String(),
    'serviceName': serviceName,
  };

  factory ProviderOffer.fromJson(Map<String, dynamic> json) {
    return ProviderOffer(
      requestId: json['requestId'] as String,
      providerId: json['providerId'] as String,
      providerName: json['providerName'] as String,
      providerRating: (json['providerRating'] as num).toDouble(),
      providerReviewCount: json['providerReviewCount'] as int,
      distanceKm: (json['distanceKm'] as num).toDouble(),
      priceFrom: json['priceFrom'] != null ? (json['priceFrom'] as num).toDouble() : null,
      imageUrl: json['imageUrl'] as String,
      acceptedAt: DateTime.parse(json['acceptedAt'] as String),
      serviceName: json['serviceName'] as String,
    );
  }
}
