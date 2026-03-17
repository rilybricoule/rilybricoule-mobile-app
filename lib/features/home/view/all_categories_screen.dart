import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rilybricoule_mobile_app/l10n/app_localizations.dart';
import '../../../core/constants/app_colors.dart';
import '../models/category_model.dart';
import '../widgets/category_item.dart';

class AllCategoriesScreen extends StatelessWidget {
  const AllCategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final categories = _getAllCategories(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
        ),
        title: Text(
          AppLocalizations.of(context)!.allCategories,
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 0.85,
        ),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          return CategoryItem(
            category: categories[index],
            onTap: () {
              // Navigate to search with category filter
              Navigator.pop(context, categories[index].id);
            },
          );
        },
      ),
    );
  }

  List<CategoryModel> _getAllCategories(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return [
      CategoryModel(id: '1', name: l10n.categoryPlumbing, icon: Icons.plumbing, backgroundColor: const Color(0xFFE8EAF6), iconColor: const Color(0xFF3F51B5)),
      CategoryModel(id: '2', name: l10n.categoryElectricity, icon: Icons.electrical_services, backgroundColor: const Color(0xFFFFF3E0), iconColor: const Color(0xFFFF9800)),
      CategoryModel(id: '3', name: l10n.categoryCleaning, icon: Icons.cleaning_services, backgroundColor: const Color(0xFFE0F2F1), iconColor: const Color(0xFF009688)),
      CategoryModel(id: '4', name: l10n.categoryPainting, icon: Icons.format_paint, backgroundColor: const Color(0xFFF3E5F5), iconColor: const Color(0xFF9C27B0)),
      CategoryModel(id: '5', name: l10n.categoryHandyman, icon: Icons.handyman, backgroundColor: const Color(0xFFFCE4EC), iconColor: const Color(0xFFE91E63)),
      CategoryModel(id: '6', name: l10n.categoryGardening, icon: Icons.yard, backgroundColor: const Color(0xFFE8F5E9), iconColor: const Color(0xFF4CAF50)),
      CategoryModel(id: '7', name: l10n.categoryAC, icon: Icons.ac_unit, backgroundColor: const Color(0xFFE1F5FE), iconColor: const Color(0xFF03A9F4)),
      CategoryModel(id: '8', name: l10n.categoryCarpentry, icon: Icons.carpenter, backgroundColor: const Color(0xFFFFF8E1), iconColor: const Color(0xFFFFC107)),
      CategoryModel(id: '9', name: l10n.categoryLocksmith, icon: Icons.lock, backgroundColor: const Color(0xFFFBE9E7), iconColor: const Color(0xFFFF5722)),
      CategoryModel(id: '10', name: l10n.categoryMoving, icon: Icons.local_shipping, backgroundColor: const Color(0xFFEDE7F6), iconColor: const Color(0xFF673AB7)),
      CategoryModel(id: '11', name: l10n.categoryRepair, icon: Icons.build, backgroundColor: const Color(0xFFE0F7FA), iconColor: const Color(0xFF00BCD4)),
      CategoryModel(id: '12', name: l10n.categoryOther, icon: Icons.more_horiz, backgroundColor: const Color(0xFFF5F5F5), iconColor: const Color(0xFF9E9E9E)),
    ];
  }
}
