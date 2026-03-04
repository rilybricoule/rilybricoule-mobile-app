import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/app_colors.dart';
import '../models/category_model.dart';
import '../widgets/category_item.dart';

class AllCategoriesScreen extends StatelessWidget {
  const AllCategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final categories = _getAllCategories();

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
          'Toutes les catégories',
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
              // TODO: Navigate to search with category filter
              Navigator.pop(context, categories[index].name);
            },
          );
        },
      ),
    );
  }

  List<CategoryModel> _getAllCategories() {
    return [
      CategoryModel(
        id: '1',
        name: 'Plomberie',
        icon: Icons.plumbing,
        backgroundColor: const Color(0xFFE8EAF6),
        iconColor: const Color(0xFF3F51B5),
      ),
      CategoryModel(
        id: '2',
        name: 'Électricité',
        icon: Icons.electrical_services,
        backgroundColor: const Color(0xFFFFF3E0),
        iconColor: const Color(0xFFFF9800),
      ),
      CategoryModel(
        id: '3',
        name: 'Ménage',
        icon: Icons.cleaning_services,
        backgroundColor: const Color(0xFFE0F2F1),
        iconColor: const Color(0xFF009688),
      ),
      CategoryModel(
        id: '4',
        name: 'Peinture',
        icon: Icons.format_paint,
        backgroundColor: const Color(0xFFF3E5F5),
        iconColor: const Color(0xFF9C27B0),
      ),
      CategoryModel(
        id: '5',
        name: 'Bricolage',
        icon: Icons.handyman,
        backgroundColor: const Color(0xFFFCE4EC),
        iconColor: const Color(0xFFE91E63),
      ),
      CategoryModel(
        id: '6',
        name: 'Jardinage',
        icon: Icons.yard,
        backgroundColor: const Color(0xFFE8F5E9),
        iconColor: const Color(0xFF4CAF50),
      ),
      CategoryModel(
        id: '7',
        name: 'Climatisation',
        icon: Icons.ac_unit,
        backgroundColor: const Color(0xFFE1F5FE),
        iconColor: const Color(0xFF03A9F4),
      ),
      CategoryModel(
        id: '8',
        name: 'Menuiserie',
        icon: Icons.carpenter,
        backgroundColor: const Color(0xFFFFF8E1),
        iconColor: const Color(0xFFFFC107),
      ),
      CategoryModel(
        id: '9',
        name: 'Serrurerie',
        icon: Icons.lock,
        backgroundColor: const Color(0xFFFBE9E7),
        iconColor: const Color(0xFFFF5722),
      ),
      CategoryModel(
        id: '10',
        name: 'Déménagement',
        icon: Icons.local_shipping,
        backgroundColor: const Color(0xFFEDE7F6),
        iconColor: const Color(0xFF673AB7),
      ),
      CategoryModel(
        id: '11',
        name: 'Réparation',
        icon: Icons.build,
        backgroundColor: const Color(0xFFE0F7FA),
        iconColor: const Color(0xFF00BCD4),
      ),
      CategoryModel(
        id: '12',
        name: 'Autres',
        icon: Icons.more_horiz,
        backgroundColor: const Color(0xFFF5F5F5),
        iconColor: const Color(0xFF9E9E9E),
      ),
    ];
  }
}
