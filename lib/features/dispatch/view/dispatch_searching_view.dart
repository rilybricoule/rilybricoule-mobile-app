import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/routes/app_routes.dart';
import '../../../l10n/app_localizations.dart';
import '../viewmodel/dispatch_viewmodel.dart';

/// Screen 3: Searching for providers (animated radar + countdown).
class DispatchSearchingView extends StatefulWidget {
  const DispatchSearchingView({super.key});

  @override
  State<DispatchSearchingView> createState() => _DispatchSearchingViewState();
}

class _DispatchSearchingViewState extends State<DispatchSearchingView>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late AnimationController _rotateController;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat();

    _rotateController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3000),
    )..repeat();
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _rotateController.dispose();
    super.dispose();
  }

  void _showCancelDialog() {
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(l10n.dispatchCancelTitle, style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
        content: Text(l10n.dispatchCancelMessage, style: GoogleFonts.poppins()),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(l10n.dispatchNo, style: GoogleFonts.poppins(color: AppColors.textSecondary)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              context.read<DispatchViewModel>().cancelRequest();
              // Pop back to search
              Navigator.popUntil(context, (route) => route.settings.name == AppRoutes.home || route.isFirst);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: Text(l10n.dispatchYesCancel, style: GoogleFonts.poppins()),
          ),
        ],
      ),
    );
  }

  String _formatTime(int seconds) {
    final remaining = max(0, 120 - seconds);
    final m = remaining ~/ 60;
    final s = remaining % 60;
    return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) _showCancelDialog();
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: SafeArea(
          child: Consumer<DispatchViewModel>(
            builder: (context, vm, child) {
              // Auto-navigate when matched
              if (vm.flowStatus == DispatchFlowStatus.matched) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  Navigator.pushReplacementNamed(context, AppRoutes.dispatchMatch);
                });
              }

              // Show expired state
              if (vm.flowStatus == DispatchFlowStatus.expired) {
                return _buildExpiredState(l10n, vm);
              }

              return Column(
                children: [
                  _buildAppBar(l10n),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Animated radar
                        _buildRadarAnimation(),
                        const SizedBox(height: 40),

                        // Status text
                        Text(
                          l10n.dispatchSearching,
                          style: GoogleFonts.poppins(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          l10n.dispatchSearchingCategory(vm.selectedCategoryName ?? ''),
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            color: AppColors.textSecondary,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 24),

                        // Countdown timer
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(30),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.timer_outlined, color: AppColors.mainAppPrimary, size: 20),
                              const SizedBox(width: 8),
                              Text(
                                _formatTime(vm.elapsedSeconds),
                                style: GoogleFonts.poppins(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.mainAppPrimary,
                                  fontFeatures: [const FontFeature.tabularFigures()],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 48),

                        // Cancel button
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 48),
                          child: OutlinedButton(
                            onPressed: _showCancelDialog,
                            style: OutlinedButton.styleFrom(
                              foregroundColor: AppColors.error,
                              side: const BorderSide(color: AppColors.error),
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              minimumSize: const Size(double.infinity, 50),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: Text(
                              l10n.dispatchCancelButton,
                              style: GoogleFonts.poppins(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ],
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

  Widget _buildAppBar(AppLocalizations l10n) {
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
            onPressed: _showCancelDialog,
            icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              l10n.dispatchSearchingTitle,
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

  Widget _buildRadarAnimation() {
    return SizedBox(
      width: 200,
      height: 200,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Pulse circles
          for (int i = 0; i < 3; i++)
            AnimatedBuilder(
              animation: _pulseController,
              builder: (context, child) {
                final delay = i * 0.33;
                final progress = (_pulseController.value + delay) % 1.0;
                return Container(
                  width: 80 + (120 * progress),
                  height: 80 + (120 * progress),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppColors.mainAppPrimary.withOpacity(0.3 * (1 - progress)),
                      width: 2,
                    ),
                  ),
                );
              },
            ),
          // Center icon
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.mainAppPrimary, AppColors.mainAppPrimary.withOpacity(0.8)],
              ),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: AppColors.mainAppPrimary.withOpacity(0.3),
                  blurRadius: 20,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: const Icon(Icons.search, color: Colors.white, size: 36),
          ),
        ],
      ),
    );
  }

  Widget _buildExpiredState(AppLocalizations l10n, DispatchViewModel vm) {
    return Column(
      children: [
        _buildAppBar(l10n),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: AppColors.warning.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.timer_off, color: AppColors.warning, size: 50),
                ),
                const SizedBox(height: 24),
                Text(
                  l10n.dispatchExpiredTitle,
                  style: GoogleFonts.poppins(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                Text(
                  l10n.dispatchExpiredMessage,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                    height: 1.5,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () => vm.relaunchRequest(),
                    icon: const Icon(Icons.refresh, size: 20),
                    label: Text(l10n.dispatchRelaunch, style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.mainAppPrimary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () {
                      vm.resetFlow();
                      Navigator.popUntil(context, (route) => route.settings.name == AppRoutes.home || route.isFirst);
                    },
                    icon: const Icon(Icons.person_search, size: 20),
                    label: Text(l10n.dispatchChooseManually, style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600)),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.mainAppPrimary,
                      side: const BorderSide(color: AppColors.mainAppPrimary, width: 2),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
