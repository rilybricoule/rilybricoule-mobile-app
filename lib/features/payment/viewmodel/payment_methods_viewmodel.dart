import 'dart:async';

import 'package:flutter/foundation.dart';

import '../../../domain/entities/payment_method_entity.dart';
import '../../../domain/entities/payment_policy.dart';
import '../../../domain/repositories/payment_repository.dart';

/// États possibles de l'écran des méthodes de paiement
enum PaymentMethodsState {
  initial,
  loading,
  loaded,
  error,
  adding,
  deleting,
}

/// ViewModel pour l'écran des méthodes de paiement
/// 
/// Gère:
/// - Le chargement des méthodes de paiement
/// - L'activation/désactivation du paiement en espèces
/// - La suppression de méthodes
/// - La définition de la méthode par défaut
/// - L'accès à la politique de paiement
class PaymentMethodsViewModel extends ChangeNotifier {
  final PaymentRepository _paymentRepository;
  StreamSubscription<List<PaymentMethod>>? _paymentMethodsSubscription;

  // État
  PaymentMethodsState _state = PaymentMethodsState.initial;
  String? _errorMessage;
  List<PaymentMethod> _paymentMethods = [];
  PaymentPolicy? _paymentPolicy;
  bool _isCashEnabled = true;

  // Getters publics
  PaymentMethodsState get state => _state;
  String? get errorMessage => _errorMessage;
  List<PaymentMethod> get paymentMethods => _paymentMethods;
  PaymentPolicy? get paymentPolicy => _paymentPolicy;
  bool get isCashEnabled => _isCashEnabled;
  bool get isLoading => _state == PaymentMethodsState.loading;
  bool get isAdding => _state == PaymentMethodsState.adding;
  bool get isDeleting => _state == PaymentMethodsState.deleting;

  // Getters filtrés
  List<PaymentMethod> get onlineMethods => _paymentMethods
      .where((m) => m.type != PaymentMethodType.cash)
      .toList();

  List<PaymentMethod> get cardMethods => _paymentMethods
      .where((m) => m.type == PaymentMethodType.cmiCard || m.type == PaymentMethodType.stripe)
      .toList();

  PaymentMethod? get cashMethod => _paymentMethods
      .firstWhere(
        (m) => m.type == PaymentMethodType.cash,
        orElse: () => PaymentMethod.cash(id: 'temp'),
      );

  PaymentMethod? get defaultMethod => _paymentMethods
      .firstWhere(
        (m) => m.isDefault,
        orElse: () => _paymentMethods.isNotEmpty ? _paymentMethods.first : PaymentMethod.cash(id: 'temp'),
      );

  bool get hasOnlineMethods => onlineMethods.isNotEmpty;
  bool get hasCardMethods => cardMethods.isNotEmpty;
  bool get isEmpty => _paymentMethods.isEmpty || (!hasOnlineMethods && !isCashEnabled);

  PaymentMethodsViewModel({
    required PaymentRepository paymentRepository,
  }) : _paymentRepository = paymentRepository {
    _init();
  }

  void _init() {
    // S'abonner aux changements du repository
    _paymentMethodsSubscription = _paymentRepository.paymentMethodsStream.listen(
      (methods) {
        _paymentMethods = methods;
        _isCashEnabled = _paymentRepository.isCashEnabled;
        notifyListeners();
      },
    );
  }

  /// Charger les données initiales
  Future<void> loadData() async {
    _setState(PaymentMethodsState.loading);
    _errorMessage = null;

    try {
      // Charger les méthodes de paiement
      final methods = await _paymentRepository.getMyPaymentMethods();
      _paymentMethods = methods;
      _isCashEnabled = _paymentRepository.isCashEnabled;

      // Charger la politique de paiement
      _paymentPolicy = await _paymentRepository.getPaymentPolicy();

      _setState(PaymentMethodsState.loaded);
    } catch (e) {
      _errorMessage = 'Erreur lors du chargement: ${e.toString()}';
      _setState(PaymentMethodsState.error);
    }
  }

  /// Rafraîchir les données
  Future<void> refresh() async {
    await loadData();
  }

  /// Activer/désactiver le paiement en espèces
  Future<bool> toggleCash(bool enabled) async {
    try {
      await _paymentRepository.setCashEnabled(enabled);
      _isCashEnabled = enabled;
      
      // Rafraîchir la liste des méthodes
      await loadData();
      
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  /// Définir une méthode comme défaut
  Future<bool> setDefaultMethod(String id) async {
    try {
      await _paymentRepository.setDefaultMethod(id);
      
      // Mettre à jour localement pour réactivité immédiate
      _paymentMethods = _paymentMethods.map((m) {
        return m.copyWith(isDefault: m.id == id);
      }).toList();
      
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  /// Supprimer une méthode de paiement
  Future<bool> deleteMethod(String id) async {
    _setState(PaymentMethodsState.deleting);
    
    try {
      await _paymentRepository.deletePaymentMethod(id);
      _setState(PaymentMethodsState.loaded);
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _setState(PaymentMethodsState.error);
      return false;
    }
  }

  /// Vérifier si une méthode peut être supprimée
  bool canDeleteMethod(PaymentMethod method) {
    // On peut toujours supprimer une méthode non-défaut
    if (!method.isDefault) return true;
    
    // Si c'est la méthode par défaut et qu'il y a d'autres méthodes, on peut supprimer
    if (_paymentMethods.length > 1) return true;
    
    // Si c'est la dernière méthode en ligne et que le cash est désactivé, on ne peut pas
    if (method.type != PaymentMethodType.cash && !isCashEnabled) return false;
    
    return true;
  }

  /// Message d'erreur pour la suppression
  String? getDeleteErrorMessage(PaymentMethod method) {
    if (canDeleteMethod(method)) return null;
    return 'Ajoutez une autre carte ou activez le paiement sur place avant de supprimer.';
  }

  void _setState(PaymentMethodsState state) {
    _state = state;
    notifyListeners();
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  @override
  void dispose() {
    _paymentMethodsSubscription?.cancel();
    super.dispose();
  }
}
