import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/app_colors.dart';
import '../models/reservation_model.dart';
import '../models/reservation_status.dart';
import '../../../l10n/app_localizations.dart';

class ReservationCard extends StatelessWidget {
  final ReservationModel reservation;
  final VoidCallback onViewDetails;
  final VoidCallback? onLeaveReview;
  final VoidCallback? onViewInvoice;

  const ReservationCard({
    super.key,
    required this.reservation,
    required this.onViewDetails,
    this.onLeaveReview,
    this.onViewInvoice,
  });

  Color _getStatusColor() {
    switch (reservation.status) {
      case ReservationStatus.ongoing:
        return AppColors.success;
      case ReservationStatus.upcoming:
        return AppColors.mainAppPrimary;
      case ReservationStatus.completed:
        return Colors.grey;
      case ReservationStatus.cancelled:
        return AppColors.error;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[200]!),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildCoverImage(context),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        reservation.title,
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                    Text(
                      reservation.priceLabel,
                      textDirection: TextDirection.ltr,
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.mainAppPrimary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.storefront, size: 16, color: Colors.grey[600]),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        '${reservation.providerName} • ${reservation.providerSubtitle}',
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          color: AppColors.textSecondary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Icon(Icons.calendar_today, size: 16, color: AppColors.mainAppPrimary),
                    const SizedBox(width: 6),
                    Text(
                      reservation.dateLabel,
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Icon(Icons.access_time, size: 16, color: AppColors.mainAppPrimary),
                    const SizedBox(width: 6),
                    Text(
                      reservation.timeLabel,
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
                if (reservation.carInfo != null || reservation.expectedArrival != null || reservation.duration != null)
                  const SizedBox(height: 12),
                if (reservation.carInfo != null || reservation.expectedArrival != null || reservation.duration != null)
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.mainAppPrimary.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: AppColors.mainAppPrimary.withOpacity(0.1),
                      ),
                    ),
                    child: Column(
                      children: [
                        if (reservation.carInfo != null)
                          Row(
                            children: [
                              Icon(Icons.directions_car, size: 16, color: AppColors.mainAppPrimary),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  reservation.carInfo!,
                                  style: GoogleFonts.poppins(
                                    fontSize: 13,
                                    color: AppColors.textPrimary,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        if (reservation.carInfo != null && (reservation.expectedArrival != null || reservation.duration != null))
                          const SizedBox(height: 8),
                        if (reservation.expectedArrival != null || reservation.duration != null)
                          Row(
                            children: [
                              if (reservation.expectedArrival != null)
                                Icon(Icons.schedule, size: 16, color: AppColors.mainAppPrimary),
                              if (reservation.expectedArrival != null)
                                const SizedBox(width: 8),
                              if (reservation.expectedArrival != null)
                                Expanded(
                                  child: Text(
                                    '${AppLocalizations.of(context)!.labelArrival}: ${reservation.expectedArrival}',
                                    style: GoogleFonts.poppins(
                                      fontSize: 13,
                                      color: AppColors.textPrimary,
                                    ),
                                  ),
                                ),
                              if (reservation.expectedArrival != null && reservation.duration != null)
                                const SizedBox(width: 12),
                              if (reservation.duration != null)
                                Icon(Icons.timer_outlined, size: 16, color: AppColors.mainAppPrimary),
                              if (reservation.duration != null)
                                const SizedBox(width: 8),
                              if (reservation.duration != null)
                                Text(
                                  reservation.duration!,
                                  style: GoogleFonts.poppins(
                                    fontSize: 13,
                                    color: AppColors.textPrimary,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                            ],
                          ),
                      ],
                    ),
                  ),
                const SizedBox(height: 16),
                _buildActionButtons(context),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCoverImage(BuildContext context) {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
          child: Image.network(
            reservation.coverImageUrl,
            height: 180,
            width: double.infinity,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                height: 180,
                color: Colors.grey[300],
                child: const Icon(Icons.image, size: 48, color: Colors.grey),
              );
            },
          ),
        ),
        Positioned(
          top: 12,
          left: 12,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: _getStatusColor(),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              reservation.status.getLocalizedLabel(context),
              style: GoogleFonts.poppins(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: Colors.white,
                letterSpacing: 0.5,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    // For completed reservations with review available
    if (reservation.canReview && onLeaveReview != null) {
      return Column(
        children: [
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: onLeaveReview,
                  icon: const Icon(Icons.star_outline, size: 18),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.mainAppPrimary,
                    side: const BorderSide(color: AppColors.mainAppPrimary),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  label: Text(
                    l10n.btnLeaveReview,
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              if (onViewInvoice != null)
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: onViewInvoice,
                    icon: const Icon(Icons.receipt_outlined, size: 18),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.textSecondary,
                      side: BorderSide(color: Colors.grey[300]!),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    label: Text(
                      l10n.btnInvoice,
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 8),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: onViewDetails,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.mainAppPrimary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
              child: Text(
                l10n.btnViewDetails,
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      );
    }

    // For completed reservations without review (already reviewed)
    if (reservation.status == ReservationStatus.completed && onViewInvoice != null) {
      return Column(
        children: [
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: onViewDetails,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.mainAppPrimary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    l10n.btnViewDetails,
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.mainAppPrimary, width: 2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: IconButton(
                  onPressed: onViewInvoice,
                  icon: const Icon(Icons.receipt_outlined, color: AppColors.mainAppPrimary),
                  constraints: const BoxConstraints(
                    minWidth: 44,
                    minHeight: 44,
                  ),
                ),
              ),
            ],
          ),
        ],
      );
    }

    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onViewDetails,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.mainAppPrimary,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 0,
        ),
        child: Text(
          l10n.btnViewDetails,
          style: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
