import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../widgets/auth_textfield.dart';

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
          label: 'Full Name',
          hint: 'Enter your full name',
          prefixIcon: Icons.person_outline,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your name';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
        AuthTextField(
          controller: emailController,
          label: 'Email',
          hint: 'Enter your email',
          prefixIcon: Icons.email_outlined,
          keyboardType: TextInputType.emailAddress,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your email';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
        AuthTextField(
          controller: phoneController,
          label: 'Phone',
          hint: 'Enter your phone number',
          prefixIcon: Icons.phone_outlined,
          keyboardType: TextInputType.phone,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your phone';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
        AuthTextField(
          controller: passwordController,
          label: 'Password',
          hint: 'Enter your password',
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
              return 'Please enter your password';
            }
            if (value.length < 6) {
              return 'Password must be at least 6 characters';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
        AuthTextField(
          controller: confirmPasswordController,
          label: 'Confirm Password',
          hint: 'Confirm your password',
          prefixIcon: Icons.lock_outline,
          obscureText: isObscure,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please confirm your password';
            }
            if (value != passwordController.text) {
              return 'Passwords do not match';
            }
            return null;
          },
        ),
      ],
    );
  }
}
