import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:rilybricoule_mobile_app/l10n/app_localizations.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/routes/app_routes.dart';
import '../../chat/domain/chat_service.dart';
import '../data/mock_reservations_repository.dart';
import '../repository/reservations_repository.dart';
import '../viewmodel/reservation_details_viewmodel.dart';
import '../widgets/eta_badge.dart';
import '../widgets/provider_mini_card.dart';
import '../widgets/tracking_timeline.dart';

class ReservationDetailsView extends StatefulWidget {
  final String reservationId;
  final MockReservationsRepository? listRepository;

  const ReservationDetailsView({
    super.key,
    required this.reservationId,
    this.listRepository,
  });

  @override
  State<ReservationDetailsView> createState() => _ReservationDetailsViewState();
}

class _ReservationDetailsViewState extends State<ReservationDetailsView> {
  late ReservationDetailsViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    final trackingRepository = MockReservationsRepositoryTracking(
      listRepository: widget.listRepository,
    );
    _viewModel = ReservationDetailsViewModel(
      trackingRepository,
      widget.reservationId,
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Safely load tracking with current localized context without listening
    _viewModel.loadTracking(context);
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _viewModel,
      child: const _ReservationDetailsContent(),
    );
  }
}

class _ReservationDetailsContent extends StatelessWidget {
  const _ReservationDetailsContent();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Consumer<ReservationDetailsViewModel>(
        builder: (context, viewModel, child) {
          if (viewModel.isLoading) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.mainAppPrimary),
            );
          }

          if (viewModel.error != null) {
            return Center(child: Text(AppLocalizations.of(context)!.errorLabel(viewModel.error!)));
          }

          final tracking = viewModel.tracking;
          if (tracking == null) return const SizedBox();

          return Stack(
            children: [
              Column(
                children: [
                  _buildHeader(context),
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.only(bottom: 200), // Extra padding for bottom actions
                      child: Column(
                        children: [
                          _buildHeroSection(viewModel),
                          const SizedBox(height: 24),
                          _buildStatusMessage(tracking),
                          const SizedBox(height: 32),
                          _buildTimeline(tracking),
                          const SizedBox(height: 24),
                          _buildProviderCard(tracking),
                          const SizedBox(height: 24),
                          // Cancel button only visible when canCancel is true
                          if (viewModel.canCancel) _buildCancelButton(context, viewModel),
                          // Cancelled banner when reservation is cancelled
                          if (viewModel.isCancelled) _buildCancelledBanner(context),
                          const SizedBox(height: 24), // Extra space at bottom
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              // Bottom actions with status-based logic
              _buildBottomActions(context, viewModel),
            ],
          );
        },
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.95),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: SafeArea(
        bottom: false,
        child: Row(
          children: [
            IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.arrow_back, color: AppColors.mainAppPrimary),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
            Expanded(
              child: Text(
                AppLocalizations.of(context)!.reservationTracking,
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: AppColors.mainAppPrimary,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(width: 40),
          ],
        ),
      ),
    );
  }

  /// Hero section - ETA badge is the main element when enRoute
  /// Otherwise shows a simple decorative element
  Widget _buildHeroSection(ReservationDetailsViewModel viewModel) {
    final tracking = viewModel.tracking;
    if (tracking == null) return const SizedBox.shrink();

    // If enRoute, show ETA badge as the main element in the hero
    if (viewModel.shouldShowEtaBadge) {
      return Container(
        height: 200,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColors.mainAppPrimary.withOpacity(0.15),
              AppColors.background,
            ],
          ),
        ),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            // Decorative background elements
            Positioned(
              top: 20,
              left: 20,
              child: Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.3),
                  shape: BoxShape.circle,
                ),
              ),
            ),
            Positioned(
              top: 40,
              right: 30,
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
              ),
            ),
            // ETA Badge centered
            Center(
              child: EtaBadge(minutes: tracking.etaMinutes!),
            ),
            // Gradient overlay at bottom
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                height: 40,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      AppColors.background.withOpacity(0),
                      AppColors.background,
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }

    // For other statuses: simple decorative hero section without icon
    return Container(
      height: 120,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppColors.mainAppPrimary.withOpacity(0.1),
            AppColors.background,
          ],
        ),
      ),
      child: Stack(
        children: [
          // Decorative circles
          Positioned(
            top: 20,
            left: 40,
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.3),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            top: 30,
            right: 60,
            child: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
            ),
          ),
          // Gradient overlay at bottom
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 40,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    AppColors.background.withOpacity(0),
                    AppColors.background,
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusMessage(tracking) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          Text(
            tracking.headerTitle,
            style: GoogleFonts.poppins(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            tracking.headerSubtitle,
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildTimeline(tracking) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(20),
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
      child: TrackingTimeline(steps: tracking.steps),
    );
  }

  Widget _buildProviderCard(tracking) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: ProviderMiniCard(
        name: tracking.providerName,
        category: tracking.providerCategory,
        imageUrl: tracking.providerImageUrl,
        rating: tracking.rating,
        reviewCount: tracking.reviewCount,
        isOnline: tracking.isOnline,
      ),
    );
  }

  Widget _buildCancelledBanner(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.error.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.error.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Icon(Icons.cancel, color: AppColors.error),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              AppLocalizations.of(context)!.reservationCancelled,
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.error,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCancelButton(BuildContext context, ReservationDetailsViewModel viewModel) {
    return Center(
      child: TextButton(
        onPressed: () => _showCancelDialog(context, viewModel),
        child: Text(
          AppLocalizations.of(context)!.cancelReservation,
          style: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.error,
            decoration: TextDecoration.underline,
          ),
        ),
      ),
    );
  }

  void _showCancelDialog(BuildContext context, ReservationDetailsViewModel viewModel) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              AppLocalizations.of(context)!.cancelReservationQuestion,
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              AppLocalizations.of(context)!.cancelWarningText,
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      side: BorderSide(color: Colors.grey[300]!),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      AppLocalizations.of(context)!.back,
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () async {
                      Navigator.pop(context);
                      final success = await viewModel.cancelReservation();
                      if (success && context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(AppLocalizations.of(context)!.reservationCancelled, style: GoogleFonts.poppins()),
                            backgroundColor: AppColors.success,
                          ),
                        );
                        // Pop with result to trigger navigation to cancelled tab
                        Navigator.pop(context, 'cancelled');
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.error,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      AppLocalizations.of(context)!.cancel,
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomActions(BuildContext context, ReservationDetailsViewModel viewModel) {
    final tracking = viewModel.tracking;
    if (tracking == null) return const SizedBox.shrink();

    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: SafeArea(
          top: false,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Main action row (Chat/Review + Call)
              _buildMainActions(context, viewModel),
              const SizedBox(height: 12),
              // Support button (always enabled)
              _buildSupportButton(context, viewModel),
              // Return to reservations button (only when cancelled)
              if (viewModel.isCancelled) ...[
                const SizedBox(height: 12),
                _buildReturnButton(context),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMainActions(BuildContext context, ReservationDetailsViewModel viewModel) {
    // When cancelled: disable chat and call
    if (viewModel.isCancelled) {
      return Row(
        children: [
          Expanded(
            child: ElevatedButton.icon(
              onPressed: null, // Disabled
              icon: const Icon(Icons.chat_bubble_outline, size: 20),
              label: Text(
                AppLocalizations.of(context)!.chatDisabled,
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey[300],
                foregroundColor: Colors.grey[600],
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey[400]!, width: 2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: IconButton(
              onPressed: null, // Disabled
              icon: Icon(Icons.phone, color: Colors.grey[400]),
            ),
          ),
        ],
      );
    }

    // When completed: show "Leave Review" instead of chat
    if (viewModel.isCompleted) {
      return Row(
        children: [
          Expanded(
            child: ElevatedButton.icon(
              onPressed: () {
                Navigator.pushNamed(
                  context,
                  AppRoutes.leaveReview,
                  arguments: viewModel.tracking?.reservationId,
                );
              },
              icon: const Icon(Icons.star_outline, size: 20),
              label: Text(
                AppLocalizations.of(context)!.leaveReview,
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.mainAppPrimary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          // View invoice button for completed
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.mainAppPrimary, width: 2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: IconButton(
              onPressed: () {
                Navigator.pushNamed(
                  context,
                  AppRoutes.invoice,
                  arguments: viewModel.tracking?.reservationId,
                );
              },
              icon: const Icon(Icons.receipt_outlined, color: AppColors.mainAppPrimary),
            ),
          ),
        ],
      );
    }

    // For confirmed, enRoute, inProgress: chat and call enabled
    return Row(
      children: [
        Expanded(
          child: ElevatedButton.icon(
            onPressed: () async {
              // Open chat with provider
              final tracking = viewModel.tracking;
              if (tracking != null) {
                try {
                  final chatRepo = ChatService().repository;
                  final conversation = await chatRepo.getOrCreateConversationWithProvider(
                    tracking.providerId,
                    bookingId: tracking.reservationId,
                  );
                  
                  if (context.mounted) {
                    Navigator.pushNamed(
                      context,
                      '/chat/${conversation.id}',
                      arguments: conversation,
                    );
                  }
                } catch (e) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          AppLocalizations.of(context)!.chatOnlyAfterBooking,
                          style: GoogleFonts.poppins(),
                        ),
                        backgroundColor: AppColors.error,
                      ),
                    );
                  }
                }
              }
            },
            icon: const Icon(Icons.chat_bubble_outline, size: 20),
            label: Text(
              viewModel.isCompleted 
                ? AppLocalizations.of(context)!.leaveReview 
                : AppLocalizations.of(context)!.discuss,
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.mainAppPrimary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.mainAppPrimary, width: 2),
            borderRadius: BorderRadius.circular(12),
          ),
          child: IconButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(AppLocalizations.of(context)!.callComingSoon, style: GoogleFonts.poppins()),
                ),
              );
            },
            icon: const Icon(Icons.phone, color: AppColors.mainAppPrimary),
          ),
        ),
      ],
    );
  }

  Widget _buildSupportButton(BuildContext context, ReservationDetailsViewModel viewModel) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(AppLocalizations.of(context)!.comingSoon, style: GoogleFonts.poppins()),
            ),
          );
        },
        icon: const Icon(Icons.support_agent, size: 20),
        label: Text(
          AppLocalizations.of(context)!.contactSupport,
          style: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.textSecondary,
          side: BorderSide(color: Colors.grey[300]!),
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }

  Widget _buildReturnButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: () => Navigator.pop(context),
        icon: const Icon(Icons.arrow_back, size: 20),
        label: Text(
          AppLocalizations.of(context)!.returnToReservations,
          style: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.background,
          foregroundColor: AppColors.textPrimary,
          side: BorderSide(color: Colors.grey[300]!),
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 0,
        ),
      ),
    );
  }
}
