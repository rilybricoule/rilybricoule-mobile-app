import 'reservation_status.dart';

class ReservationModel {
  final String id;
  final ReservationStatus status;
  final String title;
  final String providerName;
  final String providerSubtitle;
  final String coverImageUrl;
  final String dateLabel;
  final String timeLabel;
  final String priceLabel;
  final bool canReview;
  final String? carInfo;
  final String? expectedArrival;
  final String? duration;

  ReservationModel({
    required this.id,
    required this.status,
    required this.title,
    required this.providerName,
    required this.providerSubtitle,
    required this.coverImageUrl,
    required this.dateLabel,
    required this.timeLabel,
    required this.priceLabel,
    required this.canReview,
    this.carInfo,
    this.expectedArrival,
    this.duration,
  });
}
