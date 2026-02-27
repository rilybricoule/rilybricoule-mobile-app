import 'reservation_tracking_step.dart';
import 'tracking_status.dart';

class ReservationTracking {
  final String reservationId;
  final TrackingStatus status;
  final int? etaMinutes;
  final String headerTitle;
  final String headerSubtitle;
  final List<ReservationTrackingStep> steps;
  final String providerName;
  final String providerCategory;
  final String providerImageUrl;
  final double rating;
  final int reviewCount;
  final bool isOnline;
  final String locationLabel;
  final String? staticMapImageUrl;

  ReservationTracking({
    required this.reservationId,
    required this.status,
    this.etaMinutes,
    required this.headerTitle,
    required this.headerSubtitle,
    required this.steps,
    required this.providerName,
    required this.providerCategory,
    required this.providerImageUrl,
    required this.rating,
    required this.reviewCount,
    required this.isOnline,
    required this.locationLabel,
    this.staticMapImageUrl,
  });
}
