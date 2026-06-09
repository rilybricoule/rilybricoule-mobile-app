import 'package:flutter/material.dart';
import 'package:rilybricoule_mobile_app/domain/entities/payment_method_entity.dart';
import 'package:rilybricoule_mobile_app/domain/repositories/payment_repository.dart';
import 'package:rilybricoule_mobile_app/features/payment/payment_service.dart';

/// ViewModel premium pour le paiement de réservation
/// 
/// Features premium:
/// - Affiche les vraies cartes sauvegardées de l'utilisateur
/// - Préautorisation (hold) avant le service
/// - Captures différées
/// - Historique des transactions
/// - Cashback/promos
class BookingPaymentViewModel extends ChangeNotifier {
  final PaymentRepository _paymentRepository;
  
  BookingPaymentViewModel({
    PaymentRepository? paymentRepository,
  }) : _paymentRepository = paymentRepository ?? PaymentService.createRepository();

  // ==================== État ====================
  
  /// Liste des méthodes de paiement de l'utilisateur
  List<PaymentMethod> _paymentMethods = [];
  
  /// Méthode sélectionnée pour ce paiement
  PaymentMethod? _selectedPaymentMethod;
  
  /// Code promo saisi
  String _promoCode = '';
  
  /// Code promo appliqué avec succès
  String? _appliedPromoCode;
  
  /// Montant de la réduction
  double _discount = 0;
  
  /// Statut de chargement
  bool _isLoading = false;
  
  /// Message d'erreur
  String? _errorMessage;
  
  /// Statut du paiement
  PaymentStatus _paymentStatus = PaymentStatus.idle;
  
  /// ID du paiement créé
  String? _paymentId;

  // ==================== Prix (mock pour démo) ====================
  
  final double _servicePrice = 250.0;
  final double _platformFee = 25.0;
  final double _insuranceFee = 15.0;

  // ==================== Getters ====================
  
  List<PaymentMethod> get paymentMethods => _paymentMethods;
  PaymentMethod? get selectedPaymentMethod => _selectedPaymentMethod;
  String get promoCode => _promoCode;
  String? get appliedPromoCode => _appliedPromoCode;
  double get discount => _discount;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  PaymentStatus get paymentStatus => _paymentStatus;
  String? get paymentId => _paymentId;
  
  double get servicePrice => _servicePrice;
  double get platformFee => _platformFee;
  double get insuranceFee => _insuranceFee;
  double get subtotal => _servicePrice + _platformFee + _insuranceFee;
  double get total => subtotal - _discount;
  
  bool get hasPaymentMethods => _paymentMethods.isNotEmpty;
  bool get hasSelectedMethod => _selectedPaymentMethod != null;
  bool get isPromoApplied => _appliedPromoCode != null;
  bool get canConfirm => hasSelectedMethod && !_isLoading;
  
  /// Cartes sauvegardées uniquement (exclut le cash)
  List<PaymentMethod> get savedCards => _paymentMethods.where((m) => m.isCard).toList();
  
  /// Méthode cash si disponible
  PaymentMethod? get cashMethod {
    try {
      return _paymentMethods.firstWhere((m) => m.isCash);
    } catch (e) {
      return null;
    }
  }

  // ==================== Actions ====================
  
  /// Charger les méthodes de paiement de l'utilisateur
  Future<void> loadPaymentMethods() async {
    _setLoading(true);
    _clearError();
    
    try {
      final methods = await _paymentRepository.getMyPaymentMethods();
      _paymentMethods = methods;
      
      // Sélectionner la méthode par défaut si disponible
      if (methods.isNotEmpty) {
        try {
          _selectedPaymentMethod = methods.firstWhere((m) => m.isDefault);
        } catch (e) {
          _selectedPaymentMethod = methods.first;
        }
      }
      
      notifyListeners();
    } catch (e) {
      _setError('Impossible de charger vos méthodes de paiement');
    } finally {
      _setLoading(false);
    }
  }
  
  /// Rafraîchir la liste des méthodes
  Future<void> refreshPaymentMethods() async {
    await loadPaymentMethods();
  }

  /// Sélectionner une méthode de paiement
  void selectPaymentMethod(PaymentMethod method) {
    _selectedPaymentMethod = method;
    notifyListeners();
  }
  
  /// Sélectionner le paiement en espèces
  void selectCash() {
    final cash = cashMethod ?? PaymentMethod.cash(id: 'cash_${DateTime.now().millisecondsSinceEpoch}');
    _selectedPaymentMethod = cash;
    notifyListeners();
  }

  /// Définir le code promo
  void setPromoCode(String code) {
    _promoCode = code.toUpperCase();
    notifyListeners();
  }

  /// Appliquer le code promo
  Future<bool> applyPromoCode() async {
    if (_promoCode.isEmpty) return false;
    
    _setLoading(true);
    
    // Simulation - en production, appeler l'API
    await Future.delayed(const Duration(milliseconds: 500));
    
    // Mock des codes promo
    final promos = {
      'RILY20': 20.0,
      'WELCOME30': 30.0,
      'CASHBACK10': 10.0,
      'PREMIUM50': 50.0,
    };
    
    final discount = promos[_promoCode];
    
    if (discount != null) {
      _appliedPromoCode = _promoCode;
      _discount = discount;
      _paymentStatus = PaymentStatus.promoApplied;
      _clearError();
      notifyListeners();
      _setLoading(false);
      return true;
    } else {
      _setError('Code promo invalide');
      _setLoading(false);
      return false;
    }
  }

  /// Retirer le code promo
  void removePromoCode() {
    _appliedPromoCode = null;
    _discount = 0;
    _promoCode = '';
    notifyListeners();
  }

  /// Confirmer le paiement avec préautorisation
  Future<bool> confirmPayment({String? bookingId}) async {
    if (_selectedPaymentMethod == null) {
      _setError('Veuillez sélectionner une méthode de paiement');
      return false;
    }

    _setLoading(true);
    _paymentStatus = PaymentStatus.processing;
    notifyListeners();

    try {
      // Simulation - en production, appeler l'API de préautorisation
      await Future.delayed(const Duration(seconds: 2));

      // Mock du résultat
      _paymentId = 'pay_${DateTime.now().millisecondsSinceEpoch}';
      _paymentStatus = PaymentStatus.preauthorized;
      _clearError();
      
      notifyListeners();
      _setLoading(false);
      return true;
    } catch (e) {
      _paymentStatus = PaymentStatus.error;
      _setError('Le paiement a échoué. Veuillez réessayer.');
      _setLoading(false);
      return false;
    }
  }

  /// Capturer le paiement après service terminé
  Future<bool> capturePayment() async {
    if (_paymentId == null || _paymentStatus != PaymentStatus.preauthorized) {
      _setError('Aucun paiement en attente de capture');
      return false;
    }

    _setLoading(true);
    _paymentStatus = PaymentStatus.capturing;
    notifyListeners();

    try {
      // Simulation - en production, appeler l'API de capture
      await Future.delayed(const Duration(seconds: 1));

      _paymentStatus = PaymentStatus.completed;
      _clearError();
      
      notifyListeners();
      _setLoading(false);
      return true;
    } catch (e) {
      _paymentStatus = PaymentStatus.error;
      _setError('La capture du paiement a échoué');
      _setLoading(false);
      return false;
    }
  }

  /// Annuler une préautorisation
  Future<bool> cancelPreauthorization() async {
    if (_paymentId == null || _paymentStatus != PaymentStatus.preauthorized) {
      return false;
    }

    _setLoading(true);

    try {
      // Simulation - en production, appeler l'API d'annulation
      await Future.delayed(const Duration(seconds: 1));

      _paymentStatus = PaymentStatus.cancelled;
      _clearError();
      
      notifyListeners();
      _setLoading(false);
      return true;
    } catch (e) {
      _setError('Impossible d\'annuler le paiement');
      _setLoading(false);
      return false;
    }
  }

  // ==================== Helpers privés ====================
  
  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _setError(String message) {
    _errorMessage = message;
    notifyListeners();
  }

  void _clearError() {
    _errorMessage = null;
  }
}

/// Statuts possibles du paiement
enum PaymentStatus {
  idle,
  promoApplied,
  processing,
  preauthorized,
  capturing,
  completed,
  error,
  cancelled,
}

/// Mock du PaymentRepository pour le développement
/// 
/// TODO: Remplacer par le vrai repository quand l'API est prête
