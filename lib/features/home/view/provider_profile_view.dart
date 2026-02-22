import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/app_colors.dart';

class ProviderProfileView extends StatelessWidget {
  const ProviderProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Profil du Prestataire',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
      ),
      body: Center(
        child: Text(
          'Provider Profile Screen\n(To be implemented)',
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
