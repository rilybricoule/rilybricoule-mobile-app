import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'core/routes/app_routes.dart';
import 'core/theme/app_theme.dart';
import 'core/constants/app_colors.dart';
import 'features/auth/data/mock_auth_repository.dart';
import 'features/auth/viewmodel/auth_viewmodel.dart';
import 'features/auth/view/splash_view.dart';
import 'features/auth/view/login_view.dart';
import 'features/auth/view/register_view.dart';
import 'features/auth/view/forgot_password_view.dart';
import 'features/auth/view/welcome_view.dart';
import 'features/client_main_view.dart';
import 'features/home/view/prestataire_dashboard_view.dart';
import 'features/home/providers/home_provider.dart';
import 'features/search/data/mock_search_repository.dart';
import 'features/search/viewmodel/search_viewmodel.dart';
import 'features/notifications/data/mock_notification_repository.dart';
import 'features/notifications/viewmodel/notification_viewmodel.dart';
import 'features/provider_profile/view/provider_profile_screen.dart';
import 'features/booking/view/booking_date_time_screen.dart';
import 'features/booking/view/booking_summary_view.dart';
import 'features/booking/view/booking_payment_view.dart';
import 'features/booking/view/booking_status_view.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Set status bar style
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
      ),
    );
    
    // Dependency Injection: Create repository instances
    final authRepository = MockAuthRepository();
    final searchRepository = MockSearchRepository();
    final notificationRepository = MockNotificationRepository();
    
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthViewModel(authRepository)),
        ChangeNotifierProvider(create: (_) => SearchViewModel(searchRepository)),
        ChangeNotifierProvider(create: (_) => NotificationViewModel(notificationRepository)),
        ChangeNotifierProvider(create: (_) => HomeProvider()),
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
          AppRoutes.home: (context) => const ClientMainView(),
          AppRoutes.prestataireDashboard: (context) => const PrestataireDashboardView(),
          AppRoutes.providerProfile: (context) => const ProviderProfileScreen(),
          AppRoutes.bookingDateTime: (context) => const BookingDateTimeScreen(),
          AppRoutes.bookingSummary: (context) => const BookingSummaryView(),
          AppRoutes.bookingPayment: (context) => const BookingPaymentView(),
          AppRoutes.bookingStatus: (context) => const BookingStatusView(),
        },
      ),
    );
  }
}
