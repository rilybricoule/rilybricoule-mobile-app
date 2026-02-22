import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/routes/app_routes.dart';
import 'core/theme/app_theme.dart';
import 'features/auth/data/mock_auth_repository.dart';
import 'features/auth/viewmodel/auth_viewmodel.dart';
import 'features/auth/view/splash_view.dart';
import 'features/auth/view/login_view.dart';
import 'features/auth/view/register_view.dart';
import 'features/auth/view/forgot_password_view.dart';
import 'features/auth/view/welcome_view.dart';
import 'features/home/view/home_view.dart';
import 'features/home/view/prestataire_dashboard_view.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Dependency Injection: Create repository instance
    final authRepository = MockAuthRepository();
    
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthViewModel(authRepository)),
      ],
      child: MaterialApp(
        title: 'RilyBricoule',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        initialRoute: AppRoutes.splash,
        routes: {
          AppRoutes.splash: (context) => const SplashView(),
          AppRoutes.welcome: (context) => const WelcomeView(),
          AppRoutes.login: (context) => const LoginView(),
          AppRoutes.register: (context) => const RegisterView(),
          AppRoutes.forgotPassword: (context) => const ForgotPasswordView(),
          AppRoutes.home: (context) => const HomeView(),
          AppRoutes.prestataireDashboard: (context) => const PrestataireDashboardView(),
        },
      ),
    );
  }
}
