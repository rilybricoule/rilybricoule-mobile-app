import 'dart:async';
import 'dart:math';

import 'package:flutter/foundation.dart';

import '../../domain/entities/payment_method_entity.dart';
import '../../domain/entities/payment_policy.dart';
import '../../domain/entities/add_payment_method_request.dart';
import 'payment_datasource.dart';

/// Implementation Mock du PaymentDataSource
/// 
/// Simule un backend avec des données en mémoire.
/// Utilisé pour le développement et les tests jusqu'à l'intégration CMI.
/// 
/// TODO: Remplacer par ApiPaymentDataSource quand le backend CMI sera prêt (Avril 2025)
class MockPaymentDataSource implements PaymentDataSource {
  // Simuler un utilisateur connecté
  String? _currentUserId = 'mock_user_123';

  // Stockage en mémoire des méthodes de paiement par utilisateur
  final Map<String, List<PaymentMethod>> _userPaymentMethods = {};

  // Statut du paiement en espèces par utilisateur
  final Map<String, bool> _cashEnabledStatus = {};

  // Stream controller pour notifier les changements
  final _paymentMethodsController = StreamController<List<PaymentMethod>>.broadcast();

  // Politique de paiement (partagée entre tous les utilisateurs)
  final PaymentPolicy _paymentPolicy = PaymentPolicy.defaultPolicy();

  // Simuler un délai réseau
  Future<void> _simulateNetworkDelay() async {
    await Future.delayed(const Duration(milliseconds: 300));
  }

  // Générer un ID unique
  String _generateId() {
    return 'pm_${DateTime.now().millisecondsSinceEpoch}_${Random().nextInt(10000)}';
  }

  @override
  String? get currentUserId => _currentUserId;

  @override
  bool get isAuthenticated => _currentUserId != null;

  @override
  bool get isCashEnabled => _cashEnabledStatus[_currentUserId] ?? true;

  // Helper pour obtenir l'ID utilisateur non-null ou lancer une exception
  String _getUserIdOrThrow() {
    final userId = _currentUserId;
    if (userId == null) {
      throw Exception('Utilisateur non authentifié');
    }
    return userId;
  }

  @override
  Future<List<PaymentMethod>> getMyPaymentMethods() async {
    await _simulateNetworkDelay();

    final userId = _getUserIdOrThrow();

    // Retourner les méthodes de l'utilisateur ou une liste vide
    final methods = _userPaymentMethods[userId] ?? [];

    // Ajouter automatiquement la méthode cash si activée
    if (isCashEnabled && !methods.any((m) => m.type == PaymentMethodType.cash)) {
      final cashMethod = PaymentMethod.cash(
        id: 'cash_default',
        isDefault: methods.isEmpty,
        isEnabled: true,
      );
      final updatedMethods = [...methods, cashMethod];
      _userPaymentMethods[userId] = updatedMethods;
      _paymentMethodsController.add(updatedMethods);
      return updatedMethods;
    }

    debugPrint('MockPaymentDataSource: ${methods.length} méthodes trouvées');
    return methods;
  }

  @override
  Future<PaymentMethod> addPaymentMethod(AddPaymentMethodRequest request) async {
    await _simulateNetworkDelay();

    final userId = _getUserIdOrThrow();

    // Valider la requête
    final validationError = request.validate();
    if (validationError != null) {
      throw Exception(validationError);
    }

    // Créer la nouvelle méthode
    final id = _generateId();
    final methods = _userPaymentMethods[userId] ?? [];

    PaymentMethod newMethod;

    if (request.type == PaymentMethodType.cmiCard || request.type == PaymentMethodType.stripe) {
      // Détecter la marque de carte
      final brand = request.detectCardBrand();

      newMethod = PaymentMethod.cmiCard(
        id: id,
        last4: request.cardNumber!.substring(request.cardNumber!.length - 4),
        expMonth: request.expMonth!,
        expYear: request.expYear!,
        brand: brand,
        cardHolderName: request.cardHolderName,
        isDefault: request.setAsDefault || methods.isEmpty,
        createdAt: DateTime.now(),
      );
    } else if (request.type == PaymentMethodType.cash) {
      newMethod = PaymentMethod.cash(
        id: id,
        isDefault: request.setAsDefault || methods.isEmpty,
        isEnabled: true,
      );
    } else {
      throw Exception('Type de paiement non supporté: ${request.type}');
    }

    // Si on définit cette méthode comme défaut, retirer le flag des autres
    List<PaymentMethod> updatedMethods;
    if (newMethod.isDefault) {
      updatedMethods = methods.map((m) => m.copyWith(isDefault: false)).toList();
    } else {
      updatedMethods = List.from(methods);
    }

    updatedMethods.add(newMethod);
    _userPaymentMethods[userId] = updatedMethods;

    // Notifier les listeners
    _paymentMethodsController.add(updatedMethods);

    debugPrint('MockPaymentDataSource: Méthode ajoutée - ${newMethod.label}');
    return newMethod;
  }

  @override
  Future<void> deletePaymentMethod(String id) async {
    await _simulateNetworkDelay();

    final userId = _getUserIdOrThrow();

    final methods = _userPaymentMethods[userId] ?? [];
    final methodToDelete = methods.firstWhere(
      (m) => m.id == id,
      orElse: () => throw Exception('Méthode de paiement non trouvée'),
    );

    // Ne pas supprimer si c'était la méthode par défaut et qu'il en reste d'autres
    final updatedMethods = methods.where((m) => m.id != id).toList();

    if (methodToDelete.isDefault && updatedMethods.isNotEmpty) {
      // Définir la première méthode restante comme défaut
      updatedMethods[0] = updatedMethods[0].copyWith(isDefault: true);
    }

    _userPaymentMethods[userId] = updatedMethods;
    _paymentMethodsController.add(updatedMethods);

    debugPrint('MockPaymentDataSource: Méthode supprimée - $id');
  }

  @override
  Future<void> setDefaultMethod(String id) async {
    await _simulateNetworkDelay();

    final userId = _getUserIdOrThrow();

    final methods = _userPaymentMethods[userId] ?? [];

    // Vérifier que la méthode existe
    if (!methods.any((m) => m.id == id)) {
      throw Exception('Méthode de paiement non trouvée');
    }

    // Mettre à jour tous les flags isDefault
    final updatedMethods = methods.map((m) {
      return m.copyWith(isDefault: m.id == id);
    }).toList();

    _userPaymentMethods[userId] = updatedMethods;
    _paymentMethodsController.add(updatedMethods);

    debugPrint('MockPaymentDataSource: Méthode par défaut définie - $id');
  }

  @override
  Future<PaymentPolicy> getPaymentPolicy() async {
    await _simulateNetworkDelay();
    return _paymentPolicy;
  }

  @override
  Future<void> setCashEnabled(bool enabled) async {
    await _simulateNetworkDelay();

    final userId = _getUserIdOrThrow();

    _cashEnabledStatus[userId] = enabled;

    // Mettre à jour la méthode cash dans la liste
    final methods = _userPaymentMethods[userId] ?? [];
    final hasCashMethod = methods.any((m) => m.type == PaymentMethodType.cash);

    if (enabled && !hasCashMethod) {
      // Ajouter la méthode cash
      final cashMethod = PaymentMethod.cash(
        id: 'cash_$userId',
        isDefault: methods.isEmpty,
        isEnabled: true,
      );
      final updatedMethods = [...methods, cashMethod];
      _userPaymentMethods[userId] = updatedMethods;
      _paymentMethodsController.add(updatedMethods);
    } else if (!enabled && hasCashMethod) {
      // Retirer la méthode cash
      final updatedMethods = methods.where((m) => m.type != PaymentMethodType.cash).toList();
      _userPaymentMethods[userId] = updatedMethods;
      _paymentMethodsController.add(updatedMethods);
    }

    debugPrint('MockPaymentDataSource: Cash ${enabled ? 'activé' : 'désactivé'}');
  }

  /// Stream des méthodes de paiement
  Stream<List<PaymentMethod>> get paymentMethodsStream => _paymentMethodsController.stream;

  /// Méthode pour les tests: injecter des données mockées
  void injectMockData(String userId, List<PaymentMethod> methods) {
    _userPaymentMethods[userId] = methods;
    _currentUserId = userId;
  }

  /// Méthode pour les tests: réinitialiser
  void reset() {
    _userPaymentMethods.clear();
    _cashEnabledStatus.clear();
    _currentUserId = 'mock_user_123';
  }

  /// Libérer les ressources
  void dispose() {
    _paymentMethodsController.close();
  }
}
