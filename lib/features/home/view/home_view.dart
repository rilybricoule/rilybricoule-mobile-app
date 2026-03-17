import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:rilybricoule_mobile_app/l10n/app_localizations.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/marquee_text.dart';
import '../../../domain/repositories/profile_repository.dart';
import '../../../services/location/location_service.dart';
import '../../notifications/view/notifications_view.dart';
import '../../notifications/viewmodel/notification_viewmodel.dart';
import '../../profile/data/user_session.dart';
import '../../profile/widgets/avatar_image.dart';
import '../models/category_model.dart';
import '../models/provider_model.dart';
import '../providers/home_provider.dart';
import '../widgets/category_item.dart';
import '../widgets/promo_banner.dart';
import '../widgets/provider_card.dart';
import '../widgets/sort_bottom_sheet.dart';
import 'all_categories_screen.dart';

class HomeView extends StatefulWidget {
  final Function({bool showFilters})? onNavigateToSearch;
  final Function(String)? onCategorySelected;
  final Function()? onNavigateToProfile;
  
  const HomeView({
    super.key,
    this.onNavigateToSearch,
    this.onCategorySelected,
    this.onNavigateToProfile,
  });

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  String _userName = 'Utilisateur';
  String? _userAvatar;
  String _locationText = 'Localisation...';
  
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<NotificationViewModel>().loadNotifications(context);
      _loadUserData();
      _loadLocation();
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Re-generate mock providers when the locale changes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<HomeProvider>().setProviders(_getProviders(context));
      }
    });
  }
  
  Future<void> _loadUserData() async {
    // First try to get from UserSession (fast)
    final user = await UserSession.getUser();
    setState(() {
      _userName = user['name'] ?? 'Utilisateur';
      _userAvatar = user['avatarUrl'];
    });
    
    // Then listen to ProfileRepository for real-time updates
    final profileRepo = context.read<ProfileRepository>();
    
    // Listen to profile stream for updates
    profileRepo.profileStream.listen((profile) {
      if (mounted && profile != null) {
        setState(() {
          _userName = profile.fullName;
          _userAvatar = profile.photoUrl;
        });
        // Also update UserSession cache
        UserSession.saveUser(
          id: profile.id,
          name: profile.fullName,
          email: profile.email,
          avatarUrl: profile.photoUrl,
        );
      }
    });
    
    // Try to get current profile
    try {
      final currentProfile = profileRepo.currentProfile;
      if (currentProfile != null) {
        setState(() {
          _userName = currentProfile.fullName;
          _userAvatar = currentProfile.photoUrl;
        });
      } else {
        // Load from repository
        final profile = await profileRepo.getMe();
        setState(() {
          _userName = profile.fullName;
          _userAvatar = profile.photoUrl;
        });
      }
    } catch (e) {
      debugPrint('HomeView: Error loading profile - $e');
    }
  }
  
  Future<void> _loadLocation() async {
    final locationService = LocationService();
    final status = await locationService.checkPermission();
    
    if (status == LocationPermissionStatus.granted) {
      final position = await locationService.getCurrentPosition();
      if (position != null) {
        try {
          List<Placemark> placemarks = await placemarkFromCoordinates(
            position.latitude,
            position.longitude,
          );
          if (placemarks.isNotEmpty) {
            final place = placemarks.first;
            final city = place.locality ?? place.administrativeArea ?? '';
            final langCode = mounted ? Localizations.localeOf(context).languageCode : 'fr';
            final fallbackCountry = langCode == 'ar' ? 'المغرب' : langCode == 'en' ? 'Morocco' : 'Maroc';
            final country = place.country ?? fallbackCountry;
            setState(() {
              _locationText = city.isNotEmpty ? '$city, $country' : country;
            });
          }
        } catch (e) {
          final langCode = mounted ? Localizations.localeOf(context).languageCode : 'fr';
          setState(() {
            _locationText = langCode == 'ar' ? 'المغرب' : langCode == 'en' ? 'Morocco' : 'Maroc';
          });
        }
      }
    } else {
      final langCode = mounted ? Localizations.localeOf(context).languageCode : 'fr';
      setState(() {
        _locationText = langCode == 'ar' ? 'المغرب' : langCode == 'en' ? 'Morocco' : 'Maroc';
      });
    }
  }
  
  String _getGreeting() {
    return AppLocalizations.of(context)?.hello ?? 'Bonjour';
  }
  // Mock data - Categories
  List<CategoryModel> _getCategories(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return [
    CategoryModel(
      id: '1',
      name: l10n.categoryPlumbing,
      icon: Icons.plumbing,
      backgroundColor: const Color(0xFFE8EAF6),
      iconColor: const Color(0xFF3F51B5),
    ),
    CategoryModel(
      id: '2',
      name: l10n.categoryElectricity,
      icon: Icons.electrical_services,
      backgroundColor: const Color(0xFFFFF3E0),
      iconColor: const Color(0xFFFF9800),
    ),
    CategoryModel(
      id: '3',
      name: l10n.categoryCleaning,
      icon: Icons.cleaning_services,
      backgroundColor: const Color(0xFFE0F2F1),
      iconColor: const Color(0xFF009688),
    ),
    CategoryModel(
      id: '4',
      name: l10n.categoryPainting,
      icon: Icons.format_paint,
      backgroundColor: const Color(0xFFF3E5F5),
      iconColor: const Color(0xFF9C27B0),
    ),
    CategoryModel(
      id: '5',
      name: l10n.categoryHandyman,
      icon: Icons.handyman,
      backgroundColor: const Color(0xFFFCE4EC),
      iconColor: const Color(0xFFE91E63),
    ),
  ];
  }

  // Mock data - Providers
  List<ProviderModel> _getProviders(BuildContext context) {
    final lang = Localizations.localeOf(context).languageCode;
    final priceLabel = lang == 'en' ? 'From' : lang == 'ar' ? 'ابتداءً من' : 'À partir de';

    return [
      ProviderModel(
        id: '1',
        name: lang == 'ar' ? 'ياسين العمراني' : 'Yassine El Amrani',
        service: lang == 'en' ? 'Plumbing & Repair' : lang == 'ar' ? 'السباكة والإصلاح' : 'Plomberie & Réparation',
        imageUrl: 'assets/images/provider.png',
        rating: 4.8,
        reviewCount: 120,
        distance: 2.3,
        priceLabel: priceLabel,
        price: '150 MAD/hr',
        priceValue: 150.0,
        isVerified: true,
        isAvailable: true,
        categoryId: '1',
        activeJobsCount: 2,
      ),
      ProviderModel(
        id: '2',
        name: lang == 'ar' ? 'سارة بنجلون' : 'Sarah Benjelloun',
        service: lang == 'en' ? 'Professional Cleaning' : lang == 'ar' ? 'تنظيف احترافي' : 'Ménage Professionnel',
        imageUrl: 'assets/images/provider.png',
        rating: 4.9,
        reviewCount: 85,
        distance: 1.1,
        priceLabel: priceLabel,
        price: '100 MAD/hr',
        priceValue: 100.0,
        isVerified: true,
        isAvailable: false,
        categoryId: '3',
        activeJobsCount: 5,
      ),
      ProviderModel(
        id: '3',
        name: lang == 'ar' ? 'عمر المنصوري' : 'Omar Mansouri',
        service: lang == 'en' ? 'Electrical Expert' : lang == 'ar' ? 'خبير كهرباء' : 'Expert Électricité',
        imageUrl: 'assets/images/provider.png',
        rating: 4.7,
        reviewCount: 210,
        distance: 3.8,
        priceLabel: priceLabel,
        price: '200 MAD/hr',
        priceValue: 200.0,
        isVerified: true,
        isAvailable: true,
        categoryId: '2',
        activeJobsCount: 1,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: const PromoBanner(),
                    ),
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
    );
  }

  Widget _buildTopAppBar() {
    final displayUserName = _userName == 'Utilisateur' 
        ? (Localizations.localeOf(context).languageCode == 'ar' ? 'مستخدم' : Localizations.localeOf(context).languageCode == 'en' ? 'User' : 'Utilisateur')
        : _userName;
    
    final displayLocation = _locationText == 'Morocco' || _locationText == 'Localisation...'
        ? (Localizations.localeOf(context).languageCode == 'ar' ? 'المغرب' : Localizations.localeOf(context).languageCode == 'en' ? 'Morocco' : 'Maroc')
        : _locationText;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Profile Picture with AvatarImage
          GestureDetector(
            onTap: () {
              widget.onNavigateToProfile?.call();
            },
            child: AvatarImage(
              photoUrl: _userAvatar,
              name: displayUserName,
              size: 48,
            ),
          ),
          const SizedBox(width: 12),
          // Greeting & Location
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                MarqueeText(
                  text: AppLocalizations.of(context)?.helloUser(displayUserName) ?? '${_getGreeting()}, $displayUserName 👋',
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
                    Expanded(
                      child: Text(
                        displayLocation,
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                        ),
                        overflow: TextOverflow.ellipsis,
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
          Consumer<NotificationViewModel>(
            builder: (context, notificationViewModel, child) {
              final unreadCount = notificationViewModel.notifications
                  .where((n) => !n.isRead)
                  .length;
              
              return Stack(
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const NotificationsView(),
                        ),
                      );
                    },
                    icon: const Icon(Icons.notifications_outlined),
                    color: AppColors.textPrimary,
                  ),
                  if (unreadCount > 0)
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
              );
            },
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
            child: GestureDetector(
              onTap: () => widget.onNavigateToSearch?.call(),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
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
                      AppLocalizations.of(context)!.searchService,
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          GestureDetector(
            onTap: () => widget.onNavigateToSearch?.call(showFilters: true),
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.mainAppPrimary,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.tune,
                color: Colors.white,
                size: 24,
              ),
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
                AppLocalizations.of(context)!.categories,
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AllCategoriesScreen(),
                    ),
                  ).then((selectedCategory) {
                    if (selectedCategory != null) {
                      widget.onCategorySelected?.call(selectedCategory);
                    }
                  });
                },
                child: Text(
                  AppLocalizations.of(context)!.seeAll,
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
        const SizedBox(height: 12),
        SizedBox(
          height: 110,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            scrollDirection: Axis.horizontal,
            itemCount: _getCategories(context).length,
            separatorBuilder: (context, index) => const SizedBox(width: 16),
            itemBuilder: (context, index) {
              final cat = _getCategories(context)[index];
              return CategoryItem(
                category: cat,
                onTap: () {
                  widget.onCategorySelected?.call(cat.id);
                },
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildProvidersSection() {
    return Consumer<HomeProvider>(
      builder: (context, homeProvider, child) {
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    AppLocalizations.of(context)!.nearbyProviders,
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  TextButton.icon(
                    onPressed: () {
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        backgroundColor: Colors.transparent,
                        builder: (context) => const SortBottomSheet(),
                      );
                    },
                    icon: Icon(Icons.sort, size: 18, color: AppColors.mainAppPrimary),
                    label: Text(
                      AppLocalizations.of(context)!.sortBy,
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: AppColors.mainAppPrimary,
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
              itemCount: homeProvider.providers.length,
              itemBuilder: (context, index) {
                return ProviderCard(
                  provider: homeProvider.providers[index],
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      '/provider-profile',
                      arguments: homeProvider.providers[index].id,
                    );
                  },
                );
              },
            ),
          ],
        );
      },
    );
  }
}