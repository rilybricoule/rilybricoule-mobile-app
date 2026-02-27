import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
import 'features/client_main_view.dart';
import 'features/home/view/provider/provider_main_view.dart';
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
import 'features/reservations/view/reservation_details_view.dart';
import 'features/reservations/view/rate_provider_view.dart';
import 'features/reservations/view/invoice_view.dart';
import 'features/reservations/data/mock_reservations_repository.dart';
import 'features/chat/domain/chat_service.dart';
import 'features/chat/controllers/chat_thread_controller.dart';
import 'features/chat/presentation/screens/chat_thread_screen.dart';
import 'features/chat/domain/models/conversation.dart';

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
    final chatRepository = ChatService().repository;
    
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthViewModel(authRepository)),
        ChangeNotifierProvider(create: (_) => SearchViewModel(searchRepository)),
        ChangeNotifierProvider(
            create: (_) => NotificationViewModel(notificationRepository)),
        ChangeNotifierProvider(create: (_) => HomeProvider()),
      ],
      child: MaterialApp(
        title: 'RilyBricoule',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        initialRoute: AppRoutes.splash,
        onGenerateRoute: (settings) {
          // Handle dynamic chat routes
          if (settings.name?.startsWith('/chat/') == true) {
            final conversationId = settings.name!.split('/').last;
            final conversation = settings.arguments as Conversation?;
            
            if (conversation != null) {
              return MaterialPageRoute(
                builder: (_) => ChangeNotifierProvider(
                  create: (_) => ChatThreadController(chatRepository, conversationId)
                    ..setConversation(conversation),
                  child: ChatThreadScreen(conversation: conversation),
                ),
              );
            }
          }
          
          // Handle other routes
          return null;
        },
        routes: {
          AppRoutes.splash: (context) => const SplashView(),
          AppRoutes.welcome: (context) => const WelcomeView(),
          AppRoutes.login: (context) => const LoginView(),
          AppRoutes.register: (context) => const RegisterView(),
          AppRoutes.forgotPassword: (context) => const ForgotPasswordView(),
          AppRoutes.home: (context) => const ClientMainView(),
          AppRoutes.providerMain: (context) => const ProviderMainView(),
          AppRoutes.providerProfile: (context) => const ProviderProfileScreen(),
          AppRoutes.bookingDateTime: (context) => const BookingDateTimeScreen(),
          AppRoutes.bookingSummary: (context) => const BookingSummaryView(),
          AppRoutes.bookingPayment: (context) => const BookingPaymentView(),
          AppRoutes.bookingStatus: (context) => const BookingStatusView(),
          AppRoutes.reservationDetails: (context) {
            final args = ModalRoute.of(context)?.settings.arguments;
            String reservationId = '1';
            MockReservationsRepository? listRepository;
            
            if (args is String) {
              reservationId = args;
            } else if (args is Map) {
              reservationId = args['reservationId'] as String? ?? '1';
              listRepository = args['listRepository'] as MockReservationsRepository?;
            }
            
            return ReservationDetailsView(
              reservationId: reservationId,
              listRepository: listRepository,
            );
          },
          AppRoutes.leaveReview: (context) {
            final reservationId = ModalRoute.of(context)?.settings.arguments as String? ?? '1';
            return RateProviderView(reservationId: reservationId);
          },
          AppRoutes.invoice: (context) {
            final reservationId = ModalRoute.of(context)?.settings.arguments as String? ?? '1';
            return InvoiceView(reservationId: reservationId);
          },
        },
      ),
    );
  }
}
