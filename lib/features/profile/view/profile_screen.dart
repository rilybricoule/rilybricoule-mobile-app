import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/routes/app_routes.dart';
import '../../../data/models/app_user.dart';
import '../../../domain/repositories/auth_repository.dart';
import '../../../features/auth/view/welcome_view.dart';
import '../../../features/auth/viewmodel/auth_viewmodel.dart';
import '../../../models/user_role.dart';
import '../../profile/data/user_session.dart';
import '../widgets/profile_header.dart';
import '../widgets/section_title.dart';
import '../widgets/settings_tile.dart';
import '../widgets/language_switcher.dart';

class ProfileScreen extends StatefulWidget {
  final Function(int)? onNavigateToTab;
  
  const ProfileScreen({super.key, this.onNavigateToTab});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String _selectedLanguage = 'FR';
  AppUser? _user;
  bool _isLoading = true;
  
  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    // Wait a moment for auth state to be ready after navigation
    await Future.delayed(const Duration(milliseconds: 500));
    
    if (!mounted) return;
    
    // Get auth repository from Provider instead of creating new instance
    final authRepository = Provider.of<AuthRepository>(context, listen: false);
    final currentUser = authRepository.currentUser;
    
    if (currentUser == null) {
      // User not authenticated, redirect to login
      if (mounted) {
        Navigator.pushReplacementNamed(context, AppRoutes.login);
      }
      return;
    }

    setState(() {
      _user = currentUser;
      _isLoading = false;
    });
  }

  Future<void> _handleLanguageChange(String language) async {
    setState(() {
      _selectedLanguage = language;
    });
    // TODO: Save language preference to Firestore
  }

  Future<void> _handleLogout() async {
    debugPrint('ProfileScreen: Logout button tapped');
    
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          'Déconnexion',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        content: Text(
          'Êtes-vous sûr de vouloir vous déconnecter ?',
          style: GoogleFonts.poppins(
            color: AppColors.textSecondary,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(
              'Annuler',
              style: GoogleFonts.poppins(
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(
              'Déconnexion',
              style: GoogleFonts.poppins(
                color: AppColors.error,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );

    debugPrint('ProfileScreen: Logout confirmed: $confirmed');

    if (confirmed == true && mounted) {
      debugPrint('ProfileScreen: Starting logout process...');
      
      // Clear local session first
      await UserSession.logout();
      debugPrint('ProfileScreen: UserSession cleared');
      
      // Get auth repository from Provider and logout from Firebase
      final authRepository = Provider.of<AuthRepository>(context, listen: false);
      await authRepository.signOut();
      debugPrint('ProfileScreen: Firebase signOut completed');
      
      // Also logout from AuthViewModel to clear current user
      final authViewModel = Provider.of<AuthViewModel>(context, listen: false);
      await authViewModel.logout();
      debugPrint('ProfileScreen: AuthViewModel logout completed');
      
      if (mounted) {
        debugPrint('ProfileScreen: Navigating to WelcomeView...');
        // Navigate to welcome screen (not login) after logout
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => const WelcomeView()),
          (route) => false,
        );
        debugPrint('ProfileScreen: Navigation completed');
      }
    } else {
      debugPrint('ProfileScreen: Logout cancelled or not mounted');
    }
  }

  void _navigateToReservations() {
    widget.onNavigateToTab?.call(2);
  }

  String _formatMemberSince(DateTime? date) {
    if (date == null) return 'Janvier 2024';
    final months = [
      'Janvier', 'Février', 'Mars', 'Avril', 'Mai', 'Juin',
      'Juillet', 'Août', 'Septembre', 'Octobre', 'Novembre', 'Décembre'
    ];
    return '${months[date.month - 1]} ${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        backgroundColor: AppColors.background,
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final userName = _user?.fullName ?? 'Utilisateur';
    final memberSince = _formatMemberSince(_user?.createdAt);
    final avatarUrl = _user?.photoUrl;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            Container(
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
                  Text(
                    'Profil',
                    style: GoogleFonts.poppins(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.only(bottom: 100),
                children: [
                  ProfileHeader(
                    name: userName,
                    memberSince: 'Membre depuis $memberSince',
                    avatarUrl: avatarUrl,
                    onEditProfile: () {
                      Navigator.pushNamed(context, AppRoutes.editProfile);
                    },
                  ),
                  const SectionTitle(title: 'Mon Activité'),
                  SettingsTile(
                    icon: Icons.calendar_today,
                    title: 'Mes réservations',
                    onTap: _navigateToReservations,
                  ),
                  const Divider(height: 1, indent: 72),
                  SettingsTile(
                    icon: Icons.payment,
                    title: 'Modes de paiement',
                    onTap: () {
                      Navigator.pushNamed(context, AppRoutes.paymentMethods);
                    },
                  ),
                  const Divider(height: 1, indent: 72),
                  SettingsTile(
                    icon: Icons.favorite_border,
                    title: 'Favoris',
                    onTap: () {
                      Navigator.pushNamed(context, AppRoutes.favorites);
                    },
                  ),
                  const SectionTitle(title: 'Préférences'),
                  LanguageSwitcher(
                    selectedLanguage: _selectedLanguage,
                    onLanguageChanged: _handleLanguageChange,
                  ),
                  const SectionTitle(title: 'Support & Info'),
                  SettingsTile(
                    icon: Icons.help_outline,
                    title: 'Centre d\'aide',
                    onTap: () {
                      Navigator.pushNamed(context, AppRoutes.help);
                    },
                  ),
                  const Divider(height: 1, indent: 72),
                  SettingsTile(
                    icon: Icons.info_outline,
                    title: 'À propos',
                    onTap: () {
                      Navigator.pushNamed(context, AppRoutes.about);
                    },
                  ),
                  const SizedBox(height: 24),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: OutlinedButton(
                      onPressed: _handleLogout,
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.error,
                        side: const BorderSide(color: AppColors.error, width: 2),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.logout, size: 20),
                          const SizedBox(width: 8),
                          Text(
                            'Déconnexion',
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
