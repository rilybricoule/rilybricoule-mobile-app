import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rilybricoule_mobile_app/l10n/app_localizations.dart';
import '../../../core/constants/app_colors.dart';
import '../models/provider_detail_model.dart';
import '../widgets/review_card.dart';
import '../widgets/rating_summary.dart';

class AllReviewsScreen extends StatelessWidget {
  final String providerName;
  final double rating;
  final int reviewCount;
  final List<ReviewModel> reviews;

  const AllReviewsScreen({
    super.key,
    required this.providerName,
    required this.rating,
    required this.reviewCount,
    required this.reviews,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          AppLocalizations.of(context)!.customerReviews,
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          RatingSummary(rating: rating, reviewCount: reviewCount),
          const SizedBox(height: 24),
          Text(
            AppLocalizations.of(context)!.reviewsCount(reviewCount),
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          ...reviews.map((review) => ReviewCard(review: review)),
        ],
      ),
    );
  }
}
