import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import 'package:animate_do/animate_do.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/routes/app_routes.dart';
import '../../../models/user_role.dart';
import '../../../features/client_main_view.dart';
import '../../../features/prestataire/view/provider_main_view.dart';
import '../../profile/data/user_session.dart';
import '../viewmodel/auth_viewmodel.dart';
import '../widgets/auth_button.dart';
import '../widgets/client_signup_form.dart';
import '../widgets/prestataire_signup_form.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  UserRole _selectedRole = UserRole.client;
  
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  
  // Prestataire specific
  final _experienceController = TextEditingController();
  final _cityController = TextEditingController();
  final _descriptionController = TextEditingController();
  String? _selectedCategory;
  
  final _formKey = GlobalKey<FormState>();
  bool _agreedToTerms = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _experienceController.dispose();
    _cityController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authViewModel = Provider.of<AuthViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Account'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: AppColors.textPrimary,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: FadeInUp(
            duration: const Duration(milliseconds: 800),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Join Us!',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Create an account to get started',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                  ),
                  const SizedBox(height: 30),
                  
                  // Role Toggle
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                _selectedRole = UserRole.client;
                              });
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              decoration: BoxDecoration(
                                color: _selectedRole == UserRole.client
                                    ? AppColors.primary
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                'Client',
                                textAlign: TextAlign.center,
                                style: GoogleFonts.poppins(
                                  color: _selectedRole == UserRole.client
                                      ? Colors.white
                                      : AppColors.textSecondary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                _selectedRole = UserRole.prestataire;
                              });
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              decoration: BoxDecoration(
                                color: _selectedRole == UserRole.prestataire
                                    ? AppColors.primary
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                'Prestataire',
                                textAlign: TextAlign.center,
                                style: GoogleFonts.poppins(
                                  color: _selectedRole == UserRole.prestataire
                                      ? Colors.white
                                      : AppColors.textSecondary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),
                  
                  // Animated Form Switcher
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    child: _selectedRole == UserRole.client
                        ? ClientSignUpForm(
                            key: const ValueKey('client'),
                            nameController: _nameController,
                            emailController: _emailController,
                            phoneController: _phoneController,
                            passwordController: _passwordController,
                            confirmPasswordController: _confirmPasswordController,
                            isObscure: authViewModel.isObscure,
                            onToggleVisibility: () => authViewModel.toggleVisibility(),
                          )
                        : PrestataireSignUpForm(
                            key: const ValueKey('prestataire'),
                            nameController: _nameController,
                            emailController: _emailController,
                            phoneController: _phoneController,
                            passwordController: _passwordController,
                            confirmPasswordController: _confirmPasswordController,
                            experienceController: _experienceController,
                            cityController: _cityController,
                            descriptionController: _descriptionController,
                            isObscure: authViewModel.isObscure,
                            onToggleVisibility: () => authViewModel.toggleVisibility(),
                            onCategoryChanged: (value) {
                              _selectedCategory = value;
                            },
                          ),
                  ),
                  
                  const SizedBox(height: 20),
                  
                  // Terms & Privacy
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Checkbox(
                        value: _agreedToTerms,
                        onChanged: (value) {
                          setState(() {
                            _agreedToTerms = value ?? false;
                          });
                        },
                        activeColor: AppColors.primary,
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 12),
                          child: Wrap(
                            children: [
                              Text(
                                'I agree to the ',
                                style: TextStyle(fontSize: 13, color: Colors.grey[700]),
                              ),
                              GestureDetector(
                                onTap: () {},
                                child: Text(
                                  'Terms of Service',
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.w600,
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                              ),
                              Text(
                                ' and ',
                                style: TextStyle(fontSize: 13, color: Colors.grey[700]),
                              ),
                              GestureDetector(
                                onTap: () {},
                                child: Text(
                                  'Privacy Policy',
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.w600,
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  
                  AuthButton(
                    text: 'REGISTER',
                    isLoading: authViewModel.isLoading,
                    onPressed: () async {
                      if (!_agreedToTerms) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Please agree to Terms & Privacy')),
                        );
                        return;
                      }
                      if (_formKey.currentState!.validate()) {
                        final user = await authViewModel.register(
                          _emailController.text,
                          _passwordController.text,
                          _nameController.text,
                          _selectedRole,
                        );
                        if (user != null && context.mounted) {
                          // Save user session
                          await UserSession.saveUser(
                            id: user.uid,
                            name: user.fullName,
                            email: user.email,
                            memberSince: 'Janvier 2024',
                          );
                          
                          // Navigate directly using MaterialPageRoute
                          final isClient = user.role == UserRole.client;
                          if (context.mounted) {
                            debugPrint('RegisterView: DIRECT navigation to ${isClient ? "ClientMainView" : "ProviderMainView"}');
                            Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(
                                builder: (context) => isClient 
                                  ? const ClientMainView() 
                                  : const ProviderMainView(),
                              ),
                              (route) => false,
                            );
                          }
                        }
                      }
                    },
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Already have an account?"),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text('Login'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
