// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appName => 'RilyBricoule';

  @override
  String get navHome => 'Accueil';

  @override
  String get navSearch => 'Recherche';

  @override
  String get navBooking => 'Réservation';

  @override
  String get navMessages => 'Messages';

  @override
  String get navProfile => 'Profil';

  @override
  String get hello => 'Bonjour';

  @override
  String helloUser(String name) {
    return 'Bonjour, $name 👋';
  }

  @override
  String get locationHint => 'Localisation...';

  @override
  String get categories => 'Catégories';

  @override
  String get seeAll => 'Voir tout';

  @override
  String get nearbyProviders => 'Prestataires proches';

  @override
  String get sortBy => 'Trier par';

  @override
  String get specialOffer => 'OFFRE SPÉCIALE';

  @override
  String get promoDiscount => '20% de réduction\nsur votre 1er Ménage';

  @override
  String get bookNow => 'Réserver maintenant';

  @override
  String get viewProfile => 'Voir profil';

  @override
  String reviewsCount(int count) {
    return '$count avis';
  }

  @override
  String distanceKm(String distance) {
    return '$distance km';
  }

  @override
  String get categoryPlumbing => 'Plomberie';

  @override
  String get categoryElectricity => 'Électricité';

  @override
  String get categoryCleaning => 'Ménage';

  @override
  String get categoryPainting => 'Peinture';

  @override
  String get categoryHandyman => 'Bricolage';

  @override
  String get categoryGardening => 'Jardinage';

  @override
  String get categoryAC => 'Climatisation';

  @override
  String get categoryCarpentry => 'Menuiserie';

  @override
  String get categoryLocksmith => 'Serrurerie';

  @override
  String get categoryMoving => 'Déménagement';

  @override
  String get categoryRepair => 'Réparation';

  @override
  String get categoryOther => 'Autres';

  @override
  String get allCategories => 'Toutes les catégories';

  @override
  String get sortProviders => 'Trier les prestataires';

  @override
  String get sortBestRated => 'Mieux notés';

  @override
  String get sortPriceLowToHigh => 'Prix croissant';

  @override
  String get sortPriceHighToLow => 'Prix décroissant';

  @override
  String get sortNearest => 'Distance la plus proche';

  @override
  String get sortAvailableNow => 'Disponibles maintenant';

  @override
  String get reset => 'Réinitialiser';

  @override
  String get apply => 'Appliquer';

  @override
  String get searchService => 'Rechercher un service...';

  @override
  String get discoverSwipe => 'Découvrir en swipe';

  @override
  String get listView => 'Liste';

  @override
  String get mapView => 'Carte';

  @override
  String providersFoundNearby(int count) {
    return '$count PRESTATAIRES TROUVÉS PRÈS DE VOUS';
  }

  @override
  String get busy => 'OCCUPÉ';

  @override
  String get noProviderFound => 'Aucun prestataire trouvé';

  @override
  String get filters => 'Filtres';

  @override
  String get resetAll => 'Tout réinitialiser';

  @override
  String get priceRange => 'Fourchette de prix (MAD)';

  @override
  String priceRangeValue(int min, int max) {
    return '$min - $max MAD';
  }

  @override
  String get rating => 'Note';

  @override
  String get ratingAll => 'Toutes';

  @override
  String get distance => 'Distance';

  @override
  String distanceRadius(int km) {
    return 'Dans un rayon de ${km}km';
  }

  @override
  String get availableNow => 'Disponible maintenant';

  @override
  String get availableNowDescription =>
      'Afficher seulement les prestataires prêts à travailler';

  @override
  String get applyFilters => 'Appliquer les filtres';

  @override
  String get noMoreProviders => 'Plus de prestataires';

  @override
  String get discoverTitle => 'Découvrir';

  @override
  String get availableChip => 'Disponibles';

  @override
  String get noMatchCriteria =>
      'Aucun prestataire ne correspond à vos critères';

  @override
  String get resetFiltersBtn => 'Réinitialiser les filtres';

  @override
  String get backToSearch => 'Retour à la recherche';

  @override
  String addedToFavorites(String name) {
    return '$name ajouté aux favoris';
  }

  @override
  String get availableNowBadge => 'Disponible';

  @override
  String get topRatedBadge => 'Top noté';

  @override
  String get viewProfileBtn => 'Voir profil';

  @override
  String get errorGettingLocation => 'Impossible d\'obtenir votre position';

  @override
  String get errorLoadingProviders =>
      'Erreur lors du chargement des prestataires';

  @override
  String get locationPermissionRequired => 'Permission de localisation requise';

  @override
  String get locationPermissionDesc =>
      'Nous avons besoin de votre localisation pour trouver les prestataires près de vous';

  @override
  String get allowLocation => 'Autoriser la localisation';

  @override
  String get gpsDisabled => 'GPS désactivé';

  @override
  String get gpsDisabledDesc =>
      'Veuillez activer votre GPS pour utiliser cette fonctionnalité';

  @override
  String get enableLocation => 'Activer la localisation';

  @override
  String get errorTitle => 'Erreur';

  @override
  String get errorOccurred => 'Une erreur est survenue';

  @override
  String get retry => 'Réessayer';

  @override
  String get noProvidersInYourArea =>
      'Il n\'y a pas de prestataires disponibles dans votre zone';

  @override
  String get showList => 'Afficher la liste';

  @override
  String get noProviderInThisArea => 'Aucun prestataire dans cette zone';

  @override
  String get serviceProvider => 'Prestataire de services';

  @override
  String get yourReliablePartner => 'Votre partenaire de service de confiance';

  @override
  String get continueWith => 'Continuer avec';

  @override
  String get loginWithEmail => 'Se connecter avec un e-mail';

  @override
  String get signUp => 'S\'inscrire';

  @override
  String get or => 'ou';

  @override
  String get termsLabel => 'Conditions';

  @override
  String get privacyLabel => 'Confidentialité';

  @override
  String get welcomeBack => 'Prestataire de services';

  @override
  String get welcomeSubtitle =>
      'Bienvenue dans le meilleur système de prestataires !';

  @override
  String get emailAddress => 'Adresse e-mail';

  @override
  String get password => 'Mot de passe';

  @override
  String get rememberMe => 'Se souvenir de moi';

  @override
  String get forgotPasswordLink => 'Mot de passe oublié ?';

  @override
  String get login => 'Se connecter';

  @override
  String get orContinueWith => 'ou continuer avec';

  @override
  String get loginFailed => 'Échec de connexion. Vérifiez vos identifiants.';

  @override
  String get noAccount => 'Vous n\'avez pas de compte?';

  @override
  String get createAccount => 'Créer un compte';

  @override
  String get joinUs => 'Rejoignez-nous !';

  @override
  String get createAccountSubtitle => 'Créez un compte pour commencer';

  @override
  String get client => 'Client';

  @override
  String get prestataire => 'Prestataire';

  @override
  String get serviceCategory => 'Catégorie de Service';

  @override
  String get yearsOfExperience => 'Années d\'expérience';

  @override
  String get city => 'Ville';

  @override
  String get description => 'Description';

  @override
  String get uploadIdDocument => 'Télécharger la pièce d\'identité';

  @override
  String get iAgreeToThe => 'J\'accepte les';

  @override
  String get termsOfService => 'Conditions d\'utilisation';

  @override
  String get privacyPolicy => 'Politique de confidentialité';

  @override
  String get register => 'S\'INSCRIRE';

  @override
  String get alreadyHaveAccount => 'Vous avez déjà un compte?';

  @override
  String get fullName => 'Nom complet';

  @override
  String get email => 'E-mail';

  @override
  String get phone => 'Téléphone';

  @override
  String get confirmPassword => 'Confirmer le mot de passe';

  @override
  String get forgotPassword => 'Mot de passe oublié';

  @override
  String get resetPassword => 'Réinitialiser le mot de passe';

  @override
  String get enterEmailToReset => 'Entrez votre e-mail pour recevoir un lien';

  @override
  String get sendResetLink => 'ENVOYER LE LIEN';

  @override
  String get resetLinkSent => 'Lien de réinitialisation envoyé !';

  @override
  String get scheduling => 'Planification';

  @override
  String get errorMissingData => 'Erreur: Données manquantes';

  @override
  String get bookingProgress => 'PROGRESSION DE LA RÉSERVATION';

  @override
  String stepOf(int current, int total) {
    return 'Étape $current sur $total';
  }

  @override
  String get chooseDate => 'Choisir une date';

  @override
  String get availableSlots => 'Créneaux disponibles';

  @override
  String get morning => 'Matin';

  @override
  String get afternoon => 'Après-midi';

  @override
  String get confirmAddress => 'Confirmer l\'adresse';

  @override
  String get useRegisteredAddress => 'Utiliser mon adresse enregistrée';

  @override
  String get noteForProvider => 'Note pour le prestataire';

  @override
  String get noteHint =>
      'Ex: Code d\'entrée 1234, interphone B, 3ème porte à gauche...';

  @override
  String get continueButton => 'Continuer';

  @override
  String get summary => 'Récapitulatif';

  @override
  String get bookingDetails => 'Détails de la réservation';

  @override
  String get date => 'Date';

  @override
  String get time => 'Heure';

  @override
  String get address => 'Adresse';

  @override
  String get note => 'Note';

  @override
  String get notDefined => 'Non définie';

  @override
  String get selectedService => 'Service sélectionné';

  @override
  String get leakRepair => 'Réparation de fuite';

  @override
  String get continueToPayment => 'Continuer vers le paiement';

  @override
  String get payment => 'Paiement';

  @override
  String get step4Payment => 'ÉTAPE 4: PAIEMENT';

  @override
  String stepCount(int current, int total) {
    return '$current sur $total';
  }

  @override
  String get confirmed => 'Confirmé';

  @override
  String get priceDetails => 'Détails du prix';

  @override
  String get service => 'Service';

  @override
  String get platformFee => 'Frais de plateforme';

  @override
  String get platformFeeHelp => 'Frais de sécurité et support client';

  @override
  String get serviceInsurance => 'Assurance service';

  @override
  String get insuranceCoverage => 'Couverture jusqu\'à 10,000 MAD';

  @override
  String discountLabel(String code) {
    return 'Réduction ($code)';
  }

  @override
  String get totalToPay => 'Total à payer';

  @override
  String get preAuthOnly => 'Préautorisation uniquement';

  @override
  String get promoCode => 'Code promo';

  @override
  String get promoCodeHint => 'Entrez votre code (ex: RILY20)';

  @override
  String promoCodeApplied(String code, int amount) {
    return 'Code \"$code\" appliqué (-$amount MAD)';
  }

  @override
  String get invalidPromoCode => 'Code promo invalide';

  @override
  String get paymentMethod => 'Moyen de paiement';

  @override
  String get addCard => 'Ajouter une carte';

  @override
  String get addCardSubtitle => 'Pour une préautorisation sécurisée';

  @override
  String get add => 'Ajouter';

  @override
  String get yourCards => 'Vos cartes';

  @override
  String get defaultCard => 'Défaut';

  @override
  String expires(String date) {
    return 'Expire $date';
  }

  @override
  String seeMore(int count) {
    return 'Voir toutes les cartes ($count+)';
  }

  @override
  String get seeLess => 'Voir moins';

  @override
  String get orPayCash => 'Ou payer en espèces';

  @override
  String get payOnSite => 'Paiement sur place';

  @override
  String get payOnSiteSubtitle => 'Payez en espèces ou carte au prestataire';

  @override
  String get preAuthInfo =>
      'Préautorisation: le montant sera bloqué sur votre carte mais débité uniquement après la completion du service.';

  @override
  String get securePaymentSSL => 'Paiement sécurisé par cryptage SSL 256-bit';

  @override
  String get buyerProtection => 'Protection acheteur jusqu\'à 10,000 MAD';

  @override
  String get preAuthDone => 'Préautorisation effectuée !';

  @override
  String get preAuthDescription =>
      'Le montant a été bloqué sur votre carte. Il ne sera débité qu\'après la completion du service.';

  @override
  String get confirmation => 'Confirmation';

  @override
  String get bookingConfirmed => 'Réservation confirmée!';

  @override
  String get bookingConfirmedMessage =>
      'Votre demande a été acceptée. Le bricoleur vous attend à l\'heure prévue.';

  @override
  String get serviceDetails => 'DÉTAILS DE LA PRESTATION';

  @override
  String get contactProvider => 'Contacter le prestataire';

  @override
  String get viewMyBookings => 'Voir mes réservations';

  @override
  String get backToHome => 'Retour à l\'accueil';

  @override
  String get myReservations => 'Mes Réservations';

  @override
  String get noUpcomingReservation => 'Aucune réservation à venir';

  @override
  String get noOngoingReservation => 'Aucune réservation en cours';

  @override
  String get noCompletedReservation => 'Aucune réservation terminée';

  @override
  String get noCancelledReservation => 'Aucune réservation annulée';

  @override
  String get exploreProviders => 'Explorer des prestataires';

  @override
  String errorLabel(String message) {
    return 'Erreur: $message';
  }

  @override
  String get reservationTracking => 'Suivi de la réservation';

  @override
  String get cancelReservation => 'Annuler la réservation';

  @override
  String get cancelReservationQuestion => 'Annuler la réservation ?';

  @override
  String get reservationCancelled => 'Réservation annulée';

  @override
  String get cancelWarningText =>
      'Vous pouvez annuler cette réservation. Cette action est irréversible.';

  @override
  String get discuss => 'Discuter';

  @override
  String chatWith(String providerName) {
    return 'Discuter avec $providerName';
  }

  @override
  String get statusConfirmed => 'Confirmé';

  @override
  String get statusEnRoute => 'En route';

  @override
  String get statusInProgress => 'En cours';

  @override
  String get statusCompleted => 'TERMINÉE';

  @override
  String get statusCancelled => 'ANNULÉE';

  @override
  String get statusNotStarted => 'Non démarré';

  @override
  String validatedAt(String time) {
    return 'Validé à $time';
  }

  @override
  String get providerArriving => 'Le prestataire arrive';

  @override
  String arrivedAt(String time) {
    return 'Arrivé à $time';
  }

  @override
  String get interventionInProgress => 'Intervention en cours';

  @override
  String completedAt(String time) {
    return 'Terminé à $time';
  }

  @override
  String get serviceComplete => 'Prestation complète';

  @override
  String get bookingConfirmedHeader => 'Réservation confirmée';

  @override
  String get providerStartsSoon => 'Votre prestataire va bientôt commencer.';

  @override
  String get providerEnRouteHeader => 'Le prestataire est en route';

  @override
  String providerLeftAppointment(String providerName) {
    return '$providerName a quitté son précédent rendez-vous.';
  }

  @override
  String get interventionInProgressHeader => 'Intervention en cours';

  @override
  String get providerWorkingNow =>
      'Le prestataire travaille actuellement chez vous.';

  @override
  String get serviceCompletedHeader => 'Prestation terminée';

  @override
  String get thanksLeaveReview => 'Merci ! Vous pouvez laisser un avis.';

  @override
  String get bookingCancelledHeader => 'Réservation annulée';

  @override
  String get bookingNoLongerActive => 'Cette réservation n\'est plus active.';

  @override
  String get estimatedArrival => 'ARRIVÉE PRÉVUE';

  @override
  String get minPlaceholder => 'min';

  @override
  String avisText(String count) {
    return '$count avis';
  }

  @override
  String get back => 'Retour';

  @override
  String get cancel => 'Annuler';

  @override
  String get chatDisabled => 'Chat désactivé';

  @override
  String get leaveReview => 'Laisser un avis';

  @override
  String get callComingSoon => 'Appel (bientôt)';

  @override
  String get contactSupport => 'Contacter le support';

  @override
  String get comingSoon => 'Fonction bientôt disponible';

  @override
  String get chatOnlyAfterBooking =>
      'Chat disponible uniquement après réservation confirmée';

  @override
  String get returnToReservations => 'Retour à mes réservations';

  @override
  String get howWasService => 'Comment s\'est passée votre prestation ?';

  @override
  String rateExperience(String name) {
    return 'Notez votre expérience avec $name';
  }

  @override
  String get whatDoYouThink => 'Que pensez-vous du service ?';

  @override
  String get yourCommentOptional => 'Votre commentaire (optionnel)';

  @override
  String get describeExperience => 'Décrivez votre expérience...';

  @override
  String get submitReview => 'Envoyer mon avis';

  @override
  String get pleaseSelectRating => 'Veuillez sélectionner une note';

  @override
  String get thankYouReview => 'Merci pour votre avis !';

  @override
  String get tagExcellent => 'Excellent service';

  @override
  String get tagPunctual => 'Ponctuel';

  @override
  String get tagNeatWork => 'Travail soigné';

  @override
  String get tagProfessional => 'Professionnel';

  @override
  String get tagRecommended => 'À recommander';

  @override
  String get profile => 'Profil';

  @override
  String get myActivity => 'Mon Activité';

  @override
  String get myReservationsMenu => 'Mes réservations';

  @override
  String get paymentMethods => 'Modes de paiement';

  @override
  String get favorites => 'Favoris';

  @override
  String get language => 'Langue';

  @override
  String get helpCenter => 'Centre d\'aide';

  @override
  String get about => 'À propos';

  @override
  String get logout => 'Déconnexion';

  @override
  String get editProfile => 'Modifier le profil';

  @override
  String get toBeImplemented => '(To be implemented)';

  @override
  String languageChangedTo(String lang) {
    return 'Langue changée : $lang';
  }

  @override
  String get chooseLanguage => 'Choisir la langue';

  @override
  String get french => 'Français';

  @override
  String get english => 'English';

  @override
  String get arabic => 'العربية';

  @override
  String get tabUpcoming => 'À venir';

  @override
  String get tabOngoing => 'En cours';

  @override
  String get tabCompleted => 'Terminées';

  @override
  String get tabCancelled => 'Annulées';

  @override
  String get statusUpcoming => 'À VENIR';

  @override
  String get statusOngoing => 'EN COURS';

  @override
  String get labelArrival => 'Arrivée';

  @override
  String get btnLeaveReview => 'Laisser un avis';

  @override
  String get btnInvoice => 'Facture';

  @override
  String get btnViewDetails => 'Voir détails';

  @override
  String get msgNewMessage => 'Nouveau message';

  @override
  String get msgFindProviderToStart =>
      'Trouvez un prestataire pour commencer une conversation';

  @override
  String get msgMessagesTitle => 'Messages';

  @override
  String get msgOptionsSoon => 'Options (bientôt)';

  @override
  String get msgSearchConversation => 'Rechercher une conversation...';

  @override
  String get msgNoConversations => 'Aucune conversation pour le moment';

  @override
  String get msgConversationsAppearHere =>
      'Vos conversations avec les prestataires apparaîtront ici après une réservation ou un premier contact.';

  @override
  String get msgNoResults => 'Aucun résultat';

  @override
  String get msgTryAnotherSearchTerm =>
      'Essayez avec un autre terme de recherche';

  @override
  String get msgResetSearch => 'Réinitialiser la recherche';

  @override
  String memberSinceDate(String date) {
    return 'Membre depuis $date';
  }

  @override
  String get supportAndInfo => 'Support & Info';

  @override
  String get aboutProvider => 'À propos';

  @override
  String get customerReviews => 'Avis clients';

  @override
  String showAllReviews(int count) {
    return 'Afficher les $count avis';
  }

  @override
  String get readMore => 'Voir plus';

  @override
  String get readLess => 'Voir moins';

  @override
  String get statusLabel => 'STATUT';

  @override
  String get certifiedStatus => 'Certifié';

  @override
  String get missionsLabel => 'MISSIONS';

  @override
  String get responseLabel => 'RÉPONSE';

  @override
  String get book => 'Réserver';

  @override
  String stepXofY(int step, int total) {
    return 'Étape $step sur $total';
  }

  @override
  String get btnContinue => 'Continuer';

  @override
  String get securePreAuth => 'Pour une préautorisation sécurisée';

  @override
  String get orPayInCash => 'Ou payer en espèces';

  @override
  String get payInCashOrCardToProvider =>
      'Payez en espèces ou carte au prestataire';

  @override
  String preAuthorizeAmount(int amount) {
    return 'Préautoriser $amount';
  }

  @override
  String get plumberExpert => 'Plombier Expert';

  @override
  String yearsExp(int years) {
    return '$years ans d\'exp.';
  }

  @override
  String get emailHint => 'johndoe@gmail.com';

  @override
  String get passwordHint => '••••••••••';

  @override
  String get nameHint => 'NOM PRÉNOM';

  @override
  String get phoneHint => 'Entrez votre numéro de téléphone';

  @override
  String get confirmPasswordHint => 'Confirmez votre mot de passe';

  @override
  String get experienceHint => 'Entrez vos années d\'expérience';

  @override
  String get cityHint => 'Entrez votre ville';

  @override
  String get descriptionHint => 'Parlez-nous de vos services';

  @override
  String get idUploadComingSoon => 'Téléchargement d\'ID - Bientôt disponible';

  @override
  String get agreeToTermsRequired =>
      'Veuillez accepter les conditions et politiques';

  @override
  String get errorNameRequired => 'Veuillez entrer votre nom';

  @override
  String get errorEmailRequired => 'Veuillez entrer votre e-mail';

  @override
  String get errorPhoneRequired => 'Veuillez entrer votre téléphone';

  @override
  String get errorPasswordRequired => 'Veuillez entrer votre mot de passe';

  @override
  String get errorPasswordLength =>
      'Le mot de passe doit contenir au moins 6 caractères';

  @override
  String get errorConfirmPasswordRequired =>
      'Veuillez confirmer votre mot de passe';

  @override
  String get errorPasswordsNotMatch => 'Les mots de passe ne correspondent pas';

  @override
  String get errorCategoryRequired => 'Veuillez sélectionner une catégorie';

  @override
  String get errorExperienceRequired => 'Veuillez entrer votre expérience';

  @override
  String get errorCityRequired => 'Veuillez entrer votre ville';

  @override
  String get errorDescriptionRequired => 'Veuillez entrer une description';

  @override
  String get notificationsTitle => 'Notifications';

  @override
  String get markAllAsRead => 'Tout marquer comme lu';

  @override
  String get deleteAll => 'Supprimer tout';

  @override
  String get noNotificationsMsg => 'Aucune notification';

  @override
  String get noNotificationsDesc =>
      'Vous serez informé ici des mises à jour importantes.';

  @override
  String get deleteAllTitle => 'Supprimer toutes les notifications';

  @override
  String get deleteAllDesc =>
      'Êtes-vous sûr de vouloir supprimer toutes les notifications ?';

  @override
  String selectedCount(int count) {
    return '$count sélectionné(s)';
  }

  @override
  String get deleteAction => 'Supprimer';

  @override
  String get invoiceTitle => 'Facture';

  @override
  String get shareComingSoon => 'Partager bientôt disponible';

  @override
  String get downloadComingSoon => 'Téléchargement bientôt disponible';

  @override
  String get paidStatus => 'Payée';

  @override
  String get serviceDetailsTitle => 'Détails de la prestation';

  @override
  String get providerLabel => 'Prestataire';

  @override
  String get dateLabel => 'Date';

  @override
  String get timeLabel => 'Heure';

  @override
  String get paymentDetailsTitle => 'Détails du paiement';

  @override
  String get serviceFeeLabel => 'Frais de service';

  @override
  String get taxLabel => 'TVA (20%)';

  @override
  String get totalTotalLabel => 'Total';

  @override
  String get paymentMethodLabel => 'Méthode de paiement';

  @override
  String get creditCardLabel => 'Carte bancaire •••• 4242';

  @override
  String invoiceIssuedOn(String date) {
    return 'Facture émise le $date';
  }

  @override
  String get downloadInvoiceBtn => 'Télécharger la facture';

  @override
  String invoiceNumber(String number) {
    return 'Facture #$number';
  }

  @override
  String get onlinePaymentTitle => 'Paiement en ligne';

  @override
  String get addCmiCardLabel => 'Ajouter une carte (CMI)';

  @override
  String get cmiCardDescription => 'Visa, Mastercard via CMI';

  @override
  String get paymentMethodsTitleLabel => 'Modes de paiement';

  @override
  String expiresAt(String date) {
    return 'Expire $date';
  }

  @override
  String expiresLabel(String date) {
    return 'Expire $date';
  }

  @override
  String get expiresShortLabel => 'EXPIRE';

  @override
  String get expiryDateLabel => 'Expiration (MM/AA)';

  @override
  String get defaultCardChip => 'Par défaut';

  @override
  String get defaultLabel => 'Par défaut';

  @override
  String get authRequiredForCard =>
      'Veuillez vous authentifier pour voir les détails de la carte';

  @override
  String get editCardInfo => 'Modifier les informations';

  @override
  String get setAsDefaultCard => 'Définir par défaut';

  @override
  String get deleteCardLabel => 'Supprimer la carte';

  @override
  String get howItWorksLabel => 'Comment fonctionnent les paiements ?';

  @override
  String get learnMoreButton =>
      'Découvrez comment nous protégeons vos transactions';

  @override
  String get emptyStateAlert =>
      'Ajoutez une carte ou activez le paiement sur place pour pouvoir effectuer des réservations.';

  @override
  String get addCardTitle => 'Ajouter une carte';

  @override
  String get cmiSubtitle => 'CMI - Centre Monétique Interbancaire';

  @override
  String get nameOnCardLabel => 'Nom sur la carte';

  @override
  String get cardNumberLabel => 'Numéro de carte';

  @override
  String get cvvLabel => 'CVV';

  @override
  String get setAsDefaultLabel => 'Définir comme carte par défaut';

  @override
  String get setAsDefaultDescription =>
      'Cette carte sera utilisée par défaut pour les paiements';

  @override
  String get saveCardButton => 'Enregistrer la carte';

  @override
  String get invalidCardNumber => 'Numéro de carte invalide';

  @override
  String get nameRequired => 'Nom requis';

  @override
  String get expiryRequired => 'Date d\'expiration requise';

  @override
  String get invalidExpiry => 'Expiration invalide';

  @override
  String get invalidCvv => 'CVV invalide';

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
  String get editCardTitle => 'Modifier la carte';

  @override
  String get editCardWarning =>
      'Note : Vous pouvez uniquement modifier le libellé et la date d\'expiration.';

  @override
  String get saveChanges => 'Enregistrer les modifications';

  @override
  String get paymentInfoTitle => 'Informations paiement';

  @override
  String get securePayment => 'Paiement sécurisé';

  @override
  String get moneyProtected => 'Votre argent est protégé';

  @override
  String get cmiPreauthDesc =>
      'RiLyBricoule utilise le système de préautorisation CMI pour garantir que vous ne payez que les services effectivement réalisés.';

  @override
  String get cmiPreauth => 'Préautorisation CMI';

  @override
  String get cmiPreauthDetail1 =>
      'Le montant est BLOQUÉ sur votre carte bancaire';

  @override
  String get cmiPreauthDetail2 => 'Aucun débit n\'est effectué immédiatement';

  @override
  String get cmiPreauthDetail3 =>
      'Le débit final se fait APRÈS service terminé';

  @override
  String get cmiPreauthDetail4 => 'Si annulation, le blocage est levé sous 48h';

  @override
  String get cashPayment => 'Paiement en espèces';

  @override
  String get cashPaymentDetail1 => 'Aucune transaction en ligne';

  @override
  String get cashPaymentDetail2 => 'Réservation marquée \'À régler sur place\'';

  @override
  String get cashPaymentDetail3 => 'Payez directement le prestataire';

  @override
  String get cashPaymentDetail4 => 'Idéal pour les petits travaux';

  @override
  String get cancellationPolicy => 'Politique d\'annulation';

  @override
  String cancellationDetail1(int maxCancels) {
    return 'Maximum $maxCancels annulations/mois autorisées';
  }

  @override
  String get cancellationDetail2 => 'Au-delà: pénalité de visibilité';

  @override
  String get cancellationDetail3 =>
      'Répétition: suspension temporaire possible';

  @override
  String get cancellationDetail4 =>
      'Objectif: garantir la fiabilité du service';

  @override
  String get fullCmiIntegration => 'Intégration CMI complète';

  @override
  String fullCmiIntegrationDesc(String date) {
    return 'Documentation technique CMI disponible en $date. L\'intégration complète avec authentification 3D Secure et tokenization sera déployée à cette date.';
  }

  @override
  String get fullCmiIntegrationDetail1 =>
      'Authentification 3D Secure obligatoire';

  @override
  String get fullCmiIntegrationDetail2 =>
      'Tokenization des cartes (jamais stockées en clair)';

  @override
  String get fullCmiIntegrationDetail3 => 'Redirection sécurisée vers CMI';

  @override
  String get fullCmiIntegrationDetail4 => 'Conforme aux normes PCI DSS';

  @override
  String get maxSecurity => 'Sécurité maximale';

  @override
  String get encryptedData => 'Données chiffrées';

  @override
  String get encryptedDataDesc =>
      'Toutes les communications sont chiffrées SSL 256-bit';

  @override
  String get tokenization => 'Tokenization';

  @override
  String get tokenizationDesc =>
      'Les numéros de carte ne sont jamais stockés en clair';

  @override
  String get pciDss => 'Certification PCI DSS';

  @override
  String get pciDssDesc => 'Conforme aux normes de sécurité internationales';

  @override
  String get cmiCentralBank => 'CMI - Banque centrale';

  @override
  String get cmiCentralBankDesc =>
      'Intermédiaire bancaire agréé par Bank Al-Maghrib';

  @override
  String get paymentSupportNote =>
      'Pour toute question concernant les paiements, contactez notre support client disponible 7j/7 de 8h à 20h.';

  @override
  String get cardLabelInput => 'Libellé';

  @override
  String get cardLabelHint => 'Ex: Ma carte personnelle';

  @override
  String get cardExpiryInput => 'Expiration (MM/AA)';

  @override
  String get cardExpiryHint => 'MM/AA';

  @override
  String get saveButton => 'Enregistrer';

  @override
  String get closeButton => 'Fermer';

  @override
  String get optionsButton => 'Options';

  @override
  String get cardUpdatedSuccess => 'Carte mise à jour';

  @override
  String get futurePaypalLabel => 'PayPal';

  @override
  String get futurePaypalDesc => 'Paiement international';

  @override
  String get futureStripeLabel => 'Stripe';

  @override
  String get futureStripeDesc => 'Cartes internationales';

  @override
  String get futureWalletLabel => 'Portefeuille électronique';

  @override
  String get futureWalletDesc => 'Paiement mobile wallet';

  @override
  String get comingSoonBadge => 'Bientôt';

  @override
  String get onSitePaymentTitle => 'Paiement sur place';

  @override
  String get cashPaymentLabel => 'Paiement en espèces';

  @override
  String get cashPaymentDesc => 'Réglez directement sur place';

  @override
  String get cashPaymentInfo =>
      'La réservation sera marquée \"À régler sur place\". Aucune transaction en ligne ne sera effectuée.';

  @override
  String get howItWorksTitle => 'Comment ça marche ?';

  @override
  String get authCmiTitle => 'CMI - Préautorisation';

  @override
  String get providerCancelTitle => 'Annulation prestataire';

  @override
  String get cmiIntegrationTitle => 'Intégration CMI complète';

  @override
  String cmiIntegrationDesc(String date) {
    return 'Documentation CMI disponible en $date. L\'intégration complète avec authentification 3D Secure sera disponible à cette date.';
  }

  @override
  String get learnMoreBtn => 'En savoir plus';

  @override
  String get emptyPaymentMethodsAlert =>
      'Ajoutez une carte ou activez le paiement sur place pour pouvoir effectuer des réservations.';

  @override
  String get myServices => 'Mes Services';

  @override
  String servicesOfProvider(String name) {
    return 'Services de $name';
  }

  @override
  String get onlineStatus => 'En ligne';

  @override
  String get offlineStatus => 'Hors ligne';

  @override
  String get writeMessageHint => 'Écrire un message…';

  @override
  String get recordingInProgress => 'Enregistrement en cours...';

  @override
  String get today => 'Aujourd\'hui';

  @override
  String get yesterday => 'Hier';

  @override
  String get copiedMessage => 'Message copié';

  @override
  String get copyText => 'Copier';

  @override
  String get deleteMessage => 'Supprimer';

  @override
  String get reportMessage => 'Signaler';

  @override
  String get makeCall => 'Passer un appel';

  @override
  String get sendImage => 'Envoyer une image';

  @override
  String get shareLocationOption => 'Partager ma position';

  @override
  String get sendDocument => 'Envoyer PDF / Document';

  @override
  String voiceMessageSent(int duration) {
    return 'Message vocal envoyé (${duration}s)';
  }

  @override
  String get noMessages => 'Aucun message';

  @override
  String get dispatchTitle => 'Demande rapide';

  @override
  String get dispatchSubtitle =>
      'Recevez un prestataire rapidement sans chercher';

  @override
  String get dispatchChooseCategory => 'Choisissez un service';

  @override
  String get dispatchFormTitle => 'Détails de la demande';

  @override
  String get dispatchAddress => 'Adresse';

  @override
  String get dispatchAddressHint => 'Ex: 123 Rue Mohammed V, Casablanca';

  @override
  String get dispatchAddressRequired => 'L\'adresse est obligatoire';

  @override
  String get dispatchPhone => 'Téléphone';

  @override
  String get dispatchPhoneRequired => 'Le téléphone est obligatoire';

  @override
  String get dispatchPhoneInvalid => 'Numéro de téléphone invalide';

  @override
  String get dispatchNote => 'Note';

  @override
  String get dispatchNoteHint =>
      'Instructions ou détails supplémentaires (optionnel)';

  @override
  String get dispatchUrgency => 'Urgence';

  @override
  String get dispatchASAP => 'Dès que possible';

  @override
  String get dispatchSchedule => 'Planifier';

  @override
  String get dispatchSendRequest => 'Envoyer la demande';

  @override
  String get dispatchSelectedService => 'Service sélectionné';

  @override
  String get dispatchChange => 'Changer';

  @override
  String get dispatchStepCategory => 'Service';

  @override
  String get dispatchStepDetails => 'Détails';

  @override
  String get dispatchStepSearch => 'Recherche';

  @override
  String get dispatchSearchingTitle => 'Recherche en cours';

  @override
  String get dispatchSearching => 'Recherche de prestataires…';

  @override
  String dispatchSearchingCategory(String category) {
    return 'Demande envoyée aux prestataires de $category';
  }

  @override
  String get dispatchCancelButton => 'Annuler la recherche';

  @override
  String get dispatchCancelTitle => 'Annuler la demande ?';

  @override
  String get dispatchCancelMessage =>
      'Voulez-vous vraiment annuler votre demande de dispatch ?';

  @override
  String get dispatchNo => 'Non';

  @override
  String get dispatchYesCancel => 'Oui, annuler';

  @override
  String get dispatchExpiredTitle => 'Aucun prestataire disponible';

  @override
  String get dispatchExpiredMessage =>
      'Aucun prestataire n\'a répondu dans le délai imparti. Vous pouvez relancer la recherche ou choisir manuellement.';

  @override
  String get dispatchRelaunch => 'Relancer la recherche';

  @override
  String get dispatchChooseManually => 'Choisir manuellement';

  @override
  String get dispatchMatchTitle => 'Prestataire trouvé';

  @override
  String get dispatchMatchFound => 'Un prestataire a accepté !';

  @override
  String get dispatchMatchSubtitle =>
      'Voici le prestataire qui a accepté votre demande';

  @override
  String get dispatchContinueWithProvider => 'Continuer avec ce prestataire';

  @override
  String get dispatchReviews => 'avis';

  @override
  String get dispatchDistance => 'Distance';

  @override
  String get dispatchPriceFrom => 'À partir de';

  @override
  String get dispatchRequestDetails => 'Détails de la demande';

  @override
  String get dispatchService => 'Service';

  @override
  String get dispatchSearchButton => 'Demande rapide (Dispatch)';

  @override
  String get dispatchSearchSubtext => 'Recevez un prestataire rapidement';

  @override
  String get swipeFilterButton => 'Filtrer';

  @override
  String get swipeFilterTitle => 'Filtrer par swipe';

  @override
  String get swipeFilterHint =>
      'Glissez pour garder ou masquer les prestataires';

  @override
  String get swipeFilterDone => 'Terminer';

  @override
  String get swipeFilterReset => 'Reset';

  @override
  String get swipeFilterDoneMessage => 'Filtrage terminé !';

  @override
  String get swipeFilterKept => 'prestataires gardés';

  @override
  String get swipeFilterActive => 'prestataires filtrés';
}
