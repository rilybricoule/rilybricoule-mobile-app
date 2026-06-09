import 'package:flutter/material.dart';
import 'package:rilybricoule_mobile_app/l10n/app_localizations.dart';
import '../models/reservation_tracking.dart';
import '../models/tracking_status.dart';
import '../repository/reservations_repository.dart';

class ReservationDetailsViewModel extends ChangeNotifier {
  final ReservationsTrackingRepository _repository;
  final String reservationId;

  ReservationDetailsViewModel(this._repository, this.reservationId);

  bool _isLoading = false;
  String? _error;
  ReservationTracking? _tracking;

  bool get isLoading => _isLoading;
  String? get error => _error;
  ReservationTracking? get tracking => _tracking;

  // Status-based getters for UI logic
  bool get isCancelled => _tracking?.status == TrackingStatus.cancelled;
  bool get isCompleted => _tracking?.status == TrackingStatus.completed;
  bool get isEnRoute => _tracking?.status == TrackingStatus.enRoute;
  bool get isInProgress => _tracking?.status == TrackingStatus.inProgress;
  bool get isConfirmed => _tracking?.status == TrackingStatus.confirmed;

  /// ETA badge should only be shown when status is enRoute
  bool get shouldShowEtaBadge => isEnRoute && _tracking?.etaMinutes != null;

  /// Chat and Call buttons are enabled for confirmed, enRoute, and inProgress
  bool get canCommunicateWithProvider {
    if (_tracking == null) return false;
    return _tracking!.status == TrackingStatus.confirmed ||
           _tracking!.status == TrackingStatus.enRoute ||
           _tracking!.status == TrackingStatus.inProgress;
  }

  /// Cancel button is visible only for confirmed and enRoute
  /// Optionally can be shown for inProgress depending on business rules
  bool get canCancel {
    if (_tracking == null) return false;
    return _tracking!.status == TrackingStatus.confirmed ||
           _tracking!.status == TrackingStatus.enRoute;
    // Note: Can add inProgress here if business allows
  }

  /// Main action button text based on status
  String mainActionButtonText(BuildContext context) {
    if (_tracking == null) return AppLocalizations.of(context)!.discuss;
    if (isCompleted) return AppLocalizations.of(context)!.leaveReview;
    return AppLocalizations.of(context)!.chatWith(_tracking!.providerName.split(' ')[0]);
  }

  /// Main action button icon based on status
  IconData get mainActionButtonIcon {
    if (isCompleted) return Icons.star_outline;
    return Icons.chat_bubble_outline;
  }

  Future<void> loadTracking([BuildContext? context]) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final langCode = context != null ? Localizations.localeOf(context).languageCode : null;
      if (context == null) throw Exception('Context required for localization');
      _tracking = await _repository.fetchReservationTracking(context, reservationId, langCode);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> cancelReservation() async {
    try {
      await _repository.cancelReservation(reservationId);
      // Reload tracking to get updated status
      await loadTracking();
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Refresh tracking data
  Future<void> refresh() async {
    await loadTracking();
  }
}
