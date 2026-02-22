import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/app_colors.dart';
import '../widgets/auth_textfield.dart';

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

  final List<String> _categories = [
    'Plomberie',
    'Électricité',
    'Ménage',
    'Peinture',
    'Bricolage',
    'Jardinage',
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AuthTextField(
          controller: widget.nameController,
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
          controller: widget.emailController,
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
          controller: widget.phoneController,
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
          controller: widget.passwordController,
          label: 'Password',
          hint: 'Enter your password',
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
          controller: widget.confirmPasswordController,
          label: 'Confirm Password',
          hint: 'Confirm your password',
          prefixIcon: Icons.lock_outline,
          obscureText: widget.isObscure,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please confirm your password';
            }
            if (value != widget.passwordController.text) {
              return 'Passwords do not match';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
        DropdownButtonFormField<String>(
          value: _selectedCategory,
          decoration: InputDecoration(
            labelText: 'Service Category',
            prefixIcon: const Icon(Icons.work_outline),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          items: _categories.map((category) {
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
              return 'Please select a category';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
        AuthTextField(
          controller: widget.experienceController,
          label: 'Years of Experience',
          hint: 'Enter years of experience',
          prefixIcon: Icons.timeline,
          keyboardType: TextInputType.number,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your experience';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
        AuthTextField(
          controller: widget.cityController,
          label: 'City',
          hint: 'Enter your city',
          prefixIcon: Icons.location_city,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your city';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
        AuthTextField(
          controller: widget.descriptionController,
          label: 'Description',
          hint: 'Tell us about your services',
          prefixIcon: Icons.description,
          maxLines: 3,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter a description';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
        OutlinedButton.icon(
          onPressed: () {
            // TODO: Implement file picker
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('ID upload - Coming soon')),
            );
          },
          icon: const Icon(Icons.upload_file),
          label: Text(
            'Upload ID Document',
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
