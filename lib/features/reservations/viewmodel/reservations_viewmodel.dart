import 'package:flutter/foundation.dart';
import '../data/mock_reservations_repository.dart';
import '../models/reservation_model.dart';
import '../models/reservation_status.dart';

class ReservationsViewModel extends ChangeNotifier {
  final ReservationsRepository _repository;

  ReservationsViewModel(this._repository);

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

  Future<void> loadReservations() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _allReservations = await _repository.fetchReservations();
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

  Future<void> refresh() async {
    await loadReservations();
  }

  Future<void> cancelReservation(String reservationId) async {
    try {
      await _repository.cancelReservation(reservationId);
      // Reload to reflect the updated status
      await loadReservations();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }
}
