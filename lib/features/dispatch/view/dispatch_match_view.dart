import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/routes/app_routes.dart';
import '../../../l10n/app_localizations.dart';
import '../../client_main_view.dart';
import '../../booking/view/booking_payment_view.dart';
import '../../chat/domain/chat_service.dart';
import '../viewmodel/dispatch_viewmodel.dart';

/// Screen 4: Provider matched — show provider card + actions.
class DispatchMatchView extends StatelessWidget {
  const DispatchMatchView({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          // Go back to searching or cancel
          Navigator.popUntil(context, (route) => route.settings.name == AppRoutes.home || route.isFirst);
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: SafeArea(
          child: Consumer<DispatchViewModel>(
            builder: (context, vm, child) {
              final offer = vm.matchedOffer;
              if (offer == null) {
                return const Center(child: CircularProgressIndicator());
              }

              return Column(
                children: [
                  _buildAppBar(context, l10n),
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          const SizedBox(height: 16),

                          // Success badge
                          Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              color: AppColors.success.withOpacity(0.1),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.check_circle, color: AppColors.success, size: 48),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            l10n.dispatchMatchFound,
                            style: GoogleFonts.poppins(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            l10n.dispatchMatchSubtitle,
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              color: AppColors.textSecondary,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 24),

                          // Provider card
                          _buildProviderCard(context, vm, offer, l10n),
                          const SizedBox(height: 24),

                          // Service details
                          _buildServiceDetails(vm, l10n),
                          const SizedBox(height: 32),

                          // Action buttons
                          _buildActionButtons(context, vm, l10n),
                          const SizedBox(height: 16),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context, AppLocalizations l10n) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: () {
              Navigator.popUntil(context, (route) => route.settings.name == AppRoutes.home || route.isFirst);
            },
            icon: const Icon(Icons.close, color: AppColors.textPrimary),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              l10n.dispatchMatchTitle,
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProviderCard(BuildContext context, DispatchViewModel vm, dynamic offer, AppLocalizations l10n) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              // Avatar
              CircleAvatar(
                radius: 32,
                backgroundColor: AppColors.mainAppPrimary.withOpacity(0.1),
                child: const Icon(Icons.person, size: 32, color: AppColors.mainAppPrimary),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      offer.providerName,
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      offer.serviceName,
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                // Rating
                Column(
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.star, color: Colors.amber, size: 18),
                        const SizedBox(width: 4),
                        Text(
                          offer.providerRating.toStringAsFixed(1),
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${offer.providerReviewCount} ${l10n.dispatchReviews}',
                      style: GoogleFonts.poppins(fontSize: 11, color: AppColors.textSecondary),
                    ),
                  ],
                ),
                Container(width: 1, height: 30, color: AppColors.border),
                // Distance
                Column(
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.location_on, color: AppColors.mainAppPrimary, size: 18),
                        const SizedBox(width: 4),
                        Text(
                          '${offer.distanceKm.toStringAsFixed(1)} km',
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      l10n.dispatchDistance,
                      style: GoogleFonts.poppins(fontSize: 11, color: AppColors.textSecondary),
                    ),
                  ],
                ),
                Container(width: 1, height: 30, color: AppColors.border),
                // Price
                Column(
                  children: [
                    Text(
                      offer.priceFrom != null ? '${offer.priceFrom!.toInt()} MAD' : '-',
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.success,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      l10n.dispatchPriceFrom,
                      style: GoogleFonts.poppins(fontSize: 11, color: AppColors.textSecondary),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildServiceDetails(DispatchViewModel vm, AppLocalizations l10n) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.dispatchRequestDetails,
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.mainAppPrimary,
            ),
          ),
          const SizedBox(height: 12),
          _buildDetailRow(Icons.category, l10n.dispatchService, vm.selectedCategoryName ?? '-'),
          const SizedBox(height: 8),
          _buildDetailRow(Icons.location_on, l10n.dispatchAddress, vm.address),
          const SizedBox(height: 8),
          _buildDetailRow(Icons.phone, l10n.dispatchPhone, vm.phone),
          if (vm.note.isNotEmpty) ...[
            const SizedBox(height: 8),
            _buildDetailRow(Icons.note, l10n.dispatchNote, vm.note),
          ],
        ],
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 16, color: AppColors.textSecondary),
        const SizedBox(width: 8),
        Text(
          '$label: ',
          style: GoogleFonts.poppins(fontSize: 13, color: AppColors.textSecondary),
        ),
        Expanded(
          child: Text(
            value,
            style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w500, color: AppColors.textPrimary),
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons(BuildContext context, DispatchViewModel vm, AppLocalizations l10n) {
    return Column(
      children: [
        // Continue with provider → Payment (with offer data)
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: vm.isLoading ? null : () async {
              final offer = vm.matchedOffer;
              if (offer == null) return;

              await vm.acceptMatch();
              if (!context.mounted) return;

              // Navigate to BookingPaymentView with dispatch data mapped
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => BookingPaymentView(
                    bookingId: vm.currentRequest?.id,
                    serviceName: offer.serviceName,
                    providerName: offer.providerName,
                    servicePrice: offer.priceFrom ?? 200.0,
                    scheduledDate: vm.scheduledAt ?? DateTime.now().add(const Duration(hours: 1)),
                  ),
                ),
              );

              // If payment was completed (user came back or went to status)
              if (context.mounted) {
                // Mark dispatch as paid
                await vm.markPaid();

                // Create confirmed booking conversation → enables chat
                final chatRepo = ChatService().repository;
                await chatRepo.getOrCreateConversationWithProvider(
                  offer.providerId,
                  bookingId: vm.currentRequest?.id ?? 'dispatch_booking',
                  langCode: Localizations.localeOf(context).languageCode,
                );

                // Navigate to booking status (confirmation screen)
                if (context.mounted) {
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    AppRoutes.bookingStatus,
                    (route) => route.isFirst,
                  );
                }
              }
            },
            icon: const Icon(Icons.check_circle_outline, size: 20),
            label: Text(
              l10n.dispatchContinueWithProvider,
              style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.mainAppPrimary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              elevation: 0,
            ),
          ),
        ),
        const SizedBox(height: 12),

        // Relaunch dispatch
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: () {
              vm.relaunchRequest();
              Navigator.pushReplacementNamed(context, AppRoutes.dispatchSearching);
            },
            icon: const Icon(Icons.refresh, size: 20),
            label: Text(
              l10n.dispatchRelaunch,
              style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.mainAppPrimary,
              side: const BorderSide(color: AppColors.mainAppPrimary, width: 2),
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
        ),
        const SizedBox(height: 12),

        // Choose manually
        SizedBox(
          width: double.infinity,
          child: TextButton.icon(
            onPressed: () {
              vm.resetFlow();
              // Navigate to search with category pre-filled
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (_) => ClientMainView(initialIndex: 1),
                ),
                (route) => false,
              );
              // The search will be pre-filtered by the category
              // (handled by ClientMainView with Search tab)
            },
            icon: const Icon(Icons.person_search, size: 20),
            label: Text(
              l10n.dispatchChooseManually,
              style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            style: TextButton.styleFrom(
              foregroundColor: AppColors.textSecondary,
              padding: const EdgeInsets.symmetric(vertical: 14),
            ),
          ),
        ),
      ],
    );
  }
}
