// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appName => 'ريلي بريكول';

  @override
  String get navHome => 'الرئيسية';

  @override
  String get navSearch => 'البحث';

  @override
  String get navBooking => 'الحجز';

  @override
  String get navMessages => 'الرسائل';

  @override
  String get navProfile => 'الملف الشخصي';

  @override
  String get hello => 'مرحباً';

  @override
  String helloUser(String name) {
    return 'مرحباً، $name 👋';
  }

  @override
  String get locationHint => 'الموقع...';

  @override
  String get categories => 'الفئات';

  @override
  String get seeAll => 'عرض الكل';

  @override
  String get nearbyProviders => 'مزودون قريبون';

  @override
  String get sortBy => 'ترتيب حسب';

  @override
  String get specialOffer => 'عرض خاص';

  @override
  String get promoDiscount => 'خصم 20%\nعلى أول تنظيف';

  @override
  String get bookNow => 'احجز الآن';

  @override
  String get viewProfile => 'عرض الملف';

  @override
  String reviewsCount(int count) {
    return '$count تقييم';
  }

  @override
  String distanceKm(String distance) {
    return '$distance كم';
  }

  @override
  String get categoryPlumbing => 'السباكة';

  @override
  String get categoryElectricity => 'الكهرباء';

  @override
  String get categoryCleaning => 'التنظيف';

  @override
  String get categoryPainting => 'الطلاء';

  @override
  String get categoryHandyman => 'الصيانة';

  @override
  String get categoryGardening => 'البستنة';

  @override
  String get categoryAC => 'التكييف';

  @override
  String get categoryCarpentry => 'النجارة';

  @override
  String get categoryLocksmith => 'الأقفال';

  @override
  String get categoryMoving => 'النقل';

  @override
  String get categoryRepair => 'الإصلاح';

  @override
  String get categoryOther => 'أخرى';

  @override
  String get allCategories => 'جميع الفئات';

  @override
  String get sortProviders => 'ترتيب مزودي الخدمة';

  @override
  String get sortBestRated => 'الأعلى تقييماً';

  @override
  String get sortPriceLowToHigh => 'السعر: من الأقل للأعلى';

  @override
  String get sortPriceHighToLow => 'السعر: من الأعلى للأقل';

  @override
  String get sortNearest => 'الأقرب مسافة';

  @override
  String get sortAvailableNow => 'متاح الآن';

  @override
  String get reset => 'إعادة تعيين';

  @override
  String get apply => 'تطبيق';

  @override
  String get searchService => 'البحث عن خدمة...';

  @override
  String get discoverSwipe => 'اكتشف بالتمرير';

  @override
  String get listView => 'قائمة';

  @override
  String get mapView => 'خريطة';

  @override
  String providersFoundNearby(int count) {
    return '$count مزود خدمة قريب منك';
  }

  @override
  String get busy => 'مشغول';

  @override
  String get noProviderFound => 'لم يتم العثور على مزود خدمة';

  @override
  String get filters => 'المرشحات';

  @override
  String get resetAll => 'إعادة تعيين الكل';

  @override
  String get priceRange => 'نطاق السعر (درهم)';

  @override
  String priceRangeValue(int min, int max) {
    return '$min - $max درهم';
  }

  @override
  String get rating => 'التقييم';

  @override
  String get ratingAll => 'الكل';

  @override
  String get distance => 'المسافة';

  @override
  String distanceRadius(int km) {
    return 'ضمن نطاق $km كم';
  }

  @override
  String get availableNow => 'متوفر الآن';

  @override
  String get availableNowDescription => 'عرض فقط مزودي الخدمة المتاحين';

  @override
  String get applyFilters => 'تطبيق المرشحات';

  @override
  String get noMoreProviders => 'لا يوجد المزيد من مزودي الخدمة';

  @override
  String get discoverTitle => 'اكتشف';

  @override
  String get availableChip => 'متاح';

  @override
  String get noMatchCriteria => 'لا يوجد مزود خدمة يطابق معاييرك';

  @override
  String get resetFiltersBtn => 'إعادة تعيين المرشحات';

  @override
  String get backToSearch => 'العودة إلى البحث';

  @override
  String addedToFavorites(String name) {
    return 'تمت إضافة $name إلى المفضلة';
  }

  @override
  String get availableNowBadge => 'متاح';

  @override
  String get topRatedBadge => 'أعلى تقييماً';

  @override
  String get viewProfileBtn => 'عرض الملف الشخصي';

  @override
  String get errorGettingLocation => 'تعذر الحصول على موقعك';

  @override
  String get errorLoadingProviders => 'حدث خطأ أثناء تحميل المزودين';

  @override
  String get locationPermissionRequired => 'مطلوب إذن الموقع';

  @override
  String get locationPermissionDesc =>
      'نحتاج إلى موقعك للعثور على مزودين بالقرب منك';

  @override
  String get allowLocation => 'السماح بالموقع';

  @override
  String get gpsDisabled => 'نظام تحديد المواقع معطل';

  @override
  String get gpsDisabledDesc =>
      'يرجى تمكين نظام تحديد المواقع لاستخدام هذه الميزة';

  @override
  String get enableLocation => 'تفعيل الموقع';

  @override
  String get errorTitle => 'خطأ';

  @override
  String get errorOccurred => 'حدث خطأ ما';

  @override
  String get retry => 'إعادة المحاولة';

  @override
  String get noProvidersInYourArea => 'لا يوجد مزودون متاحون في منطقتك';

  @override
  String get showList => 'إظهار القائمة';

  @override
  String get noProviderInThisArea => 'لا يوجد مزود في هذه المنطقة';

  @override
  String get serviceProvider => 'مزود خدمة';

  @override
  String get yourReliablePartner => 'شريكك الموثوق في الخدمات';

  @override
  String get continueWith => 'متابعة مع';

  @override
  String get loginWithEmail => 'تسجيل الدخول بالبريد';

  @override
  String get signUp => 'إنشاء حساب';

  @override
  String get or => 'أو';

  @override
  String get termsLabel => 'الشروط';

  @override
  String get privacyLabel => 'الخصوصية';

  @override
  String get welcomeBack => 'مزود خدمة';

  @override
  String get welcomeSubtitle => 'مرحباً بك في أفضل نظام مزودي الخدمات!';

  @override
  String get emailAddress => 'البريد الإلكتروني';

  @override
  String get password => 'كلمة المرور';

  @override
  String get rememberMe => 'تذكرني';

  @override
  String get forgotPasswordLink => 'نسيت كلمة المرور؟';

  @override
  String get login => 'تسجيل الدخول';

  @override
  String get orContinueWith => 'أو متابعة مع';

  @override
  String get loginFailed => 'فشل تسجيل الدخول. تحقق من بياناتك.';

  @override
  String get noAccount => 'ليس لديك حساب؟';

  @override
  String get createAccount => 'إنشاء حساب';

  @override
  String get joinUs => 'انضم إلينا!';

  @override
  String get createAccountSubtitle => 'أنشئ حساباً للبدء';

  @override
  String get client => 'عميل';

  @override
  String get prestataire => 'مزود خدمة';

  @override
  String get serviceCategory => 'فئة الخدمة';

  @override
  String get yearsOfExperience => 'سنوات الخبرة';

  @override
  String get city => 'المدينة';

  @override
  String get description => 'الوصف';

  @override
  String get uploadIdDocument => 'تحميل وثيقة الهوية';

  @override
  String get iAgreeToThe => 'أوافق على';

  @override
  String get termsOfService => 'شروط الخدمة';

  @override
  String get privacyPolicy => 'سياسة الخصوصية';

  @override
  String get register => 'تسجيل';

  @override
  String get alreadyHaveAccount => 'لديك حساب بالفعل؟';

  @override
  String get fullName => 'الاسم الكامل';

  @override
  String get email => 'البريد';

  @override
  String get phone => 'الهاتف';

  @override
  String get confirmPassword => 'تأكيد كلمة المرور';

  @override
  String get forgotPassword => 'نسيت كلمة المرور';

  @override
  String get resetPassword => 'إعادة تعيين كلمة المرور';

  @override
  String get enterEmailToReset => 'أدخل بريدك لتلقي رابط إعادة التعيين';

  @override
  String get sendResetLink => 'إرسال رابط إعادة التعيين';

  @override
  String get resetLinkSent => 'تم إرسال الرابط بنجاح!';

  @override
  String get scheduling => 'الجدولة';

  @override
  String get errorMissingData => 'خطأ: بيانات مفقودة';

  @override
  String get bookingProgress => 'تقدم الحجز';

  @override
  String stepOf(int current, int total) {
    return 'الخطوة $current من $total';
  }

  @override
  String get chooseDate => 'اختر تاريخاً';

  @override
  String get availableSlots => 'المواعيد المتاحة';

  @override
  String get morning => 'صباحاً';

  @override
  String get afternoon => 'مساءً';

  @override
  String get confirmAddress => 'تأكيد العنوان';

  @override
  String get useRegisteredAddress => 'استخدام عنواني المسجل';

  @override
  String get noteForProvider => 'ملاحظة لمزود الخدمة';

  @override
  String get noteHint => 'مثال: الرمز 1234، الباب الثالث على اليسار...';

  @override
  String get continueButton => 'متابعة';

  @override
  String get summary => 'الملخص';

  @override
  String get bookingDetails => 'تفاصيل الحجز';

  @override
  String get date => 'التاريخ';

  @override
  String get time => 'الوقت';

  @override
  String get address => 'العنوان';

  @override
  String get note => 'ملاحظة';

  @override
  String get notDefined => 'غير محدد';

  @override
  String get selectedService => 'الخدمة المختارة';

  @override
  String get leakRepair => 'إصلاح التسرب';

  @override
  String get continueToPayment => 'متابعة للدفع';

  @override
  String get payment => 'الدفع';

  @override
  String get step4Payment => 'الخطوة 4: الدفع';

  @override
  String stepCount(int current, int total) {
    return '$current من $total';
  }

  @override
  String get confirmed => 'مؤكد';

  @override
  String get priceDetails => 'تفاصيل السعر';

  @override
  String get service => 'الخدمة';

  @override
  String get platformFee => 'رسوم المنصة';

  @override
  String get platformFeeHelp => 'رسوم الأمان ودعم العملاء';

  @override
  String get serviceInsurance => 'تأمين الخدمة';

  @override
  String get insuranceCoverage => 'تغطية حتى 10,000 درهم';

  @override
  String discountLabel(String code) {
    return 'خصم ($code)';
  }

  @override
  String get totalToPay => 'الإجمالي للدفع';

  @override
  String get preAuthOnly => 'تفويض مسبق فقط';

  @override
  String get promoCode => 'رمز ترويجي';

  @override
  String get promoCodeHint => 'أدخل رمزك (مثال: RILY20)';

  @override
  String promoCodeApplied(String code, int amount) {
    return 'الرمز \"$code\" مطبق (-$amount درهم)';
  }

  @override
  String get invalidPromoCode => 'رمز ترويجي غير صالح';

  @override
  String get paymentMethod => 'وسيلة الدفع';

  @override
  String get addCard => 'إضافة بطاقة';

  @override
  String get addCardSubtitle => 'لتفويض مسبق آمن';

  @override
  String get add => 'إضافة';

  @override
  String get yourCards => 'بطاقاتك';

  @override
  String get defaultCard => 'افتراضي';

  @override
  String expires(String date) {
    return 'تنتهي $date';
  }

  @override
  String seeMore(int count) {
    return 'عرض كل البطاقات ($count+)';
  }

  @override
  String get seeLess => 'عرض أقل';

  @override
  String get orPayCash => 'أو ادفع نقداً';

  @override
  String get payOnSite => 'الدفع في الموقع';

  @override
  String get payOnSiteSubtitle => 'ادفع نقداً أو ببطاقة لمزود الخدمة';

  @override
  String get preAuthInfo =>
      'التفويض المسبق: سيتم حجز المبلغ على بطاقتك ولكن لن يتم خصمه إلا بعد إتمام الخدمة.';

  @override
  String get securePaymentSSL => 'دفع آمن بتشفير SSL 256-bit';

  @override
  String get buyerProtection => 'حماية المشتري حتى 10,000 درهم';

  @override
  String get preAuthDone => 'تم التفويض المسبق!';

  @override
  String get preAuthDescription =>
      'تم حجز المبلغ على بطاقتك. لن يتم خصمه إلا بعد إتمام الخدمة.';

  @override
  String get confirmation => 'تأكيد';

  @override
  String get bookingConfirmed => 'تم تأكيد الحجز!';

  @override
  String get bookingConfirmedMessage =>
      'تم قبول طلبك. الحرفي ينتظرك في الوقت المحدد.';

  @override
  String get serviceDetails => 'تفاصيل الخدمة';

  @override
  String get contactProvider => 'اتصل بمزود الخدمة';

  @override
  String get viewMyBookings => 'عرض حجوزاتي';

  @override
  String get backToHome => 'العودة للرئيسية';

  @override
  String get myReservations => 'حجوزاتي';

  @override
  String get noUpcomingReservation => 'لا توجد حجوزات قادمة';

  @override
  String get noOngoingReservation => 'لا توجد حجوزات جارية';

  @override
  String get noCompletedReservation => 'لا توجد حجوزات مكتملة';

  @override
  String get noCancelledReservation => 'لا توجد حجوزات ملغاة';

  @override
  String get exploreProviders => 'استكشاف مزودي الخدمة';

  @override
  String errorLabel(String message) {
    return 'خطأ: $message';
  }

  @override
  String get reservationTracking => 'تتبع الحجز';

  @override
  String get cancelReservation => 'إلغاء الحجز';

  @override
  String get cancelReservationQuestion => 'إلغاء الحجز؟';

  @override
  String get reservationCancelled => 'تم إلغاء الحجز';

  @override
  String get cancelWarningText =>
      'يمكنك إلغاء هذا الحجز. هذا الإجراء لا رجعة فيه.';

  @override
  String get discuss => 'دردشة';

  @override
  String chatWith(String providerName) {
    return 'الدردشة مع $providerName';
  }

  @override
  String get statusConfirmed => 'تم التأكيد';

  @override
  String get statusEnRoute => 'في الطريق';

  @override
  String get statusInProgress => 'جارٍ التنفيذ';

  @override
  String get statusCompleted => 'مكتملة';

  @override
  String get statusCancelled => 'ملغاة';

  @override
  String get statusNotStarted => 'لم يبدأ';

  @override
  String validatedAt(String time) {
    return 'تم التحقق في $time';
  }

  @override
  String get providerArriving => 'المزود قادم';

  @override
  String arrivedAt(String time) {
    return 'وصل في $time';
  }

  @override
  String get interventionInProgress => 'التدخل جارٍ';

  @override
  String completedAt(String time) {
    return 'اكتمل في $time';
  }

  @override
  String get serviceComplete => 'تم تقديم الخدمة';

  @override
  String get bookingConfirmedHeader => 'تم تأكيد الحجز';

  @override
  String get providerStartsSoon => 'سيبدأ المزود قريباً.';

  @override
  String get providerEnRouteHeader => 'المزود في طريقه إليك';

  @override
  String providerLeftAppointment(String providerName) {
    return 'غادر $providerName موعده السابق.';
  }

  @override
  String get interventionInProgressHeader => 'التدخل جارٍ';

  @override
  String get providerWorkingNow => 'المزود يعمل حالياً.';

  @override
  String get serviceCompletedHeader => 'تم إنجاز الخدمة';

  @override
  String get thanksLeaveReview => 'شكراً لك! يمكنك ترك تقييم.';

  @override
  String get bookingCancelledHeader => 'تم إلغاء الحجز';

  @override
  String get bookingNoLongerActive => 'هذا الحجز لم يعد نشطاً.';

  @override
  String get estimatedArrival => 'الوصول المتوقع';

  @override
  String get minPlaceholder => 'دقيقة';

  @override
  String avisText(String count) {
    return '$count تقييم';
  }

  @override
  String get back => 'رجوع';

  @override
  String get cancel => 'إلغاء';

  @override
  String get chatDisabled => 'الدردشة معطلة';

  @override
  String get leaveReview => 'اترك تقييماً';

  @override
  String get callComingSoon => 'اتصال (قريباً)';

  @override
  String get contactSupport => 'اتصل بالدعم';

  @override
  String get comingSoon => 'الميزة قادمة قريباً';

  @override
  String get chatOnlyAfterBooking => 'الدردشة متاحة فقط بعد تأكيد الحجز';

  @override
  String get returnToReservations => 'العودة لحجوزاتي';

  @override
  String get howWasService => 'كيف كانت خدمتك؟';

  @override
  String rateExperience(String name) {
    return 'قيّم تجربتك مع $name';
  }

  @override
  String get whatDoYouThink => 'ما رأيك في الخدمة؟';

  @override
  String get yourCommentOptional => 'تعليقك (اختياري)';

  @override
  String get describeExperience => 'صف تجربتك...';

  @override
  String get submitReview => 'إرسال التقييم';

  @override
  String get pleaseSelectRating => 'يرجى اختيار تقييم';

  @override
  String get thankYouReview => 'شكراً لتقييمك!';

  @override
  String get tagExcellent => 'خدمة ممتازة';

  @override
  String get tagPunctual => 'ملتزم بالوقت';

  @override
  String get tagNeatWork => 'عمل متقن';

  @override
  String get tagProfessional => 'محترف';

  @override
  String get tagRecommended => 'يُنصح به';

  @override
  String get profile => 'الملف الشخصي';

  @override
  String get myActivity => 'نشاطي';

  @override
  String get myReservationsMenu => 'حجوزاتي';

  @override
  String get paymentMethods => 'وسائل الدفع';

  @override
  String get favorites => 'المفضلة';

  @override
  String get language => 'اللغة';

  @override
  String get helpCenter => 'مركز المساعدة';

  @override
  String get about => 'حول التطبيق';

  @override
  String get logout => 'تسجيل الخروج';

  @override
  String get editProfile => 'تعديل الملف الشخصي';

  @override
  String get toBeImplemented => '(قيد التنفيذ)';

  @override
  String languageChangedTo(String lang) {
    return 'تم تغيير اللغة: $lang';
  }

  @override
  String get chooseLanguage => 'اختر اللغة';

  @override
  String get french => 'Français';

  @override
  String get english => 'English';

  @override
  String get arabic => 'العربية';

  @override
  String get tabUpcoming => 'قادمة';

  @override
  String get tabOngoing => 'جارية';

  @override
  String get tabCompleted => 'مكتملة';

  @override
  String get tabCancelled => 'ملغاة';

  @override
  String get statusUpcoming => 'قادمة';

  @override
  String get statusOngoing => 'جارية';

  @override
  String get labelArrival => 'الوصول';

  @override
  String get btnLeaveReview => 'اترك تقييماً';

  @override
  String get btnInvoice => 'الفاتورة';

  @override
  String get btnViewDetails => 'عرض التفاصيل';

  @override
  String get msgNewMessage => 'رسالة جديدة';

  @override
  String get msgFindProviderToStart => 'ابحث عن مزود خدمة لبدء محادثة';

  @override
  String get msgMessagesTitle => 'الرسائل';

  @override
  String get msgOptionsSoon => 'خيارات (قريباً)';

  @override
  String get msgSearchConversation => 'البحث عن محادثة...';

  @override
  String get msgNoConversations => 'لا توجد محادثات حتى الآن';

  @override
  String get msgConversationsAppearHere =>
      'ستظهر محادثاتك مع مزودي الخدمة هنا بعد إجراء حجز أو اتصال أولي.';

  @override
  String get msgNoResults => 'لا توجد نتائج';

  @override
  String get msgTryAnotherSearchTerm => 'جرب كلمة بحث أخرى';

  @override
  String get msgResetSearch => 'إعادة ضبط البحث';

  @override
  String memberSinceDate(String date) {
    return 'عضو منذ $date';
  }

  @override
  String get supportAndInfo => 'الدعم والمعلومات';

  @override
  String get aboutProvider => 'نبذة';

  @override
  String get customerReviews => 'تقييمات العملاء';

  @override
  String showAllReviews(int count) {
    return 'عرض كل التقييمات ($count)';
  }

  @override
  String get readMore => 'عرض المزيد';

  @override
  String get readLess => 'عرض أقل';

  @override
  String get statusLabel => 'الحالة';

  @override
  String get certifiedStatus => 'معتمد';

  @override
  String get missionsLabel => 'المهام';

  @override
  String get responseLabel => 'الاستجابة';

  @override
  String get book => 'احجز';

  @override
  String stepXofY(int step, int total) {
    return 'الخطوة $step من $total';
  }

  @override
  String get btnContinue => 'متابعة';

  @override
  String get securePreAuth => 'لتفويض مسبق آمن';

  @override
  String get orPayInCash => 'أو الدفع نقداً';

  @override
  String get payInCashOrCardToProvider =>
      'الدفع نقداً أو بالبطاقة لمزود الخدمة';

  @override
  String preAuthorizeAmount(int amount) {
    return 'تفويض مسبق بـ $amount';
  }

  @override
  String get plumberExpert => 'خبير سباكة';

  @override
  String yearsExp(int years) {
    return '$years سنوات خبرة';
  }

  @override
  String get emailHint => 'johndoe@gmail.com';

  @override
  String get passwordHint => '••••••••••';

  @override
  String get nameHint => 'الاسم والنسب';

  @override
  String get phoneHint => 'أدخل رقم هاتفك';

  @override
  String get confirmPasswordHint => 'قم بتأكيد كلمة المرور';

  @override
  String get experienceHint => 'أدخل سنوات الخبرة';

  @override
  String get cityHint => 'أدخل مدينتك';

  @override
  String get descriptionHint => 'أخبرنا عن خدماتك';

  @override
  String get idUploadComingSoon => 'رفع الهوية - قريباً';

  @override
  String get agreeToTermsRequired => 'يرجى الموافقة على الشروط والخصوصية';

  @override
  String get errorNameRequired => 'يرجى إدخال اسمك';

  @override
  String get errorEmailRequired => 'يرجى إدخال بريدك الإلكتروني';

  @override
  String get errorPhoneRequired => 'يرجى إدخال رقم هاتفك';

  @override
  String get errorPasswordRequired => 'يرجى إدخال كلمة المرور';

  @override
  String get errorPasswordLength => 'كلمة المرور يجب أن تكون 6 أحرف على الأقل';

  @override
  String get errorConfirmPasswordRequired => 'يرجى تأكيد كلمة المرور';

  @override
  String get errorPasswordsNotMatch => 'كلمتا المرور غير متطابقتين';

  @override
  String get errorCategoryRequired => 'يرجى اختيار فئة';

  @override
  String get errorExperienceRequired => 'يرجى إدخال خبرتك';

  @override
  String get errorCityRequired => 'يرجى إدخال مدينتك';

  @override
  String get errorDescriptionRequired => 'يرجى إدخال وصف';

  @override
  String get notificationsTitle => 'الإشعارات';

  @override
  String get markAllAsRead => 'تحديد الكل كمقروء';

  @override
  String get deleteAll => 'حذف الكل';

  @override
  String get noNotificationsMsg => 'لا توجد إشعارات';

  @override
  String get noNotificationsDesc => 'سيتم إعلامك هنا بالتحديثات المهمة.';

  @override
  String get deleteAllTitle => 'حذف جميع الإشعارات';

  @override
  String get deleteAllDesc => 'هل أنت متأكد أنك تريد حذف جميع الإشعارات؟';

  @override
  String selectedCount(int count) {
    return 'تم تحديد $count';
  }

  @override
  String get deleteAction => 'حذف';

  @override
  String get invoiceTitle => 'فاتورة';

  @override
  String get shareComingSoon => 'المشاركة قريباً';

  @override
  String get downloadComingSoon => 'التحميل قريباً';

  @override
  String get paidStatus => 'مدفوعة';

  @override
  String get serviceDetailsTitle => 'تفاصيل الخدمة';

  @override
  String get providerLabel => 'مزود الخدمة';

  @override
  String get dateLabel => 'التاريخ';

  @override
  String get timeLabel => 'الوقت';

  @override
  String get paymentDetailsTitle => 'تفاصيل الدفع';

  @override
  String get serviceFeeLabel => 'رسوم الخدمة';

  @override
  String get taxLabel => 'ضريبة القيمة المضافة (20٪)';

  @override
  String get totalTotalLabel => 'الإجمالي';

  @override
  String get paymentMethodLabel => 'وسيلة الدفع';

  @override
  String get creditCardLabel => 'بطاقة بنكية •••• 4242';

  @override
  String invoiceIssuedOn(String date) {
    return 'أُصدرت الفاتورة في $date';
  }

  @override
  String get downloadInvoiceBtn => 'تحميل الفاتورة';

  @override
  String invoiceNumber(String number) {
    return 'فاتورة #$number';
  }

  @override
  String get onlinePaymentTitle => 'الدفع عبر الإنترنت';

  @override
  String get addCmiCardLabel => 'إضافة بطاقة (CMI)';

  @override
  String get cmiCardDescription => 'فيزا، ماستركارد عبر CMI';

  @override
  String get paymentMethodsTitleLabel => 'وسائل الدفع';

  @override
  String expiresAt(String date) {
    return 'تنتهي في $date';
  }

  @override
  String expiresLabel(String date) {
    return 'تنتهي في $date';
  }

  @override
  String get expiresShortLabel => 'الانتهاء';

  @override
  String get expiryDateLabel => 'الانتهاء (شهر/سنة)';

  @override
  String get defaultCardChip => 'افتراضية';

  @override
  String get defaultLabel => 'افتراضية';

  @override
  String get authRequiredForCard => 'يرجى المصادقة لعرض تفاصيل البطاقة';

  @override
  String get editCardInfo => 'تعديل المعلومات';

  @override
  String get setAsDefaultCard => 'تعيين كافتراضية';

  @override
  String get deleteCardLabel => 'حذف البطاقة';

  @override
  String get howItWorksLabel => 'كيف تعمل المدفوعات؟';

  @override
  String get learnMoreButton => 'اكتشف كيف نحمي معاملاتك';

  @override
  String get emptyStateAlert =>
      'أضف بطاقة أو قم بتمكين الدفع عند الوصول لتتمكن من إجراء الحجوزات.';

  @override
  String get addCardTitle => 'إضافة بطاقة';

  @override
  String get cmiSubtitle => 'مركز النقديات';

  @override
  String get nameOnCardLabel => 'الاسم على البطاقة';

  @override
  String get cardNumberLabel => 'رقم البطاقة';

  @override
  String get cvvLabel => 'رمز الأمان';

  @override
  String get setAsDefaultLabel => 'تعيين كبطاقة افتراضية';

  @override
  String get setAsDefaultDescription =>
      'سيتم استخدام هذه البطاقة افتراضيًا للمدفوعات';

  @override
  String get saveCardButton => 'حفظ البطاقة';

  @override
  String get invalidCardNumber => 'رقم البطاقة غير صالح';

  @override
  String get nameRequired => 'الاسم مطلوب';

  @override
  String get expiryRequired => 'تاريخ الانتهاء مطلوب';

  @override
  String get invalidExpiry => 'تاريخ الانتهاء غير صالح';

  @override
  String get invalidCvv => 'رمز الأمان غير صالح';

  @override
  String get deleteCardConfirmTitle => 'Supprimer la carte ?';

  @override
  String deleteCardConfirmContent(String cardLabel) {
    return 'Voulez-vous vraiment supprimer $cardLabel ?';
  }

  @override
  String get cardCannotBeDeleted => 'Impossible de supprimer cette carte';

  @override
  String get cardDeletedSuccess => 'Carte supprimée';

  @override
  String get cardDeleteError => 'Erreur lors de la suppression';

  @override
  String get cardSetDefaultSuccess => 'Carte définie par défaut';

  @override
  String get editCardTitle => 'تعديل البطاقة';

  @override
  String get editCardWarning =>
      'ملاحظة: يمكنك فقط تعديل التسمية وتاريخ الانتهاء.';

  @override
  String get saveChanges => 'حفظ التغييرات';

  @override
  String get paymentInfoTitle => 'معلومات الدفع';

  @override
  String get securePayment => 'دفع آمن';

  @override
  String get moneyProtected => 'أموالك محمية';

  @override
  String get cmiPreauthDesc =>
      'يستخدم RiLyBricoule نظام التفويض المسبق لمركز النقديات لضمان عدم الدفع إلا للخدمات التي تم إنجازها بالفعل.';

  @override
  String get cmiPreauth => 'التفويض المسبق لمركز النقديات';

  @override
  String get cmiPreauthDetail1 => 'يتم حجز المبلغ على بطاقتك البنكية';

  @override
  String get cmiPreauthDetail2 => 'لا يتم الخصم الفوري';

  @override
  String get cmiPreauthDetail3 => 'يتم الخصم النهائي بعد الانتهاء من الخدمة';

  @override
  String get cmiPreauthDetail4 => 'في حالة الإلغاء، يتم رفع الحجز خلال 48 ساعة';

  @override
  String get cashPayment => 'الدفع نقدًا';

  @override
  String get cashPaymentDetail1 => 'بدون معاملة عبر الإنترنت';

  @override
  String get cashPaymentDetail2 => 'الحجز يُعتبر \'يُدفع في الموقع\'';

  @override
  String get cashPaymentDetail3 => 'ادفع مباشرة لمقدم الخدمة';

  @override
  String get cashPaymentDetail4 => 'مثالي للأعمال الصغيرة';

  @override
  String get cancellationPolicy => 'سياسة الإلغاء';

  @override
  String cancellationDetail1(int maxCancels) {
    return 'يسمح بحد أقصى $maxCancels إلغاءات / شهر';
  }

  @override
  String get cancellationDetail2 => 'ما بعد ذلك: عقوبة على الرؤية';

  @override
  String get cancellationDetail3 => 'في حالة التكرار: توقف مؤقت ممكن';

  @override
  String get cancellationDetail4 => 'الهدف: ضمان موثوقية الخدمة';

  @override
  String get fullCmiIntegration => 'اندماج كامل لمركز النقديات';

  @override
  String fullCmiIntegrationDesc(String date) {
    return 'وثائق مركز النقديات التقنية متاحة بدءًا من $date. سيتم نشر الاندماج الكامل مع مصادقة 3D Secure وتمثيل العلامات الرقمية في هذا التاريخ.';
  }

  @override
  String get fullCmiIntegrationDetail1 => 'مصادقة 3D Secure إلزامية';

  @override
  String get fullCmiIntegrationDetail2 =>
      'تمثيل أرقام البطاقة (لا يتم تخزينها بدون تشفير)';

  @override
  String get fullCmiIntegrationDetail3 => 'توجيه آمن إلى مركز النقديات';

  @override
  String get fullCmiIntegrationDetail4 => 'يتوافق مع معايير الأمان PCI DSS';

  @override
  String get maxSecurity => 'أقصى حماية';

  @override
  String get encryptedData => 'تشفير البيانات';

  @override
  String get encryptedDataDesc =>
      'جميع اتصالات التشفير تتم باستخدام بروتوكول SSL 256-bit';

  @override
  String get tokenization => 'التحويل الرقمي';

  @override
  String get tokenizationDesc => 'لا يتم تخزين أرقام البطاقة مطلقًا في نص واضح';

  @override
  String get pciDss => 'شهادة PCI DSS';

  @override
  String get pciDssDesc => 'يتوافق مع معايير الأمان الدولية';

  @override
  String get cmiCentralBank => 'مركز النقديات - البنك المركزي';

  @override
  String get cmiCentralBankDesc => 'وسيط مصرفي معتمد من بنك المغرب';

  @override
  String get paymentSupportNote =>
      'لأي سؤال حول المدفوعات، يرجى الاتصال بخدمة العملاء لدينا المتاحة طوال أيام الأسبوع من 8 صباحًا حتى 8 مساءً.';

  @override
  String get cardLabelInput => 'التسمية';

  @override
  String get cardLabelHint => 'مثال: بطاقتي الشخصية';

  @override
  String get cardExpiryInput => 'الانتهاء (شهر/سنة)';

  @override
  String get cardExpiryHint => 'شهر/سنة';

  @override
  String get saveButton => 'حفظ';

  @override
  String get closeButton => 'إغلاق';

  @override
  String get optionsButton => 'خيارات';

  @override
  String get cardUpdatedSuccess => 'تم تحديث البطاقة';

  @override
  String get futurePaypalLabel => 'باي بال';

  @override
  String get futurePaypalDesc => 'دفع دولي';

  @override
  String get futureStripeLabel => 'سترايب';

  @override
  String get futureStripeDesc => 'بطاقات دولية';

  @override
  String get futureWalletLabel => 'محفظة إلكترونية';

  @override
  String get futureWalletDesc => 'دفع عبر المحفظة المتنقلة';

  @override
  String get comingSoonBadge => 'قريباً';

  @override
  String get onSitePaymentTitle => 'الدفع في الموقع';

  @override
  String get cashPaymentLabel => 'الدفع نقداً';

  @override
  String get cashPaymentDesc => 'الدفع مباشرة في الموقع';

  @override
  String get cashPaymentInfo =>
      'سيتم تمييز الحجز بـ \"للدفع في الموقع\". لن تتم أي معاملة عبر الإنترنت.';

  @override
  String get howItWorksTitle => 'كيف تعمل؟';

  @override
  String get authCmiTitle => 'CMI - تفويض مسبق';

  @override
  String get providerCancelTitle => 'إلغاء مزود الخدمة';

  @override
  String get cmiIntegrationTitle => 'تكامل CMI الكامل';

  @override
  String cmiIntegrationDesc(String date) {
    return 'وثائق CMI متاحة في $date. سيكون التكامل الكامل مع مصادقة 3D Secure متاحاً في هذا التاريخ.';
  }

  @override
  String get learnMoreBtn => 'معرفة المزيد';

  @override
  String get emptyPaymentMethodsAlert =>
      'أضف بطاقة أو فعّل الدفع النقدي لتتمكن من إجراء الحجوزات.';

  @override
  String get myServices => 'خدماتي';

  @override
  String servicesOfProvider(String name) {
    return 'خدمات $name';
  }

  @override
  String get onlineStatus => 'متصل';

  @override
  String get offlineStatus => 'غير متصل';

  @override
  String get writeMessageHint => 'اكتب رسالة...';

  @override
  String get recordingInProgress => 'جاري التسجيل...';

  @override
  String get today => 'اليوم';

  @override
  String get yesterday => 'أمس';

  @override
  String get copiedMessage => 'تم نسخ الرسالة';

  @override
  String get copyText => 'نسخ';

  @override
  String get deleteMessage => 'حذف';

  @override
  String get reportMessage => 'إبلاغ';

  @override
  String get makeCall => 'إجراء مكالمة';

  @override
  String get sendImage => 'إرسال صورة';

  @override
  String get shareLocationOption => 'مشاركة موقعي';

  @override
  String get sendDocument => 'إرسال ملف PDF / مستند';

  @override
  String voiceMessageSent(int duration) {
    return 'تم إرسال رسالة صوتية ($durationث)';
  }

  @override
  String get noMessages => 'لا توجد رسائل';
}
