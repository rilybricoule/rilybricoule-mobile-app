import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import 'package:animate_do/animate_do.dart';
import '../../../core/constants/app_assets.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/routes/app_routes.dart';
import '../../../models/user_role.dart';
import '../../../features/client_main_view.dart';
import '../../../features/prestataire/view/provider_main_view.dart';
import '../../profile/data/user_session.dart';
import '../viewmodel/auth_viewmodel.dart';
import '../widgets/auth_button.dart';
import '../widgets/auth_textfield.dart';
import '../widgets/social_icon_button.dart';
import 'register_view.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _rememberMe = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authViewModel = Provider.of<AuthViewModel>(context);

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Top colored section with title
            FadeInDown(
              duration: const Duration(milliseconds: 800),
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.only(
                  top: MediaQuery.of(context).padding.top + 40,
                  bottom: 80,
                ),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      AppColors.primary,                    // Bleu
                      AppColors.primary.withOpacity(0.9),
                      AppColors.secondary.withOpacity(0.3), // Touch d'orange
                    ],
                  ),
                ),
                child: Column(
                  children: [
                    Text(
                      'Service Provider',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Welcome to the best service provider system!',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white.withOpacity(0.9),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),

            // Logo overlapping the colored section
            Transform.translate(
              offset: Offset(0, -60),
              child: FadeInUp(
                duration: const Duration(milliseconds: 1000),
                child: Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 20,
                        offset: Offset(0, 5),
                      ),
                    ],
                  ),
                  padding: EdgeInsets.all(20),
                  child: Image.asset(
                    AppAssets.providerImage,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),

            // Form section
            Transform.translate(
              offset: Offset(0, -40),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: FadeInUp(
                  duration: const Duration(milliseconds: 1200),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Email field
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 10,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                          child: AuthTextField(
                            controller: _emailController,
                            label: 'Email Address',
                            hint: 'johndoe@gmail.com',
                            prefixIcon: Icons.alternate_email,
                            keyboardType: TextInputType.emailAddress,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your email';
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Password field
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 10,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                          child: AuthTextField(
                            controller: _passwordController,
                            label: 'Password',
                            hint: '••••••••••',
                            prefixIcon: Icons.lock_outline,
                            obscureText: authViewModel.isObscure,
                            suffixIcon: IconButton(
                              icon: Icon(
                                authViewModel.isObscure
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                                color: Colors.grey,
                              ),
                              onPressed: () {
                                authViewModel.toggleVisibility();
                              },
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your password';
                              }
                              return null;
                            },
                          ),
                        ),

                        const SizedBox(height: 20),

// Divider
                        Row(
                          children: [
                            Expanded(child: Divider(color: Colors.grey.shade400)),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 16),
                              child: Text(
                                'or continue with',
                                style: TextStyle(color: Colors.grey[600], fontSize: 14),
                              ),
                            ),
                            Expanded(child: Divider(color: Colors.grey.shade400)),
                          ],
                        ),

                        const SizedBox(height: 20),

// Social Login Icons
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SocialIconButton(
                              provider: 'google',
                              onPressed: () async {
                                try {
                                  debugPrint('Starting Google Sign In...');
                                  final user = await authViewModel.signInWithGoogle(UserRole.client);
                                  debugPrint('Google Sign In result: $user');
                                  
                                  if (user != null && context.mounted) {
                                    debugPrint('User signed in: ${user.uid}, role: ${user.role}');
                                    await UserSession.saveUser(
                                      id: user.uid,
                                      name: user.fullName,
                                      email: user.email,
                                      memberSince: 'Janvier 2024',
                                    );
                                    
                                    // Store role locally before async gap
                                    final isClient = user.role == UserRole.client;
                                    
                                    // COMPLETELY reset navigation stack
                                    if (context.mounted) {
                                      try {
                                        debugPrint('LoginView: REPLACING all routes with ${isClient ? "ClientMainView" : "ProviderMainView"}');
                                        
                                        // Use the root navigator and clear everything
                                        Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
                                          PageRouteBuilder(
                                            pageBuilder: (context, animation1, animation2) => isClient 
                                              ? const ClientMainView() 
                                              : const ProviderMainView(),
                                            transitionDuration: Duration.zero,
                                            settings: const RouteSettings(name: '/home'),
                                          ),
                                          (route) => false,
                                        );
                                        
                                        debugPrint('LoginView: Navigation completed - should be on home now');
                                      } catch (e, stackTrace) {
                                        debugPrint('LoginView: Navigation ERROR: $e');
                                        debugPrint('LoginView: StackTrace: $stackTrace');
                                      }
                                    }
                                  } else if (context.mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('Google Sign In Failed. User is null.'),
                                        backgroundColor: AppColors.error,
                                      ),
                                    );
                                  }
                                } catch (e, stackTrace) {
                                  debugPrint('Google Sign In Error: $e');
                                  debugPrint('StackTrace: $stackTrace');
                                  if (context.mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text('Google Sign In Error: $e'),
                                        backgroundColor: AppColors.error,
                                      ),
                                    );
                                  }
                                }
                              },
                            ),
                            SizedBox(width: 16),
                            SocialIconButton(
                              provider: 'facebook',
                              onPressed: () async {
                                final user = await authViewModel.signInWithFacebook(UserRole.client);
                                if (user != null && context.mounted) {
                                  await UserSession.saveUser(
                                    id: user.uid,
                                    name: user.fullName,
                                    email: user.email,
                                    memberSince: 'Janvier 2024',
                                  );
                                  
                                  // Navigate directly using MaterialPageRoute
                                  final isClient = user.role == UserRole.client;
                                  if (context.mounted) {
                                    debugPrint('LoginView: DIRECT navigation to ${isClient ? "ClientMainView" : "ProviderMainView"}');
                                    Navigator.of(context).pushAndRemoveUntil(
                                      MaterialPageRoute(
                                        builder: (context) => isClient 
                                          ? const ClientMainView() 
                                          : const ProviderMainView(),
                                      ),
                                      (route) => false,
                                    );
                                  }
                                } else if (context.mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Facebook Sign In Failed.'),
                                      backgroundColor: AppColors.error,
                                    ),
                                  );
                                }
                              },
                            ),
                            SizedBox(width: 16),
                            SocialIconButton(
                              provider: 'apple',
                              onPressed: () async {
                                final user = await authViewModel.signInWithApple(UserRole.client);
                                if (user != null && context.mounted) {
                                  await UserSession.saveUser(
                                    id: user.uid,
                                    name: user.fullName,
                                    email: user.email,
                                    memberSince: 'Janvier 2024',
                                  );
                                  
                                  // Navigate directly using MaterialPageRoute
                                  final isClient = user.role == UserRole.client;
                                  if (context.mounted) {
                                    debugPrint('LoginView: DIRECT navigation to ${isClient ? "ClientMainView" : "ProviderMainView"}');
                                    Navigator.of(context).pushAndRemoveUntil(
                                      MaterialPageRoute(
                                        builder: (context) => isClient 
                                          ? const ClientMainView() 
                                          : const ProviderMainView(),
                                      ),
                                      (route) => false,
                                    );
                                  }
                                } else if (context.mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Apple Sign In Failed.'),
                                      backgroundColor: AppColors.error,
                                    ),
                                  );
                                }
                              },
                            ),
                          ],
                        ),

                        // After password field container
                        const SizedBox(height: 10),

// Remember Me Checkbox
                        Row(
                          children: [
                            Checkbox(
                              value: _rememberMe, // TODO: Connect to state later
                              onChanged: (value) {
                                setState(() {
                                  _rememberMe = value ?? false;
                                });
                              },
                              activeColor: AppColors.secondary,  // CHANGÉ: Orange au lieu de bleu
                            ),
                            Text(
                              'Remember me',
                              style: TextStyle(
                                color: Colors.grey[700],
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 5),  // Reduce spacing before social login

                        // Forgot password
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () {
                              Navigator.pushNamed(context, AppRoutes.forgotPassword);
                            },
                            child: Text(
                              'Forgot Password?',
                              style: TextStyle(
                                color: AppColors.primary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 10),

                        // Login button
                        AuthButton(
                          text: 'Login',
                          isLoading: authViewModel.isLoading,
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              final user = await authViewModel.login(
                                _emailController.text,
                                _passwordController.text,
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
                                  debugPrint('LoginView: DIRECT navigation to ${isClient ? "ClientMainView" : "ProviderMainView"}');
                                  Navigator.of(context).pushAndRemoveUntil(
                                    MaterialPageRoute(
                                      builder: (context) => isClient 
                                        ? const ClientMainView() 
                                        : const ProviderMainView(),
                                    ),
                                    (route) => false,
                                  );
                                }
                              } else if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Login Failed. Check credentials.'),
                                    backgroundColor: AppColors.error,
                                  ),
                                );
                              }
                            }
                          },
                        ),

                        const SizedBox(height: 30),

                        // Register link
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "You don't have an account?",
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 14,
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (_) => const RegisterView()),
                                );
                              },
                              child: Text(
                                'Register',
                                style: TextStyle(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
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
            ),
          ],
        ),
      ),
    );
  }
}