class AppRoutes {
  static const String splash = '/';
  static const String login = '/login';
  static const String register = '/register';
  static const String forgotPassword = '/forgot_password';
  static const String welcome = '/welcome';
  static const String home = '/home';
  static const String providerMain = '/provider-main';
  static const String providerProfile = '/provider-profile';
  static const String bookingDateTime = '/booking-date-time';
  static const String bookingSummary = '/booking-summary';
  static const String bookingPayment = '/booking-payment';
  static const String bookingStatus = '/booking-status';
  static const String reservationDetails = '/reservation-details';
  static const String leaveReview = '/leave-review';
  static const String invoice = '/invoice';
  static const String tracking = '/tracking';
  static const String messages = '/messages';
  static const String editProfile = '/edit-profile';
  static const String paymentMethods = '/payment-methods';
  static const String addPaymentMethod = '/add-payment-method';
  static const String paymentPolicyInfo = '/payment-policy-info';
  static const String favorites = '/favorites';
  static const String help = '/help';
  static const String about = '/about';
  static const String discoverSwipe = '/discover-swipe';
  
  // Dispatch routes
  static const String dispatchStart = '/dispatch/start';
  static const String dispatchForm = '/dispatch/form';
  static const String dispatchSearching = '/dispatch/searching';
  static const String dispatchMatch = '/dispatch/match';
  
  // Dynamic route for chat thread
  static String chatThread(String conversationId) => '/chat/$conversationId';
}
