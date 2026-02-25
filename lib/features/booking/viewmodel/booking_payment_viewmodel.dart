import 'package:flutter/material.dart';
import '../models/payment_method.dart';

class BookingPaymentViewModel extends ChangeNotifier {
  PaymentMethodType _selectedPaymentMethod = PaymentMethodType.card;
  String _promoCode = '';
  bool _isPromoApplied = false;
  double _discount = 0;
  bool _isLoading = false;

  final double _servicePrice = 250.0;
  final double _platformFee = 25.0;

  PaymentMethodType get selectedPaymentMethod => _selectedPaymentMethod;
  String get promoCode => _promoCode;
  bool get isPromoApplied => _isPromoApplied;
  double get discount => _discount;
  bool get isLoading => _isLoading;
  double get servicePrice => _servicePrice;
  double get platformFee => _platformFee;
  double get subtotal => _servicePrice + _platformFee;
  double get total => subtotal - _discount;

  void selectPaymentMethod(PaymentMethodType method) {
    _selectedPaymentMethod = method;
    notifyListeners();
  }

  void setPromoCode(String code) {
    _promoCode = code;
    notifyListeners();
  }

  bool applyPromoCode() {
    if (_promoCode.toUpperCase() == 'RILY20') {
      _isPromoApplied = true;
      _discount = 20.0;
      notifyListeners();
      return true;
    }
    return false;
  }

  void removePromoCode() {
    _isPromoApplied = false;
    _discount = 0;
    _promoCode = '';
    notifyListeners();
  }

  Future<bool> confirmPayment() async {
    _isLoading = true;
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 500));

    _isLoading = false;
    notifyListeners();

    return true;
  }
}
