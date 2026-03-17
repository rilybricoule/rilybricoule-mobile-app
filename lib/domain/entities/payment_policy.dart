/// Politique d'annulation pour les prestataires
/// 
/// Définit les règles de pénalisation en cas d'annulations excessives.
class ProviderCancellationPolicy {
  final int maxCancelsAllowed;
  final String penaltyDescription;
  final String? additionalInfo;

  const ProviderCancellationPolicy({
    required this.maxCancelsAllowed,
    required this.penaltyDescription,
    this.additionalInfo,
  });

  Map<String, dynamic> toMap() {
    return {
      'maxCancelsAllowed': maxCancelsAllowed,
      'penaltyDescription': penaltyDescription,
      'additionalInfo': additionalInfo,
    };
  }

  factory ProviderCancellationPolicy.fromMap(Map<String, dynamic> map) {
    return ProviderCancellationPolicy(
      maxCancelsAllowed: map['maxCancelsAllowed'] ?? 3,
      penaltyDescription: map['penaltyDescription'] ??
          'Au-delà de 3 annulations par mois, le prestataire est pénalisé',
      additionalInfo: map['additionalInfo'],
    );
  }

  @override
  String toString() {
    return 'ProviderCancellationPolicy(maxCancels: $maxCancelsAllowed)';
  }
}

/// Entity Domain: Politique de paiement
/// 
/// Définit les règles métier du système de paiement.
/// Fournie par le backend pour permettre des modifications dynamiques.
class PaymentPolicy {
  final String currency;
  final String onlineFlow;
  final String cashFlow;
  final String cmiDocsAvailableFrom;
  final ProviderCancellationPolicy providerCancellationPolicy;
  final String? preauthDescription;
  final String? captureDescription;
  final DateTime? updatedAt;

  const PaymentPolicy({
    required this.currency,
    required this.onlineFlow,
    required this.cashFlow,
    required this.cmiDocsAvailableFrom,
    required this.providerCancellationPolicy,
    this.preauthDescription,
    this.captureDescription,
    this.updatedAt,
  });

  /// Factory pour créer la politique par défaut (Maroc - CMI)
  factory PaymentPolicy.defaultPolicy() {
    return PaymentPolicy(
      currency: 'MAD',
      onlineFlow: 'preauth_then_capture',
      cashFlow: 'pay_on_site',
      cmiDocsAvailableFrom: 'Avril 2025',
      preauthDescription:
          'Le montant est bloqué (préautorisation) sur votre carte. '
          'Il ne sera débité qu\'après confirmation de l\'accomplissement du service.',
      captureDescription:
          'Le débit final est effectué après validation que le service a été réalisé.',
      providerCancellationPolicy: const ProviderCancellationPolicy(
        maxCancelsAllowed: 3,
        penaltyDescription:
            'Au-delà de 3 annulations par mois, le prestataire fait l\'objet d\'une pénalité '
            '(baisse de visibilité, suspension temporaire).',
        additionalInfo:
            'Cette politique garantit la fiabilité du service pour les clients.',
      ),
      updatedAt: DateTime.now(),
    );
  }

  /// Vérifier si le flux est de type preauth + capture
  bool get isPreauthFlow => onlineFlow == 'preauth_then_capture';

  /// Vérifier si le flux est de type escrow
  bool get isEscrowFlow => onlineFlow == 'escrow';

  /// Texte explicatif pour le préautorisation
  String get preauthExplanation {
    return preauthDescription ??
        'Le montant est bloqué sur votre carte et débité après service.';
  }

  /// Texte explicatif pour le cash
  String get cashExplanation {
    return 'Aucune transaction en ligne. Vous payez directement le prestataire sur place.';
  }

  Map<String, dynamic> toMap() {
    return {
      'currency': currency,
      'onlineFlow': onlineFlow,
      'cashFlow': cashFlow,
      'cmiDocsAvailableFrom': cmiDocsAvailableFrom,
      'preauthDescription': preauthDescription,
      'captureDescription': captureDescription,
      'providerCancellationPolicy': providerCancellationPolicy.toMap(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  factory PaymentPolicy.fromMap(Map<String, dynamic> map) {
    return PaymentPolicy(
      currency: map['currency'] ?? 'MAD',
      onlineFlow: map['onlineFlow'] ?? 'preauth_then_capture',
      cashFlow: map['cashFlow'] ?? 'pay_on_site',
      cmiDocsAvailableFrom: map['cmiDocsAvailableFrom'] ?? 'Avril 2025',
      preauthDescription: map['preauthDescription'],
      captureDescription: map['captureDescription'],
      providerCancellationPolicy: map['providerCancellationPolicy'] != null
          ? ProviderCancellationPolicy.fromMap(map['providerCancellationPolicy'])
          : ProviderCancellationPolicy.fromMap({}),
      updatedAt: map['updatedAt'] != null
          ? DateTime.tryParse(map['updatedAt'])
          : null,
    );
  }

  @override
  String toString() {
    return 'PaymentPolicy(currency: $currency, onlineFlow: $onlineFlow)';
  }
}
