import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';

class ProviderServicesView extends StatelessWidget {
  const ProviderServicesView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('My Services'),
        backgroundColor: AppColors.surface,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
      ),
      body: Center(
        child: Text(
          'Services View - Coming Soon',
          style: TextStyle(color: AppColors.textSecondary),
        ),
      ),
    );
  }
}