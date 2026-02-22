import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/app_colors.dart';
import '../models/category_model.dart';
import '../models/provider_model.dart';
import '../widgets/category_item.dart';
import '../widgets/promo_banner.dart';
import '../widgets/provider_card.dart';
import '../widgets/custom_bottom_nav_bar.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  int _currentNavIndex = 0;

  // Mock data - Categories
  final List<CategoryModel> _categories = [
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
  ];

  // Mock data - Providers
  final List<ProviderModel> _providers = [
    ProviderModel(
      id: '1',
      name: 'Yassine El Amrani',
      service: 'Plomberie & Réparation',
      imageUrl: 'assets/images/provider.png',
      rating: 4.8,
      reviewCount: 120,
      distance: 2.3,
      priceLabel: 'À partir de',
      price: '150 MAD',
      isVerified: true,
    ),
    ProviderModel(
      id: '2',
      name: 'Sarah Benjelloun',
      service: 'Ménage Professionnel',
      imageUrl: 'assets/images/provider.png',
      rating: 4.9,
      reviewCount: 85,
      distance: 1.1,
      priceLabel: 'À partir de',
      price: '100 MAD/h',
      isVerified: true,
    ),
    ProviderModel(
      id: '3',
      name: 'Omar Mansouri',
      service: 'Expert Électricité',
      imageUrl: 'assets/images/provider.png',
      rating: 4.7,
      reviewCount: 210,
      distance: 3.8,
      priceLabel: 'À partir de',
      price: '200 MAD',
      isVerified: true,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // Top App Bar
            _buildTopAppBar(),
            // Scrollable Content
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 16),
                    // Search Bar
                    _buildSearchBar(),
                    const SizedBox(height: 24),
                    // Categories Section
                    _buildCategoriesSection(),
                    const SizedBox(height: 24),
                    // Promo Banner
                    const PromoBanner(),
                    const SizedBox(height: 24),
                    // Nearby Providers Section
                    _buildProvidersSection(),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: _currentNavIndex,
        onTap: (index) {
          setState(() {
            _currentNavIndex = index;
          });
          // TODO: Navigate to other screens based on index
        },
      ),
    );
  }

  Widget _buildTopAppBar() {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.white,
      child: Row(
        children: [
          // Profile Picture
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.primary, width: 2),
            ),
            child: ClipOval(
              child: Image.asset(
                'assets/images/provider.png',
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: AppColors.primary.withOpacity(0.1),
                    child: const Icon(Icons.person, color: AppColors.primary),
                  );
                },
              ),
            ),
          ),
          const SizedBox(width: 12),
          // Greeting & Location
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Bonjour, Marouane 👋',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Row(
                  children: [
                    const Icon(
                      Icons.location_on,
                      size: 14,
                      color: AppColors.textSecondary,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Casablanca, Morocco',
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const Icon(
                      Icons.keyboard_arrow_down,
                      size: 16,
                      color: AppColors.textSecondary,
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Notification Icon with Badge
          Stack(
            children: [
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.notifications_outlined),
                color: AppColors.textPrimary,
              ),
              Positioned(
                right: 8,
                top: 8,
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: AppColors.error,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
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
                  const Icon(Icons.search, color: AppColors.textSecondary),
                  const SizedBox(width: 12),
                  Text(
                    'Rechercher un service...',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.tune,
              color: Colors.white,
              size: 24,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoriesSection() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Catégories',
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              TextButton(
                onPressed: () {},
                child: Text(
                  'Voir tout',
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 110,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            scrollDirection: Axis.horizontal,
            itemCount: _categories.length,
            separatorBuilder: (context, index) => const SizedBox(width: 16),
            itemBuilder: (context, index) {
              return CategoryItem(
                category: _categories[index],
                onTap: () {
                  // TODO: Navigate to category results
                },
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildProvidersSection() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Prestataires proches',
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              TextButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.sort, size: 18),
                label: Text(
                  'Trier par',
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _providers.length,
          itemBuilder: (context, index) {
            return ProviderCard(
              provider: _providers[index],
              onTap: () {
                // TODO: Navigate to provider profile
              },
            );
          },
        ),
      ],
    );
  }
}
