import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rilybricoule_mobile_app/l10n/app_localizations.dart';
import '../../../core/constants/app_colors.dart';
import '../models/reservation_status.dart';
import '../data/mock_reservations_repository.dart';
import '../models/reservation_model.dart';

class RateProviderView extends StatefulWidget {
  final String reservationId;

  const RateProviderView({super.key, required this.reservationId});

  @override
  State<RateProviderView> createState() => _RateProviderViewState();
}

class _RateProviderViewState extends State<RateProviderView> {
  double _rating = 0;
  final TextEditingController _commentController = TextEditingController();
  bool _isSubmitting = false;
  final List<String> _selectedTags = [];

  List<String> _getQuickTags(BuildContext context) {
    return [
      AppLocalizations.of(context)!.tagExcellent,
      AppLocalizations.of(context)!.tagPunctual,
      AppLocalizations.of(context)!.tagNeatWork,
      AppLocalizations.of(context)!.tagProfessional,
      AppLocalizations.of(context)!.tagRecommended,
    ];
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  Future<void> _submitReview() async {
    if (_rating == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.pleaseSelectRating, style: GoogleFonts.poppins()),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    setState(() => _isSubmitting = true);
    
    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));
    
    if (mounted) {
      setState(() => _isSubmitting = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.thankYouReview, style: GoogleFonts.poppins()),
          backgroundColor: AppColors.success,
        ),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Get reservation data from mock
    final reservation = MockReservationsRepository()
        .fetchReservations(status: ReservationStatus.completed)
        .then((list) => list.firstWhere((r) => r.id == widget.reservationId));

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
          AppLocalizations.of(context)!.leaveReview,
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: AppColors.mainAppPrimary,
          ),
        ),
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
            (r) => r.id == widget.reservationId,
            orElse: () => ReservationModel(
              id: widget.reservationId,
              status: ReservationStatus.completed,
              title: AppLocalizations.of(context)!.service,
              providerName: Localizations.localeOf(context).languageCode == 'ar' ? 'أحمد المنصوري' : 'Ahmed El Mansouri',
              providerSubtitle: AppLocalizations.of(context)!.plumberExpert,
              coverImageUrl: '',
              dateLabel: '',
              timeLabel: '',
              priceLabel: '350.00 MAD',
              canReview: true,
            ),
          );

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Service Info Card
                _buildServiceCard(reservation),
                const SizedBox(height: 32),
                
                // Rating Section
                Text(
                  AppLocalizations.of(context)!.howWasService,
                  style: GoogleFonts.poppins(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  AppLocalizations.of(context)!.rateExperience(reservation.providerName),
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 24),
                
                // Star Rating
                Center(
                  child: _buildStarRating(),
                ),
                const SizedBox(height: 32),
                
                // Quick Tags
                Text(
                  AppLocalizations.of(context)!.whatDoYouThink,
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 16),
                _buildQuickTags(context),
                const SizedBox(height: 32),
                
                // Comment Section
                Text(
                  AppLocalizations.of(context)!.yourCommentOptional,
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 12),
                _buildCommentField(),
                const SizedBox(height: 32),
                
                // Submit Button
                _buildSubmitButton(),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildServiceCard(ReservationModel reservation) {
    return Container(
      padding: const EdgeInsets.all(16),
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
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              reservation.coverImageUrl.isNotEmpty
                  ? reservation.coverImageUrl
                  : 'https://images.unsplash.com/photo-1604654894610-df63bc536371?w=200',
              width: 80,
              height: 80,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                width: 80,
                height: 80,
                color: Colors.grey[200],
                child: Icon(Icons.image, color: Colors.grey[400]),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  reservation.title,
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  reservation.providerName,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  reservation.priceLabel,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.mainAppPrimary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStarRating() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(5, (index) {
        final starValue = index + 1;
        return GestureDetector(
          onTap: () => setState(() => _rating = starValue.toDouble()),
          child: Container(
            padding: const EdgeInsets.all(4),
            child: Icon(
              starValue <= _rating ? Icons.star : Icons.star_border,
              size: 48,
              color: starValue <= _rating ? Colors.amber : Colors.grey[300],
            ),
          ),
        );
      }),
    );
  }

  Widget _buildQuickTags(BuildContext context) {
    final quickTags = _getQuickTags(context);
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: quickTags.map((tag) {
        final isSelected = _selectedTags.contains(tag);
        return GestureDetector(
          onTap: () {
            setState(() {
              if (isSelected) {
                _selectedTags.remove(tag);
              } else {
                _selectedTags.add(tag);
              }
            });
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: isSelected ? AppColors.mainAppPrimary : Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isSelected ? AppColors.mainAppPrimary : Colors.grey[300]!,
              ),
            ),
            child: Text(
              tag,
              style: GoogleFonts.poppins(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: isSelected ? Colors.white : AppColors.textSecondary,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildCommentField() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: TextField(
        controller: _commentController,
        maxLines: 4,
        maxLength: 500,
        decoration: InputDecoration(
          hintText: AppLocalizations.of(context)!.describeExperience,
          hintStyle: GoogleFonts.poppins(
            fontSize: 14,
            color: AppColors.textSecondary,
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.all(16),
          counterStyle: GoogleFonts.poppins(
            fontSize: 12,
            color: AppColors.textSecondary,
          ),
        ),
      ),
    );
  }

  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _isSubmitting ? null : _submitReview,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.mainAppPrimary,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 18),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 0,
        ),
        child: _isSubmitting
            ? const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              )
            : Text(
                AppLocalizations.of(context)!.submitReview,
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
      ),
    );
  }
}
