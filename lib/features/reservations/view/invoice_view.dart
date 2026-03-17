import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rilybricoule_mobile_app/l10n/app_localizations.dart';
import '../../../core/constants/app_colors.dart';
import '../models/reservation_status.dart';
import '../data/mock_reservations_repository.dart';
import '../models/reservation_model.dart';

class InvoiceView extends StatelessWidget {
  final String reservationId;

  const InvoiceView({super.key, required this.reservationId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.mainAppPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          AppLocalizations.of(context)!.invoiceTitle,
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: AppColors.mainAppPrimary,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.share, color: AppColors.mainAppPrimary),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(AppLocalizations.of(context)!.shareComingSoon, style: GoogleFonts.poppins()),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.download, color: AppColors.mainAppPrimary),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(AppLocalizations.of(context)!.downloadComingSoon, style: GoogleFonts.poppins()),
                ),
              );
            },
          ),
        ],
      ),
      body: FutureBuilder<List<ReservationModel>>(
        future: MockReservationsRepository().fetchReservations(status: ReservationStatus.completed),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.mainAppPrimary),
            );
          }

          final reservations = snapshot.data ?? [];
          final reservation = reservations.firstWhere(
            (r) => r.id == reservationId,
            orElse: () => ReservationModel(
              id: reservationId,
              status: ReservationStatus.completed,
              title: AppLocalizations.of(context)!.service,
              providerName: Localizations.localeOf(context).languageCode == 'ar' ? 'أحمد المنصوري' : 'Ahmed El Mansouri',
              providerSubtitle: AppLocalizations.of(context)!.plumberExpert,
              coverImageUrl: '',
              dateLabel: Localizations.localeOf(context).languageCode == 'ar' ? '15 أكتوبر، 2023' : '15 Oct, 2023',
              timeLabel: '10:30',
              priceLabel: '350.00 MAD',
              canReview: true,
            ),
          );

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                // Invoice Card
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      // Header with Logo/Brand
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: AppColors.mainAppPrimary.withOpacity(0.05),
                          borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                        ),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.receipt_long,
                                  size: 32,
                                  color: AppColors.mainAppPrimary,
                                ),
                                const SizedBox(width: 12),
                                Text(
                                  'RiLyBricoule',
                                  style: GoogleFonts.poppins(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.mainAppPrimary,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              AppLocalizations.of(context)!.invoiceNumber(reservation.id.padLeft(6, '0')),
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      
                      // Invoice Details
                      Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Status Badge
                            Center(
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                decoration: BoxDecoration(
                                  color: AppColors.success.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(color: AppColors.success.withOpacity(0.3)),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.check_circle,
                                      size: 16,
                                      color: AppColors.success,
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      AppLocalizations.of(context)!.paidStatus,
                                      style: GoogleFonts.poppins(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.success,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 24),
                            
                            // Service Details
                            _buildSectionTitle(AppLocalizations.of(context)!.serviceDetailsTitle),
                            const SizedBox(height: 12),
                            _buildInfoRow(AppLocalizations.of(context)!.service, reservation.title),
                            _buildInfoRow(AppLocalizations.of(context)!.providerLabel, reservation.providerName),
                            _buildInfoRow(AppLocalizations.of(context)!.dateLabel, reservation.dateLabel),
                            _buildInfoRow(AppLocalizations.of(context)!.timeLabel, reservation.timeLabel),
                            const Divider(height: 32),
                            
                            // Pricing Breakdown
                            _buildSectionTitle(AppLocalizations.of(context)!.paymentDetailsTitle),
                            const SizedBox(height: 12),
                            _buildPriceRow(AppLocalizations.of(context)!.service, reservation.priceLabel),
                            _buildPriceRow(AppLocalizations.of(context)!.serviceFeeLabel, '20.00 MAD'),
                            _buildPriceRow(AppLocalizations.of(context)!.taxLabel, 
                              '${(double.parse(reservation.priceLabel.replaceAll(RegExp(r'[^0-9,\.]'), '').replaceAll(',', '.')) * 0.2).toStringAsFixed(2)} MAD'),
                            const Divider(height: 32),
                            _buildTotalRow(AppLocalizations.of(context)!.totalTotalLabel, 
                              '${(double.parse(reservation.priceLabel.replaceAll(RegExp(r'[^0-9,\.]'), '').replaceAll(',', '.')) * 1.2 + 20).toStringAsFixed(2)} MAD'),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 24),
                
                // Payment Method
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey[200]!),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: AppColors.mainAppPrimary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          Icons.credit_card,
                          color: AppColors.mainAppPrimary,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              AppLocalizations.of(context)!.paymentMethodLabel,
                              style: GoogleFonts.poppins(
                                fontSize: 12,
                                color: AppColors.textSecondary,
                              ),
                            ),
                            Text(
                              AppLocalizations.of(context)!.creditCardLabel,
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textPrimary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Icon(
                        Icons.verified,
                        color: AppColors.success,
                        size: 20,
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 24),
                
                // Date Info
                Text(
                  AppLocalizations.of(context)!.invoiceIssuedOn(reservation.dateLabel.isNotEmpty ? reservation.dateLabel : '15 Oct, 2023'),
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 32),
                
                // Download Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(AppLocalizations.of(context)!.downloadComingSoon, style: GoogleFonts.poppins()),
                          backgroundColor: AppColors.success,
                        ),
                      );
                    },
                    icon: const Icon(Icons.download),
                    label: Text(
                      AppLocalizations.of(context)!.downloadInvoiceBtn,
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.mainAppPrimary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: GoogleFonts.poppins(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: AppColors.textSecondary,
            ),
          ),
          Text(
            value,
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPriceRow(String label, String price) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: AppColors.textSecondary,
            ),
          ),
          Text(
            price,
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTotalRow(String label, String price) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        Text(
          price,
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColors.mainAppPrimary,
          ),
        ),
      ],
    );
  }
}