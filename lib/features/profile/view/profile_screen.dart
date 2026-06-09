import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:rilybricoule_mobile_app/l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/routes/app_routes.dart';
import '../../../domain/entities/user_profile.dart';
import '../../../domain/repositories/auth_repository.dart';
import '../../../domain/repositories/profile_repository.dart';
import '../../../features/auth/view/welcome_view.dart';
import '../../../features/auth/viewmodel/auth_viewmodel.dart';
import '../../profile/data/user_session.dart';
import '../../language/widgets/language_bottom_sheet.dart';
import '../widgets/profile_header.dart';
import '../widgets/section_title.dart';
import '../widgets/settings_tile.dart';

class ProfileScreen extends StatefulWidget {
  final Function(int)? onNavigateToTab;
  
  const ProfileScreen({super.key, this.onNavigateToTab});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {

  UserProfile? _userProfile;
  bool _isLoading = true;
  
  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    // Wait a moment for auth state to be ready after navigation
    await Future.delayed(const Duration(milliseconds: 300));
    
    if (!mounted) return;
    
    final authRepository = Provider.of<AuthRepository>(context, listen: false);
    final profileRepository = Provider.of<ProfileRepository>(context, listen: false);
    final currentUser = authRepository.currentUser;
    
    if (currentUser == null) {
      if (mounted) {
        Navigator.pushReplacementNamed(context, AppRoutes.login);
      }
      return;
    }

    // Écouter les changements du profil
    profileRepository.profileStream.listen((profile) {
      if (mounted && profile != null) {
        setState(() {
          _userProfile = profile;
          _isLoading = false;
        });
      }
    });

    // Charger le profil initial
    try {
      final profile = await profileRepository.getMe();
      if (mounted) {
        setState(() {
          _userProfile = profile;
          _isLoading = false;
        });
      }
    } catch (e) {
      // Fallback: utiliser AppUser si ProfileRepository échoue
      if (mounted) {
        setState(() {
          _userProfile = UserProfile.fromAppUser(currentUser);
          _isLoading = false;
        });
      }
    }
  }



  Future<void> _handleLogout() async {
    debugPrint('ProfileScreen: Logout button tapped');
    
    final l10n = AppLocalizations.of(context)!;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          l10n.logout,
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        content: Text(
          l10n.logout,
          style: GoogleFonts.poppins(
            color: AppColors.textSecondary,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(
              l10n.cancel,
              style: GoogleFonts.poppins(
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(
              l10n.logout,
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
      
      await UserSession.logout();
      debugPrint('ProfileScreen: UserSession cleared');
      
      final authRepository = Provider.of<AuthRepository>(context, listen: false);
      await authRepository.signOut();
      debugPrint('ProfileScreen: Firebase signOut completed');
      
      final authViewModel = Provider.of<AuthViewModel>(context, listen: false);
      await authViewModel.logout();
      debugPrint('ProfileScreen: AuthViewModel logout completed');
      
      if (mounted) {
        debugPrint('ProfileScreen: Navigating to WelcomeView...');
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => const WelcomeView()),
          (route) => false,
        );
        debugPrint('ProfileScreen: Navigation completed');
      }
    }
  }

  void _navigateToReservations() {
    widget.onNavigateToTab?.call(2);
  }

  String _formatMemberSince(DateTime? date) {
    final targetDate = date ?? DateTime(2024, 1);
    final locale = Localizations.localeOf(context).languageCode;
    return DateFormat.yMMMM(locale).format(targetDate);
  }

  /// Naviguer vers l'écran d'édition avec résultat
  Future<void> _navigateToEditProfile() async {
    final result = await Navigator.pushNamed(context, AppRoutes.editProfile);
    
    // Si le profil a été modifié (result == true), rafraîchir
    if (result == true && mounted) {
      debugPrint('ProfileScreen: Refreshing after profile update');
      final profileRepository = Provider.of<ProfileRepository>(context, listen: false);
      await profileRepository.refreshProfile();
    }
  }

  /// Naviguer vers l'édition avec focus sur l'avatar
  Future<void> _navigateToEditAvatar() async {
    // Même comportement: ouvrir l'écran d'édition
    // L'utilisateur pourra changer l'avatar là-bas
    await _navigateToEditProfile();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        backgroundColor: AppColors.background,
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final userName = _userProfile?.fullName ?? 'Utilisateur';
    final memberSince = _formatMemberSince(_userProfile?.createdAt);
    final avatarUrl = _userProfile?.photoUrl;

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
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Text(
                    AppLocalizations.of(context)!.profile,
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
              child: Builder(
                builder: (context) {
                  final l10n = AppLocalizations.of(context)!;
                  return ListView(
                    padding: const EdgeInsets.only(bottom: 100),
                    children: [
                      ProfileHeader(
                        name: userName,
                        memberSince: memberSince,
                        avatarUrl: avatarUrl,
                        onEditProfile: _navigateToEditProfile,
                        onAvatarTap: _navigateToEditAvatar,
                      ),
                      SectionTitle(title: l10n.myActivity),
                      SettingsTile(
                        icon: Icons.calendar_today,
                        title: l10n.myReservationsMenu,
                        onTap: _navigateToReservations,
                      ),
                      const Divider(height: 1, indent: 72),
                      SettingsTile(
                        icon: Icons.payment,
                        title: l10n.paymentMethods,
                        onTap: () {
                          Navigator.pushNamed(context, AppRoutes.paymentMethods);
                        },
                      ),
                      const Divider(height: 1, indent: 72),
                      SettingsTile(
                        icon: Icons.favorite_border,
                        title: l10n.favorites,
                        onTap: () {
                          Navigator.pushNamed(context, AppRoutes.favorites);
                        },
                      ),
                      SectionTitle(title: l10n.language),
                      SettingsTile(
                        icon: Icons.language,
                        title: l10n.language,
                        onTap: () => LanguageBottomSheet.show(context),
                      ),
                      SectionTitle(title: l10n.supportAndInfo),
                      SettingsTile(
                        icon: Icons.help_outline,
                        title: l10n.helpCenter,
                        onTap: () {
                          Navigator.pushNamed(context, AppRoutes.help);
                        },
                      ),
                      const Divider(height: 1, indent: 72),
                      SettingsTile(
                        icon: Icons.info_outline,
                        title: l10n.about,
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
                                l10n.logout,
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
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
