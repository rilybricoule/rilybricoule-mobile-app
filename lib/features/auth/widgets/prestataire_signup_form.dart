import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/app_colors.dart';
import '../widgets/auth_textfield.dart';
import '../../../../l10n/app_localizations.dart';

class PrestataireSignUpForm extends StatefulWidget {
  final TextEditingController nameController;
  final TextEditingController emailController;
  final TextEditingController phoneController;
  final TextEditingController passwordController;
  final TextEditingController confirmPasswordController;
  final TextEditingController experienceController;
  final TextEditingController cityController;
  final TextEditingController descriptionController;
  final bool isObscure;
  final VoidCallback onToggleVisibility;
  final Function(String?) onCategoryChanged;

  const PrestataireSignUpForm({
    super.key,
    required this.nameController,
    required this.emailController,
    required this.phoneController,
    required this.passwordController,
    required this.confirmPasswordController,
    required this.experienceController,
    required this.cityController,
    required this.descriptionController,
    required this.isObscure,
    required this.onToggleVisibility,
    required this.onCategoryChanged,
  });

  @override
  State<PrestataireSignUpForm> createState() => _PrestataireSignUpFormState();
}

class _PrestataireSignUpFormState extends State<PrestataireSignUpForm> {
  String? _selectedCategory;

  List<String> _getCategories(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return [
      l10n.categoryPlumbing,
      l10n.categoryElectricity,
      l10n.categoryCleaning,
      l10n.categoryPainting,
      l10n.categoryHandyman,
      l10n.categoryGardening,
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AuthTextField(
          controller: widget.nameController,
          label: AppLocalizations.of(context)!.fullName,
          hint: AppLocalizations.of(context)!.nameHint,
          prefixIcon: Icons.person_outline,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return AppLocalizations.of(context)!.errorNameRequired;
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
        AuthTextField(
          controller: widget.emailController,
          label: AppLocalizations.of(context)!.email,
          hint: AppLocalizations.of(context)!.emailHint,
          prefixIcon: Icons.email_outlined,
          keyboardType: TextInputType.emailAddress,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return AppLocalizations.of(context)!.errorEmailRequired;
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
        AuthTextField(
          controller: widget.phoneController,
          label: AppLocalizations.of(context)!.phone,
          hint: AppLocalizations.of(context)!.phoneHint,
          prefixIcon: Icons.phone_outlined,
          keyboardType: TextInputType.phone,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return AppLocalizations.of(context)!.errorPhoneRequired;
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
        AuthTextField(
          controller: widget.passwordController,
          label: AppLocalizations.of(context)!.password,
          hint: AppLocalizations.of(context)!.passwordHint,
          prefixIcon: Icons.lock_outline,
          obscureText: widget.isObscure,
          suffixIcon: IconButton(
            icon: Icon(
              widget.isObscure ? Icons.visibility_off : Icons.visibility,
              color: AppColors.textSecondary,
            ),
            onPressed: widget.onToggleVisibility,
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return AppLocalizations.of(context)!.errorPasswordRequired;
            }
            if (value.length < 6) {
              return AppLocalizations.of(context)!.errorPasswordLength;
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
        AuthTextField(
          controller: widget.confirmPasswordController,
          label: AppLocalizations.of(context)!.confirmPassword,
          hint: AppLocalizations.of(context)!.confirmPasswordHint,
          prefixIcon: Icons.lock_outline,
          obscureText: widget.isObscure,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return AppLocalizations.of(context)!.errorConfirmPasswordRequired;
            }
            if (value != widget.passwordController.text) {
              return AppLocalizations.of(context)!.errorPasswordsNotMatch;
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
        DropdownButtonFormField<String>(
          initialValue: _selectedCategory,
          decoration: InputDecoration(
            labelText: AppLocalizations.of(context)!.serviceCategory,
            prefixIcon: const Icon(Icons.work_outline),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          items: _getCategories(context).map((category) {
            return DropdownMenuItem(
              value: category,
              child: Text(category),
            );
          }).toList(),
          onChanged: (value) {
            setState(() {
              _selectedCategory = value;
            });
            widget.onCategoryChanged(value);
          },
          validator: (value) {
            if (value == null || value.isEmpty) {
              return AppLocalizations.of(context)!.errorCategoryRequired;
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
        AuthTextField(
          controller: widget.experienceController,
          label: AppLocalizations.of(context)!.yearsOfExperience,
          hint: AppLocalizations.of(context)!.experienceHint,
          prefixIcon: Icons.timeline,
          keyboardType: TextInputType.number,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return AppLocalizations.of(context)!.errorExperienceRequired;
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
        AuthTextField(
          controller: widget.cityController,
          label: AppLocalizations.of(context)!.city,
          hint: AppLocalizations.of(context)!.cityHint,
          prefixIcon: Icons.location_city,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return AppLocalizations.of(context)!.errorCityRequired;
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
        AuthTextField(
          controller: widget.descriptionController,
          label: AppLocalizations.of(context)!.description,
          hint: AppLocalizations.of(context)!.descriptionHint,
          prefixIcon: Icons.description,
          maxLines: 3,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return AppLocalizations.of(context)!.errorDescriptionRequired;
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
        OutlinedButton.icon(
          onPressed: () {
            // TODO: Implement file picker
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(AppLocalizations.of(context)!.idUploadComingSoon)),
            );
          },
          icon: const Icon(Icons.upload_file),
          label: Text(
            AppLocalizations.of(context)!.uploadIdDocument,
            style: GoogleFonts.poppins(),
          ),
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16),
            side: BorderSide(color: AppColors.primary),
          ),
        ),
      ],
    );
  }
}
