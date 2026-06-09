import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rilybricoule_mobile_app/l10n/app_localizations.dart';
import '../../../core/constants/app_colors.dart';
import '../models/provider_detail_model.dart';
import '../widgets/service_card.dart';

class AllServicesScreen extends StatelessWidget {
  final String providerName;
  final List<ServiceModel> services;

  const AllServicesScreen({
    super.key,
    required this.providerName,
    required this.services,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          AppLocalizations.of(context)!.servicesOfProvider(providerName),
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        centerTitle: true,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: services.length,
        itemBuilder: (context, index) {
          return ServiceCard(
            service: services[index],
            onReserve: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Réservation: ${services[index].title}'),
                  backgroundColor: AppColors.mainAppPrimary,
                ),
              );
            },
          );
        },
      ),
    );
  }
}
