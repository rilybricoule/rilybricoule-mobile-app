import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rilybricoule_mobile_app/l10n/app_localizations.dart';
import 'package:local_auth/local_auth.dart';
import 'package:local_auth_android/local_auth_android.dart';
import 'package:local_auth_darwin/local_auth_darwin.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/routes/app_routes.dart';
import '../../../domain/entities/payment_method_entity.dart';
import '../../../domain/entities/payment_policy.dart';
import '../../../domain/repositories/payment_repository.dart';
import '../viewmodel/payment_methods_viewmodel.dart';

/// Écran des modes de paiement
/// 
/// Affiche:
/// - Les méthodes de paiement en ligne (cartes CMI)
/// - Les options futurs (PayPal, Stripe, Wallet) en mode "Bientôt"
/// - Le toggle pour paiement en espèces
/// - La section "Comment ça marche ?"
/// - Le lien vers les informations détaillées
class PaymentMethodsScreen extends StatelessWidget {
  const PaymentMethodsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => PaymentMethodsViewModel(
        paymentRepository: context.read<PaymentRepository>(),
      )..loadData(),
      child: const _PaymentMethodsContent(),
    );
  }
}

class _PaymentMethodsContent extends StatefulWidget {
  const _PaymentMethodsContent();

  @override
  State<_PaymentMethodsContent> createState() => _PaymentMethodsContentState();
}

class _PaymentMethodsContentState extends State<_PaymentMethodsContent> {
  final LocalAuthentication _localAuth = LocalAuthentication();

  Future<bool> _authenticateWithBiometrics() async {
    try {
      final bool isAvailable = await _localAuth.isDeviceSupported();
      if (!isAvailable) {
        // Device doesn't support biometrics, allow access without auth
        return true;
      }

      final bool canCheckBiometrics = await _localAuth.canCheckBiometrics;
      if (!canCheckBiometrics) {
        // Biometrics not available, allow access without auth
        return true;
      }

      final bool didAuthenticate = await _localAuth.authenticate(
        localizedReason: 'Veuillez vous authentifier pour voir les détails de la carte',
        authMessages: [
          AndroidAuthMessages(
            signInTitle: 'Authentification requise',
            cancelButton: 'Annuler',
            biometricHint: 'Confirmer votre identité',
            biometricNotRecognized: 'Non reconnu, réessayez',
            biometricRequiredTitle: 'Authentification biométrique requise',
            deviceCredentialsRequiredTitle: 'Identifiants de l\'appareil requis',
            deviceCredentialsSetupDescription: 'Veuillez configurer un code PIN ou un mot de passe',
            goToSettingsButton: 'Paramètres',
            goToSettingsDescription: 'Veuillez configurer l\'authentification biométrique dans les paramètres de votre appareil',
          ),
          IOSAuthMessages(
            cancelButton: 'Annuler',
            goToSettingsButton: 'Paramètres',
            goToSettingsDescription: 'Veuillez configurer Face ID ou Touch ID dans les paramètres de votre appareil',
            lockOut: 'Veuillez réactiver Face ID ou Touch ID',
          ),
        ],
        options: const AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: false,
          useErrorDialogs: true,
        ),
      );

      return didAuthenticate;
    } on PlatformException catch (e) {
      debugPrint('Biometric auth error: $e');
      // If biometrics fail, we could fall back to device credentials or just deny access
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            _buildAppBar(context),
            Expanded(
              child: Consumer<PaymentMethodsViewModel>(
                builder: (context, viewModel, child) {
                  if (viewModel.isLoading && viewModel.paymentMethods.isEmpty) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  return RefreshIndicator(
                      onRefresh: viewModel.refresh,
                      color: AppColors.mainAppPrimary,
                      child: ListView(
                        padding: const EdgeInsets.all(16),
                        children: [
                          // Section: Paiement en ligne
                          _buildSectionTitle(AppLocalizations.of(context)!.onlinePaymentTitle),
                          const SizedBox(height: 16),
                          _buildOnlinePaymentSection(context, viewModel),
                          const SizedBox(height: 32),

                          // Section: Méthodes futures
                          _buildFutureMethodsSection(context),
                          const SizedBox(height: 32),

                          // Section: Paiement sur place
                          _buildSectionTitle(AppLocalizations.of(context)!.onSitePaymentTitle),
                          const SizedBox(height: 16),
                          _buildCashSection(context, viewModel),
                          const SizedBox(height: 32),

                          // Section: Comment ça marche
                          _buildSectionTitle(AppLocalizations.of(context)!.howItWorksTitle),
                          const SizedBox(height: 16),
                          _buildInfoCard(context, viewModel),
                          const SizedBox(height: 24),

                          // Alert si aucune méthode
                          if (viewModel.paymentMethods.isEmpty && !viewModel.isCashEnabled)
                            _buildEmptyStateAlert(context),

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
          AppLocalizations.of(context)!.paymentMethodsTitleLabel,
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

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: GoogleFonts.poppins(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
      ),
    );
  }

  Widget _buildOnlinePaymentSection(BuildContext context, PaymentMethodsViewModel viewModel) {
    final cardMethods = viewModel.cardMethods;

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
        children: [
          // Liste des cartes enregistrées
          if (cardMethods.isNotEmpty) ...[
            ...cardMethods.map((method) => _buildCardMethodTile(context, method, viewModel)),
            const Divider(height: 1),
          ],

          // Bouton ajouter une carte
          InkWell(
            onTap: () => Navigator.pushNamed(context, AppRoutes.addPaymentMethod),
            borderRadius: BorderRadius.only(
              topLeft: cardMethods.isEmpty ? const Radius.circular(16) : Radius.zero,
              topRight: cardMethods.isEmpty ? const Radius.circular(16) : Radius.zero,
              bottomLeft: const Radius.circular(16),
              bottomRight: const Radius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: AppColors.mainAppPrimary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.add_card,
                      color: AppColors.mainAppPrimary,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          AppLocalizations.of(context)!.addCmiCardLabel,
                          style: GoogleFonts.poppins(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          AppLocalizations.of(context)!.cmiCardDescription,
                          style: GoogleFonts.poppins(
                            fontSize: 13,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                    color: AppColors.textSecondary,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCardMethodTile(
    BuildContext context,
    PaymentMethod method,
    PaymentMethodsViewModel viewModel,
  ) {
    return InkWell(
      onTap: () async {
        final bool authenticated = await _authenticateWithBiometrics();
        if (authenticated && mounted) {
          _showCardDetails(context, method, viewModel);
        }
      },
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.border),
              ),
              child: Icon(
                Icons.credit_card,
                color: AppColors.mainAppPrimary,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        method.label,
                        style: GoogleFonts.poppins(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      if (method.isDefault) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppColors.success.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            AppLocalizations.of(context)!.defaultLabel,
                            style: GoogleFonts.poppins(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: AppColors.success,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    AppLocalizations.of(context)!.expiresLabel(method.expiryDisplay ?? ''),
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.more_vert,
              color: AppColors.textSecondary,
            ),
          ],
        ),
      ),
    );
  }

  void _showCardDetails(BuildContext context, PaymentMethod method, PaymentMethodsViewModel viewModel) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 20),
                
                // Card Visual
                Container(
                  height: 200,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        AppColors.mainAppPrimary,
                        AppColors.mainAppPrimary.withValues(alpha: 0.8),
                        AppColors.accent,
                      ],
                    ),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.mainAppPrimary.withValues(alpha: 0.4),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Logo CMI
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              'CMI',
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          // Logo marque
                          if (method.brand != null)
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                method.brand!.displayName.toUpperCase(),
                                style: GoogleFonts.poppins(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                        ],
                      ),
                      // Numéro de carte masqué
                      Text(
                        method.label,
                        style: GoogleFonts.poppins(
                          fontSize: 24,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                          letterSpacing: 2,
                          fontFeatures: const [FontFeature.tabularFigures()],
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                AppLocalizations.of(context)!.expiresShortLabel,
                                style: GoogleFonts.poppins(
                                  fontSize: 10,
                                  color: Colors.white.withValues(alpha: 0.7),
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                method.expiryDisplay ?? 'MM/AA',
                                style: GoogleFonts.poppins(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                          if (method.isDefault)
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: AppColors.success,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                AppLocalizations.of(context)!.defaultLabel,
                                style: GoogleFonts.poppins(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                
                // Actions
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {
                          Navigator.pop(context);
                          _showCardOptions(context, method, viewModel);
                        },
                        icon: const Icon(Icons.settings_outlined),
                        label: Text(
                          AppLocalizations.of(context)!.optionsButton,
                          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
                        ),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.mainAppPrimary,
                          side: BorderSide(color: AppColors.mainAppPrimary),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.check),
                        label: Text(
                          AppLocalizations.of(context)!.closeButton,
                          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.mainAppPrimary,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showCardOptions(BuildContext context, PaymentMethod method, PaymentMethodsViewModel viewModel) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header avec flèche retour et titre
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back),
                      onPressed: () {
                        Navigator.pop(context);
                        _showCardDetails(context, method, viewModel);
                      },
                    ),
                    Expanded(
                      child: Text(
                        method.label,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(width: 48), // Pour centrer le titre
                  ],
                ),
              ),
              const SizedBox(height: 16),
              // Option: Modifier les informations
              ListTile(
                leading: Icon(Icons.edit, color: AppColors.info),
                title: Text(
                  AppLocalizations.of(context)!.editCardInfo,
                  style: GoogleFonts.poppins(),
                ),
                onTap: () {
                  Navigator.pop(context);
                  _showEditCardScreen(context, method, viewModel);
                },
              ),
              if (!method.isDefault)
                ListTile(
                  leading: const Icon(Icons.star_border),
                  title: Text(
                    AppLocalizations.of(context)!.setAsDefaultCard,
                    style: GoogleFonts.poppins(),
                  ),
                  onTap: () async {
                    Navigator.pop(context);
                    final success = await viewModel.setDefaultMethod(method.id);
                    if (success && context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            AppLocalizations.of(context)!.cardSetDefaultSuccess,
                            style: GoogleFonts.poppins(),
                          ),
                          backgroundColor: AppColors.success,
                        ),
                      );
                    }
                  },
                ),
              ListTile(
                leading: Icon(Icons.delete_outline, color: AppColors.error),
                title: Text(
                  AppLocalizations.of(context)!.deleteCardLabel,
                  style: GoogleFonts.poppins(color: AppColors.error),
                ),
                enabled: viewModel.canDeleteMethod(method),
                onTap: () async {
                  Navigator.pop(context);
                  
                  // Vérifier si on peut supprimer
                  if (!viewModel.canDeleteMethod(method)) {
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            AppLocalizations.of(context)!.emptyPaymentMethodsAlert,
                            style: GoogleFonts.poppins(),
                          ),
                          backgroundColor: AppColors.error,
                        ),
                      );
                    }
                    return;
                  }
                  
                  // Confirmation
                  final confirmed = await showDialog<bool>(
                    context: context,
                    builder: (context) => AlertDialog(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      title: Text(
                        AppLocalizations.of(context)!.deleteCardConfirmTitle,
                        style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
                      ),
                      content: Text(
                        AppLocalizations.of(context)!.deleteCardConfirmContent(method.label),
                        style: GoogleFonts.poppins(),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context, false),
                          child: Text(
                            AppLocalizations.of(context)!.cancel,
                            style: GoogleFonts.poppins(),
                          ),
                        ),
                        TextButton(
                          onPressed: () => Navigator.pop(context, true),
                          child: Text(
                            AppLocalizations.of(context)!.deleteCardLabel,
                            style: GoogleFonts.poppins(
                              color: AppColors.error,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );

                  if (confirmed == true) {
                    final success = await viewModel.deleteMethod(method.id);
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            success ? AppLocalizations.of(context)!.cardDeletedSuccess : AppLocalizations.of(context)!.cardDeleteError,
                            style: GoogleFonts.poppins(),
                          ),
                          backgroundColor: success ? AppColors.success : AppColors.error,
                        ),
                      );
                    }
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showEditCardScreen(BuildContext context, PaymentMethod method, PaymentMethodsViewModel viewModel) {
    final TextEditingController labelController = TextEditingController(text: method.label);
    final TextEditingController expiryController = TextEditingController(text: method.expiryDisplay ?? '');

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back),
                      onPressed: () {
                        Navigator.pop(context);
                        _showCardOptions(context, method, viewModel);
                      },
                    ),
                    Expanded(
                      child: Text(
                        AppLocalizations.of(context)!.editCardTitle,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(width: 48),
                  ],
                ),
                const SizedBox(height: 24),
                
                // Card Visual (même que dans la vue détails)
                Container(
                  height: 200,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        AppColors.mainAppPrimary,
                        AppColors.mainAppPrimary.withValues(alpha: 0.8),
                        AppColors.accent,
                      ],
                    ),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.mainAppPrimary.withValues(alpha: 0.4),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              'CMI',
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          if (method.brand != null)
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                method.brand!.displayName.toUpperCase(),
                                style: GoogleFonts.poppins(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                        ],
                      ),
                      Text(
                        method.label,
                        style: GoogleFonts.poppins(
                          fontSize: 24,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                          letterSpacing: 2,
                          fontFeatures: const [FontFeature.tabularFigures()],
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                AppLocalizations.of(context)!.expiresShortLabel,
                                style: GoogleFonts.poppins(
                                  fontSize: 10,
                                  color: Colors.white.withValues(alpha: 0.7),
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                method.expiryDisplay ?? 'MM/AA',
                                style: GoogleFonts.poppins(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                          if (method.isDefault)
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: AppColors.success,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                AppLocalizations.of(context)!.defaultLabel,
                                style: GoogleFonts.poppins(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                
                // Info text
                Text(
                  AppLocalizations.of(context)!.editCardWarning,
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 16),
                
                // Form fields
                TextField(
                  controller: labelController,
                  decoration: InputDecoration(
                    labelText: AppLocalizations.of(context)!.cardLabelInput,
                    hintText: AppLocalizations.of(context)!.cardLabelHint,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    filled: true,
                    fillColor: AppColors.background,
                  ),
                  style: GoogleFonts.poppins(),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: expiryController,
                  decoration: InputDecoration(
                    labelText: AppLocalizations.of(context)!.expiryDateLabel,
                    hintText: 'MM/AA',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    filled: true,
                    fillColor: AppColors.background,
                  ),
                  style: GoogleFonts.poppins(),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 24),
                
                // Buttons
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          Navigator.pop(context);
                          _showCardOptions(context, method, viewModel);
                        },
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.textSecondary,
                          side: BorderSide(color: AppColors.border),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        child: Text(
                          AppLocalizations.of(context)!.cancel,
                          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                          // TODO: Implement actual update in viewModel
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                AppLocalizations.of(context)!.cardUpdatedSuccess,
                                style: GoogleFonts.poppins(),
                              ),
                              backgroundColor: AppColors.success,
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.mainAppPrimary,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        child: Text(
                          AppLocalizations.of(context)!.saveButton,
                          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFutureMethodsSection(BuildContext context) {
    final futureMethods = [
      _FutureMethod(
        icon: Icons.account_balance_wallet,
        name: AppLocalizations.of(context)!.futurePaypalLabel,
        description: AppLocalizations.of(context)!.futurePaypalDesc,
      ),
      _FutureMethod(
        icon: Icons.credit_card,
        name: AppLocalizations.of(context)!.futureStripeLabel,
        description: AppLocalizations.of(context)!.futureStripeDesc,
      ),
      _FutureMethod(
        icon: Icons.wallet,
        name: AppLocalizations.of(context)!.futureWalletLabel,
        description: AppLocalizations.of(context)!.futureWalletDesc,
      ),
    ];

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
        children: futureMethods.map((method) => _buildFutureMethodTile(method)).toList(),
      ),
    );
  }

  Widget _buildFutureMethodTile(_FutureMethod method) {
    return Opacity(
      opacity: 0.5,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(method.icon, color: Colors.grey[600]),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          method.name,
                          style: GoogleFonts.poppins(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          AppLocalizations.of(context)!.comingSoonBadge,
                          style: GoogleFonts.poppins(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey[600],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    method.description,
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      color: AppColors.textSecondary,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCashSection(BuildContext context, PaymentMethodsViewModel viewModel) {
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
                child: const Icon(
                  Icons.payments,
                  color: AppColors.success,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppLocalizations.of(context)!.cashPaymentLabel,
                      style: GoogleFonts.poppins(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      AppLocalizations.of(context)!.cashPaymentDesc,
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              Switch(
                value: viewModel.isCashEnabled,
                onChanged: (value) => viewModel.toggleCash(value),
                activeThumbColor: AppColors.success,
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            AppLocalizations.of(context)!.cashPaymentInfo,
            style: GoogleFonts.poppins(
              fontSize: 13,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard(BuildContext context, PaymentMethodsViewModel viewModel) {
    final policy = viewModel.paymentPolicy ?? PaymentPolicy.defaultPolicy();

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
          _buildInfoItem(
            icon: Icons.lock_outline,
            color: AppColors.mainAppPrimary,
            title: AppLocalizations.of(context)!.authCmiTitle,
            description: policy.preauthExplanation,
          ),
          const Divider(height: 24),
          _buildInfoItem(
            icon: Icons.payments_outlined,
            color: AppColors.success,
            title: AppLocalizations.of(context)!.onSitePaymentTitle,
            description: policy.cashExplanation,
          ),
          const Divider(height: 24),
          _buildInfoItem(
            icon: Icons.warning_amber_outlined,
            color: AppColors.warning,
            title: AppLocalizations.of(context)!.providerCancelTitle,
            description: policy.providerCancellationPolicy.penaltyDescription,
          ),
          const Divider(height: 24),
          _buildInfoItem(
            icon: Icons.schedule,
            color: AppColors.info,
            title: AppLocalizations.of(context)!.cmiIntegrationTitle,
            description: AppLocalizations.of(context)!.cmiIntegrationDesc(policy.cmiDocsAvailableFrom),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () => Navigator.pushNamed(context, AppRoutes.paymentPolicyInfo),
              icon: const Icon(Icons.info_outline),
              label: Text(
                AppLocalizations.of(context)!.learnMoreBtn,
                style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
              ),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.mainAppPrimary,
                side: BorderSide(color: AppColors.mainAppPrimary),
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoItem({
    required IconData icon,
    required Color color,
    required String title,
    required String description,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: color, size: 20),
        ),
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
              const SizedBox(height: 4),
              Text(
                description,
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  color: AppColors.textSecondary,
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyStateAlert(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.warning.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.warning.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Icon(Icons.info_outline, color: AppColors.warning),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              AppLocalizations.of(context)!.emptyPaymentMethodsAlert,
              style: GoogleFonts.poppins(
                fontSize: 13,
                color: AppColors.warning,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FutureMethod {
  final IconData icon;
  final String name;
  final String description;

  _FutureMethod({
    required this.icon,
    required this.name,
    required this.description,
  });
}
