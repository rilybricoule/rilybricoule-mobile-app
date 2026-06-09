/// Address model for dispatch requests.
class DispatchAddress {
  final String city;
  final String street;
  final double? lat;
  final double? lng;

  const DispatchAddress({
    required this.city,
    required this.street,
    this.lat,
    this.lng,
  });

  DispatchAddress copyWith({
    String? city,
    String? street,
    double? lat,
    double? lng,
  }) {
    return DispatchAddress(
      city: city ?? this.city,
      street: street ?? this.street,
      lat: lat ?? this.lat,
      lng: lng ?? this.lng,
    );
  }

  Map<String, dynamic> toJson() => {
    'city': city,
    'street': street,
    'lat': lat,
    'lng': lng,
  };

  factory DispatchAddress.fromJson(Map<String, dynamic> json) {
    return DispatchAddress(
      city: json['city'] as String,
      street: json['street'] as String,
      lat: json['lat'] as double?,
      lng: json['lng'] as double?,
    );
  }
}

/// Status of a dispatch request.
enum DispatchRequestStatus {
  pending,
  searching,
  matched,
  cancelled,
  expired,
  paid,
}

/// Model representing a broadcast dispatch request from a client.
class DispatchRequest {
  final String id;
  final String clientId;
  final String categoryId;
  final String? subCategoryId;
  final DispatchAddress address;
  final String phone;
  final String? note;
  final DateTime createdAt;
  final DispatchRequestStatus status;
  final String? matchedProviderId;
  final DateTime expiresAt;
  final bool isUrgent;
  final DateTime? scheduledAt;

  const DispatchRequest({
    required this.id,
    required this.clientId,
    required this.categoryId,
    this.subCategoryId,
    required this.address,
    required this.phone,
    this.note,
    required this.createdAt,
    required this.status,
    this.matchedProviderId,
    required this.expiresAt,
    this.isUrgent = true,
    this.scheduledAt,
  });

  DispatchRequest copyWith({
    String? id,
    String? clientId,
    String? categoryId,
    String? subCategoryId,
    DispatchAddress? address,
    String? phone,
    String? note,
    DateTime? createdAt,
    DispatchRequestStatus? status,
    String? matchedProviderId,
    DateTime? expiresAt,
    bool? isUrgent,
    DateTime? scheduledAt,
  }) {
    return DispatchRequest(
      id: id ?? this.id,
      clientId: clientId ?? this.clientId,
      categoryId: categoryId ?? this.categoryId,
      subCategoryId: subCategoryId ?? this.subCategoryId,
      address: address ?? this.address,
      phone: phone ?? this.phone,
      note: note ?? this.note,
      createdAt: createdAt ?? this.createdAt,
      status: status ?? this.status,
      matchedProviderId: matchedProviderId ?? this.matchedProviderId,
      expiresAt: expiresAt ?? this.expiresAt,
      isUrgent: isUrgent ?? this.isUrgent,
      scheduledAt: scheduledAt ?? this.scheduledAt,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'clientId': clientId,
    'categoryId': categoryId,
    'subCategoryId': subCategoryId,
    'address': address.toJson(),
    'phone': phone,
    'note': note,
    'createdAt': createdAt.toIso8601String(),
    'status': status.name,
    'matchedProviderId': matchedProviderId,
    'expiresAt': expiresAt.toIso8601String(),
    'isUrgent': isUrgent,
    'scheduledAt': scheduledAt?.toIso8601String(),
  };
}
