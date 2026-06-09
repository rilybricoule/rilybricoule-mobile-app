/// Modèle pour les tokens JWT du backend
class AuthTokens {
  final String accessToken;
  final String refreshToken;
  final int expiresIn; // en secondes
  final DateTime issuedAt;

  AuthTokens({
    required this.accessToken,
    required this.refreshToken,
    required this.expiresIn,
    DateTime? issuedAt,
  }) : issuedAt = issuedAt ?? DateTime.now();

  /// Vérifie si le token est expiré
  bool get isExpired {
    final expiryTime = issuedAt.add(Duration(seconds: expiresIn));
    return DateTime.now().isAfter(expiryTime);
  }

  /// Vérifie si le token doit être refresh (5min avant expiration)
  bool get shouldRefresh {
    final refreshTime = issuedAt.add(Duration(seconds: expiresIn - 300));
    return DateTime.now().isAfter(refreshTime);
  }

  /// Temps restant avant expiration (en secondes)
  int get timeUntilExpiry {
    final expiryTime = issuedAt.add(Duration(seconds: expiresIn));
    final remaining = expiryTime.difference(DateTime.now()).inSeconds;
    return remaining > 0 ? remaining : 0;
  }

  factory AuthTokens.fromJson(Map<String, dynamic> json) {
    return AuthTokens(
      accessToken: json['accessToken'] as String,
      refreshToken: json['refreshToken'] as String,
      expiresIn: json['expiresIn'] as int,
      issuedAt: json['issuedAt'] != null
          ? DateTime.parse(json['issuedAt'] as String)
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'accessToken': accessToken,
      'refreshToken': refreshToken,
      'expiresIn': expiresIn,
      'issuedAt': issuedAt.toIso8601String(),
    };
  }

  AuthTokens copyWith({
    String? accessToken,
    String? refreshToken,
    int? expiresIn,
    DateTime? issuedAt,
  }) {
    return AuthTokens(
      accessToken: accessToken ?? this.accessToken,
      refreshToken: refreshToken ?? this.refreshToken,
      expiresIn: expiresIn ?? this.expiresIn,
      issuedAt: issuedAt ?? this.issuedAt,
    );
  }
}
