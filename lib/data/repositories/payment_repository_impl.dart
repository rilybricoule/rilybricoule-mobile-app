import 'dart:async';

import 'package:flutter/foundation.dart';

import '../../domain/entities/payment_method_entity.dart';
import '../../domain/entities/payment_policy.dart';
import '../../domain/entities/add_payment_method_request.dart';
import '../../domain/repositories/payment_repository.dart';
import '../datasources/payment_datasource.dart';

/// Implementation du PaymentRepository
/// 
/// Fait le lien entre la couche domain (use cases/UI) et la couche data (sources de données).
/// Gère également le caching et les notifications de changement.
///
/// Implémente le pattern Repository avec:
/// - Caching des méthodes de paiement
/// - Stream pour les mises à jour en temps réel
/// - Fallback sur données locales si nécessaire
class PaymentRepositoryImpl implements PaymentRepository {
  final PaymentDataSource _dataSource;

  // Stream controller pour notifier les listeners des changements
  final _paymentMethodsController = StreamController<List<PaymentMethod>>.broadcast();

  // Cache des méthodes de paiement
  List<PaymentMethod>? _cachedMethods;

  // Cache de la méthode par défaut
  PaymentMethod? _cachedDefaultMethod;

  PaymentRepositoryImpl({
    required PaymentDataSource dataSource,
  }) : _dataSource = dataSource;

  @override
  Stream<List<PaymentMethod>> get paymentMethodsStream => _paymentMethodsController.stream;

  @override
  PaymentMethod? get defaultMethod => _cachedDefaultMethod;

  @override
  bool get isCashEnabled => _dataSource.isCashEnabled;

  @override
  Future<List<PaymentMethod>> getMyPaymentMethods() async {
    try {
      final methods = await _dataSource.getMyPaymentMethods();
      _cachedMethods = methods;
      _updateDefaultMethod();
      _paymentMethodsController.add(methods);
      return methods;
    } catch (e) {
      debugPrint('PaymentRepositoryImpl: getMyPaymentMethods error - $e');
      // Retourner le cache si disponible
      if (_cachedMethods != null) {
        return _cachedMethods!;
      }
      rethrow;
    }
  }

  @override
  Future<PaymentMethod> addPaymentMethod(AddPaymentMethodRequest request) async {
    try {
      // Validation
      final validationError = request.validate();
      if (validationError != null) {
        throw Exception(validationError);
      }

      debugPrint('PaymentRepositoryImpl: addPaymentMethod - ${request.type.name}');

      final newMethod = await _dataSource.addPaymentMethod(request);

      // Rafraîchir le cache
      await getMyPaymentMethods();

      debugPrint('PaymentRepositoryImpl: Méthode ajoutée - ${newMethod.label}');
      return newMethod;
    } catch (e) {
      debugPrint('PaymentRepositoryImpl: addPaymentMethod error - $e');
      rethrow;
    }
  }

  @override
  Future<void> deletePaymentMethod(String id) async {
    try {
      debugPrint('PaymentRepositoryImpl: deletePaymentMethod - $id');

      // Vérifier qu'on ne supprime pas la dernière méthode en ligne si cash est désactivé
      final methods = _cachedMethods ?? await getMyPaymentMethods();
      final onlineMethods = methods.where((m) => m.type != PaymentMethodType.cash).toList();
      final targetMethod = methods.firstWhere((m) => m.id == id);

      if (targetMethod.type != PaymentMethodType.cash &&
          onlineMethods.length == 1 &&
          !isCashEnabled) {
        throw Exception(
          'Vous devez avoir au moins une méthode de paiement. '
          'Activez le paiement sur place ou ajoutez une autre carte.',
        );
      }

      await _dataSource.deletePaymentMethod(id);

      // Rafraîchir le cache
      await getMyPaymentMethods();

      debugPrint('PaymentRepositoryImpl: Méthode supprimée - $id');
    } catch (e) {
      debugPrint('PaymentRepositoryImpl: deletePaymentMethod error - $e');
      rethrow;
    }
  }

  @override
  Future<void> setDefaultMethod(String id) async {
    try {
      debugPrint('PaymentRepositoryImpl: setDefaultMethod - $id');

      await _dataSource.setDefaultMethod(id);

      // Rafraîchir le cache
      await getMyPaymentMethods();

      debugPrint('PaymentRepositoryImpl: Méthode par défaut définie - $id');
    } catch (e) {
      debugPrint('PaymentRepositoryImpl: setDefaultMethod error - $e');
      rethrow;
    }
  }

  @override
  Future<PaymentPolicy> getPaymentPolicy() async {
    try {
      final policy = await _dataSource.getPaymentPolicy();
      return policy;
    } catch (e) {
      debugPrint('PaymentRepositoryImpl: getPaymentPolicy error - $e');
      // Retourner la politique par défaut en cas d'erreur
      return PaymentPolicy.defaultPolicy();
    }
  }

  @override
  Future<void> setCashEnabled(bool enabled) async {
    try {
      debugPrint('PaymentRepositoryImpl: setCashEnabled - $enabled');

      // Vérifier qu'il reste au moins une méthode si on désactive le cash
      if (!enabled) {
        final methods = _cachedMethods ?? await getMyPaymentMethods();
        final onlineMethods = methods.where((m) => m.type != PaymentMethodType.cash).toList();

        if (onlineMethods.isEmpty) {
          throw Exception(
            'Vous devez avoir au moins une carte enregistrée '
            'pour désactiver le paiement sur place.',
          );
        }
      }

      await _dataSource.setCashEnabled(enabled);

      // Rafraîchir le cache
      await getMyPaymentMethods();

      debugPrint('PaymentRepositoryImpl: Cash ${enabled ? 'activé' : 'désactivé'}');
    } catch (e) {
      debugPrint('PaymentRepositoryImpl: setCashEnabled error - $e');
      rethrow;
    }
  }

  /// Mettre à jour la méthode par défaut en cache
  void _updateDefaultMethod() {
    if (_cachedMethods == null || _cachedMethods!.isEmpty) {
      _cachedDefaultMethod = null;
      return;
    }

    _cachedDefaultMethod = _cachedMethods!.firstWhere(
      (m) => m.isDefault,
      orElse: () => _cachedMethods!.first,
    );
  }

  /// Forcer le rafraîchissement depuis la source
  Future<void> refreshPaymentMethods() async {
    _cachedMethods = null;
    await getMyPaymentMethods();
  }

  /// Libérer les ressources
  void dispose() {
    _paymentMethodsController.close();
  }
}
