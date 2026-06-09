import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/app_colors.dart';
import '../../../l10n/app_localizations.dart';
import '../models/provider_location.dart';

/// Premium swipe deck overlay for filtering providers on the map.
/// Floats above the map with glassmorphic styling.
class SwipeFilterDeck extends StatefulWidget {
  final List<ProviderLocation> providers;
  final int currentIndex;
  final Set<String> likedIds;
  final Set<String> dislikedIds;
  final void Function(String providerId, bool liked) onSwipe;
  final VoidCallback onDone;
  final VoidCallback onReset;

  const SwipeFilterDeck({
    super.key,
    required this.providers,
    required this.currentIndex,
    required this.likedIds,
    required this.dislikedIds,
    required this.onSwipe,
    required this.onDone,
    required this.onReset,
  });

  @override
  State<SwipeFilterDeck> createState() => _SwipeFilterDeckState();
}

class _SwipeFilterDeckState extends State<SwipeFilterDeck>
    with SingleTickerProviderStateMixin {
  double _dragX = 0;
  double _dragY = 0;
  bool _isDragging = false;

  void _onPanStart(DragStartDetails details) {
    setState(() => _isDragging = true);
  }

  void _onPanUpdate(DragUpdateDetails details) {
    setState(() {
      _dragX += details.delta.dx;
      _dragY += details.delta.dy;
    });
  }

  void _onPanEnd(DragEndDetails details) {
    final screenWidth = MediaQuery.of(context).size.width;
    final threshold = screenWidth * 0.25;

    if (_dragX.abs() > threshold) {
      final liked = _dragX > 0;
      final provider = _currentProvider;
      if (provider != null) {
        HapticFeedback.lightImpact();
        widget.onSwipe(provider.id, liked);
      }
    }

    setState(() {
      _dragX = 0;
      _dragY = 0;
      _isDragging = false;
    });
  }

  void _swipeLeft() {
    final provider = _currentProvider;
    if (provider != null) {
      HapticFeedback.lightImpact();
      widget.onSwipe(provider.id, false);
    }
  }

  void _swipeRight() {
    final provider = _currentProvider;
    if (provider != null) {
      HapticFeedback.lightImpact();
      widget.onSwipe(provider.id, true);
    }
  }

  ProviderLocation? get _currentProvider {
    final remaining = _remainingProviders;
    if (remaining.isEmpty) return null;
    return remaining.first;
  }

  List<ProviderLocation> get _remainingProviders {
    return widget.providers.where((p) =>
        !widget.likedIds.contains(p.id) &&
        !widget.dislikedIds.contains(p.id)).toList();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final remaining = _remainingProviders;
    final total = widget.providers.length;
    final swiped = widget.likedIds.length + widget.dislikedIds.length;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.95),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 24,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 12),

          // Header: title + progress
          Row(
            children: [
              const Icon(Icons.swipe, color: AppColors.mainAppPrimary, size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  l10n.swipeFilterTitle,
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.mainAppPrimary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '$swiped/$total',
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.mainAppPrimary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),

          // Subtitle
          Align(
            alignment: AlignmentDirectional.centerStart,
            child: Text(
              l10n.swipeFilterHint,
              style: GoogleFonts.poppins(
                fontSize: 12,
                color: AppColors.textSecondary,
              ),
            ),
          ),
          const SizedBox(height: 12),

          // Progress bar
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: total > 0 ? swiped / total : 0,
              backgroundColor: Colors.grey[200],
              valueColor: const AlwaysStoppedAnimation(AppColors.mainAppPrimary),
              minHeight: 4,
            ),
          ),
          const SizedBox(height: 16),

          // Card stack
          if (remaining.isEmpty)
            _buildAllSwipedState(l10n)
          else
            _buildCardStack(remaining, l10n),

          const SizedBox(height: 16),

          // Controls
          _buildControls(remaining.isNotEmpty, l10n),
        ],
      ),
    );
  }

  Widget _buildAllSwipedState(AppLocalizations l10n) {
    return Container(
      height: 160,
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.success.withOpacity(0.06),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.success.withOpacity(0.2)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.check_circle_outline, size: 48, color: AppColors.success),
          const SizedBox(height: 12),
          Text(
            l10n.swipeFilterDoneMessage,
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '${widget.likedIds.length} ${l10n.swipeFilterKept}',
            style: GoogleFonts.poppins(
              fontSize: 13,
              color: AppColors.success,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCardStack(List<ProviderLocation> remaining, AppLocalizations l10n) {
    return SizedBox(
      height: 160,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Next card preview (behind)
          if (remaining.length > 1)
            Positioned(
              left: 8,
              right: 8,
              top: 8,
              child: _buildProviderCard(remaining[1], isPreview: true),
            ),

          // Current card (draggable)
          Positioned.fill(
            child: GestureDetector(
              onPanStart: _onPanStart,
              onPanUpdate: _onPanUpdate,
              onPanEnd: _onPanEnd,
              child: AnimatedContainer(
                duration: _isDragging
                    ? Duration.zero
                    : const Duration(milliseconds: 200),
                transform: Matrix4.identity()
                  ..translate(_dragX, _dragY * 0.3)
                  ..rotateZ(_dragX / 1000),
                transformAlignment: Alignment.center,
                child: Stack(
                  children: [
                    _buildProviderCard(remaining.first),

                    // LIKE overlay
                    if (_dragX > 40)
                      Positioned.fill(
                        child: Container(
                          decoration: BoxDecoration(
                            color: AppColors.success.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: AppColors.success,
                              width: 2,
                            ),
                          ),
                          child: Center(
                            child: Transform.rotate(
                              angle: -0.3,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: AppColors.success,
                                    width: 3,
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  'LIKE',
                                  style: GoogleFonts.poppins(
                                    fontSize: 28,
                                    fontWeight: FontWeight.w900,
                                    color: AppColors.success,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),

                    // NOPE overlay
                    if (_dragX < -40)
                      Positioned.fill(
                        child: Container(
                          decoration: BoxDecoration(
                            color: AppColors.error.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: AppColors.error,
                              width: 2,
                            ),
                          ),
                          child: Center(
                            child: Transform.rotate(
                              angle: 0.3,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: AppColors.error,
                                    width: 3,
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  'NOPE',
                                  style: GoogleFonts.poppins(
                                    fontSize: 28,
                                    fontWeight: FontWeight.w900,
                                    color: AppColors.error,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProviderCard(ProviderLocation provider, {bool isPreview = false}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isPreview ? Colors.grey[100] : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isPreview ? Colors.grey[200]! : AppColors.border,
        ),
        boxShadow: isPreview
            ? []
            : [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
      ),
      child: Row(
        children: [
          // Avatar
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: AppColors.mainAppPrimary.withOpacity(0.1),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                provider.imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Icon(
                  Icons.person,
                  size: 36,
                  color: AppColors.mainAppPrimary.withOpacity(0.5),
                ),
              ),
            ),
          ),
          const SizedBox(width: 14),

          // Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        provider.name,
                        style: GoogleFonts.poppins(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: isPreview ? AppColors.textSecondary : AppColors.textPrimary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (provider.isVerified)
                      const Padding(
                        padding: EdgeInsets.only(left: 4),
                        child: Icon(Icons.verified, size: 16, color: AppColors.mainAppPrimary),
                      ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  provider.category,
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    // Rating
                    const Icon(Icons.star, size: 14, color: Colors.amber),
                    const SizedBox(width: 3),
                    Text(
                      provider.rating.toStringAsFixed(1),
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    Text(
                      ' (${provider.reviewCount})',
                      style: GoogleFonts.poppins(fontSize: 11, color: AppColors.textSecondary),
                    ),
                    const SizedBox(width: 12),

                    // Distance
                    const Icon(Icons.location_on, size: 14, color: AppColors.textSecondary),
                    const SizedBox(width: 2),
                    Text(
                      '${provider.distance.toStringAsFixed(1)} km',
                      style: GoogleFonts.poppins(fontSize: 12, color: AppColors.textSecondary),
                    ),

                    const Spacer(),

                    // Status
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: provider.status == ProviderStatus.available
                            ? AppColors.success
                            : Colors.orange,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(width: 8),

          // Price
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                provider.price.split(' ')[0],
                textDirection: TextDirection.ltr,
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: isPreview ? AppColors.textSecondary : AppColors.mainAppPrimary,
                ),
              ),
              Text(
                'MAD',
                style: GoogleFonts.poppins(
                  fontSize: 10,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildControls(bool hasCards, AppLocalizations l10n) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        // Reset
        _buildControlButton(
          icon: Icons.refresh,
          label: l10n.swipeFilterReset,
          color: AppColors.textSecondary,
          onTap: widget.onReset,
        ),

        // Dislike
        _buildCircleButton(
          icon: Icons.close,
          color: AppColors.error,
          size: 52,
          onTap: hasCards ? _swipeLeft : null,
        ),

        // Like
        _buildCircleButton(
          icon: Icons.favorite,
          color: AppColors.success,
          size: 52,
          onTap: hasCards ? _swipeRight : null,
        ),

        // Done
        _buildControlButton(
          icon: Icons.check,
          label: l10n.swipeFilterDone,
          color: AppColors.mainAppPrimary,
          onTap: widget.onDone,
        ),
      ],
    );
  }

  Widget _buildCircleButton({
    required IconData icon,
    required Color color,
    required double size,
    VoidCallback? onTap,
  }) {
    final isDisabled = onTap == null;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isDisabled ? Colors.grey[100] : color.withOpacity(0.1),
          border: Border.all(
            color: isDisabled ? Colors.grey[300]! : color,
            width: 2,
          ),
        ),
        child: Icon(
          icon,
          color: isDisabled ? Colors.grey[400] : color,
          size: size * 0.45,
        ),
      ),
    );
  }

  Widget _buildControlButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 22),
          const SizedBox(height: 2),
          Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 10,
              color: color,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
