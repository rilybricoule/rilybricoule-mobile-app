import '../entities/payment_method_entity.dart';
import '../entities/payment_policy.dart';
import '../entities/add_payment_method_request.dart';

/// Interface du repository de paiement
/// 
/// Cette interface définit le contrat pour toutes les opérations
/// liées aux méthodes de paiement et à la politique de paiement.
/// 
/// L'UI ne connaît que cette interface - les implémentations
/// (mock, Firebase, API) sont dans la couche data.
/// 
/// Implémentations:
/// - PaymentRepositoryImpl (data layer)
/// - Utilise PaymentDataSource (mock ou API)
abstract class PaymentRepository {
  /// Récupérer toutes les méthodes de paiement de l'utilisateur
  /// 
  /// Retourne la liste des méthodes de paiement enregistrées
  Future<List<PaymentMethod>> getMyPaymentMethods();

  /// Ajouter une nouvelle méthode de paiement
  /// 
  /// [request] contient les informations de la méthode à ajouter
  /// Retourne la méthode de paiement créée avec son ID
  /// 
  /// TODO: À l'avenir avec CMI, cette méthode lancera un flux 3D Secure
  /// et retournera le résultat après authentification.
  Future<PaymentMethod> addPaymentMethod(AddPaymentMethodRequest request);

  /// Supprimer une méthode de paiement
  /// 
  /// [id] identifiant de la méthode à supprimer
  Future<void> deletePaymentMethod(String id);

  /// Définir une méthode comme défaut
  /// 
  /// [id] identifiant de la méthode par défaut
  Future<void> setDefaultMethod(String id);

  /// Récupérer la politique de paiement actuelle
  /// 
  /// Retourne les règles métier du système de paiement
  Future<PaymentPolicy> getPaymentPolicy();

  /// Activer/désactiver le paiement en espèces
  /// 
  /// [enabled] true pour activer, false pour désactiver
  Future<void> setCashEnabled(bool enabled);

  /// Stream des méthodes de paiement (pour mises à jour en temps réel)
  /// 
  /// Émet une nouvelle liste à chaque modification
  Stream<List<PaymentMethod>> get paymentMethodsStream;

  /// Méthode de paiement par défaut actuelle
  /// 
  /// Retourne null si aucune méthode par défaut
  PaymentMethod? get defaultMethod;

  /// Vérifier si le paiement en espèces est activé
  bool get isCashEnabled;
}
