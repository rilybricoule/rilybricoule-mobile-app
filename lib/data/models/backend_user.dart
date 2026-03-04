import '../../models/user_role.dart';

/// Modèle utilisateur venant du backend (endpoint /auth/me)
/// C'est la source de vérité pour le rôle et les permissions
class BackendUser {
  final String id;
  final String email;
  final String fullName;
  final UserRole role; // IMPORTANT: Vient du backend, pas de Firebase
  final String? phone;
  final String? photoUrl;
  final bool isVerified;
  final DateTime createdAt;
  final DateTime updatedAt;
  final Map<String, dynamic>? metadata;

  BackendUser({
    required this.id,
    required this.email,
    required this.fullName,
    required this.role,
    this.phone,
    this.photoUrl,
    required this.isVerified,
    required this.createdAt,
    required this.updatedAt,
    this.metadata,
  });

  factory BackendUser.fromJson(Map<String, dynamic> json) {
    return BackendUser(
      id: json['id'] as String,
      email: json['email'] as String,
      fullName: json['fullName'] as String,
      role: _parseRole(json['role'] as String),
      phone: json['phone'] as String?,
      photoUrl: json['photoUrl'] as String?,
      isVerified: json['isVerified'] as bool? ?? false,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      metadata: json['metadata'] as Map<String, dynamic>?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'fullName': fullName,
      'role': role.name,
      'phone': phone,
      'photoUrl': photoUrl,
      'isVerified': isVerified,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'metadata': metadata,
    };
  }

  static UserRole _parseRole(String roleStr) {
    switch (roleStr.toLowerCase()) {
      case 'client':
        return UserRole.client;
      case 'prestataire':
      case 'provider':
        return UserRole.prestataire;
      default:
        return UserRole.client;
    }
  }

  BackendUser copyWith({
    String? id,
    String? email,
    String? fullName,
    UserRole? role,
    String? phone,
    String? photoUrl,
    bool? isVerified,
    DateTime? createdAt,
    DateTime? updatedAt,
    Map<String, dynamic>? metadata,
  }) {
    return BackendUser(
      id: id ?? this.id,
      email: email ?? this.email,
      fullName: fullName ?? this.fullName,
      role: role ?? this.role,
      phone: phone ?? this.phone,
      photoUrl: photoUrl ?? this.photoUrl,
      isVerified: isVerified ?? this.isVerified,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      metadata: metadata ?? this.metadata,
    );
  }
}
