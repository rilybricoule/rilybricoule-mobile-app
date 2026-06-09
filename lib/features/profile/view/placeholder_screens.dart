import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:rilybricoule_mobile_app/l10n/app_localizations.dart';
import '../../../core/constants/app_colors.dart';
import '../../../domain/repositories/profile_repository.dart';
import 'edit_profile_view.dart';
import '../viewmodel/edit_profile_viewmodel.dart';

// Re-export the actual EditProfileView
export 'edit_profile_view.dart';

// EditProfileScreen with Provider setup
class EditProfileScreen extends StatelessWidget {
  const EditProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Create the ViewModel with the ProfileRepository from context
    return ChangeNotifierProvider(
      create: (context) => EditProfileViewModel(
        profileRepository: context.read<ProfileRepository>(),
      )..loadProfile(),
      child: const EditProfileView(),
    );
  }
}

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.favorites),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Center(
        child: Text(
          '${AppLocalizations.of(context)!.favorites}\n${AppLocalizations.of(context)!.toBeImplemented}',
          textAlign: TextAlign.center,
          style: GoogleFonts.poppins(
            fontSize: 16,
            color: AppColors.textSecondary,
          ),
        ),
      ),
    );
  }
}

class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.helpCenter),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Center(
        child: Text(
          '${AppLocalizations.of(context)!.helpCenter}\n${AppLocalizations.of(context)!.toBeImplemented}',
          textAlign: TextAlign.center,
          style: GoogleFonts.poppins(
            fontSize: 16,
            color: AppColors.textSecondary,
          ),
        ),
      ),
    );
  }
}

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.about),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Center(
        child: Text(
          '${AppLocalizations.of(context)!.about}\n${AppLocalizations.of(context)!.toBeImplemented}',
          textAlign: TextAlign.center,
          style: GoogleFonts.poppins(
            fontSize: 16,
            color: AppColors.textSecondary,
          ),
        ),
      ),
    );
  }
}
