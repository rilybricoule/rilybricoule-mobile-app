import 'package:flutter/material.dart';
import 'package:rilybricoule_mobile_app/l10n/app_localizations.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/app_colors.dart';
import '../../../domain/entities/add_payment_method_request.dart';
import '../../../domain/entities/payment_method_entity.dart';
import '../../../domain/repositories/payment_repository.dart';

/// ViewModel pour l'ajout d'une méthode de paiement
class AddPaymentMethodViewModel extends ChangeNotifier {
  final PaymentRepository _paymentRepository;

  // Controllers
  final TextEditingController cardNumberController = TextEditingController();
  final TextEditingController cardHolderController = TextEditingController();
  final TextEditingController expiryController = TextEditingController();
  final TextEditingController cvvController = TextEditingController();

  // État
  bool _isLoading = false;
  String? _errorMessage;
  bool _setAsDefault = true;
  CardBrand _detectedBrand = CardBrand.unknown;

  // Getters
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get setAsDefault => _setAsDefault;
  CardBrand get detectedBrand => _detectedBrand;

  AddPaymentMethodViewModel({
    required PaymentRepository paymentRepository,
  }) : _paymentRepository = paymentRepository {
    _initListeners();
  }

  void _initListeners() {
    cardNumberController.addListener(_onCardDataChanged);
    cardHolderController.addListener(_onCardDataChanged);
    expiryController.addListener(_onCardDataChanged);
  }

  void _onCardDataChanged() {
    _detectCardBrand();
    notifyListeners();
  }

  void _detectCardBrand() {
    final number = cardNumberController.text.replaceAll(' ', '');
    CardBrand brand = CardBrand.unknown;

    if (number.startsWith('4')) {
      brand = CardBrand.visa;
    } else if (RegExp(r'^(5[1-5]|2(2(2[1-9]|[3-9])|[3-6]|7([01]|20)))').hasMatch(number)) {
      brand = CardBrand.mastercard;
    } else if (RegExp(r'^(5374|5175|4582|4794|5133)').hasMatch(number)) {
      brand = CardBrand.cmi;
    }

    if (brand != _detectedBrand) {
      _detectedBrand = brand;
      notifyListeners();
    }
  }

  void toggleSetAsDefault(bool value) {
    _setAsDefault = value;
    notifyListeners();
  }

  // isValid and error getters are handled dynamically via context now
  // see validateField(context, field) and isValid(context)


  String? _validateCardNumber(BuildContext context) {
    final number = cardNumberController.text.replaceAll(' ', '');
    final l10n = AppLocalizations.of(context)!;
    if (number.isEmpty) return l10n.invalidCardNumber; // Using invalid for empty too to save keys
    if (number.length < 15) return l10n.invalidCardNumber;
    return null;
  }

  String? _validateCardHolder(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    if (cardHolderController.text.trim().isEmpty) return l10n.nameRequired;
    if (cardHolderController.text.trim().length < 3) return l10n.nameRequired;
    return null;
  }

  String? _validateExpiry(BuildContext context) {
    final expiry = expiryController.text;
    final l10n = AppLocalizations.of(context)!;
    if (expiry.isEmpty) return l10n.expiryRequired;
    if (!RegExp(r'^\d{2}/\d{2}$').hasMatch(expiry)) return l10n.invalidExpiry;

    final parts = expiry.split('/');
    final month = int.tryParse(parts[0]);
    final year = int.tryParse('20${parts[1]}');

    if (month == null || month < 1 || month > 12) return l10n.invalidExpiry;
    if (year == null || year < DateTime.now().year) return l10n.invalidExpiry;

    return null;
  }

  String? _validateCVV(BuildContext context) {
    final cvv = cvvController.text;
    final l10n = AppLocalizations.of(context)!;
    if (cvv.isEmpty) return l10n.invalidCvv;
    if (cvv.length < 3) return l10n.invalidCvv;
    return null;
  }

  String? validateField(BuildContext context, String field) {
    switch (field) {
      case 'cardNumber':
        return _validateCardNumber(context);
      case 'cardHolder':
        return _validateCardHolder(context);
      case 'expiry':
        return _validateExpiry(context);
      case 'cvv':
        return _validateCVV(context);
      default:
        return null;
    }
  }

  bool isValid(BuildContext context) {
    return _validateCardNumber(context) == null &&
        _validateCardHolder(context) == null &&
        _validateExpiry(context) == null &&
        _validateCVV(context) == null;
  }

  Future<bool> savePaymentMethod(BuildContext context) async {
    if (!isValid(context)) {
      _errorMessage = 'Validation error'; 
      notifyListeners();
      return false;
    }

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // Parser la date d'expiration
      final expiryParts = expiryController.text.split('/');
      final expMonth = int.parse(expiryParts[0]);
      final expYear = int.parse('20${expiryParts[1]}');

      final request = AddPaymentMethodRequest(
        type: PaymentMethodType.cmiCard,
        cardNumber: cardNumberController.text.replaceAll(' ', ''),
        cardHolderName: cardHolderController.text.trim(),
        expMonth: expMonth,
        expYear: expYear,
        cvv: cvvController.text,
        setAsDefault: _setAsDefault,
      );

      await _paymentRepository.addPaymentMethod(request);

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  @override
  void dispose() {
    cardNumberController.dispose();
    cardHolderController.dispose();
    expiryController.dispose();
    cvvController.dispose();
    super.dispose();
  }
}

/// Écran d'ajout d'une méthode de paiement (CMI Mock)
/// 
/// UI de saisie mock pour les cartes bancaires.
/// 
/// TODO Backend Avril 2025:
/// - Remplacer par: POST /payments/cmi/preauth-intent
/// - Ouvrir WebView/redirect CMI sécurisé
/// - Recevoir tokenized card ref
/// - Sauvegarder ref côté backend (NE JAMAIS stocker la carte en clair)
class AddPaymentMethodScreen extends StatelessWidget {
  const AddPaymentMethodScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AddPaymentMethodViewModel(
        paymentRepository: context.read<PaymentRepository>(),
      ),
      child: const _AddPaymentMethodContent(),
    );
  }
}

class _AddPaymentMethodContent extends StatelessWidget {
  const _AddPaymentMethodContent();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            _buildAppBar(context),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Card visual
                    _buildCardVisual(context),
                    const SizedBox(height: 24),

                    // Formulaire
                    _buildForm(context),
                    const SizedBox(height: 24),

                    // Option défaut
                    _buildDefaultOption(context),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
            _buildBottomBar(context),
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppLocalizations.of(context)!.addCardTitle,
                  style: GoogleFonts.poppins(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  AppLocalizations.of(context)!.cmiSubtitle,
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: AppColors.mainAppPrimary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCardVisual(BuildContext context) {
    return Consumer<AddPaymentMethodViewModel>(
      builder: (context, viewModel, child) {
        return Container(
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
                  if (viewModel.detectedBrand != CardBrand.unknown)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        viewModel.detectedBrand.displayName.toUpperCase(),
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                ],
              ),
              // Numéro de carte
              Text(
                _formatCardDisplay(viewModel.cardNumberController.text),
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
                        'TITULAIRE',
                        style: GoogleFonts.poppins(
                          fontSize: 10,
                          color: Colors.white.withValues(alpha: 0.7),
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        viewModel.cardHolderController.text.toUpperCase().isEmpty
                            ? AppLocalizations.of(context)!.nameHint
                            : viewModel.cardHolderController.text.toUpperCase(),
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
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
                        viewModel.expiryController.text.isEmpty
                            ? 'MM/AA'
                            : viewModel.expiryController.text,
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  String _formatCardDisplay(String cardNumber) {
    final cleaned = cardNumber.replaceAll(' ', '');
    if (cleaned.isEmpty) return '•••• •••• •••• ••••';

    final buffer = StringBuffer();
    for (int i = 0; i < 16; i++) {
      if (i < cleaned.length) {
        buffer.write(cleaned[i]);
      } else {
        buffer.write('•');
      }
      if ((i + 1) % 4 == 0 && i < 15) buffer.write(' ');
    }
    return buffer.toString();
  }

  Widget _buildForm(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
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
          _buildTextField(
            context,
            label: AppLocalizations.of(context)!.cardNumberLabel,
            hint: '1234 5678 9012 3456',
            controller: context.read<AddPaymentMethodViewModel>().cardNumberController,
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              _CardNumberFormatter(),
            ],
            maxLength: 19,
            prefixIcon: Icons.credit_card,
          ),
          const SizedBox(height: 16),
          _buildTextField(
            context,
            label: AppLocalizations.of(context)!.nameOnCardLabel,
            hint: AppLocalizations.of(context)!.nameHint,
            controller: context.read<AddPaymentMethodViewModel>().cardHolderController,
            textCapitalization: TextCapitalization.characters,
            prefixIcon: Icons.person_outline,
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildTextField(
                  context,
                  label: AppLocalizations.of(context)!.expiryDateLabel,
                  hint: 'MM/AA',
                  controller: context.read<AddPaymentMethodViewModel>().expiryController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    _ExpiryDateFormatter(),
                  ],
                  maxLength: 5,
                  prefixIcon: Icons.calendar_today,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildTextField(
                  context,
                  label: AppLocalizations.of(context)!.cvvLabel,
                  hint: '123',
                  controller: context.read<AddPaymentMethodViewModel>().cvvController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  maxLength: 4,
                  obscureText: true,
                  prefixIcon: Icons.lock_outline,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(
    BuildContext context, {
    required String label,
    required String hint,
    required TextEditingController controller,
    required IconData prefixIcon,
    TextInputType? keyboardType,
    List<TextInputFormatter>? inputFormatters,
    int? maxLength,
    bool obscureText = false,
    TextCapitalization textCapitalization = TextCapitalization.none,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          inputFormatters: inputFormatters,
          maxLength: maxLength,
          obscureText: obscureText,
          textCapitalization: textCapitalization,
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: GoogleFonts.poppins(
              fontSize: 16,
              color: AppColors.textSecondary.withValues(alpha: 0.5),
            ),
            prefixIcon: Icon(prefixIcon, color: AppColors.textSecondary),
            filled: true,
            fillColor: AppColors.background,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppColors.mainAppPrimary, width: 2),
            ),
            counterText: '',
          ),
        ),
      ],
    );
  }

  Widget _buildDefaultOption(BuildContext context) {
    return Consumer<AddPaymentMethodViewModel>(
      builder: (context, viewModel, child) {
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.border),
          ),
          child: Row(
            children: [
              Icon(
                Icons.star,
                color: AppColors.mainAppPrimary,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppLocalizations.of(context)!.setAsDefaultLabel,
                      style: GoogleFonts.poppins(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      AppLocalizations.of(context)!.setAsDefaultDescription,
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              Switch(
                value: viewModel.setAsDefault,
                onChanged: viewModel.toggleSetAsDefault,
                activeThumbColor: AppColors.mainAppPrimary,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildBottomBar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Consumer<AddPaymentMethodViewModel>(
          builder: (context, viewModel, child) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                  if (viewModel.errorMessage != null)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Text(
                        viewModel.errorMessage!,
                        style: GoogleFonts.poppins(
                          fontSize: 13,
                          color: AppColors.error,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: viewModel.isLoading
                          ? null
                          : () async {
                              final success = await viewModel.savePaymentMethod(context);
                              if (success && context.mounted) {
                                Navigator.pop(context, true);
                              }
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.mainAppPrimary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                      child: viewModel.isLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : Text(
                              AppLocalizations.of(context)!.saveCardButton,
                              style: GoogleFonts.poppins(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      );
  }
}

/// Formatter pour le numéro de carte (ajoute des espaces tous les 4 chiffres)
class _CardNumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final text = newValue.text.replaceAll(' ', '');
    final buffer = StringBuffer();

    for (int i = 0; i < text.length; i++) {
      buffer.write(text[i]);
      if ((i + 1) % 4 == 0 && i < text.length - 1) {
        buffer.write(' ');
      }
    }

    final newText = buffer.toString();
    return TextEditingValue(
      text: newText,
      selection: TextSelection.collapsed(offset: newText.length),
    );
  }
}

/// Formatter pour la date d'expiration (ajoute un / après 2 chiffres)
class _ExpiryDateFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final text = newValue.text.replaceAll('/', '');
    final buffer = StringBuffer();

    for (int i = 0; i < text.length; i++) {
      buffer.write(text[i]);
      if (i == 1 && text.length > 2) {
        buffer.write('/');
      }
    }

    final newText = buffer.toString();
    return TextEditingValue(
      text: newText,
      selection: TextSelection.collapsed(offset: newText.length),
    );
  }
}
