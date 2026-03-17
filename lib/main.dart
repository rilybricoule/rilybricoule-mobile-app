import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:rilybricoule_mobile_app/l10n/app_localizations.dart';
// Firebase
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'core/config/app_config.dart';
import 'core/routes/app_routes.dart';
import 'core/theme/app_theme.dart';
// Auth - Firebase & Backend
import 'data/datasources/firebase_auth_datasource.dart';
import 'data/datasources/backend_auth_datasource.dart';
import 'data/repositories/firebase_auth_repository.dart';
import 'data/repositories/hybrid_auth_repository.dart';
import 'domain/repositories/auth_repository.dart';
import 'features/auth/viewmodel/auth_viewmodel.dart';
// Profile
import 'domain/repositories/profile_repository.dart';
import 'features/profile/profile_service.dart';
// Payment
import 'domain/repositories/payment_repository.dart';
import 'features/payment/payment_service.dart';
// API Client
import 'services/api/api_client.dart';
// Services
import 'services/notifications/fcm_service.dart';
import 'services/remote_config/remote_config_service.dart';
// i18n / Language
import 'data/repositories/language_repository_impl.dart';
import 'features/language/viewmodel/language_viewmodel.dart';
// Views
import 'features/auth/view/splash_view.dart';
import 'features/auth/view/login_view.dart';
import 'features/auth/view/register_view.dart';
import 'features/auth/view/forgot_password_view.dart';
import 'features/auth/view/welcome_view.dart';
import 'features/client_main_view.dart';
import 'features/prestataire/view/provider_main_view.dart';
import 'features/home/providers/home_provider.dart';
// Search
import 'features/search/data/mock_search_repository.dart';
import 'features/search/viewmodel/search_viewmodel.dart';
// Discover Swipe
import 'features/discover_swipe/view/discover_swipe_view.dart';
import 'features/discover_swipe/viewmodel/discover_swipe_viewmodel.dart';
import 'features/discover_swipe/repository/mock_swipe_repository.dart';
// Notifications
import 'features/notifications/data/mock_notification_repository.dart';
import 'features/notifications/viewmodel/notification_viewmodel.dart';
// Provider Profile
import 'features/provider_profile/view/provider_profile_screen.dart';
// Booking
import 'features/booking/view/booking_date_time_screen.dart';
import 'features/booking/view/booking_summary_view.dart';
import 'features/booking/view/booking_payment_view.dart';
import 'features/booking/view/booking_status_view.dart';
// Reservations
import 'features/reservations/view/reservation_details_view.dart';
import 'features/reservations/view/rate_provider_view.dart';
import 'features/reservations/view/invoice_view.dart';
import 'features/reservations/data/mock_reservations_repository.dart';
// Chat
import 'features/chat/domain/chat_service.dart';
import 'features/chat/controllers/chat_thread_controller.dart';
import 'features/chat/presentation/screens/chat_thread_screen.dart';
import 'features/chat/domain/models/conversation.dart';
import 'features/prestataire/viewmodel/provider_state.dart';
// Profile
import 'features/profile/view/placeholder_screens.dart';
// Payment
import 'features/payment/views/payment_methods_screen.dart';
import 'features/payment/views/add_payment_method_screen.dart';
import 'features/payment/views/payment_policy_info_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  // Initialize API Client (for backend mode)
  ApiClient().initialize();
  
  // Initialize FCM Service
  await FCMService().initialize();
  
  // Initialize Remote Config
  await RemoteConfigService().initialize();
  
  // Initialize Language
  final languageRepo = LanguageRepositoryImpl();
  final languageViewModel = LanguageViewModel(languageRepo);
  await languageViewModel.loadSavedLocale();
  
  runApp(MyApp(languageViewModel: languageViewModel));
}

class MyApp extends StatelessWidget {
  final LanguageViewModel languageViewModel;
  
  const MyApp({super.key, required this.languageViewModel});

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
    // Auth Repository (Firebase-only or Hybrid Backend+Firebase based on config)
    final authDataSource = FirebaseAuthDataSource();
    final AuthRepository authRepository = AppConfig.USE_BACKEND_AUTH
        ? HybridAuthRepository(
            firebaseDataSource: authDataSource,
            backendDataSource: BackendAuthDataSource(),
          )
        : FirebaseAuthRepository(authDataSource);
    
    // Profile Repository (Firebase ou API selon config)
    final ProfileRepository profileRepository = ProfileService.createRepository();
    
    // Payment Repository (Mock pour développement, API quand CMI sera prêt)
    final PaymentRepository paymentRepository = PaymentService.createRepository();
    
    final searchRepository = MockSearchRepository();
    final swipeRepository = MockSwipeRepository();
    final notificationRepository = MockNotificationRepository();
    final chatRepository = ChatService().repository;
    
    return MultiProvider(
      providers: [
        Provider<AuthRepository>.value(value: authRepository),
        Provider<ProfileRepository>.value(value: profileRepository),
        Provider<PaymentRepository>.value(value: paymentRepository),
        ChangeNotifierProvider.value(value: languageViewModel),
        ChangeNotifierProvider(create: (_) => AuthViewModel(authRepository)),
        ChangeNotifierProvider(create: (_) => SearchViewModel(searchRepository)),
        ChangeNotifierProvider(create: (_) => DiscoverSwipeViewModel(searchRepository, swipeRepository)),
        ChangeNotifierProvider(
            create: (_) => NotificationViewModel(notificationRepository)),
        ChangeNotifierProvider(create: (_) => HomeProvider()),
        ChangeNotifierProvider(create: (_) => ProviderState()),
      ],
      child: Consumer<LanguageViewModel>(
        builder: (context, langVM, child) {
          return MaterialApp(
            title: 'RilyBricoule',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            // i18n configuration
            locale: langVM.currentLocale,
            supportedLocales: AppLocalizations.supportedLocales,
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            localeResolutionCallback: (locale, supportedLocales) {
              if (locale?.languageCode == 'ar') {
                return const Locale('ar', 'MA');
              }
              for (final supportedLocale in supportedLocales) {
                if (supportedLocale.languageCode == locale?.languageCode) {
                  return supportedLocale;
                }
              }
              return const Locale('fr');
            },
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
              AppRoutes.editProfile: (context) => const EditProfileScreen(),
              AppRoutes.paymentMethods: (context) => const PaymentMethodsScreen(),
              AppRoutes.addPaymentMethod: (context) => const AddPaymentMethodScreen(),
              AppRoutes.paymentPolicyInfo: (context) => const PaymentPolicyInfoScreen(),
              AppRoutes.favorites: (context) => const FavoritesScreen(),
              AppRoutes.help: (context) => const HelpScreen(),
              AppRoutes.about: (context) => const AboutScreen(),
              AppRoutes.discoverSwipe: (context) => const DiscoverSwipeView(),
            },
          );
        },
      ),
    );
  }
}
