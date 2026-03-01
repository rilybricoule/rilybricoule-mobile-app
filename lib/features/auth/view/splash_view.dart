import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../core/constants/app_assets.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/routes/app_routes.dart';
import '../../../data/datasources/firebase_auth_datasource.dart';
import '../../../data/repositories/firebase_auth_repository.dart';
import '../../../domain/repositories/auth_repository.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late final AuthRepository _authRepository;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );

    _controller.forward();
    
    _authRepository = FirebaseAuthRepository(FirebaseAuthDataSource());
    _navigateBasedOnAuth();
  }

  _navigateBasedOnAuth() async {
    await Future.delayed(const Duration(milliseconds: 1500));

    if (!mounted) return;

    // Check Firebase Auth state
    final currentUser = _authRepository.currentUser;
    
    if (currentUser != null) {
      // User is logged in, redirect based on role after build phase
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (currentUser.role.name == 'client') {
          Navigator.pushReplacementNamed(context, AppRoutes.home);
        } else {
          Navigator.pushReplacementNamed(context, AppRoutes.providerMain);
        }
      });
    } else {
      // User not logged in, go to welcome after build phase
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacementNamed(context, AppRoutes.welcome);
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

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
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.white,                           // Blanc pur en haut
              AppColors.primary.withOpacity(0.05),    // Très subtil bleu
              AppColors.secondary.withOpacity(0.03),  // Très subtil orange
            ],
          ),
        ),
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo
                Container(
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.secondary.withOpacity(0.2),
                        blurRadius: 30,
                        spreadRadius: 10,
                      ),
                    ],
                  ),
                  child: Image.asset(
                    AppAssets.providerImage,
                    width: 100,
                    height: 100,
                  ),
                ),

                const SizedBox(height: 40),

                // Loader
                SizedBox(
                  width: 35,
                  height: 35,
                  child: CircularProgressIndicator(
                    strokeWidth: 3,
                    valueColor: AlwaysStoppedAnimation<Color>(AppColors.secondary),
                    backgroundColor: AppColors.primary.withOpacity(0.2),
                  ),
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