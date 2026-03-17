import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:rilybricoule_mobile_app/l10n/app_localizations.dart';
import 'package:rilybricoule_mobile_app/core/constants/app_colors.dart';
import 'package:rilybricoule_mobile_app/domain/entities/payment_method_entity.dart';
import 'package:rilybricoule_mobile_app/features/booking/viewmodel/booking_payment_viewmodel.dart';
import 'package:rilybricoule_mobile_app/features/payment/views/add_payment_method_screen.dart';

/// Vue premium de paiement pour réservation
class BookingPaymentView extends StatelessWidget {
  final String? bookingId;
  final String? serviceName;
  final String? providerName;
  final double? servicePrice;
  final DateTime? scheduledDate;

  const BookingPaymentView({
    super.key,
    this.bookingId,
    this.serviceName,
    this.providerName,
    this.servicePrice,
    this.scheduledDate,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => BookingPaymentViewModel()..loadPaymentMethods(),
      child: const _BookingPaymentContent(),
    );
  }
}

class _BookingPaymentContent extends StatefulWidget {
  const _BookingPaymentContent();

  @override
  State<_BookingPaymentContent> createState() => _BookingPaymentContentState();
}

class _BookingPaymentContentState extends State<_BookingPaymentContent> {
  final TextEditingController _promoController = TextEditingController();
  bool _showAllCards = false;

  @override
  void dispose() {
    _promoController.dispose();
    super.dispose();
  }

  void _confirmPayment() async {
    final viewModel = context.read<BookingPaymentViewModel>();
    final success = await viewModel.confirmPayment();

    if (success && mounted) {
      _showSuccessDialog();
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: AppColors.success.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.check_circle, color: AppColors.success, size: 50),
            ),
            const SizedBox(height: 20),
            Text(
              AppLocalizations.of(context)!.preAuthDone,
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              AppLocalizations.of(context)!.preAuthDescription,
              style: GoogleFonts.poppins(fontSize: 14, color: AppColors.textSecondary),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pushReplacementNamed(context, '/booking-status');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.success,
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: Text(AppLocalizations.of(context)!.continueButton, style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600)),
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToAddCard() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const AddPaymentMethodScreen()),
    ).then((_) {
      if (mounted) {
        context.read<BookingPaymentViewModel>().refreshPaymentMethods();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          SafeArea(
            child: Column(
              children: [
                _buildAppBar(),
                Expanded(
                  child: Consumer<BookingPaymentViewModel>(
                    builder: (context, viewModel, child) {
                      if (viewModel.isLoading && viewModel.paymentMethods.isEmpty) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      return SingleChildScrollView(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Column(
                          children: [
                            const SizedBox(height: 16),
                            _buildServiceSummary(),
                            const SizedBox(height: 16),
                            _buildPriceBreakdown(),
                            const SizedBox(height: 16),
                            _buildPromoCodeSection(),
                            const SizedBox(height: 16),
                            _buildPaymentMethodsSection(),
                            const SizedBox(height: 16),
                            _buildSecurityInfo(),
                            const SizedBox(height: 100),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          _buildBottomBar(),
        ],
      ),
    );
  }

  Widget _buildAppBar() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 4, offset: const Offset(0, 2))],
      ),
      child: Column(
        children: [
          Row(
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
                  AppLocalizations.of(context)!.payment,
                  style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                AppLocalizations.of(context)!.step4Payment,
                style: GoogleFonts.poppins(fontSize: 10, fontWeight: FontWeight.w500, color: AppColors.textSecondary, letterSpacing: 0.5),
              ),
              Text('4 sur 5', style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.mainAppPrimary)),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: 0.8,
              backgroundColor: Colors.grey[200],
              valueColor: const AlwaysStoppedAnimation<Color>(AppColors.mainAppPrimary),
              minHeight: 6,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildServiceSummary() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, 2))],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Container(
              width: 70,
              height: 70,
              color: AppColors.mainAppPrimary.withValues(alpha: 0.1),
              child: const Icon(Icons.build, size: 32, color: AppColors.mainAppPrimary),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppLocalizations.of(context)!.leakRepair,
                  style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  Localizations.localeOf(context).languageCode == 'ar' ? 'أحمد المنصوري' : 'Ahmed El Mansouri',
                  style: GoogleFonts.poppins(fontSize: 14, color: AppColors.textSecondary),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.calendar_today, size: 14, color: Colors.grey[600]),
                    const SizedBox(width: 4),
                    Flexible(
                      child: Text(
                        '15 Jan 2024 • 10:30',
                        style: GoogleFonts.poppins(fontSize: 13, color: AppColors.textSecondary),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.success.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              AppLocalizations.of(context)!.confirmed,
              style: GoogleFonts.poppins(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.success),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPriceBreakdown() {
    return Consumer<BookingPaymentViewModel>(
      builder: (context, viewModel, child) {
        return Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, 2))],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(AppLocalizations.of(context)!.priceDetails, style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
              const SizedBox(height: 16),
              _buildPriceRow(AppLocalizations.of(context)!.service, '${viewModel.servicePrice.toInt()} MAD'),
              const SizedBox(height: 12),
              _buildPriceRow(AppLocalizations.of(context)!.platformFee, '${viewModel.platformFee.toInt()} MAD', helpText: AppLocalizations.of(context)!.platformFeeHelp),
              const SizedBox(height: 12),
              _buildPriceRow(AppLocalizations.of(context)!.serviceInsurance, '${viewModel.insuranceFee.toInt()} MAD', helpText: AppLocalizations.of(context)!.insuranceCoverage),
              if (viewModel.isPromoApplied) ...[
                const SizedBox(height: 12),
                _buildPriceRow(AppLocalizations.of(context)!.discountLabel(viewModel.appliedPromoCode ?? ''), '-${viewModel.discount.toInt()} MAD', color: AppColors.success, isDiscount: true),
              ],
              const SizedBox(height: 16),
              Divider(color: Colors.grey[300], thickness: 1),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(AppLocalizations.of(context)!.totalToPay, style: GoogleFonts.poppins(fontSize: 14, color: AppColors.textSecondary)),
                      Text(AppLocalizations.of(context)!.preAuthOnly, style: GoogleFonts.poppins(fontSize: 12, color: AppColors.success)),
                    ],
                  ),
                  Text(
                    '${viewModel.total.toInt()} MAD',
                    style: GoogleFonts.poppins(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.mainAppPrimary),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildPriceRow(String label, String amount, {Color? color, String? helpText, bool isDiscount = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Text(label, style: GoogleFonts.poppins(fontSize: 15, color: color ?? AppColors.textSecondary)),
            if (helpText != null) ...[
              const SizedBox(width: 4),
              Tooltip(message: helpText, child: Icon(Icons.info_outline, size: 16, color: Colors.grey[400])),
            ],
          ],
        ),
        Text(
          amount,
          style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.w600, color: isDiscount ? AppColors.success : (color ?? AppColors.textPrimary)),
        ),
      ],
    );
  }

  Widget _buildPromoCodeSection() {
    return Consumer<BookingPaymentViewModel>(
      builder: (context, viewModel, child) {
        return Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, 2))],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(AppLocalizations.of(context)!.promoCode, style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
              const SizedBox(height: 16),
              if (viewModel.isPromoApplied)
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.success.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.success),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.check_circle, color: AppColors.success, size: 20),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Code "${viewModel.appliedPromoCode}" appliqué (-${viewModel.discount.toInt()} MAD)',
                          style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.success),
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          viewModel.removePromoCode();
                          _promoController.clear();
                        },
                        icon: const Icon(Icons.close, size: 20),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                    ],
                  ),
                )
              else
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _promoController,
                        decoration: InputDecoration(
                          hintText: AppLocalizations.of(context)!.promoCodeHint,
                          hintStyle: GoogleFonts.poppins(fontSize: 14, color: AppColors.textSecondary),
                          filled: true,
                          fillColor: AppColors.background,
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                          prefixIcon: const Icon(Icons.local_offer_outlined),
                        ),
                        onChanged: viewModel.setPromoCode,
                        textCapitalization: TextCapitalization.characters,
                      ),
                    ),
                    const SizedBox(width: 12),
                    ElevatedButton(
                      onPressed: viewModel.promoCode.isEmpty || viewModel.isLoading
                          ? null
                          : () async {
                              final success = await viewModel.applyPromoCode();
                              if (!success && mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(AppLocalizations.of(context)!.invalidPromoCode, style: GoogleFonts.poppins()),
                                    backgroundColor: AppColors.error,
                                    behavior: SnackBarBehavior.floating,
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                  ),
                                );
                              }
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.mainAppPrimary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: viewModel.isLoading
                          ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                          : Text(AppLocalizations.of(context)!.apply, style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w600)),
                    ),
                  ],
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildPaymentMethodsSection() {
    return Consumer<BookingPaymentViewModel>(
      builder: (context, viewModel, child) {
        final savedCards = viewModel.savedCards;
        final hasCards = savedCards.isNotEmpty;
        final cashMethod = viewModel.cashMethod;

        return Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, 2))],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(AppLocalizations.of(context)!.paymentMethod, style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
                  if (hasCards)
                    TextButton.icon(
                      onPressed: _navigateToAddCard,
                      icon: const Icon(Icons.add, size: 18),
                      label: Text(AppLocalizations.of(context)!.add, style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w500)),
                    ),
                ],
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.info.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.info.withValues(alpha: 0.3)),
                ),
                child: Row(
                  children: [
                    Icon(Icons.shield_outlined, size: 20, color: AppColors.info),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        AppLocalizations.of(context)!.preAuthInfo,
                        style: GoogleFonts.poppins(fontSize: 12, color: AppColors.info, height: 1.4),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              if (hasCards) ...[
                Text('Vos cartes', style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w500, color: AppColors.textSecondary)),
                const SizedBox(height: 12),
                for (final card in savedCards.take(_showAllCards ? savedCards.length : 2))
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: _buildSavedCardTile(card, viewModel),
                  ),
                if (savedCards.length > 2)
                  TextButton(
                    onPressed: () => setState(() => _showAllCards = !_showAllCards),
                    child: Text(
                      _showAllCards ? 'Voir moins' : 'Voir toutes les cartes (${savedCards.length - 2}+)',
                      style: GoogleFonts.poppins(fontSize: 13, color: AppColors.mainAppPrimary),
                    ),
                  ),
                const SizedBox(height: 16),
              ] else ...[
                InkWell(
                  onTap: _navigateToAddCard,
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.mainAppPrimary.withValues(alpha: 0.05),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.mainAppPrimary.withValues(alpha: 0.3), style: BorderStyle.solid),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(color: AppColors.mainAppPrimary.withValues(alpha: 0.1), shape: BoxShape.circle),
                          child: const Icon(Icons.credit_card, color: AppColors.mainAppPrimary),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(AppLocalizations.of(context)!.addCard, style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
                              Text(AppLocalizations.of(context)!.securePreAuth, style: GoogleFonts.poppins(fontSize: 13, color: AppColors.textSecondary)),
                            ],
                          ),
                        ),
                        const Icon(Icons.arrow_forward_ios, size: 16, color: AppColors.mainAppPrimary),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
              ],
              if (cashMethod != null) ...[
                Text(AppLocalizations.of(context)!.orPayInCash, style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w500, color: AppColors.textSecondary)),
                const SizedBox(height: 12),
                _buildCashTile(cashMethod, viewModel),
              ],
            ],
          ),
        );
      },
    );
  }

  Widget _buildSavedCardTile(PaymentMethod card, BookingPaymentViewModel viewModel) {
    final isSelected = viewModel.selectedPaymentMethod?.id == card.id;

    return InkWell(
      onTap: () => viewModel.selectPaymentMethod(card),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.mainAppPrimary.withValues(alpha: 0.05) : Colors.grey[50],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: isSelected ? AppColors.mainAppPrimary : Colors.grey[300]!, width: isSelected ? 2 : 1),
        ),
        child: Row(
          children: [
            Container(
              width: 45,
              height: 32,
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(6), border: Border.all(color: Colors.grey[300]!)),
              child: Center(child: _getCardIcon(card.brand)),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    spacing: 8,
                    children: [
                      Text(
                        '${card.brand?.displayName ?? 'Carte'} •••• ${card.last4}',
                        style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
                      ),
                      if (card.isDefault)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(color: AppColors.mainAppPrimary.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(4)),
                          child: Text('Défaut', style: GoogleFonts.poppins(fontSize: 10, fontWeight: FontWeight.w600, color: AppColors.mainAppPrimary)),
                        ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text('Expire ${card.expiryDisplay}', style: GoogleFonts.poppins(fontSize: 12, color: AppColors.textSecondary)),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Checkbox(
              value: isSelected,
              onChanged: (value) => viewModel.selectPaymentMethod(card),
              activeColor: AppColors.mainAppPrimary,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCashTile(PaymentMethod cash, BookingPaymentViewModel viewModel) {
    final isSelected = viewModel.selectedPaymentMethod?.isCash == true;

    return InkWell(
      onTap: viewModel.selectCash,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected ? Colors.orange.withValues(alpha: 0.05) : Colors.grey[50],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: isSelected ? Colors.orange : Colors.grey[300]!, width: isSelected ? 2 : 1),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(color: Colors.orange.withValues(alpha: 0.1), shape: BoxShape.circle),
              child: const Icon(Icons.payments_outlined, color: Colors.orange, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(AppLocalizations.of(context)!.payOnSite, style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
                  Text(
                    AppLocalizations.of(context)!.payInCashOrCardToProvider,
                    style: GoogleFonts.poppins(fontSize: 12, color: AppColors.textSecondary),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Checkbox(
              value: isSelected,
              onChanged: (value) => viewModel.selectCash(),
              activeColor: Colors.orange,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _getCardIcon(CardBrand? brand) {
    IconData iconData;
    Color color;

    switch (brand) {
      case CardBrand.visa:
        iconData = Icons.credit_card;
        color = const Color(0xFF1A1F71);
        break;
      case CardBrand.mastercard:
        iconData = Icons.credit_card;
        color = const Color(0xFFEB001B);
        break;
      case CardBrand.cmi:
        iconData = Icons.credit_card;
        color = AppColors.mainAppPrimary;
        break;
      default:
        iconData = Icons.credit_card;
        color = Colors.grey;
    }

    return Icon(iconData, color: color, size: 24);
  }

  Widget _buildSecurityInfo() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.circular(12)),
      child: Column(
        children: [
          Row(
            children: [
              Icon(Icons.verified_user, size: 20, color: Colors.grey[700]),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  AppLocalizations.of(context)!.securePaymentSSL,
                  style: GoogleFonts.poppins(fontSize: 13, color: Colors.grey[700]),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Icon(Icons.shield, size: 20, color: Colors.grey[700]),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  AppLocalizations.of(context)!.buyerProtection,
                  style: GoogleFonts.poppins(fontSize: 13, color: Colors.grey[700]),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBottomBar() {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Consumer<BookingPaymentViewModel>(
        builder: (context, viewModel, child) {
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 10, offset: const Offset(0, -2))],
            ),
            child: SafeArea(
              top: false,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (viewModel.errorMessage != null)
                    Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(color: AppColors.error.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8)),
                      child: Row(
                        children: [
                          const Icon(Icons.error_outline, color: AppColors.error, size: 20),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(viewModel.errorMessage!, style: GoogleFonts.poppins(fontSize: 13, color: AppColors.error)),
                          ),
                        ],
                      ),
                    ),
                  ElevatedButton(
                    onPressed: viewModel.isLoading || !viewModel.canConfirm ? null : _confirmPayment,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.mainAppPrimary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      elevation: 0,
                      minimumSize: const Size(double.infinity, 56),
                    ),
                    child: viewModel.isLoading
                        ? const SizedBox(height: 24, width: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                        : Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(Icons.lock_outline, size: 20),
                                  const SizedBox(width: 8),
                                  Text(
                                    AppLocalizations.of(context)!.preAuthorizeAmount(viewModel.total.toInt()),
                                    style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600),
                                  ),
                                ],
                              ),
                              Text(
                                'Paiement après service • Annulation gratuite',
                                style: GoogleFonts.poppins(fontSize: 11, color: Colors.white.withValues(alpha: 0.8)),
                              ),
                            ],
                          ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
