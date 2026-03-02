import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/user_role.dart';

/// Modèle utilisateur complet pour Firebase
/// Supporte 2 rôles: CLIENT et PRESTATAIRE avec champs spécifiques
class AppUser {
  // ========== CHAMPS COMMUNS ==========
  final String uid;
  final UserRole role;
  final String fullName;
  final String email;
  final String? phone;
  final String? photoUrl;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isVerified;
  final Map<String, String> fcmTokens; // Multi-device support
  final String locale; // 'fr' ou 'ar'
  final DateTime? lastActiveAt;

  // ========== PROFIL CLIENT ==========
  final ClientProfile? clientProfile;

  // ========== PROFIL PRESTATAIRE ==========
  final ProviderProfile? providerProfile;

  AppUser({
    required this.uid,
    required this.role,
    required this.fullName,
    required this.email,
    this.phone,
    this.photoUrl,
    required this.createdAt,
    required this.updatedAt,
    this.isVerified = false,
    this.fcmTokens = const {},
    this.locale = 'fr',
    this.lastActiveAt,
    this.clientProfile,
    this.providerProfile,
  });

  /// Conversion depuis Firestore
  factory AppUser.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    final role = UserRole.values.firstWhere(
      (e) => e.name == data['role'],
      orElse: () => UserRole.client,
    );

    return AppUser(
      uid: doc.id,
      role: role,
      fullName: data['fullName'] ?? '',
      email: data['email'] ?? '',
      phone: data['phone'],
      photoUrl: data['photoUrl'],
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      updatedAt: (data['updatedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      isVerified: data['isVerified'] ?? false,
      fcmTokens: Map<String, String>.from(data['fcmTokens'] ?? {}),
      locale: data['locale'] ?? 'fr',
      lastActiveAt: (data['lastActiveAt'] as Timestamp?)?.toDate(),
      clientProfile: role == UserRole.client && data['clientProfile'] != null
          ? ClientProfile.fromMap(data['clientProfile'])
          : null,
      providerProfile:
          role == UserRole.prestataire && data['providerProfile'] != null
              ? ProviderProfile.fromMap(data['providerProfile'])
              : null,
    );
  }

  /// Conversion vers Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'role': role.name,
      'fullName': fullName,
      'email': email,
      'phone': phone,
      'photoUrl': photoUrl,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
      'isVerified': isVerified,
      'fcmTokens': fcmTokens,
      'locale': locale,
      'lastActiveAt':
          lastActiveAt != null ? Timestamp.fromDate(lastActiveAt!) : null,
      if (clientProfile != null) 'clientProfile': clientProfile!.toMap(),
      if (providerProfile != null)
        'providerProfile': providerProfile!.toMap(),
    };
  }

  AppUser copyWith({
    String? fullName,
    String? phone,
    String? photoUrl,
    bool? isVerified,
    Map<String, String>? fcmTokens,
    String? locale,
    DateTime? lastActiveAt,
    ClientProfile? clientProfile,
    ProviderProfile? providerProfile,
  }) {
    return AppUser(
      uid: uid,
      role: role,
      fullName: fullName ?? this.fullName,
      email: email,
      phone: phone ?? this.phone,
      photoUrl: photoUrl ?? this.photoUrl,
      createdAt: createdAt,
      updatedAt: DateTime.now(),
      isVerified: isVerified ?? this.isVerified,
      fcmTokens: fcmTokens ?? this.fcmTokens,
      locale: locale ?? this.locale,
      lastActiveAt: lastActiveAt ?? this.lastActiveAt,
      clientProfile: clientProfile ?? this.clientProfile,
      providerProfile: providerProfile ?? this.providerProfile,
    );
  }
}

/// Profil spécifique CLIENT
class ClientProfile {
  final UserAddress? address;
  final List<String> favoritesProviderIds;
  final String? defaultPaymentMethod;
  final ClientStats stats;

  ClientProfile({
    this.address,
    this.favoritesProviderIds = const [],
    this.defaultPaymentMethod,
    ClientStats? stats,
  }) : stats = stats ?? ClientStats();

  factory ClientProfile.fromMap(Map<String, dynamic> map) {
    return ClientProfile(
      address:
          map['address'] != null ? UserAddress.fromMap(map['address']) : null,
      favoritesProviderIds: List<String>.from(map['favoritesProviderIds'] ?? []),
      defaultPaymentMethod: map['defaultPaymentMethod'],
      stats: map['stats'] != null
          ? ClientStats.fromMap(map['stats'])
          : ClientStats(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'address': address?.toMap(),
      'favoritesProviderIds': favoritesProviderIds,
      'defaultPaymentMethod': defaultPaymentMethod,
      'stats': stats.toMap(),
    };
  }
}

class ClientStats {
  final int totalBookings;

  ClientStats({this.totalBookings = 0});

  factory ClientStats.fromMap(Map<String, dynamic> map) {
    return ClientStats(totalBookings: map['totalBookings'] ?? 0);
  }

  Map<String, dynamic> toMap() => {'totalBookings': totalBookings};
}

/// Profil spécifique PRESTATAIRE
class ProviderProfile {
  final List<String> categories; // plomberie, électricité, etc.
  final String? bio;
  final int yearsExperience;
  final double priceFrom; // MAD
  final ServiceArea? serviceArea;
  final GeoPoint? geo;
  final double ratingAvg;
  final int reviewsCount;
  final bool isCertified;
  final bool isAvailableNow;
  final List<String> portfolioImages;

  ProviderProfile({
    this.categories = const [],
    this.bio,
    this.yearsExperience = 0,
    this.priceFrom = 0,
    this.serviceArea,
    this.geo,
    this.ratingAvg = 0,
    this.reviewsCount = 0,
    this.isCertified = false,
    this.isAvailableNow = false,
    this.portfolioImages = const [],
  });

  factory ProviderProfile.fromMap(Map<String, dynamic> map) {
    return ProviderProfile(
      categories: List<String>.from(map['categories'] ?? []),
      bio: map['bio'],
      yearsExperience: map['yearsExperience'] ?? 0,
      priceFrom: (map['priceFrom'] ?? 0).toDouble(),
      serviceArea: map['serviceArea'] != null
          ? ServiceArea.fromMap(map['serviceArea'])
          : null,
      geo: map['geo'] != null ? GeoPoint(map['geo']['lat'], map['geo']['lng']) : null,
      ratingAvg: (map['ratingAvg'] ?? 0).toDouble(),
      reviewsCount: map['reviewsCount'] ?? 0,
      isCertified: map['isCertified'] ?? false,
      isAvailableNow: map['isAvailableNow'] ?? false,
      portfolioImages: List<String>.from(map['portfolioImages'] ?? []),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'categories': categories,
      'bio': bio,
      'yearsExperience': yearsExperience,
      'priceFrom': priceFrom,
      'serviceArea': serviceArea?.toMap(),
      'geo': geo != null ? {'lat': geo!.latitude, 'lng': geo!.longitude} : null,
      'ratingAvg': ratingAvg,
      'reviewsCount': reviewsCount,
      'isCertified': isCertified,
      'isAvailableNow': isAvailableNow,
      'portfolioImages': portfolioImages,
    };
  }
}

/// Adresse utilisateur
class UserAddress {
  final String city;
  final String? street;
  final double? lat;
  final double? lng;

  UserAddress({
    required this.city,
    this.street,
    this.lat,
    this.lng,
  });

  factory UserAddress.fromMap(Map<String, dynamic> map) {
    return UserAddress(
      city: map['city'] ?? '',
      street: map['street'],
      lat: map['lat']?.toDouble(),
      lng: map['lng']?.toDouble(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'city': city,
      'street': street,
      'lat': lat,
      'lng': lng,
    };
  }
}

/// Zone de service prestataire
class ServiceArea {
  final String city;
  final double radiusKm;

  ServiceArea({
    required this.city,
    this.radiusKm = 10,
  });

  factory ServiceArea.fromMap(Map<String, dynamic> map) {
    return ServiceArea(
      city: map['city'] ?? '',
      radiusKm: (map['radiusKm'] ?? 10).toDouble(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'city': city,
      'radiusKm': radiusKm,
    };
  }
}
