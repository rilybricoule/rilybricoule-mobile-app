import '../models/reservation_model.dart';
import '../models/reservation_status.dart';

abstract class ReservationsRepository {
  Future<List<ReservationModel>> fetchReservations({ReservationStatus? status, String? langCode});
  Future<void> cancelReservation(String reservationId);
}

class MockReservationsRepository implements ReservationsRepository {
  List<ReservationModel> _getReservations(String lang) {
    return [
      ReservationModel(
        id: '1',
        status: ReservationStatus.ongoing,
        title: lang == 'en' ? 'Men\'s Haircut & Beard' : lang == 'ar' ? 'حلاقة رجالي ولحية' : 'Coiffure Homme & Barbe',
        providerName: lang == 'en' ? 'John\'s Salon' : lang == 'ar' ? 'صالون جان' : 'Salon de Jean',
        providerSubtitle: lang == 'en' ? 'Hairdressing • Casablanca' : lang == 'ar' ? 'حلاقة • الدار البيضاء' : 'Coiffure • Casablanca',
        coverImageUrl: 'https://images.unsplash.com/photo-1585747860715-2ba37e788b70?w=800',
        dateLabel: lang == 'en' ? 'Oct 15, 2023' : lang == 'ar' ? '15 أكتوبر، 2023' : '15 Oct, 2023',
        timeLabel: '14:30',
        priceLabel: '450.00 MAD/hr',
        canReview: false,
        carInfo: lang == 'en' ? 'White Renault Clio' : lang == 'ar' ? 'رينو كليو بيضاء' : 'Renault Clio Blanche',
        expectedArrival: lang == 'en' ? 'Arrived' : lang == 'ar' ? 'وصل' : 'Arrivé',
        duration: lang == 'en' ? '1h 30min' : lang == 'ar' ? 'ساعة و 30 دقيقة' : '1h 30min',
      ),
      ReservationModel(
        id: '2',
        status: ReservationStatus.upcoming,
        title: lang == 'en' ? 'Swedish Massage' : lang == 'ar' ? 'مساج سويدي' : 'Massage Suédois',
        providerName: 'Zen & Spa',
        providerSubtitle: lang == 'en' ? 'Spa • Marrakech' : lang == 'ar' ? 'سبا • مراكش' : 'Spa • Marrakech',
        coverImageUrl: 'https://images.unsplash.com/photo-1540555700478-4be289fbecef?w=800',
        dateLabel: lang == 'en' ? 'Oct 20, 2023' : lang == 'ar' ? '20 أكتوبر، 2023' : '20 Oct, 2023',
        timeLabel: '10:00',
        priceLabel: '750.00 MAD/hr',
        canReview: false,
        carInfo: lang == 'en' ? 'Grey Toyota Corolla' : lang == 'ar' ? 'تويوتا كورولا رمادية' : 'Toyota Corolla Grise',
        expectedArrival: '10:00',
        duration: lang == 'en' ? '2h 00min' : lang == 'ar' ? 'ساعتان' : '2h 00min',
      ),
      ReservationModel(
        id: '3',
        status: ReservationStatus.completed,
        title: lang == 'en' ? 'Manicure & Pedicure' : lang == 'ar' ? 'مانيكير' : 'Manucure & Pose',
        providerName: 'Beauty Lab',
        providerSubtitle: lang == 'en' ? 'Beauty • Rabat' : lang == 'ar' ? 'تجميل • الرباط' : 'Beauté • Rabat',
        coverImageUrl: 'https://images.unsplash.com/photo-1604654894610-df63bc536371?w=800',
        dateLabel: lang == 'en' ? 'Oct 05, 2023' : lang == 'ar' ? '05 أكتوبر، 2023' : '05 Oct, 2023',
        timeLabel: '16:00',
        priceLabel: '350.00 MAD/hr',
        canReview: true,
        carInfo: lang == 'en' ? 'Black Peugeot 208' : lang == 'ar' ? 'بيجو 208 سوداء' : 'Peugeot 208 Noire',
        expectedArrival: lang == 'en' ? 'Arrived at 16:05' : lang == 'ar' ? 'وصل في 16:05' : 'Arrivé à 16:05',
        duration: lang == 'en' ? '1h 15min' : lang == 'ar' ? 'ساعة و 15 دقيقة' : '1h 15min',
      ),
      ReservationModel(
        id: '4',
        status: ReservationStatus.upcoming,
        title: lang == 'en' ? 'Plumbing Repair' : lang == 'ar' ? 'إصلاح سباكة' : 'Réparation Plomberie',
        providerName: lang == 'ar' ? 'أحمد هـ.' : 'Ahmed H.',
        providerSubtitle: lang == 'en' ? 'Plumbing • Casablanca' : lang == 'ar' ? 'سباكة • الدار البيضاء' : 'Plomberie • Casablanca',
        coverImageUrl: 'https://images.unsplash.com/photo-1607472586893-edb57bdc0e39?w=800',
        dateLabel: lang == 'en' ? 'Oct 22, 2023' : lang == 'ar' ? '22 أكتوبر، 2023' : '22 Oct, 2023',
        timeLabel: '09:00',
        priceLabel: '220 MAD/hr',
        canReview: false,
        carInfo: lang == 'en' ? 'White Dacia Logan' : lang == 'ar' ? 'داسيا لوغان بيضاء' : 'Dacia Logan Blanche',
        expectedArrival: '09:00',
        duration: lang == 'en' ? '45min' : lang == 'ar' ? '45 دقيقة' : '45min',
      ),
      ReservationModel(
        id: '5',
        status: ReservationStatus.cancelled,
        title: lang == 'en' ? 'Deep Cleaning' : lang == 'ar' ? 'تنظيف شامل' : 'Nettoyage Complet',
        providerName: 'Clean Pro',
        providerSubtitle: lang == 'en' ? 'Cleaning • Rabat' : lang == 'ar' ? 'تنظيف • الرباط' : 'Nettoyage • Rabat',
        coverImageUrl: 'https://images.unsplash.com/photo-1581578731548-c64695cc6952?w=800',
        dateLabel: lang == 'en' ? 'Oct 10, 2023' : lang == 'ar' ? '10 أكتوبر، 2023' : '10 Oct, 2023',
        timeLabel: '11:00',
        priceLabel: '150 MAD/hr',
        canReview: false,
        carInfo: lang == 'en' ? 'Red Hyundai i10' : lang == 'ar' ? 'هيونداي i10 حمراء' : 'Hyundai i10 Rouge',
        expectedArrival: '11:00',
        duration: lang == 'en' ? '2h 30min' : lang == 'ar' ? 'ساعتان و 30 دقيقة' : '2h 30min',
      ),
    ];
  }

  // Active reservations state that will get seeded on first fetch based on lang
  List<ReservationModel> _activeState = [];

  @override
  Future<List<ReservationModel>> fetchReservations({ReservationStatus? status, String? langCode}) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final lang = langCode ?? 'fr';

    // Populate state once
    if (_activeState.isEmpty) {
      _activeState = List.from(_getReservations(lang));
    } else {
      // Re-map translations carefully avoiding wiping out cancel states
      final mapped = _getReservations(lang);
      _activeState = _activeState.map((res) {
          final fresh = mapped.firstWhere((r) => r.id == res.id);
          return ReservationModel(
              id: res.id,
              status: res.status, // preserve mutation
              title: fresh.title,
              providerName: fresh.providerName,
              providerSubtitle: fresh.providerSubtitle,
              coverImageUrl: fresh.coverImageUrl,
              dateLabel: fresh.dateLabel,
              timeLabel: fresh.timeLabel,
              priceLabel: fresh.priceLabel,
              canReview: res.canReview,
              carInfo: fresh.carInfo,
              expectedArrival: fresh.expectedArrival,
              duration: fresh.duration,
          );
      }).toList();
    }

    if (status == null) {
      return List.unmodifiable(_activeState);
    }

    return _activeState.where((r) => r.status == status).toList();
  }

  @override
  Future<void> cancelReservation(String reservationId) async {
    await Future.delayed(const Duration(milliseconds: 800));

    // Find the reservation and update its status to cancelled
    final index = _activeState.indexWhere((r) => r.id == reservationId);
    if (index != -1) {
      final reservation = _activeState[index];
      // Create a new instance with updated status
      _activeState[index] = ReservationModel(
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
