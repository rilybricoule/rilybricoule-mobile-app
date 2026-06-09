import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/routes/app_routes.dart';
import '../../../l10n/app_localizations.dart';
import '../viewmodel/dispatch_viewmodel.dart';

/// Screen 1: Category selection for dispatch.
class DispatchStartView extends StatelessWidget {
  const DispatchStartView({super.key});

  static const List<_CategoryItem> _categoryItems = [
    _CategoryItem('1', Icons.plumbing, Color(0xFFE8EAF6), Color(0xFF3F51B5)),
    _CategoryItem('2', Icons.electrical_services, Color(0xFFFFF3E0), Color(0xFFFF9800)),
    _CategoryItem('3', Icons.cleaning_services, Color(0xFFE0F2F1), Color(0xFF009688)),
    _CategoryItem('4', Icons.format_paint, Color(0xFFF3E5F5), Color(0xFF9C27B0)),
    _CategoryItem('5', Icons.handyman, Color(0xFFFCE4EC), Color(0xFFE91E63)),
    _CategoryItem('6', Icons.yard, Color(0xFFE8F5E9), Color(0xFF4CAF50)),
    _CategoryItem('7', Icons.ac_unit, Color(0xFFE1F5FE), Color(0xFF03A9F4)),
    _CategoryItem('8', Icons.carpenter, Color(0xFFFFF8E1), Color(0xFFFFC107)),
    _CategoryItem('9', Icons.lock, Color(0xFFEFEBE9), Color(0xFF795548)),
    _CategoryItem('10', Icons.local_shipping, Color(0xFFE0E0E0), Color(0xFF616161)),
    _CategoryItem('11', Icons.build, Color(0xFFE8EAF6), Color(0xFF5C6BC0)),
    _CategoryItem('12', Icons.more_horiz, Color(0xFFF5F5F5), Color(0xFF9E9E9E)),
  ];

  String _getCategoryName(BuildContext context, String id) {
    final l10n = AppLocalizations.of(context)!;
    switch (id) {
      case '1': return l10n.categoryPlumbing;
      case '2': return l10n.categoryElectricity;
      case '3': return l10n.categoryCleaning;
      case '4': return l10n.categoryPainting;
      case '5': return l10n.categoryHandyman;
      case '6': return l10n.categoryGardening;
      case '7': return l10n.categoryAC;
      case '8': return l10n.categoryCarpentry;
      case '9': return l10n.categoryLocksmith;
      case '10': return l10n.categoryMoving;
      case '11': return l10n.categoryRepair;
      case '12': return l10n.categoryOther;
      default: return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            _buildAppBar(context, l10n),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header info
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            AppColors.mainAppPrimary,
                            AppColors.mainAppPrimary.withOpacity(0.85),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.flash_on, color: Colors.white, size: 28),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  l10n.dispatchTitle,
                                  style: GoogleFonts.poppins(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  l10n.dispatchSubtitle,
                                  style: GoogleFonts.poppins(
                                    fontSize: 13,
                                    color: Colors.white.withOpacity(0.9),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Section title
                    Text(
                      l10n.dispatchChooseCategory,
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Category grid
                    GridView.builder(
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        childAspectRatio: 0.95,
                      ),
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _categoryItems.length,
                      itemBuilder: (context, index) {
                        final item = _categoryItems[index];
                        final name = _getCategoryName(context, item.id);
                        return _CategoryCard(
                          name: name,
                          icon: item.icon,
                          bgColor: item.bgColor,
                          iconColor: item.iconColor,
                          onTap: () {
                            final vm = context.read<DispatchViewModel>();
                            vm.selectCategory(item.id, name);
                            Navigator.pushNamed(context, AppRoutes.dispatchForm);
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
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
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              l10n.dispatchTitle,
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
}

class _CategoryItem {
  final String id;
  final IconData icon;
  final Color bgColor;
  final Color iconColor;
  const _CategoryItem(this.id, this.icon, this.bgColor, this.iconColor);
}

class _CategoryCard extends StatelessWidget {
  final String name;
  final IconData icon;
  final Color bgColor;
  final Color iconColor;
  final VoidCallback onTap;

  const _CategoryCard({
    required this.name,
    required this.icon,
    required this.bgColor,
    required this.iconColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
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
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: bgColor,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: iconColor, size: 28),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Text(
                name,
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textPrimary,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
