import 'payment_method_entity.dart';

/// Request pour ajouter une méthode de paiement
/// 
/// Utilisé pour créer une nouvelle méthode de paiement.
/// Note: Dans le futur avec CMI, ce sera remplacé par un token
/// retourné après authentification 3D Secure.
class AddPaymentMethodRequest {
  final PaymentMethodType type;
  final String? cardNumber;
  final String? cardHolderName;
  final int? expMonth;
  final int? expYear;
  final String? cvv;
  final bool setAsDefault;

  const AddPaymentMethodRequest({
    required this.type,
    this.cardNumber,
    this.cardHolderName,
    this.expMonth,
    this.expYear,
    this.cvv,
    this.setAsDefault = false,
  });

  /// Valider la requête selon le type
  String? validate() {
    if (type == PaymentMethodType.cmiCard || type == PaymentMethodType.stripe) {
      if (cardNumber == null || cardNumber!.length < 15) {
        return 'Numéro de carte invalide';
      }
      if (cardHolderName == null || cardHolderName!.isEmpty) {
        return 'Nom du titulaire requis';
      }
      if (expMonth == null || expMonth! < 1 || expMonth! > 12) {
        return 'Mois d\'expiration invalide';
      }
      if (expYear == null || expYear! < DateTime.now().year) {
        return 'Année d\'expiration invalide';
      }
      if (cvv == null || cvv!.length < 3) {
        return 'CVV invalide';
      }
    }
    return null;
  }

  /// Détecter la marque de carte depuis le numéro
  CardBrand detectCardBrand() {
    if (cardNumber == null || cardNumber!.isEmpty) return CardBrand.unknown;
    
    final number = cardNumber!.replaceAll(' ', '');
    
    // Visa: commence par 4
    if (number.startsWith('4')) return CardBrand.visa;
    
    // Mastercard: commence par 51-55 ou 2221-2720
    if (RegExp(r'^(5[1-5]|2(2(2[1-9]|[3-9])|[3-6]|7([01]|20)))').hasMatch(number)) {
      return CardBrand.mastercard;
    }
    
    // CMI: cartes marocaines spécifiques (patterns communs)
    // Les cartes CMI commencent souvent par des ranges spécifiques
    if (RegExp(r'^(5374|5175|4582|4794|5133)').hasMatch(number)) {
      return CardBrand.cmi;
    }
    
    return CardBrand.unknown;
  }

  /// Masquer le numéro de carte (garder les 4 derniers)
  String get maskedCardNumber {
    if (cardNumber == null || cardNumber!.length < 4) return '';
    final last4 = cardNumber!.substring(cardNumber!.length - 4);
    return '•••• $last4';
  }

  Map<String, dynamic> toMap() {
    return {
      'type': type.name,
      'cardHolderName': cardHolderName,
      'expMonth': expMonth,
      'expYear': expYear,
      'setAsDefault': setAsDefault,
      // NE JAMAIS inclure le numéro de carte complet ou CVV
      'last4': cardNumber != null && cardNumber!.length >= 4
          ? cardNumber!.substring(cardNumber!.length - 4)
          : null,
    };
  }
}
