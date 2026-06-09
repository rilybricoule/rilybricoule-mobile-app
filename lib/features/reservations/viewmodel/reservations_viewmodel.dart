import 'package:flutter/material.dart';
import '../data/mock_reservations_repository.dart';
import '../models/reservation_model.dart';
import '../models/reservation_status.dart';

class ReservationsViewModel extends ChangeNotifier {
  final ReservationsRepository _repository;
  bool _disposed = false;

  ReservationsViewModel(this._repository);

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }

  @override
  void notifyListeners() {
    if (!_disposed) {
      super.notifyListeners();
    }
  }

  bool _isLoading = false;
  String? _error;
  List<ReservationModel> _allReservations = [];
  ReservationStatus _selectedStatus = ReservationStatus.upcoming;

  bool get isLoading => _isLoading;
  String? get error => _error;
  ReservationStatus get selectedStatus => _selectedStatus;

  List<ReservationModel> get filteredReservations {
    return _allReservations.where((r) => r.status == _selectedStatus).toList();
  }

  Future<void> loadReservations([BuildContext? context]) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final String? langCode = context != null ? Localizations.localeOf(context).languageCode : null;
      _allReservations = await _repository.fetchReservations(langCode: langCode);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  void selectTab(ReservationStatus status) {
    _selectedStatus = status;
    notifyListeners();
  }

  Future<void> refresh([BuildContext? context]) async {
    await loadReservations(context);
  }

  Future<void> cancelReservation(String reservationId, [BuildContext? context]) async {
    try {
      await _repository.cancelReservation(reservationId);
      // Reload to reflect the updated status
      await loadReservations(context);
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }
}
