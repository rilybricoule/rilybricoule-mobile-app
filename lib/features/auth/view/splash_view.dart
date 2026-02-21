import 'package:flutter/material.dart';
import '../../../core/constants/app_assets.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/routes/app_routes.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

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
    _navigateToWelcome();
  }

  _navigateToWelcome() async {
    await Future.delayed(const Duration(milliseconds: 1500));

    if (mounted) {
      Navigator.pushReplacementNamed(context, AppRoutes.welcome);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
    );
  }
}