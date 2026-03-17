import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../widgets/auth_textfield.dart';
import '../../../../l10n/app_localizations.dart';

class ClientSignUpForm extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController emailController;
  final TextEditingController phoneController;
  final TextEditingController passwordController;
  final TextEditingController confirmPasswordController;
  final bool isObscure;
  final VoidCallback onToggleVisibility;

  const ClientSignUpForm({
    super.key,
    required this.nameController,
    required this.emailController,
    required this.phoneController,
    required this.passwordController,
    required this.confirmPasswordController,
    required this.isObscure,
    required this.onToggleVisibility,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AuthTextField(
          controller: nameController,
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
          controller: emailController,
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
          controller: phoneController,
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
          controller: passwordController,
          label: AppLocalizations.of(context)!.password,
          hint: AppLocalizations.of(context)!.passwordHint,
          prefixIcon: Icons.lock_outline,
          obscureText: isObscure,
          suffixIcon: IconButton(
            icon: Icon(
              isObscure ? Icons.visibility_off : Icons.visibility,
              color: AppColors.textSecondary,
            ),
            onPressed: onToggleVisibility,
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
          controller: confirmPasswordController,
          label: AppLocalizations.of(context)!.confirmPassword,
          hint: AppLocalizations.of(context)!.confirmPasswordHint,
          prefixIcon: Icons.lock_outline,
          obscureText: isObscure,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return AppLocalizations.of(context)!.errorConfirmPasswordRequired;
            }
            if (value != passwordController.text) {
              return AppLocalizations.of(context)!.errorPasswordsNotMatch;
            }
            return null;
          },
        ),
      ],
    );
  }
}
