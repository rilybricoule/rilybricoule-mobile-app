import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:rilybricoule_mobile_app/l10n/app_localizations.dart';

import '../../../core/constants/app_colors.dart';
import '../../../domain/entities/payment_policy.dart';
import '../../../domain/repositories/payment_repository.dart';

/// ViewModel pour l'écran d'information sur la politique de paiement
class PaymentPolicyInfoViewModel extends ChangeNotifier {
  final PaymentRepository _paymentRepository;

  PaymentPolicy? _policy;
  bool _isLoading = true;
  String? _errorMessage;

  PaymentPolicy? get policy => _policy;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  PaymentPolicyInfoViewModel({
    required PaymentRepository paymentRepository,
  }) : _paymentRepository = paymentRepository {
    loadPolicy();
  }

  Future<void> loadPolicy() async {
    _isLoading = true;
    notifyListeners();

    try {
      _policy = await _paymentRepository.getPaymentPolicy();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString();
      notifyListeners();
    }
  }
}

/// Écran d'information sur la politique de paiement
/// 
/// Explique en détail:
/// - Le fonctionnement de la préautorisation CMI
/// - Le paiement en espèces
/// - La politique d'annulation des prestataires
/// - Le calendrier d'intégration CMI
class PaymentPolicyInfoScreen extends StatelessWidget {
  const PaymentPolicyInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => PaymentPolicyInfoViewModel(
        paymentRepository: context.read<PaymentRepository>(),
      ),
      child: const _PaymentPolicyInfoContent(),
    );
  }
}

class _PaymentPolicyInfoContent extends StatelessWidget {
  const _PaymentPolicyInfoContent();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            _buildAppBar(context),
            Expanded(
              child: Consumer<PaymentPolicyInfoViewModel>(
                builder: (context, viewModel, child) {
                  if (viewModel.isLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final policy = viewModel.policy ?? PaymentPolicy.defaultPolicy();

                  return SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // En-tête explicatif
                        _buildHeader(context),
                        const SizedBox(height: 24),

                        // Section: Préautorisation CMI
                        _buildSection(
                          icon: Icons.lock_outline,
                          iconColor: AppColors.mainAppPrimary,
                          title: AppLocalizations.of(context)!.cmiPreauth,
                          content: AppLocalizations.of(context)!.cmiPreauthDesc,
                          details: [
                            AppLocalizations.of(context)!.cmiPreauthDetail1,
                            AppLocalizations.of(context)!.cmiPreauthDetail2,
                            AppLocalizations.of(context)!.cmiPreauthDetail3,
                            AppLocalizations.of(context)!.cmiPreauthDetail4,
                          ],
                        ),
                        const SizedBox(height: 16),

                        // Section: Paiement sur place
                        _buildSection(
                          icon: Icons.payments_outlined,
                          iconColor: AppColors.success,
                          title: AppLocalizations.of(context)!.cashPayment,
                          content: policy.cashExplanation, // Use localized text from policy if available
                          details: [
                            AppLocalizations.of(context)!.cashPaymentDetail1,
                            AppLocalizations.of(context)!.cashPaymentDetail2,
                            AppLocalizations.of(context)!.cashPaymentDetail3,
                            AppLocalizations.of(context)!.cashPaymentDetail4,
                          ],
                        ),
                        const SizedBox(height: 16),

                        // Section: Annulation prestataire
                        _buildSection(
                          icon: Icons.warning_amber_outlined,
                          iconColor: AppColors.warning,
                          title: AppLocalizations.of(context)!.cancellationPolicy,
                          content: policy.providerCancellationPolicy.penaltyDescription,
                          details: [
                            AppLocalizations.of(context)!.cancellationDetail1(policy.providerCancellationPolicy.maxCancelsAllowed),
                            AppLocalizations.of(context)!.cancellationDetail2,
                            AppLocalizations.of(context)!.cancellationDetail3,
                            AppLocalizations.of(context)!.cancellationDetail4,
                          ],
                        ),
                        const SizedBox(height: 16),

                        // Section: Intégration CMI future
                        _buildSection(
                          icon: Icons.schedule,
                          iconColor: AppColors.info,
                          title: AppLocalizations.of(context)!.fullCmiIntegration,
                          content: AppLocalizations.of(context)!.fullCmiIntegrationDesc(policy.cmiDocsAvailableFrom),
                          details: [
                            AppLocalizations.of(context)!.fullCmiIntegrationDetail1,
                            AppLocalizations.of(context)!.fullCmiIntegrationDetail2,
                            AppLocalizations.of(context)!.fullCmiIntegrationDetail3,
                            AppLocalizations.of(context)!.fullCmiIntegrationDetail4,
                          ],
                        ),
                        const SizedBox(height: 16),

                        // Section: Sécurité
                        _buildSecuritySection(context),
                        const SizedBox(height: 24),

                        // Note de bas de page
                        _buildFooterNote(context),
                        const SizedBox(height: 32),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
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
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              AppLocalizations.of(context)!.paymentInfoTitle,
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.mainAppPrimary,
            AppColors.accent,
          ],
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.security,
                  color: Colors.white,
                  size: 28,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppLocalizations.of(context)!.securePayment,
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      AppLocalizations.of(context)!.moneyProtected,
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        color: Colors.white.withValues(alpha: 0.8),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            AppLocalizations.of(context)!.cmiPreauthDesc,
            style: GoogleFonts.poppins(
              fontSize: 13,
              color: Colors.white.withValues(alpha: 0.9),
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String content,
    required List<String> details,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: iconColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: iconColor),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    title,
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Content
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              content,
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: AppColors.textSecondary,
                height: 1.5,
              ),
            ),
          ),
          const SizedBox(height: 16),
          // Details list
          ...details.map((detail) => _buildDetailItem(detail)),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildDetailItem(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 6,
            height: 6,
            margin: const EdgeInsets.only(top: 8, right: 12),
            decoration: BoxDecoration(
              color: AppColors.mainAppPrimary,
              shape: BoxShape.circle,
            ),
          ),
          Expanded(
            child: Text(
              text,
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: AppColors.textPrimary,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSecuritySection(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: AppColors.success.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.verified_user, color: AppColors.success),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  AppLocalizations.of(context)!.maxSecurity,
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildSecurityItem(
            icon: Icons.shield_outlined,
            title: AppLocalizations.of(context)!.encryptedData,
            description: AppLocalizations.of(context)!.encryptedDataDesc,
          ),
          const SizedBox(height: 12),
          _buildSecurityItem(
            icon: Icons.token_outlined,
            title: AppLocalizations.of(context)!.tokenization,
            description: AppLocalizations.of(context)!.tokenizationDesc,
          ),
          const SizedBox(height: 12),
          _buildSecurityItem(
            icon: Icons.verified_outlined,
            title: AppLocalizations.of(context)!.pciDss,
            description: AppLocalizations.of(context)!.pciDssDesc,
          ),
          const SizedBox(height: 12),
          _buildSecurityItem(
            icon: Icons.account_balance,
            title: AppLocalizations.of(context)!.cmiCentralBank,
            description: AppLocalizations.of(context)!.cmiCentralBankDesc,
          ),
        ],
      ),
    );
  }

  Widget _buildSecurityItem({
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: AppColors.mainAppPrimary),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                description,
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFooterNote(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.info.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.info.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Icon(Icons.info_outline, color: AppColors.info, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              AppLocalizations.of(context)!.paymentSupportNote,
              style: GoogleFonts.poppins(
                fontSize: 13,
                color: AppColors.textSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
