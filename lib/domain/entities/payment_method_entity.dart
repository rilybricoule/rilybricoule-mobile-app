/// Types de méthodes de paiement supportés
/// 
/// - [cmiCard]: Carte bancaire via CMI (Centre Monétique Interbancaire) - Maroc
/// - [paypal]: PayPal (optionnel, futur)
/// - [stripe]: Stripe (optionnel, futur)
/// - [wallet]: Portefeuille électronique (futur)
/// - [cash]: Espèces - Paiement sur place
enum PaymentMethodType {
  cmiCard,
  paypal,
  stripe,
  wallet,
  cash;

  String get displayName {
    switch (this) {
      case PaymentMethodType.cmiCard:
        return 'Carte bancaire (CMI)';
      case PaymentMethodType.paypal:
        return 'PayPal';
      case PaymentMethodType.stripe:
        return 'Carte bancaire (Stripe)';
      case PaymentMethodType.wallet:
        return 'Portefeuille électronique';
      case PaymentMethodType.cash:
        return 'Paiement sur place';
    }
  }

  String get icon {
    switch (this) {
      case PaymentMethodType.cmiCard:
        return 'credit_card';
      case PaymentMethodType.paypal:
        return 'paypal';
      case PaymentMethodType.stripe:
        return 'credit_card';
      case PaymentMethodType.wallet:
        return 'account_balance_wallet';
      case PaymentMethodType.cash:
        return 'payments';
    }
  }

  bool get isOnline => this != PaymentMethodType.cash;

  bool get isAvailableNow {
    switch (this) {
      case PaymentMethodType.cmiCard:
      case PaymentMethodType.cash:
        return true;
      case PaymentMethodType.paypal:
      case PaymentMethodType.stripe:
      case PaymentMethodType.wallet:
        return false; // Futur
    }
  }
}

/// Marques de cartes supportées
enum CardBrand {
  visa,
  mastercard,
  cmi,
  unknown;

  String get displayName {
    switch (this) {
      case CardBrand.visa:
        return 'Visa';
      case CardBrand.mastercard:
        return 'Mastercard';
      case CardBrand.cmi:
        return 'CMI';
      case CardBrand.unknown:
        return 'Carte';
    }
  }

  String get assetIcon {
    switch (this) {
      case CardBrand.visa:
        return 'assets/icons/visa.png';
      case CardBrand.mastercard:
        return 'assets/icons/mastercard.png';
      case CardBrand.cmi:
        return 'assets/icons/cmi.png';
      case CardBrand.unknown:
        return 'assets/icons/card_generic.png';
    }
  }
}

/// Entity Domain: Méthode de paiement
/// 
/// Représente une méthode de paiement enregistrée par l'utilisateur.
/// Agnostique de la source de données (Firebase/API).
class PaymentMethod {
  final String id;
  final PaymentMethodType type;
  final String label;
  final CardBrand? brand;
  final String? last4;
  final String? cardHolderName;
  final int? expMonth;
  final int? expYear;
  final bool isDefault;
  final bool isEnabled;
  final String currency;
  final String country;
  final DateTime? createdAt;

  const PaymentMethod({
    required this.id,
    required this.type,
    required this.label,
    this.brand,
    this.last4,
    this.cardHolderName,
    this.expMonth,
    this.expYear,
    this.isDefault = false,
    this.isEnabled = true,
    this.currency = 'MAD',
    this.country = 'MA',
    this.createdAt,
  });

  /// Créer une méthode de paiement CMI
  factory PaymentMethod.cmiCard({
    required String id,
    required String last4,
    required int expMonth,
    required int expYear,
    CardBrand brand = CardBrand.cmi,
    String? cardHolderName,
    bool isDefault = false,
    DateTime? createdAt,
  }) {
    return PaymentMethod(
      id: id,
      type: PaymentMethodType.cmiCard,
      label: '${brand.displayName} •••• $last4',
      brand: brand,
      last4: last4,
      cardHolderName: cardHolderName,
      expMonth: expMonth,
      expYear: expYear,
      isDefault: isDefault,
      currency: 'MAD',
      country: 'MA',
      createdAt: createdAt ?? DateTime.now(),
    );
  }

  /// Créer une méthode de paiement Cash
  factory PaymentMethod.cash({
    required String id,
    bool isDefault = false,
    bool isEnabled = true,
  }) {
    return PaymentMethod(
      id: id,
      type: PaymentMethodType.cash,
      label: 'Paiement sur place',
      isDefault: isDefault,
      isEnabled: isEnabled,
      currency: 'MAD',
      country: 'MA',
    );
  }

  /// Getter pour vérifier si c'est une carte
  bool get isCard => type == PaymentMethodType.cmiCard || type == PaymentMethodType.stripe;

  /// Getter pour vérifier si c'est du cash
  bool get isCash => type == PaymentMethodType.cash;

  /// Getter pour l'affichage de l'expiration
  String? get expiryDisplay {
    if (expMonth == null || expYear == null) return null;
    return '${expMonth.toString().padLeft(2, '0')}/${expYear.toString().substring(2)}';
  }

  PaymentMethod copyWith({
    String? id,
    PaymentMethodType? type,
    String? label,
    CardBrand? brand,
    String? last4,
    String? cardHolderName,
    int? expMonth,
    int? expYear,
    bool? isDefault,
    bool? isEnabled,
    String? currency,
    String? country,
    DateTime? createdAt,
  }) {
    return PaymentMethod(
      id: id ?? this.id,
      type: type ?? this.type,
      label: label ?? this.label,
      brand: brand ?? this.brand,
      last4: last4 ?? this.last4,
      cardHolderName: cardHolderName ?? this.cardHolderName,
      expMonth: expMonth ?? this.expMonth,
      expYear: expYear ?? this.expYear,
      isDefault: isDefault ?? this.isDefault,
      isEnabled: isEnabled ?? this.isEnabled,
      currency: currency ?? this.currency,
      country: country ?? this.country,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'type': type.name,
      'label': label,
      'brand': brand?.name,
      'last4': last4,
      'cardHolderName': cardHolderName,
      'expMonth': expMonth,
      'expYear': expYear,
      'isDefault': isDefault,
      'isEnabled': isEnabled,
      'currency': currency,
      'country': country,
      'createdAt': createdAt?.toIso8601String(),
    };
  }

  factory PaymentMethod.fromMap(Map<String, dynamic> map) {
    return PaymentMethod(
      id: map['id'] ?? '',
      type: PaymentMethodType.values.firstWhere(
        (e) => e.name == map['type'],
        orElse: () => PaymentMethodType.cash,
      ),
      label: map['label'] ?? '',
      brand: map['brand'] != null
          ? CardBrand.values.firstWhere(
              (e) => e.name == map['brand'],
              orElse: () => CardBrand.unknown,
            )
          : null,
      last4: map['last4'],
      cardHolderName: map['cardHolderName'],
      expMonth: map['expMonth'],
      expYear: map['expYear'],
      isDefault: map['isDefault'] ?? false,
      isEnabled: map['isEnabled'] ?? true,
      currency: map['currency'] ?? 'MAD',
      country: map['country'] ?? 'MA',
      createdAt: map['createdAt'] != null
          ? DateTime.tryParse(map['createdAt'])
          : null,
    );
  }

  @override
  String toString() {
    return 'PaymentMethod(id: $id, type: $type, label: $label, isDefault: $isDefault)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is PaymentMethod && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
