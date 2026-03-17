import '../../domain/entities/payment_method_entity.dart';
import '../../domain/entities/payment_policy.dart';
import '../../domain/entities/add_payment_method_request.dart';

/// Interface DataSource pour le paiement
/// 
/// Définit les opérations de bas niveau pour accéder aux données de paiement.
/// Les implémentations peuvent être Mock, API REST, ou autre.
/// 
/// Implémentations:
/// - MockPaymentDataSource: données mockées en local
/// - ApiPaymentDataSource: appels API REST au backend
abstract class PaymentDataSource {
  /// Récupérer toutes les méthodes de paiement
  Future<List<PaymentMethod>> getMyPaymentMethods();

  /// Ajouter une méthode de paiement
  Future<PaymentMethod> addPaymentMethod(AddPaymentMethodRequest request);

  /// Supprimer une méthode de paiement
  Future<void> deletePaymentMethod(String id);

  /// Définir une méthode comme défaut
  Future<void> setDefaultMethod(String id);

  /// Récupérer la politique de paiement
  Future<PaymentPolicy> getPaymentPolicy();

  /// Activer/désactiver le paiement en espèces
  Future<void> setCashEnabled(bool enabled);

  /// Vérifier si le paiement en espèces est activé
  bool get isCashEnabled;

  /// Récupérer l'ID utilisateur courant
  String? get currentUserId;

  /// Vérifier si un utilisateur est authentifié
  bool get isAuthenticated;
}
