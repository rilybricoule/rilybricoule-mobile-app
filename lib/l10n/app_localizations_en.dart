// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'RilyBricoule';

  @override
  String get navHome => 'Home';

  @override
  String get navSearch => 'Search';

  @override
  String get navBooking => 'Booking';

  @override
  String get navMessages => 'Messages';

  @override
  String get navProfile => 'Profile';

  @override
  String get hello => 'Hello';

  @override
  String helloUser(String name) {
    return 'Hello, $name 👋';
  }

  @override
  String get locationHint => 'Location...';

  @override
  String get categories => 'Categories';

  @override
  String get seeAll => 'See all';

  @override
  String get nearbyProviders => 'Nearby providers';

  @override
  String get sortBy => 'Sort by';

  @override
  String get specialOffer => 'SPECIAL OFFER';

  @override
  String get promoDiscount => '20% off\nyour 1st Cleaning';

  @override
  String get bookNow => 'Book now';

  @override
  String get viewProfile => 'View profile';

  @override
  String reviewsCount(int count) {
    return '$count reviews';
  }

  @override
  String distanceKm(String distance) {
    return '$distance km';
  }

  @override
  String get categoryPlumbing => 'Plumbing';

  @override
  String get categoryElectricity => 'Electricity';

  @override
  String get categoryCleaning => 'Cleaning';

  @override
  String get categoryPainting => 'Painting';

  @override
  String get categoryHandyman => 'Handyman';

  @override
  String get categoryGardening => 'Gardening';

  @override
  String get categoryAC => 'Air conditioning';

  @override
  String get categoryCarpentry => 'Carpentry';

  @override
  String get categoryLocksmith => 'Locksmith';

  @override
  String get categoryMoving => 'Moving';

  @override
  String get categoryRepair => 'Repair';

  @override
  String get categoryOther => 'Other';

  @override
  String get allCategories => 'All categories';

  @override
  String get sortProviders => 'Sort providers';

  @override
  String get sortBestRated => 'Best rated';

  @override
  String get sortPriceLowToHigh => 'Price: Low to High';

  @override
  String get sortPriceHighToLow => 'Price: High to Low';

  @override
  String get sortNearest => 'Nearest distance';

  @override
  String get sortAvailableNow => 'Available now';

  @override
  String get reset => 'Reset';

  @override
  String get apply => 'Apply';

  @override
  String get searchService => 'Search for a service...';

  @override
  String get discoverSwipe => 'Discover by swiping';

  @override
  String get listView => 'List';

  @override
  String get mapView => 'Map';

  @override
  String providersFoundNearby(int count) {
    return '$count PROVIDERS FOUND NEAR YOU';
  }

  @override
  String get busy => 'BUSY';

  @override
  String get noProviderFound => 'No provider found';

  @override
  String get filters => 'Filters';

  @override
  String get resetAll => 'Reset all';

  @override
  String get priceRange => 'Price range (MAD)';

  @override
  String priceRangeValue(int min, int max) {
    return '$min - $max MAD';
  }

  @override
  String get rating => 'Rating';

  @override
  String get ratingAll => 'All';

  @override
  String get distance => 'Distance';

  @override
  String distanceRadius(int km) {
    return 'Within ${km}km radius';
  }

  @override
  String get availableNow => 'Available now';

  @override
  String get availableNowDescription => 'Show only providers ready to work';

  @override
  String get applyFilters => 'Apply filters';

  @override
  String get noMoreProviders => 'No more providers';

  @override
  String get discoverTitle => 'Discover';

  @override
  String get availableChip => 'Available';

  @override
  String get noMatchCriteria => 'No provider matches your criteria';

  @override
  String get resetFiltersBtn => 'Reset filters';

  @override
  String get backToSearch => 'Back to search';

  @override
  String addedToFavorites(String name) {
    return '$name added to favorites';
  }

  @override
  String get availableNowBadge => 'Available';

  @override
  String get topRatedBadge => 'Top rated';

  @override
  String get viewProfileBtn => 'View profile';

  @override
  String get errorGettingLocation => 'Unable to get your location';

  @override
  String get errorLoadingProviders => 'Error loading providers';

  @override
  String get locationPermissionRequired => 'Location permission required';

  @override
  String get locationPermissionDesc =>
      'We need your location to find providers near you';

  @override
  String get allowLocation => 'Allow location';

  @override
  String get gpsDisabled => 'GPS disabled';

  @override
  String get gpsDisabledDesc => 'Please enable your GPS to use this feature';

  @override
  String get enableLocation => 'Enable location';

  @override
  String get errorTitle => 'Error';

  @override
  String get errorOccurred => 'An error occurred';

  @override
  String get retry => 'Retry';

  @override
  String get noProvidersInYourArea =>
      'There are no providers available in your area';

  @override
  String get showList => 'Show list';

  @override
  String get noProviderInThisArea => 'No provider in this area';

  @override
  String get serviceProvider => 'Service Provider';

  @override
  String get yourReliablePartner => 'Your reliable service partner';

  @override
  String get continueWith => 'Continue with';

  @override
  String get loginWithEmail => 'Login with Email';

  @override
  String get signUp => 'Sign Up';

  @override
  String get or => 'or';

  @override
  String get termsLabel => 'Terms';

  @override
  String get privacyLabel => 'Privacy';

  @override
  String get welcomeBack => 'Service Provider';

  @override
  String get welcomeSubtitle => 'Welcome to the best service provider system!';

  @override
  String get emailAddress => 'Email Address';

  @override
  String get password => 'Password';

  @override
  String get rememberMe => 'Remember me';

  @override
  String get forgotPasswordLink => 'Forgot Password?';

  @override
  String get login => 'Login';

  @override
  String get orContinueWith => 'or continue with';

  @override
  String get loginFailed => 'Login Failed. Check credentials.';

  @override
  String get noAccount => 'You don\'t have an account?';

  @override
  String get createAccount => 'Create Account';

  @override
  String get joinUs => 'Join Us!';

  @override
  String get createAccountSubtitle => 'Create an account to get started';

  @override
  String get client => 'Client';

  @override
  String get prestataire => 'Provider';

  @override
  String get serviceCategory => 'Service Category';

  @override
  String get yearsOfExperience => 'Years of Experience';

  @override
  String get city => 'City';

  @override
  String get description => 'Description';

  @override
  String get uploadIdDocument => 'Upload ID Document';

  @override
  String get iAgreeToThe => 'I agree to the';

  @override
  String get termsOfService => 'Terms of Service';

  @override
  String get privacyPolicy => 'Privacy Policy';

  @override
  String get register => 'REGISTER';

  @override
  String get alreadyHaveAccount => 'Already have an account?';

  @override
  String get fullName => 'Full Name';

  @override
  String get email => 'Email';

  @override
  String get phone => 'Phone';

  @override
  String get confirmPassword => 'Confirm Password';

  @override
  String get forgotPassword => 'Forgot Password';

  @override
  String get resetPassword => 'Reset Password';

  @override
  String get enterEmailToReset => 'Enter your email to receive a reset link';

  @override
  String get sendResetLink => 'SEND RESET LINK';

  @override
  String get resetLinkSent => 'Reset link sent!';

  @override
  String get scheduling => 'Scheduling';

  @override
  String get errorMissingData => 'Error: Missing data';

  @override
  String get bookingProgress => 'BOOKING PROGRESS';

  @override
  String stepOf(int current, int total) {
    return 'Step $current of $total';
  }

  @override
  String get chooseDate => 'Choose a date';

  @override
  String get availableSlots => 'Available slots';

  @override
  String get morning => 'Morning';

  @override
  String get afternoon => 'Afternoon';

  @override
  String get confirmAddress => 'Confirm address';

  @override
  String get useRegisteredAddress => 'Use my registered address';

  @override
  String get noteForProvider => 'Note for provider';

  @override
  String get noteHint =>
      'Ex: Entry code 1234, intercom B, 3rd door on the left...';

  @override
  String get continueButton => 'Continue';

  @override
  String get summary => 'Summary';

  @override
  String get bookingDetails => 'Booking details';

  @override
  String get date => 'Date';

  @override
  String get time => 'Time';

  @override
  String get address => 'Address';

  @override
  String get note => 'Note';

  @override
  String get notDefined => 'Not defined';

  @override
  String get selectedService => 'Selected service';

  @override
  String get leakRepair => 'Leak repair';

  @override
  String get continueToPayment => 'Continue to payment';

  @override
  String get payment => 'Payment';

  @override
  String get step4Payment => 'STEP 4: PAYMENT';

  @override
  String stepCount(int current, int total) {
    return '$current of $total';
  }

  @override
  String get confirmed => 'Confirmed';

  @override
  String get priceDetails => 'Price details';

  @override
  String get service => 'Service';

  @override
  String get platformFee => 'Platform fee';

  @override
  String get platformFeeHelp => 'Security and customer support fee';

  @override
  String get serviceInsurance => 'Service insurance';

  @override
  String get insuranceCoverage => 'Coverage up to 10,000 MAD';

  @override
  String discountLabel(String code) {
    return 'Discount ($code)';
  }

  @override
  String get totalToPay => 'Total to pay';

  @override
  String get preAuthOnly => 'Pre-authorization only';

  @override
  String get promoCode => 'Promo code';

  @override
  String get promoCodeHint => 'Enter your code (e.g.: RILY20)';

  @override
  String promoCodeApplied(String code, int amount) {
    return 'Code \"$code\" applied (-$amount MAD)';
  }

  @override
  String get invalidPromoCode => 'Invalid promo code';

  @override
  String get paymentMethod => 'Payment method';

  @override
  String get addCard => 'Add a card';

  @override
  String get addCardSubtitle => 'For a secure pre-authorization';

  @override
  String get add => 'Add';

  @override
  String get yourCards => 'Your cards';

  @override
  String get defaultCard => 'Default';

  @override
  String expires(String date) {
    return 'Expires $date';
  }

  @override
  String seeMore(int count) {
    return 'See all cards ($count+)';
  }

  @override
  String get seeLess => 'See less';

  @override
  String get orPayCash => 'Or pay in cash';

  @override
  String get payOnSite => 'Pay on site';

  @override
  String get payOnSiteSubtitle => 'Pay in cash or card to the provider';

  @override
  String get preAuthInfo =>
      'Pre-authorization: the amount will be held on your card but debited only after service completion.';

  @override
  String get securePaymentSSL => 'Secure payment with 256-bit SSL encryption';

  @override
  String get buyerProtection => 'Buyer protection up to 10,000 MAD';

  @override
  String get preAuthDone => 'Pre-authorization done!';

  @override
  String get preAuthDescription =>
      'The amount has been blocked on your card. It will only be charged after service completion.';

  @override
  String get confirmation => 'Confirmation';

  @override
  String get bookingConfirmed => 'Booking confirmed!';

  @override
  String get bookingConfirmedMessage =>
      'Your request has been accepted. The handyman is waiting for you at the scheduled time.';

  @override
  String get serviceDetails => 'SERVICE DETAILS';

  @override
  String get contactProvider => 'Contact provider';

  @override
  String get viewMyBookings => 'View my bookings';

  @override
  String get backToHome => 'Back to home';

  @override
  String get myReservations => 'My Bookings';

  @override
  String get noUpcomingReservation => 'No upcoming bookings';

  @override
  String get noOngoingReservation => 'No ongoing bookings';

  @override
  String get noCompletedReservation => 'No completed bookings';

  @override
  String get noCancelledReservation => 'No cancelled bookings';

  @override
  String get exploreProviders => 'Explore providers';

  @override
  String errorLabel(String message) {
    return 'Error: $message';
  }

  @override
  String get reservationTracking => 'Booking tracking';

  @override
  String get cancelReservation => 'Cancel booking';

  @override
  String get cancelReservationQuestion => 'Cancel reservation?';

  @override
  String get reservationCancelled => 'Booking cancelled';

  @override
  String get cancelWarningText =>
      'You can cancel this reservation. This action is irreversible.';

  @override
  String get discuss => 'Chat';

  @override
  String chatWith(String providerName) {
    return 'Chat with $providerName';
  }

  @override
  String get statusConfirmed => 'Confirmed';

  @override
  String get statusEnRoute => 'En route';

  @override
  String get statusInProgress => 'In progress';

  @override
  String get statusCompleted => 'COMPLETED';

  @override
  String get statusCancelled => 'CANCELLED';

  @override
  String get statusNotStarted => 'Not started';

  @override
  String validatedAt(String time) {
    return 'Validated at $time';
  }

  @override
  String get providerArriving => 'Provider arriving';

  @override
  String arrivedAt(String time) {
    return 'Arrived at $time';
  }

  @override
  String get interventionInProgress => 'Intervention in progress';

  @override
  String completedAt(String time) {
    return 'Completed at $time';
  }

  @override
  String get serviceComplete => 'Service complete';

  @override
  String get bookingConfirmedHeader => 'Booking confirmed';

  @override
  String get providerStartsSoon => 'Your provider will start soon.';

  @override
  String get providerEnRouteHeader => 'Provider is en route';

  @override
  String providerLeftAppointment(String providerName) {
    return '$providerName has left their previous appointment.';
  }

  @override
  String get interventionInProgressHeader => 'Intervention in progress';

  @override
  String get providerWorkingNow => 'The provider is currently working.';

  @override
  String get serviceCompletedHeader => 'Service completed';

  @override
  String get thanksLeaveReview => 'Thank you! You can leave a review.';

  @override
  String get bookingCancelledHeader => 'Booking cancelled';

  @override
  String get bookingNoLongerActive => 'This booking is no longer active.';

  @override
  String get estimatedArrival => 'ESTIMATED ARRIVAL';

  @override
  String get minPlaceholder => 'min';

  @override
  String avisText(String count) {
    return '$count reviews';
  }

  @override
  String get back => 'Back';

  @override
  String get cancel => 'Cancel';

  @override
  String get chatDisabled => 'Chat disabled';

  @override
  String get leaveReview => 'Leave a review';

  @override
  String get callComingSoon => 'Call (coming soon)';

  @override
  String get contactSupport => 'Contact support';

  @override
  String get comingSoon => 'Feature coming soon';

  @override
  String get chatOnlyAfterBooking =>
      'Chat available only after confirmed booking';

  @override
  String get returnToReservations => 'Back to my bookings';

  @override
  String get howWasService => 'How was your service?';

  @override
  String rateExperience(String name) {
    return 'Rate your experience with $name';
  }

  @override
  String get whatDoYouThink => 'What do you think of the service?';

  @override
  String get yourCommentOptional => 'Your comment (optional)';

  @override
  String get describeExperience => 'Describe your experience...';

  @override
  String get submitReview => 'Submit review';

  @override
  String get pleaseSelectRating => 'Please select a rating';

  @override
  String get thankYouReview => 'Thank you for your review!';

  @override
  String get tagExcellent => 'Excellent service';

  @override
  String get tagPunctual => 'Punctual';

  @override
  String get tagNeatWork => 'Neat work';

  @override
  String get tagProfessional => 'Professional';

  @override
  String get tagRecommended => 'Recommended';

  @override
  String get profile => 'Profile';

  @override
  String get myActivity => 'My Activity';

  @override
  String get myReservationsMenu => 'My bookings';

  @override
  String get paymentMethods => 'Payment methods';

  @override
  String get favorites => 'Favorites';

  @override
  String get language => 'Language';

  @override
  String get helpCenter => 'Help center';

  @override
  String get about => 'About';

  @override
  String get logout => 'Logout';

  @override
  String get editProfile => 'Edit profile';

  @override
  String get toBeImplemented => '(To be implemented)';

  @override
  String languageChangedTo(String lang) {
    return 'Language changed: $lang';
  }

  @override
  String get chooseLanguage => 'Choose language';

  @override
  String get french => 'Français';

  @override
  String get english => 'English';

  @override
  String get arabic => 'العربية';

  @override
  String get tabUpcoming => 'Upcoming';

  @override
  String get tabOngoing => 'Ongoing';

  @override
  String get tabCompleted => 'Completed';

  @override
  String get tabCancelled => 'Cancelled';

  @override
  String get statusUpcoming => 'UPCOMING';

  @override
  String get statusOngoing => 'ONGOING';

  @override
  String get labelArrival => 'Arrival';

  @override
  String get btnLeaveReview => 'Leave a review';

  @override
  String get btnInvoice => 'Invoice';

  @override
  String get btnViewDetails => 'View details';

  @override
  String get msgNewMessage => 'New message';

  @override
  String get msgFindProviderToStart =>
      'Find a provider to start a conversation';

  @override
  String get msgMessagesTitle => 'Messages';

  @override
  String get msgOptionsSoon => 'Options (soon)';

  @override
  String get msgSearchConversation => 'Search for a conversation...';

  @override
  String get msgNoConversations => 'No conversations yet';

  @override
  String get msgConversationsAppearHere =>
      'Your conversations with providers will appear here after a booking or a first contact.';

  @override
  String get msgNoResults => 'No results';

  @override
  String get msgTryAnotherSearchTerm => 'Try another search term';

  @override
  String get msgResetSearch => 'Reset search';

  @override
  String memberSinceDate(String date) {
    return 'Member since $date';
  }

  @override
  String get supportAndInfo => 'Support & Info';

  @override
  String get aboutProvider => 'About';

  @override
  String get customerReviews => 'Customer reviews';

  @override
  String showAllReviews(int count) {
    return 'Show all $count reviews';
  }

  @override
  String get readMore => 'See more';

  @override
  String get readLess => 'See less';

  @override
  String get statusLabel => 'STATUS';

  @override
  String get certifiedStatus => 'Certified';

  @override
  String get missionsLabel => 'MISSIONS';

  @override
  String get responseLabel => 'RESPONSE';

  @override
  String get book => 'Book';

  @override
  String stepXofY(int step, int total) {
    return 'Step $step of $total';
  }

  @override
  String get btnContinue => 'Continue';

  @override
  String get securePreAuth => 'For a secure pre-authorization';

  @override
  String get orPayInCash => 'Or pay in cash';

  @override
  String get payInCashOrCardToProvider => 'Pay in cash or card to the provider';

  @override
  String preAuthorizeAmount(int amount) {
    return 'Pre-authorize $amount';
  }

  @override
  String get plumberExpert => 'Plumber Expert';

  @override
  String yearsExp(int years) {
    return '$years yrs exp.';
  }

  @override
  String get emailHint => 'johndoe@gmail.com';

  @override
  String get passwordHint => '••••••••••';

  @override
  String get nameHint => 'FIRST LAST NAME';

  @override
  String get phoneHint => 'Enter your phone number';

  @override
  String get confirmPasswordHint => 'Confirm your password';

  @override
  String get experienceHint => 'Enter years of experience';

  @override
  String get cityHint => 'Enter your city';

  @override
  String get descriptionHint => 'Tell us about your services';

  @override
  String get idUploadComingSoon => 'ID upload - Coming soon';

  @override
  String get agreeToTermsRequired => 'Please agree to Terms & Privacy';

  @override
  String get errorNameRequired => 'Please enter your name';

  @override
  String get errorEmailRequired => 'Please enter your email';

  @override
  String get errorPhoneRequired => 'Please enter your phone';

  @override
  String get errorPasswordRequired => 'Please enter your password';

  @override
  String get errorPasswordLength => 'Password must be at least 6 characters';

  @override
  String get errorConfirmPasswordRequired => 'Please confirm your password';

  @override
  String get errorPasswordsNotMatch => 'Passwords do not match';

  @override
  String get errorCategoryRequired => 'Please select a category';

  @override
  String get errorExperienceRequired => 'Please enter your experience';

  @override
  String get errorCityRequired => 'Please enter your city';

  @override
  String get errorDescriptionRequired => 'Please enter a description';

  @override
  String get notificationsTitle => 'Notifications';

  @override
  String get markAllAsRead => 'Mark all as read';

  @override
  String get deleteAll => 'Delete all';

  @override
  String get noNotificationsMsg => 'No notifications';

  @override
  String get noNotificationsDesc =>
      'You will be informed here of important updates.';

  @override
  String get deleteAllTitle => 'Delete all notifications';

  @override
  String get deleteAllDesc =>
      'Are you sure you want to delete all notifications?';

  @override
  String selectedCount(int count) {
    return '$count selected';
  }

  @override
  String get deleteAction => 'Delete';

  @override
  String get invoiceTitle => 'Invoice';

  @override
  String get shareComingSoon => 'Share coming soon';

  @override
  String get downloadComingSoon => 'Download coming soon';

  @override
  String get paidStatus => 'Paid';

  @override
  String get serviceDetailsTitle => 'Service Details';

  @override
  String get providerLabel => 'Provider';

  @override
  String get dateLabel => 'Date';

  @override
  String get timeLabel => 'Time';

  @override
  String get paymentDetailsTitle => 'Payment Details';

  @override
  String get serviceFeeLabel => 'Service Fee';

  @override
  String get taxLabel => 'VAT (20%)';

  @override
  String get totalTotalLabel => 'Total';

  @override
  String get paymentMethodLabel => 'Payment Method';

  @override
  String get creditCardLabel => 'Credit Card •••• 4242';

  @override
  String invoiceIssuedOn(String date) {
    return 'Invoice issued on $date';
  }

  @override
  String get downloadInvoiceBtn => 'Download Invoice';

  @override
  String invoiceNumber(String number) {
    return 'Invoice #$number';
  }

  @override
  String get onlinePaymentTitle => 'Online Payment';

  @override
  String get addCmiCardLabel => 'Add a card (CMI)';

  @override
  String get cmiCardDescription => 'Visa, Mastercard via CMI';

  @override
  String get paymentMethodsTitleLabel => 'Payment Methods';

  @override
  String expiresAt(String date) {
    return 'Expires $date';
  }

  @override
  String expiresLabel(String date) {
    return 'Expires $date';
  }

  @override
  String get expiresShortLabel => 'EXPIRES';

  @override
  String get expiryDateLabel => 'Expiration (MM/YY)';

  @override
  String get defaultCardChip => 'Default';

  @override
  String get defaultLabel => 'Default';

  @override
  String get authRequiredForCard => 'Please authenticate to view card details';

  @override
  String get editCardInfo => 'Edit Information';

  @override
  String get setAsDefaultCard => 'Set as Default';

  @override
  String get deleteCardLabel => 'Delete Card';

  @override
  String get howItWorksLabel => 'How do payments work?';

  @override
  String get learnMoreButton => 'Learn how we protect your transactions';

  @override
  String get emptyStateAlert =>
      'Add a card or enable cash on delivery to be able to make bookings.';

  @override
  String get addCardTitle => 'Add a card';

  @override
  String get cmiSubtitle => 'CMI - Interbank Electronic Banking Centre';

  @override
  String get nameOnCardLabel => 'Name on card';

  @override
  String get cardNumberLabel => 'Card number';

  @override
  String get cvvLabel => 'CVV';

  @override
  String get setAsDefaultLabel => 'Set as default card';

  @override
  String get setAsDefaultDescription =>
      'This card will be used by default for payments';

  @override
  String get saveCardButton => 'Save card';

  @override
  String get invalidCardNumber => 'Invalid card number';

  @override
  String get nameRequired => 'Name required';

  @override
  String get expiryRequired => 'Expiration date required';

  @override
  String get invalidExpiry => 'Invalid expiration';

  @override
  String get invalidCvv => 'Invalid CVV';

  @override
  String get deleteCardConfirmTitle => 'Delete this card?';

  @override
  String deleteCardConfirmContent(String cardLabel) {
    return 'Are you sure you want to delete $cardLabel?';
  }

  @override
  String get cardCannotBeDeleted => 'Cannot delete this card';

  @override
  String get cardDeletedSuccess => 'Card deleted';

  @override
  String get cardDeleteError => 'Error deleting card';

  @override
  String get cardSetDefaultSuccess => 'Card set as default';

  @override
  String get editCardTitle => 'Edit Card';

  @override
  String get editCardWarning =>
      'Note: Only the label and expiration date can be modified.';

  @override
  String get saveChanges => 'Save Changes';

  @override
  String get paymentInfoTitle => 'Payment Information';

  @override
  String get securePayment => 'Secure Payment';

  @override
  String get moneyProtected => 'Your money is protected';

  @override
  String get cmiPreauthDesc =>
      'RiLyBricoule uses the CMI pre-authorization system to ensure that you only pay for services actually performed.';

  @override
  String get cmiPreauth => 'CMI Pre-authorization';

  @override
  String get cmiPreauthDetail1 => 'The amount is BLOCKED on your credit card';

  @override
  String get cmiPreauthDetail2 => 'No immediate deduction is made';

  @override
  String get cmiPreauthDetail3 =>
      'The final deduction occurs AFTER the service is completed';

  @override
  String get cmiPreauthDetail4 =>
      'If cancelled, the block is lifted within 48 hours';

  @override
  String get cashPayment => 'Cash Payment';

  @override
  String get cashPaymentDetail1 => 'No online transaction';

  @override
  String get cashPaymentDetail2 => 'Reservation marked \'Pay on site\'';

  @override
  String get cashPaymentDetail3 => 'Pay the provider directly';

  @override
  String get cashPaymentDetail4 => 'Ideal for minor tasks';

  @override
  String get cancellationPolicy => 'Cancellation Policy';

  @override
  String cancellationDetail1(int maxCancels) {
    return 'Maximum $maxCancels cancellations/month allowed';
  }

  @override
  String get cancellationDetail2 => 'Beyond: visibility penalty';

  @override
  String get cancellationDetail3 => 'Repetition: temporary suspension possible';

  @override
  String get cancellationDetail4 => 'Goal: ensure service reliability';

  @override
  String get fullCmiIntegration => 'Full CMI Integration';

  @override
  String fullCmiIntegrationDesc(String date) {
    return 'Technical CMI documentation available in $date. Full integration with 3D Secure authentication and tokenization will be deployed on this date.';
  }

  @override
  String get fullCmiIntegrationDetail1 => '3D Secure authentication required';

  @override
  String get fullCmiIntegrationDetail2 =>
      'Card tokenization (never stored in plain text)';

  @override
  String get fullCmiIntegrationDetail3 => 'Secure redirection to CMI';

  @override
  String get fullCmiIntegrationDetail4 => 'Compliant with PCI DSS standards';

  @override
  String get maxSecurity => 'Maximum Security';

  @override
  String get encryptedData => 'Encrypted Data';

  @override
  String get encryptedDataDesc =>
      'All communications are 256-bit SSL encrypted';

  @override
  String get tokenization => 'Tokenization';

  @override
  String get tokenizationDesc => 'Card numbers are never stored in plain text';

  @override
  String get pciDss => 'PCI DSS Certification';

  @override
  String get pciDssDesc => 'Compliant with international security standards';

  @override
  String get cmiCentralBank => 'CMI - Central Bank';

  @override
  String get cmiCentralBankDesc =>
      'Bank intermediary approved by Bank Al-Maghrib';

  @override
  String get paymentSupportNote =>
      'For any questions regarding payments, contact our customer support available 7 days a week from 8 AM to 8 PM.';

  @override
  String get cardLabelInput => 'Label';

  @override
  String get cardLabelHint => 'E.g.: My personal card';

  @override
  String get cardExpiryInput => 'Expiration (MM/YY)';

  @override
  String get cardExpiryHint => 'MM/YY';

  @override
  String get saveButton => 'Save';

  @override
  String get closeButton => 'Close';

  @override
  String get optionsButton => 'Options';

  @override
  String get cardUpdatedSuccess => 'Card updated';

  @override
  String get futurePaypalLabel => 'PayPal';

  @override
  String get futurePaypalDesc => 'International payment';

  @override
  String get futureStripeLabel => 'Stripe';

  @override
  String get futureStripeDesc => 'International cards';

  @override
  String get futureWalletLabel => 'E-Wallet';

  @override
  String get futureWalletDesc => 'Mobile wallet payment';

  @override
  String get comingSoonBadge => 'Soon';

  @override
  String get onSitePaymentTitle => 'On-site Payment';

  @override
  String get cashPaymentLabel => 'Cash Payment';

  @override
  String get cashPaymentDesc => 'Pay directly on site';

  @override
  String get cashPaymentInfo =>
      'The booking will be marked as \'To be paid on site\'. No online transaction will be performed.';

  @override
  String get howItWorksTitle => 'How does it work?';

  @override
  String get authCmiTitle => 'CMI - Pre-authorization';

  @override
  String get providerCancelTitle => 'Provider Cancellation';

  @override
  String get cmiIntegrationTitle => 'Full CMI Integration';

  @override
  String cmiIntegrationDesc(String date) {
    return 'CMI documentation available in $date. Full integration with 3D Secure authentication will be available at that time.';
  }

  @override
  String get learnMoreBtn => 'Learn More';

  @override
  String get emptyPaymentMethodsAlert =>
      'Add a card or enable cash payment to be able to make bookings.';

  @override
  String get myServices => 'My Services';

  @override
  String servicesOfProvider(String name) {
    return 'Services by $name';
  }

  @override
  String get onlineStatus => 'Online';

  @override
  String get offlineStatus => 'Offline';

  @override
  String get writeMessageHint => 'Write a message...';

  @override
  String get recordingInProgress => 'Recording in progress...';

  @override
  String get today => 'Today';

  @override
  String get yesterday => 'Yesterday';

  @override
  String get copiedMessage => 'Message copied';

  @override
  String get copyText => 'Copy';

  @override
  String get deleteMessage => 'Delete';

  @override
  String get reportMessage => 'Report';

  @override
  String get makeCall => 'Make a Call';

  @override
  String get sendImage => 'Send an Image';

  @override
  String get shareLocationOption => 'Share my location';

  @override
  String get sendDocument => 'Send PDF / Document';

  @override
  String voiceMessageSent(int duration) {
    return 'Voice message sent (${duration}s)';
  }

  @override
  String get noMessages => 'No messages';

  @override
  String get dispatchTitle => 'Quick Request';

  @override
  String get dispatchSubtitle => 'Get a provider quickly without searching';

  @override
  String get dispatchChooseCategory => 'Choose a service';

  @override
  String get dispatchFormTitle => 'Request Details';

  @override
  String get dispatchAddress => 'Address';

  @override
  String get dispatchAddressHint => 'E.g.: 123 Mohammed V Street, Casablanca';

  @override
  String get dispatchAddressRequired => 'Address is required';

  @override
  String get dispatchPhone => 'Phone';

  @override
  String get dispatchPhoneRequired => 'Phone number is required';

  @override
  String get dispatchPhoneInvalid => 'Invalid phone number';

  @override
  String get dispatchNote => 'Note';

  @override
  String get dispatchNoteHint =>
      'Additional instructions or details (optional)';

  @override
  String get dispatchUrgency => 'Urgency';

  @override
  String get dispatchASAP => 'As soon as possible';

  @override
  String get dispatchSchedule => 'Schedule';

  @override
  String get dispatchSendRequest => 'Send Request';

  @override
  String get dispatchSelectedService => 'Selected service';

  @override
  String get dispatchChange => 'Change';

  @override
  String get dispatchStepCategory => 'Service';

  @override
  String get dispatchStepDetails => 'Details';

  @override
  String get dispatchStepSearch => 'Search';

  @override
  String get dispatchSearchingTitle => 'Searching';

  @override
  String get dispatchSearching => 'Searching for providers…';

  @override
  String dispatchSearchingCategory(String category) {
    return 'Request sent to $category providers';
  }

  @override
  String get dispatchCancelButton => 'Cancel Search';

  @override
  String get dispatchCancelTitle => 'Cancel request?';

  @override
  String get dispatchCancelMessage =>
      'Are you sure you want to cancel your dispatch request?';

  @override
  String get dispatchNo => 'No';

  @override
  String get dispatchYesCancel => 'Yes, cancel';

  @override
  String get dispatchExpiredTitle => 'No provider available';

  @override
  String get dispatchExpiredMessage =>
      'No provider responded in time. You can relaunch or choose manually.';

  @override
  String get dispatchRelaunch => 'Relaunch Search';

  @override
  String get dispatchChooseManually => 'Choose Manually';

  @override
  String get dispatchMatchTitle => 'Provider Found';

  @override
  String get dispatchMatchFound => 'A provider has accepted!';

  @override
  String get dispatchMatchSubtitle =>
      'Here is the provider who accepted your request';

  @override
  String get dispatchContinueWithProvider => 'Continue with this provider';

  @override
  String get dispatchReviews => 'reviews';

  @override
  String get dispatchDistance => 'Distance';

  @override
  String get dispatchPriceFrom => 'Starting from';

  @override
  String get dispatchRequestDetails => 'Request Details';

  @override
  String get dispatchService => 'Service';

  @override
  String get dispatchSearchButton => 'Quick Request (Dispatch)';

  @override
  String get dispatchSearchSubtext => 'Get a provider quickly';

  @override
  String get swipeFilterButton => 'Filter';

  @override
  String get swipeFilterTitle => 'Swipe to filter';

  @override
  String get swipeFilterHint => 'Swipe to keep or hide providers on the map';

  @override
  String get swipeFilterDone => 'Done';

  @override
  String get swipeFilterReset => 'Reset';

  @override
  String get swipeFilterDoneMessage => 'Filtering complete!';

  @override
  String get swipeFilterKept => 'providers kept';

  @override
  String get swipeFilterActive => 'providers filtered';
}
