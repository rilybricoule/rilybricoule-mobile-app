import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/routes/app_routes.dart';
import '../../../l10n/app_localizations.dart';
import '../viewmodel/dispatch_viewmodel.dart';

/// Screen 2: Dispatch request form (address, phone, note, urgency).
class DispatchRequestFormView extends StatefulWidget {
  const DispatchRequestFormView({super.key});

  @override
  State<DispatchRequestFormView> createState() => _DispatchRequestFormViewState();
}

class _DispatchRequestFormViewState extends State<DispatchRequestFormView> {
  final _addressController = TextEditingController();
  final _phoneController = TextEditingController();
  final _noteController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    final vm = context.read<DispatchViewModel>();
    // Pre-fill from previous data or profile
    _addressController.text = vm.address;
    _phoneController.text = vm.phone.isNotEmpty ? vm.phone : '+212 ';
  }

  @override
  void dispose() {
    _addressController.dispose();
    _phoneController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    final vm = context.read<DispatchViewModel>();
    vm.setAddress(_addressController.text.trim());
    vm.setPhone(_phoneController.text.trim());
    vm.setNote(_noteController.text.trim());

    // Navigate to searching and start dispatch
    Navigator.pushNamed(context, AppRoutes.dispatchSearching);
    vm.submitRequest();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            _buildAppBar(l10n),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Step indicator
                      _buildStepIndicator(l10n),
                      const SizedBox(height: 20),

                      // Service summary
                      _buildServiceSummary(l10n),
                      const SizedBox(height: 20),

                      // Address
                      _buildSectionTitle(l10n.dispatchAddress, Icons.location_on),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _addressController,
                        decoration: InputDecoration(
                          hintText: l10n.dispatchAddressHint,
                          hintStyle: GoogleFonts.poppins(fontSize: 14, color: AppColors.textSecondary),
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: AppColors.border),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: AppColors.border),
                          ),
                          prefixIcon: const Icon(Icons.location_on_outlined, color: AppColors.mainAppPrimary),
                        ),
                        validator: (v) => v == null || v.trim().isEmpty ? l10n.dispatchAddressRequired : null,
                      ),
                      const SizedBox(height: 20),

                      // Phone
                      _buildSectionTitle(l10n.dispatchPhone, Icons.phone),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _phoneController,
                        keyboardType: TextInputType.phone,
                        decoration: InputDecoration(
                          hintText: '+212 6XX XXX XXX',
                          hintStyle: GoogleFonts.poppins(fontSize: 14, color: AppColors.textSecondary),
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: AppColors.border),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: AppColors.border),
                          ),
                          prefixIcon: const Icon(Icons.phone_outlined, color: AppColors.mainAppPrimary),
                        ),
                        validator: (v) {
                          if (v == null || v.trim().isEmpty) return l10n.dispatchPhoneRequired;
                          if (v.trim().length < 8) return l10n.dispatchPhoneInvalid;
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),

                      // Note
                      _buildSectionTitle(l10n.dispatchNote, Icons.note),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _noteController,
                        maxLines: 3,
                        decoration: InputDecoration(
                          hintText: l10n.dispatchNoteHint,
                          hintStyle: GoogleFonts.poppins(fontSize: 14, color: AppColors.textSecondary),
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: AppColors.border),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: AppColors.border),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Urgency
                      _buildUrgencySection(l10n),
                      const SizedBox(height: 32),

                      // Submit button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _submit,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.mainAppPrimary,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 0,
                          ),
                          child: Text(
                            l10n.dispatchSendRequest,
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar(AppLocalizations l10n) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
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
              l10n.dispatchFormTitle,
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

  Widget _buildStepIndicator(AppLocalizations l10n) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          _buildStep(1, l10n.dispatchStepCategory, true),
          Expanded(child: Container(height: 2, color: AppColors.mainAppPrimary)),
          _buildStep(2, l10n.dispatchStepDetails, true),
          Expanded(child: Container(height: 2, color: AppColors.border)),
          _buildStep(3, l10n.dispatchStepSearch, false),
        ],
      ),
    );
  }

  Widget _buildStep(int num, String label, bool isActive) {
    return Column(
      children: [
        Container(
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            color: isActive ? AppColors.mainAppPrimary : AppColors.border,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              '$num',
              style: GoogleFonts.poppins(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: isActive ? Colors.white : AppColors.textSecondary,
              ),
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 10,
            color: isActive ? AppColors.mainAppPrimary : AppColors.textSecondary,
            fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
          ),
        ),
      ],
    );
  }

  Widget _buildServiceSummary(AppLocalizations l10n) {
    final vm = context.watch<DispatchViewModel>();
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.mainAppPrimary.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.mainAppPrimary.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.mainAppPrimary.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.flash_on, color: AppColors.mainAppPrimary, size: 24),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.dispatchSelectedService,
                  style: GoogleFonts.poppins(fontSize: 12, color: AppColors.textSecondary),
                ),
                Text(
                  vm.selectedCategoryName ?? '-',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.mainAppPrimary,
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Text(
              l10n.dispatchChange,
              style: GoogleFonts.poppins(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppColors.mainAppPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 18, color: AppColors.mainAppPrimary),
        const SizedBox(width: 8),
        Text(
          title,
          style: GoogleFonts.poppins(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }

  Widget _buildUrgencySection(AppLocalizations l10n) {
    final vm = context.watch<DispatchViewModel>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle(l10n.dispatchUrgency, Icons.schedule),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () => vm.setUrgent(true),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  decoration: BoxDecoration(
                    color: vm.isUrgent ? AppColors.mainAppPrimary : Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: vm.isUrgent ? AppColors.mainAppPrimary : AppColors.border,
                    ),
                  ),
                  child: Center(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.flash_on,
                          size: 18,
                          color: vm.isUrgent ? Colors.white : AppColors.textSecondary,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          l10n.dispatchASAP,
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: vm.isUrgent ? Colors.white : AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: GestureDetector(
                onTap: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now().add(const Duration(hours: 1)),
                    firstDate: DateTime.now(),
                    lastDate: DateTime.now().add(const Duration(days: 30)),
                  );
                  if (picked != null && mounted) {
                    final time = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.now(),
                    );
                    if (time != null) {
                      vm.setScheduledAt(DateTime(
                        picked.year, picked.month, picked.day,
                        time.hour, time.minute,
                      ));
                    }
                  }
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  decoration: BoxDecoration(
                    color: !vm.isUrgent ? AppColors.mainAppPrimary : Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: !vm.isUrgent ? AppColors.mainAppPrimary : AppColors.border,
                    ),
                  ),
                  child: Center(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.calendar_today,
                          size: 18,
                          color: !vm.isUrgent ? Colors.white : AppColors.textSecondary,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          l10n.dispatchSchedule,
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: !vm.isUrgent ? Colors.white : AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        if (vm.scheduledAt != null) ...[
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.success.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                const Icon(Icons.check_circle, color: AppColors.success, size: 16),
                const SizedBox(width: 8),
                Text(
                  '${vm.scheduledAt!.day}/${vm.scheduledAt!.month}/${vm.scheduledAt!.year} ${vm.scheduledAt!.hour.toString().padLeft(2, '0')}:${vm.scheduledAt!.minute.toString().padLeft(2, '0')}',
                  style: GoogleFonts.poppins(fontSize: 13, color: AppColors.success, fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }
}
