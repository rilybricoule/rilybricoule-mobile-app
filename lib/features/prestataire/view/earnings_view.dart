import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_section_header.dart';
import '../../../../core/widgets/app_status_chip.dart';

class ProviderEarningsView extends StatelessWidget {
  const ProviderEarningsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Mes Revenus'),
        backgroundColor: AppColors.surface,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
      ),
    body: SafeArea(
    bottom: true,
    child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
        children: [
          _buildWalletCard(context),
          const SizedBox(height: 24),
          _buildStatsRow(),
          const SizedBox(height: 24),
          const AppSectionHeader(title: 'Historique des transactions'),
          const SizedBox(height: 12),
          _buildTransactionList(),
        ],
      ),
     ),
    );
  }

  Widget _buildWalletCard(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.providerPrimary,
            AppColors.providerPrimary.withOpacity(0.8),
          ],
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Solde disponible',
                style: TextStyle(color: Colors.white70, fontSize: 14),
              ),
              Icon(Icons.account_balance_wallet, color: Colors.white.withOpacity(0.5)),
            ],
          ),
          const SizedBox(height: 8),
          const Text(
            '4,850.00 MAD',
            style: TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: AppColors.providerPrimary,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text('Retirer l\'argent', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ),
              const SizedBox(width: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.history, color: Colors.white),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatsRow() {
    return Row(
      children: [
        Expanded(child: _buildMiniStat('Ce mois', '2,150 MAD', Icons.calendar_today)),
        const SizedBox(width: 16),
        Expanded(child: _buildMiniStat('Missions', '12', Icons.task_alt)),
      ],
    );
  }

  Widget _buildMiniStat(String label, String value, IconData icon) {
    return AppCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: AppColors.providerPrimary, size: 20),
          const SizedBox(height: 8),
          Text(label, style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
          const SizedBox(height: 4),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        ],
      ),
    );
  }

  Widget _buildTransactionList() {
    final items = [
      const _MockEarning(
        id: 'e1',
        title: 'Réparation Fuite',
        subtitle: 'Sarah B. • 03 Mars',
        amountLabel: '+150 MAD',
        statusLabel: 'Validé',
        statusColor: AppColors.success,
      ),
      const _MockEarning(
        id: 'e2',
        title: 'Installation Prise',
        subtitle: 'Omar M. • 02 Mars',
        amountLabel: '+200 MAD',
        statusLabel: 'En attente',
        statusColor: AppColors.warning,
      ),
      const _MockEarning(
        id: 'e3',
        title: 'Peinture Salon',
        subtitle: 'Imane Z. • 28 Fév',
        amountLabel: '+1,200 MAD',
        statusLabel: 'Retiré',
        statusColor: AppColors.info,
      ),
    ];

    return Column(
      children: items.map((e) => Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: AppCard(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: e.statusLabel == 'Retiré' ? AppColors.error.withOpacity(0.1) : AppColors.success.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  e.statusLabel == 'Retiré' ? Icons.north_east : Icons.south_west,
                  color: e.statusLabel == 'Retiré' ? AppColors.error : AppColors.success,
                  size: 20,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(e.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                    Text(e.subtitle, style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    e.amountLabel,
                    style: TextStyle(
                      color: e.statusLabel == 'Retiré' ? AppColors.textPrimary : AppColors.success,
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(e.statusLabel, style: TextStyle(color: e.statusColor, fontSize: 11, fontWeight: FontWeight.w600)),
                ],
              ),
            ],
          ),
        ),
      )).toList(),
    );
  }
}

class _MockEarning {
  final String id;
  final String title;
  final String subtitle;
  final String amountLabel;
  final String statusLabel;
  final Color statusColor;

  const _MockEarning({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.amountLabel,
    required this.statusLabel,
    required this.statusColor,
  });
}