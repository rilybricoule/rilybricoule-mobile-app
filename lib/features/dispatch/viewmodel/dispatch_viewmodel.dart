import 'dart:async';
import 'package:flutter/material.dart';
import '../domain/dispatch_repository.dart';
import '../domain/models/dispatch_request.dart';
import '../domain/models/provider_offer.dart';

/// ViewModel managing the entire dispatch flow.
class DispatchViewModel extends ChangeNotifier {
  final DispatchRepository _repository;

  DispatchViewModel(this._repository);

  // ─── State ───
  DispatchFlowStatus _flowStatus = DispatchFlowStatus.idle;
  DispatchFlowStatus get flowStatus => _flowStatus;

  DispatchRequest? _currentRequest;
  DispatchRequest? get currentRequest => _currentRequest;

  ProviderOffer? _matchedOffer;
  ProviderOffer? get matchedOffer => _matchedOffer;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  // ─── Form fields ───
  String? _selectedCategoryId;
  String? get selectedCategoryId => _selectedCategoryId;

  String? _selectedCategoryName;
  String? get selectedCategoryName => _selectedCategoryName;

  String? _subCategoryId;
  String? get subCategoryId => _subCategoryId;

  String _address = '';
  String get address => _address;

  String _city = 'Casablanca';
  String get city => _city;

  String _phone = '';
  String get phone => _phone;

  String _note = '';
  String get note => _note;

  bool _isUrgent = true;
  bool get isUrgent => _isUrgent;

  DateTime? _scheduledAt;
  DateTime? get scheduledAt => _scheduledAt;

  // ─── Searching state ───
  int _elapsedSeconds = 0;
  int get elapsedSeconds => _elapsedSeconds;

  int _maxWaitSeconds = 120;
  int get maxWaitSeconds => _maxWaitSeconds;

  Timer? _countdownTimer;

  // ─── Session blocked providers ───
  final Set<String> _blockedProviderIds = {};
  Set<String> get blockedProviderIds => _blockedProviderIds;

  // ─── Categories ───
  List<Map<String, dynamic>> getCategories(String langCode) {
    return _repository.getCategories(langCode);
  }

  // ─── Form setters ───
  void selectCategory(String categoryId, String categoryName) {
    _selectedCategoryId = categoryId;
    _selectedCategoryName = categoryName;
    notifyListeners();
  }

  void setAddress(String address) {
    _address = address;
    notifyListeners();
  }

  void setCity(String city) {
    _city = city;
    notifyListeners();
  }

  void setPhone(String phone) {
    _phone = phone;
    notifyListeners();
  }

  void setNote(String note) {
    _note = note;
    notifyListeners();
  }

  void setUrgent(bool urgent) {
    _isUrgent = urgent;
    if (urgent) _scheduledAt = null;
    notifyListeners();
  }

  void setScheduledAt(DateTime? dateTime) {
    _scheduledAt = dateTime;
    if (dateTime != null) _isUrgent = false;
    notifyListeners();
  }

  // ─── Form validation ───
  bool get isFormValid {
    return _selectedCategoryId != null &&
        _address.isNotEmpty &&
        _phone.isNotEmpty &&
        _phone.length >= 8;
  }

  String? validateForm() {
    if (_selectedCategoryId == null) return 'Veuillez sélectionner une catégorie';
    if (_address.isEmpty) return 'L\'adresse est obligatoire';
    if (_phone.isEmpty) return 'Le téléphone est obligatoire';
    if (_phone.length < 8) return 'Numéro de téléphone invalide';
    return null;
  }

  // ─── Core actions ───

  /// Submit the dispatch request and start searching.
  Future<void> submitRequest() async {
    final validationError = validateForm();
    if (validationError != null) {
      _errorMessage = validationError;
      notifyListeners();
      return;
    }

    _isLoading = true;
    _errorMessage = null;
    _flowStatus = DispatchFlowStatus.searching;
    _elapsedSeconds = 0;
    notifyListeners();

    try {
      final now = DateTime.now();
      final request = DispatchRequest(
        id: 'dispatch_${now.millisecondsSinceEpoch}',
        clientId: 'current_user',
        categoryId: _selectedCategoryId!,
        subCategoryId: _subCategoryId,
        address: DispatchAddress(
          city: _city,
          street: _address,
        ),
        phone: _phone,
        note: _note.isNotEmpty ? _note : null,
        createdAt: now,
        status: DispatchRequestStatus.searching,
        expiresAt: now.add(Duration(seconds: _maxWaitSeconds)),
        isUrgent: _isUrgent,
        scheduledAt: _scheduledAt,
      );

      _currentRequest = await _repository.createRequest(request);
      _isLoading = false;
      notifyListeners();

      // Start countdown timer
      _startCountdown();

      // Wait for first acceptance (async, runs in background)
      _waitForMatch();
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'Erreur lors de l\'envoi de la demande';
      _flowStatus = DispatchFlowStatus.idle;
      notifyListeners();
    }
  }

  /// Cancel the current dispatch request.
  Future<void> cancelRequest() async {
    if (_currentRequest == null) return;

    _countdownTimer?.cancel();
    try {
      await _repository.cancelRequest(_currentRequest!.id);
    } catch (_) {}

    _flowStatus = DispatchFlowStatus.cancelled;
    notifyListeners();

    // Reset after a short delay
    Future.delayed(const Duration(milliseconds: 500), () {
      resetFlow();
    });
  }

  /// Accept the matched provider and navigate to payment.
  Future<void> acceptMatch() async {
    if (_currentRequest == null || _matchedOffer == null) return;

    _isLoading = true;
    notifyListeners();

    try {
      await _repository.confirmProvider(
        _currentRequest!.id,
        _matchedOffer!.providerId,
      );
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'Erreur de confirmation';
      notifyListeners();
    }
  }

  /// Relaunch dispatch: block current provider, create new request.
  Future<void> relaunchRequest() async {
    if (_matchedOffer != null) {
      _blockedProviderIds.add(_matchedOffer!.providerId);
    }

    _matchedOffer = null;
    _flowStatus = DispatchFlowStatus.searching;
    _elapsedSeconds = 0;
    _errorMessage = null;
    notifyListeners();

    // Create a new request
    final now = DateTime.now();
    final request = DispatchRequest(
      id: 'dispatch_${now.millisecondsSinceEpoch}',
      clientId: 'current_user',
      categoryId: _selectedCategoryId!,
      subCategoryId: _subCategoryId,
      address: DispatchAddress(city: _city, street: _address),
      phone: _phone,
      note: _note.isNotEmpty ? _note : null,
      createdAt: now,
      status: DispatchRequestStatus.searching,
      expiresAt: now.add(Duration(seconds: _maxWaitSeconds)),
      isUrgent: _isUrgent,
      scheduledAt: _scheduledAt,
    );

    _currentRequest = await _repository.createRequest(request);
    notifyListeners();

    _startCountdown();
    _waitForMatch();
  }

  /// Mark the request as paid after payment completes.
  Future<void> markPaid() async {
    if (_currentRequest == null) return;
    await _repository.markPaid(_currentRequest!.id);
    _flowStatus = DispatchFlowStatus.paid;
    notifyListeners();
  }

  /// Reset the entire flow.
  void resetFlow() {
    _countdownTimer?.cancel();
    _flowStatus = DispatchFlowStatus.idle;
    _currentRequest = null;
    _matchedOffer = null;
    _errorMessage = null;
    _isLoading = false;
    _elapsedSeconds = 0;
    _selectedCategoryId = null;
    _selectedCategoryName = null;
    _address = '';
    _phone = '';
    _note = '';
    _isUrgent = true;
    _scheduledAt = null;
    _blockedProviderIds.clear();
    notifyListeners();
  }

  // ─── Internal ───

  void _startCountdown() {
    _countdownTimer?.cancel();
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _elapsedSeconds++;
      notifyListeners();

      if (_elapsedSeconds >= _maxWaitSeconds) {
        timer.cancel();
        if (_flowStatus == DispatchFlowStatus.searching) {
          _flowStatus = DispatchFlowStatus.expired;
          notifyListeners();
        }
      }
    });
  }

  Future<void> _waitForMatch() async {
    if (_currentRequest == null) return;

    final offer = await _repository.waitForFirstAcceptance(
      _currentRequest!.id,
      blockedProviderIds: _blockedProviderIds,
    );

    // Check if cancelled/expired during wait
    if (_flowStatus != DispatchFlowStatus.searching) return;

    _countdownTimer?.cancel();

    if (offer != null) {
      _matchedOffer = offer;
      _flowStatus = DispatchFlowStatus.matched;
    } else {
      _flowStatus = DispatchFlowStatus.expired;
    }
    notifyListeners();
  }

  @override
  void dispose() {
    _countdownTimer?.cancel();
    super.dispose();
  }
}

/// Status of the dispatch flow.
enum DispatchFlowStatus {
  idle,
  searching,
  matched,
  expired,
  cancelled,
  paid,
}
