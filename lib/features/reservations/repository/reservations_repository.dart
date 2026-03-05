import 'package:flutter/material.dart';
import '../models/reservation_tracking.dart';
import '../models/reservation_tracking_step.dart';
import '../models/tracking_status.dart';
import '../data/mock_reservations_repository.dart';

/// Abstract interface for reservation tracking
abstract class ReservationsTrackingRepository {
  Future<ReservationTracking> fetchReservationTracking(String reservationId);
  Future<void> cancelReservation(String reservationId);
}

/// Builds the correct tracking steps based on the tracking status
class TrackingStepBuilder {
  static List<ReservationTrackingStep> buildSteps(TrackingStatus status) {
    switch (status) {
      case TrackingStatus.confirmed:
        return [
          ReservationTrackingStep(
            title: 'Confirmé',
            subtitle: 'Validé à 10:30',
            icon: Icons.check_circle,
            state: TrackingStepState.active,
            timeLabel: '10:30',
          ),
          ReservationTrackingStep(
            title: 'En route',
            subtitle: 'Le prestataire arrive chez vous',
            icon: Icons.directions_car,
            state: TrackingStepState.pending,
          ),
          ReservationTrackingStep(
            title: 'En cours',
            subtitle: 'Non démarré',
            icon: Icons.build,
            state: TrackingStepState.pending,
          ),
          ReservationTrackingStep(
            title: 'Terminé',
            subtitle: 'Non démarré',
            icon: Icons.done_all,
            state: TrackingStepState.pending,
          ),
        ];
      case TrackingStatus.enRoute:
        return [
          ReservationTrackingStep(
            title: 'Confirmé',
            subtitle: 'Validé à 10:30',
            icon: Icons.check_circle,
            state: TrackingStepState.done,
            timeLabel: '10:30',
          ),
          ReservationTrackingStep(
            title: 'En route',
            subtitle: 'Le prestataire arrive chez vous',
            icon: Icons.directions_car,
            state: TrackingStepState.active,
          ),
          ReservationTrackingStep(
            title: 'En cours',
            subtitle: 'Non démarré',
            icon: Icons.build,
            state: TrackingStepState.pending,
          ),
          ReservationTrackingStep(
            title: 'Terminé',
            subtitle: 'Non démarré',
            icon: Icons.done_all,
            state: TrackingStepState.pending,
          ),
        ];
      case TrackingStatus.inProgress:
        return [
          ReservationTrackingStep(
            title: 'Confirmé',
            subtitle: 'Validé à 10:30',
            icon: Icons.check_circle,
            state: TrackingStepState.done,
            timeLabel: '10:30',
          ),
          ReservationTrackingStep(
            title: 'En route',
            subtitle: 'Arrivé à 10:45',
            icon: Icons.directions_car,
            state: TrackingStepState.done,
          ),
          ReservationTrackingStep(
            title: 'En cours',
            subtitle: 'Intervention en cours',
            icon: Icons.build,
            state: TrackingStepState.active,
          ),
          ReservationTrackingStep(
            title: 'Terminé',
            subtitle: 'Non démarré',
            icon: Icons.done_all,
            state: TrackingStepState.pending,
          ),
        ];
      case TrackingStatus.completed:
        return [
          ReservationTrackingStep(
            title: 'Confirmé',
            subtitle: 'Validé à 10:30',
            icon: Icons.check_circle,
            state: TrackingStepState.done,
            timeLabel: '10:30',
          ),
          ReservationTrackingStep(
            title: 'En route',
            subtitle: 'Arrivé à 10:45',
            icon: Icons.directions_car,
            state: TrackingStepState.done,
          ),
          ReservationTrackingStep(
            title: 'En cours',
            subtitle: 'Terminé à 11:30',
            icon: Icons.build,
            state: TrackingStepState.done,
          ),
          ReservationTrackingStep(
            title: 'Terminé',
            subtitle: 'Prestation complète',
            icon: Icons.done_all,
            state: TrackingStepState.done,
          ),
        ];
      case TrackingStatus.cancelled:
        return [
          ReservationTrackingStep(
            title: 'Confirmé',
            subtitle: 'Validé à 10:30',
            icon: Icons.check_circle,
            state: TrackingStepState.done,
            timeLabel: '10:30',
          ),
          ReservationTrackingStep(
            title: 'En route',
            subtitle: 'Annulé',
            icon: Icons.directions_car,
            state: TrackingStepState.pending,
          ),
          ReservationTrackingStep(
            title: 'En cours',
            subtitle: 'Non démarré',
            icon: Icons.build,
            state: TrackingStepState.pending,
          ),
          ReservationTrackingStep(
            title: 'Terminé',
            subtitle: 'Non démarré',
            icon: Icons.done_all,
            state: TrackingStepState.pending,
          ),
        ];
    }
  }
}

/// Builds header messages based on tracking status
class HeaderMessageBuilder {
  static ({String title, String subtitle}) build(TrackingStatus status, String providerName) {
    switch (status) {
      case TrackingStatus.confirmed:
        return (
          title: 'Réservation confirmée',
          subtitle: 'Votre prestataire va bientôt commencer.',
        );
      case TrackingStatus.enRoute:
        return (
          title: 'Le prestataire est en route',
          subtitle: '$providerName a quitté son précédent rendez-vous.',
        );
      case TrackingStatus.inProgress:
        return (
          title: 'Intervention en cours',
          subtitle: 'Le prestataire travaille actuellement chez vous.',
        );
      case TrackingStatus.completed:
        return (
          title: 'Prestation terminée',
          subtitle: 'Merci ! Vous pouvez laisser un avis.',
        );
      case TrackingStatus.cancelled:
        return (
          title: 'Réservation annulée',
          subtitle: 'Cette réservation n\'est plus active.',
        );
    }
  }
}

/// Maps TrackingStatus to ReservationStatus
class StatusMapper {
  static TrackingStatus toTrackingStatus(reservationStatus) {
    switch (reservationStatus.toString()) {
      case 'ReservationStatus.upcoming':
        return TrackingStatus.confirmed;
      case 'ReservationStatus.ongoing':
        return TrackingStatus.inProgress;
      case 'ReservationStatus.completed':
        return TrackingStatus.completed;
      case 'ReservationStatus.cancelled':
        return TrackingStatus.cancelled;
      default:
        return TrackingStatus.confirmed;
    }
  }
}

class MockReservationsRepositoryTracking implements ReservationsTrackingRepository {
  // Shared reference to the list repository for cancellation updates
  final MockReservationsRepository? _listRepository;

  // Simulate different statuses for different reservation IDs
  final Map<String, TrackingStatus> _reservationStatuses = {
    '1': TrackingStatus.inProgress,
    '2': TrackingStatus.confirmed,
    '3': TrackingStatus.completed,
    '4': TrackingStatus.enRoute,
    '5': TrackingStatus.cancelled,
  };

  final Map<String, int?> _reservationEtas = {
    '1': null, // inProgress - no ETA
    '2': null, // confirmed - no ETA
    '3': null, // completed - no ETA
    '4': 12,   // enRoute - has ETA
    '5': null, // cancelled - no ETA
  };

  MockReservationsRepositoryTracking({MockReservationsRepository? listRepository})
      : _listRepository = listRepository;

  @override
  Future<ReservationTracking> fetchReservationTracking(String reservationId) async {
    await Future.delayed(const Duration(milliseconds: 500));

    final status = _reservationStatuses[reservationId] ?? TrackingStatus.enRoute;
    final etaMinutes = _reservationEtas[reservationId];
    final providerName = 'Ahmed El Mansouri';
    final providerId = '1'; // Mock: All reservations use provider '1' for testing

    final headerMessage = HeaderMessageBuilder.build(status, providerName);
    final steps = TrackingStepBuilder.buildSteps(status);

    return ReservationTracking(
      reservationId: reservationId,
      providerId: providerId,
      status: status,
      etaMinutes: etaMinutes,
      headerTitle: headerMessage.title,
      headerSubtitle: headerMessage.subtitle,
      steps: steps,
      providerName: providerName,
      providerCategory: 'Plombier Expert',
      providerImageUrl: 'https://images.unsplash.com/photo-1560250097-0b93528c311a?w=200',
      rating: 4.9,
      reviewCount: 128,
      isOnline: status != TrackingStatus.cancelled && status != TrackingStatus.completed,
      locationLabel: 'Casablanca',
    );
  }

  @override
  Future<void> cancelReservation(String reservationId) async {
    await Future.delayed(const Duration(milliseconds: 800));
    
    // Update the status in this repository
    _reservationStatuses[reservationId] = TrackingStatus.cancelled;
    _reservationEtas[reservationId] = null;
    
    // Also update the list repository to move the reservation to cancelled tab
    if (_listRepository != null) {
      await _listRepository!.cancelReservation(reservationId);
    }
  }
}
