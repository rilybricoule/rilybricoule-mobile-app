import '../../data/models/app_user.dart';
import '../../models/user_role.dart';

/// Entity Domain: UserProfile
/// Représente le profil utilisateur côté backend (source de vérité métier)
/// 
/// Cette entity est agnostique de la source de données (Firebase/API)
/// et sera utilisée par toute l'application pour le profil utilisateur.
class UserProfile {
  final String id;
  final String? backendId;
  final String? firebaseUid;
  final UserRole role;
  final String fullName;
  final String email;
  final String? phone;
  final String? photoUrl;
  final String locale;
  final UserProfileAddress? address;
  final DateTime createdAt;
  final DateTime updatedAt;

  const UserProfile({
    required this.id,
    this.backendId,
    this.firebaseUid,
    required this.role,
    required this.fullName,
    required this.email,
    this.phone,
    this.photoUrl,
    this.locale = 'fr',
    this.address,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Créer un UserProfile depuis un AppUser (Firebase)
  factory UserProfile.fromAppUser(AppUser appUser) {
    return UserProfile(
      id: appUser.uid,
      firebaseUid: appUser.uid,
      role: appUser.role,
      fullName: appUser.fullName,
      email: appUser.email,
      phone: appUser.phone,
      photoUrl: appUser.photoUrl,
      locale: appUser.locale,
      address: appUser.clientProfile?.address != null
          ? UserProfileAddress.fromUserAddress(appUser.clientProfile!.address!)
          : null,
      createdAt: appUser.createdAt,
      updatedAt: appUser.updatedAt,
    );
  }

  /// Convertir vers AppUser (pour compatibilité existante)
  AppUser toAppUser() {
    return AppUser(
      uid: firebaseUid ?? id,
      role: role,
      fullName: fullName,
      email: email,
      phone: phone,
      photoUrl: photoUrl,
      createdAt: createdAt,
      updatedAt: updatedAt,
      locale: locale,
      clientProfile: address != null
          ? ClientProfile(address: address!.toUserAddress())
          : ClientProfile(),
    );
  }

  UserProfile copyWith({
    String? fullName,
    String? phone,
    String? photoUrl,
    String? locale,
    UserProfileAddress? address,
    DateTime? updatedAt,
  }) {
    return UserProfile(
      id: id,
      backendId: backendId,
      firebaseUid: firebaseUid,
      role: role,
      fullName: fullName ?? this.fullName,
      email: email,
      phone: phone ?? this.phone,
      photoUrl: photoUrl ?? this.photoUrl,
      locale: locale ?? this.locale,
      address: address ?? this.address,
      createdAt: createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  /// Vérifier si le profil est complet (minimum requis)
  bool get isComplete => fullName.isNotEmpty && fullName.length >= 2;

  /// Vérifier si l'utilisateur a une photo
  bool get hasPhoto => photoUrl != null && photoUrl!.isNotEmpty;

  /// Vérifier si l'utilisateur a une adresse
  bool get hasAddress => address != null && address!.city.isNotEmpty;

  @override
  String toString() {
    return 'UserProfile(id: $id, fullName: $fullName, email: $email, role: $role)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is UserProfile &&
        other.id == id &&
        other.fullName == fullName &&
        other.phone == phone &&
        other.photoUrl == photoUrl &&
        other.locale == locale &&
        other.address == address;
  }

  @override
  int get hashCode {
    return Object.hash(
      id,
      fullName,
      phone,
      photoUrl,
      locale,
      address,
    );
  }
}

/// Adresse du profil utilisateur (Domain Entity)
class UserProfileAddress {
  final String city;
  final String? street;
  final double? lat;
  final double? lng;

  const UserProfileAddress({
    required this.city,
    this.street,
    this.lat,
    this.lng,
  });

  /// Créer depuis UserAddress (data layer)
  factory UserProfileAddress.fromUserAddress(UserAddress address) {
    return UserProfileAddress(
      city: address.city,
      street: address.street,
      lat: address.lat,
      lng: address.lng,
    );
  }

  /// Convertir vers UserAddress (data layer)
  UserAddress toUserAddress() {
    return UserAddress(
      city: city,
      street: street,
      lat: lat,
      lng: lng,
    );
  }

  UserProfileAddress copyWith({
    String? city,
    String? street,
    double? lat,
    double? lng,
  }) {
    return UserProfileAddress(
      city: city ?? this.city,
      street: street ?? this.street,
      lat: lat ?? this.lat,
      lng: lng ?? this.lng,
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

  factory UserProfileAddress.fromMap(Map<String, dynamic> map) {
    return UserProfileAddress(
      city: map['city'] ?? '',
      street: map['street'],
      lat: map['lat']?.toDouble(),
      lng: map['lng']?.toDouble(),
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is UserProfileAddress &&
        other.city == city &&
        other.street == street &&
        other.lat == lat &&
        other.lng == lng;
  }

  @override
  int get hashCode => Object.hash(city, street, lat, lng);
}
