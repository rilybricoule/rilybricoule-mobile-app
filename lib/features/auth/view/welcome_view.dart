import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:animate_do/animate_do.dart';
import '../../../core/constants/app_assets.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/routes/app_routes.dart';
import '../widgets/language_picker.dart';
import '../widgets/social_icon_button.dart';

class WelcomeView extends StatelessWidget {
  const WelcomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (!didPop) SystemNavigator.pop();
      },
      child: Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.primary,
              AppColors.primary.withOpacity(0.8),
              AppColors.secondary.withOpacity(0.3),
            ],
          ),
        ),
        child: SafeArea(
          child: Stack(  // ← CHANGÉ ICI
            children: [
              // Main content
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const SizedBox(height: 50),  // Espace pour language picker

                    // Logo Section
                    Column(
                      children: [
                        FadeInDown(
                          duration: Duration(milliseconds: 1000),
                          child: Container(
                            padding: EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.secondary.withOpacity(0.3),
                                  blurRadius: 20,
                                  spreadRadius: 5,
                                ),
                              ],
                            ),
                            child: Image.asset(
                              AppAssets.providerImage,
                              width: 80,
                              height: 80,
                            ),
                          ),
                        ),

                        const SizedBox(height: 20),

                        FadeInUp(
                          delay: Duration(milliseconds: 300),
                          duration: Duration(milliseconds: 1000),
                          child: Text(
                            'Service Provider',
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              letterSpacing: 1.5,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),

                        const SizedBox(height: 8),

                        FadeInUp(
                          delay: Duration(milliseconds: 500),
                          duration: Duration(milliseconds: 1000),
                          child: Text(
                            'Your reliable service partner',
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.white.withOpacity(0.9),
                              fontWeight: FontWeight.w300,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),

                    // Bottom Section
                    Column(
                      children: [
                        // Social Login
                        FadeInUp(
                          delay: Duration(milliseconds: 600),
                          duration: Duration(milliseconds: 1000),
                          child: Column(
                            children: [
                              Text(
                                'Continue with',
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.9),
                                  fontSize: 12,
                                ),
                              ),
                              SizedBox(height: 12),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SocialIconButton(
                                    provider: 'google',
                                    onPressed: () => print('Google Sign In'),
                                  ),
                                  SizedBox(width: 10),
                                  SocialIconButton(
                                    provider: 'facebook',
                                    onPressed: () => print('Facebook Sign In'),
                                  ),
                                  SizedBox(width: 10),
                                  SocialIconButton(
                                    provider: 'apple',
                                    onPressed: () => print('Apple Sign In'),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 20),

                        FadeInUp(
                          delay: Duration(milliseconds: 700),
                          duration: Duration(milliseconds: 1000),
                          child: Row(
                            children: [
                              Expanded(child: Divider(color: Colors.white.withOpacity(0.5), thickness: 1)),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 12),
                                child: Text('or', style: TextStyle(color: Colors.white.withOpacity(0.9), fontSize: 12)),
                              ),
                              Expanded(child: Divider(color: Colors.white.withOpacity(0.5), thickness: 1)),
                            ],
                          ),
                        ),

                        const SizedBox(height: 20),

                        // Login Button - ORANGE
                        FadeInUp(
                          delay: Duration(milliseconds: 800),
                          duration: Duration(milliseconds: 1000),
                          child: Container(
                            width: double.infinity,
                            height: 50,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [AppColors.secondary, AppColors.secondary.withOpacity(0.8)],
                              ),
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.secondary.withOpacity(0.4),
                                  blurRadius: 12,
                                  offset: Offset(0, 6),
                                ),
                              ],
                            ),
                            child: ElevatedButton(
                              onPressed: () => Navigator.pushNamed(context, AppRoutes.login),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                shadowColor: Colors.transparent,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                              ),
                              child: Text(
                                'Login with Email',
                                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white),
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 12),

                        // Sign Up Button
                        FadeInUp(
                          delay: Duration(milliseconds: 900),
                          duration: Duration(milliseconds: 1000),
                          child: SizedBox(
                            width: double.infinity,
                            height: 50,
                            child: OutlinedButton(
                              onPressed: () => Navigator.pushNamed(context, AppRoutes.register),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: Colors.white,
                                backgroundColor: Colors.white.withOpacity(0.1),
                                side: BorderSide(color: AppColors.secondary, width: 2),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                              ),
                              child: Text('Sign Up', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                            ),
                          ),
                        ),

                        const SizedBox(height: 15),

                        // Terms & Privacy
                        FadeInUp(
                          delay: Duration(milliseconds: 1100),
                          duration: Duration(milliseconds: 1000),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              TextButton(
                                onPressed: () => print('Terms of Service'),
                                style: TextButton.styleFrom(padding: EdgeInsets.symmetric(horizontal: 4)),
                                child: Text('Terms', style: TextStyle(color: Colors.white.withOpacity(0.9), fontSize: 11, decoration: TextDecoration.underline)),
                              ),
                              Text('•', style: TextStyle(color: Colors.white.withOpacity(0.9), fontSize: 11)),
                              TextButton(
                                onPressed: () => print('Privacy Policy'),
                                style: TextButton.styleFrom(padding: EdgeInsets.symmetric(horizontal: 4)),
                                child: Text('Privacy', style: TextStyle(color: Colors.white.withOpacity(0.9), fontSize: 11, decoration: TextDecoration.underline)),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Language Picker PAR-DESSUS TOUT
              Positioned(
                top: 15,
                right: 20,
                child: FadeInDown(
                  duration: Duration(milliseconds: 800),
                  child: LanguagePicker(
                    iconColor: Colors.white,
                    backgroundColor: AppColors.secondary.withOpacity(0.2),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      ),
    );
  }
}