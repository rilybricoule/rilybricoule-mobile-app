import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:appinio_swiper/appinio_swiper.dart';
import '../../../core/constants/app_colors.dart';
import '../models/search_context_bundle.dart';
import '../viewmodel/discover_swipe_viewmodel.dart';
import '../widgets/provider_swipe_card.dart';
import '../widgets/swipe_action_buttons.dart';
import '../widgets/swipe_overlay_label.dart';

class DiscoverSwipeView extends StatefulWidget {
  const DiscoverSwipeView({super.key});

  @override
  State<DiscoverSwipeView> createState() => _DiscoverSwipeViewState();
}

class _DiscoverSwipeViewState extends State<DiscoverSwipeView> {
  final AppinioSwiperController _swiperController = AppinioSwiperController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final bundle = ModalRoute.of(context)?.settings.arguments as SearchContextBundle?;
      if (bundle != null) {
        context.read<DiscoverSwipeViewModel>().loadProviders(bundle);
      }
    });
  }

  @override
  void dispose() {
    _swiperController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(),
      body: SafeArea(
        child: Consumer<DiscoverSwipeViewModel>(
          builder: (context, viewModel, child) {
            if (viewModel.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (viewModel.providers.isEmpty) {
              return _buildEmptyState(viewModel);
            }

            return Column(
              children: [
                _buildContextChips(viewModel),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: AppinioSwiper(
                      controller: _swiperController,
                      cardCount: viewModel.providers.length,
                      cardBuilder: (context, index) {
                        return ProviderSwipeCard(
                          provider: viewModel.providers[index],
                          onViewProfile: () => _viewProfile(viewModel.providers[index].id),
                        );
                      },
                      onSwipeEnd: (previousIndex, targetIndex, activity) {
                        _handleSwipe(viewModel, previousIndex, activity);
                      },
                      onEnd: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Plus de prestataires')),
                        );
                      },
                      backgroundCardCount: 2,
                      backgroundCardScale: 0.9,
                      backgroundCardOffset: const Offset(0, 10),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                SwipeActionButtons(
                  onSkip: () => _swiperController.swipeLeft(),
                  onLike: () => _swiperController.swipeRight(),
                  onInfo: () {
                    if (viewModel.providers.isNotEmpty) {
                      _viewProfile(viewModel.providers.first.id);
                    }
                  },
                ),
                const SizedBox(height: 24),
              ],
            );
          },
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
        onPressed: () => Navigator.pop(context),
      ),
      title: Text(
        'Découvrir',
        style: GoogleFonts.poppins(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: AppColors.textPrimary,
        ),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.refresh, color: AppColors.mainAppPrimary),
          onPressed: () {
            context.read<DiscoverSwipeViewModel>().resetFilters();
          },
        ),
      ],
    );
  }

  Widget _buildContextChips(DiscoverSwipeViewModel viewModel) {
    final context = viewModel.context;
    if (context == null) return const SizedBox.shrink();

    final chips = <Widget>[];

    if (context.query != null && context.query!.isNotEmpty) {
      chips.add(_buildChip(context.query!));
    }
    if (context.availableNow == true) {
      chips.add(_buildChip('Disponibles', Icons.check_circle));
    }
    if (context.maxDistanceKm != null) {
      chips.add(_buildChip('≤ ${context.maxDistanceKm!.toInt()} km', Icons.location_on));
    }
    if (context.minRating != null) {
      chips.add(_buildChip('${context.minRating}+ ⭐'));
    }

    if (chips.isEmpty) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: chips,
      ),
    );
  }

  Widget _buildChip(String label, [IconData? icon]) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.mainAppPrimary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.mainAppPrimary.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 14, color: AppColors.mainAppPrimary),
            const SizedBox(width: 4),
          ],
          Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppColors.mainAppPrimary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(DiscoverSwipeViewModel viewModel) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.explore_off, size: 80, color: Colors.grey[400]),
            const SizedBox(height: 24),
            Text(
              'Plus de prestataires',
              style: GoogleFonts.poppins(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              'Aucun prestataire ne correspond à vos critères',
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: () => viewModel.resetFilters(),
              icon: const Icon(Icons.refresh),
              label: Text(
                'Réinitialiser les filtres',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.mainAppPrimary,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 12),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Retour à la recherche',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.mainAppPrimary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handleSwipe(DiscoverSwipeViewModel viewModel, int index, SwiperActivity activity) {
    if (index >= viewModel.providers.length) return;

    final provider = viewModel.providers[index];

    HapticFeedback.lightImpact();

    final activityStr = activity.toString().split('.').last;

    if (activityStr == 'swipeRight' || activityStr.contains('Right')) {
      viewModel.likeProvider(provider.id);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${provider.name} ajouté aux favoris'),
          duration: const Duration(seconds: 1),
          backgroundColor: AppColors.mainAppPrimary,
        ),
      );
    } else if (activityStr == 'swipeLeft' || activityStr.contains('Left')) {
      viewModel.skipProvider(provider.id);
    }
  }

  void _viewProfile(String providerId) {
    Navigator.pushNamed(
      context,
      '/provider-profile',
      arguments: providerId,
    );
  }
}
