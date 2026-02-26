import '../models/reservation_model.dart';
import '../models/reservation_status.dart';

abstract class ReservationsRepository {
  Future<List<ReservationModel>> fetchReservations({ReservationStatus? status});
  Future<void> cancelReservation(String reservationId);
}

class MockReservationsRepository implements ReservationsRepository {
  // Mutable list of reservations to track state changes
  final List<ReservationModel> _reservations = [
    ReservationModel(
      id: '1',
      status: ReservationStatus.ongoing,
      title: 'Coiffure Homme & Barbe',
      providerName: 'Salon de Jean',
      providerSubtitle: 'Coiffure • Casablanca',
      coverImageUrl: 'https://images.unsplash.com/photo-1585747860715-2ba37e788b70?w=800',
      dateLabel: '15 Oct, 2023',
      timeLabel: '14:30',
      priceLabel: '450.00 MAD',
      canReview: false,
      carInfo: 'Renault Clio Blanche',
      expectedArrival: 'Arrivé',
      duration: '1h 30min',
    ),
    ReservationModel(
      id: '2',
      status: ReservationStatus.upcoming,
      title: 'Massage Suédois',
      providerName: 'Zen & Spa',
      providerSubtitle: 'Spa • Marrakech',
      coverImageUrl: 'https://images.unsplash.com/photo-1540555700478-4be289fbecef?w=800',
      dateLabel: '20 Oct, 2023',
      timeLabel: '10:00',
      priceLabel: '750.00 MAD',
      canReview: false,
      carInfo: 'Toyota Corolla Grise',
      expectedArrival: '10:00',
      duration: '2h 00min',
    ),
    ReservationModel(
      id: '3',
      status: ReservationStatus.completed,
      title: 'Manucure & Pose',
      providerName: 'Beauty Lab',
      providerSubtitle: 'Beauté • Rabat',
      coverImageUrl: 'https://images.unsplash.com/photo-1604654894610-df63bc536371?w=800',
      dateLabel: '05 Oct, 2023',
      timeLabel: '16:00',
      priceLabel: '350.00 MAD',
      canReview: true,
      carInfo: 'Peugeot 208 Noire',
      expectedArrival: 'Arrivé à 16:05',
      duration: '1h 15min',
    ),
    ReservationModel(
      id: '4',
      status: ReservationStatus.upcoming,
      title: 'Réparation Plomberie',
      providerName: 'Ahmed H.',
      providerSubtitle: 'Plomberie • Casablanca',
      coverImageUrl: 'https://images.unsplash.com/photo-1607472586893-edb57bdc0e39?w=800',
      dateLabel: '22 Oct, 2023',
      timeLabel: '09:00',
      priceLabel: '220 MAD',
      canReview: false,
      carInfo: 'Dacia Logan Blanche',
      expectedArrival: '09:00',
      duration: '45min',
    ),
    ReservationModel(
      id: '5',
      status: ReservationStatus.cancelled,
      title: 'Nettoyage Complet',
      providerName: 'Clean Pro',
      providerSubtitle: 'Nettoyage • Rabat',
      coverImageUrl: 'https://images.unsplash.com/photo-1581578731548-c64695cc6952?w=800',
      dateLabel: '10 Oct, 2023',
      timeLabel: '11:00',
      priceLabel: '150 MAD',
      canReview: false,
      carInfo: 'Hyundai i10 Rouge',
      expectedArrival: '11:00',
      duration: '2h 30min',
    ),
  ];

  @override
  Future<List<ReservationModel>> fetchReservations({ReservationStatus? status}) async {
    await Future.delayed(const Duration(milliseconds: 500));

    if (status == null) {
      return List.unmodifiable(_reservations);
    }

    return _reservations.where((r) => r.status == status).toList();
  }

  @override
  Future<void> cancelReservation(String reservationId) async {
    await Future.delayed(const Duration(milliseconds: 800));

    // Find the reservation and update its status to cancelled
    final index = _reservations.indexWhere((r) => r.id == reservationId);
    if (index != -1) {
      final reservation = _reservations[index];
      // Create a new instance with updated status
      _reservations[index] = ReservationModel(
        id: reservation.id,
        status: ReservationStatus.cancelled,
        title: reservation.title,
        providerName: reservation.providerName,
        providerSubtitle: reservation.providerSubtitle,
        coverImageUrl: reservation.coverImageUrl,
        dateLabel: reservation.dateLabel,
        timeLabel: reservation.timeLabel,
        priceLabel: reservation.priceLabel,
        canReview: false,
        carInfo: reservation.carInfo,
        expectedArrival: reservation.expectedArrival,
        duration: reservation.duration,
      );
    }
  }
}
