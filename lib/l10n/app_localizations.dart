import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';
import 'app_localizations_fr.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en'),
    Locale('fr')
  ];

  /// No description provided for @appName.
  ///
  /// In fr, this message translates to:
  /// **'RilyBricoule'**
  String get appName;

  /// No description provided for @navHome.
  ///
  /// In fr, this message translates to:
  /// **'Accueil'**
  String get navHome;

  /// No description provided for @navSearch.
  ///
  /// In fr, this message translates to:
  /// **'Recherche'**
  String get navSearch;

  /// No description provided for @navBooking.
  ///
  /// In fr, this message translates to:
  /// **'Réservation'**
  String get navBooking;

  /// No description provided for @navMessages.
  ///
  /// In fr, this message translates to:
  /// **'Messages'**
  String get navMessages;

  /// No description provided for @navProfile.
  ///
  /// In fr, this message translates to:
  /// **'Profil'**
  String get navProfile;

  /// No description provided for @hello.
  ///
  /// In fr, this message translates to:
  /// **'Bonjour'**
  String get hello;

  /// No description provided for @helloUser.
  ///
  /// In fr, this message translates to:
  /// **'Bonjour, {name} 👋'**
  String helloUser(String name);

  /// No description provided for @locationHint.
  ///
  /// In fr, this message translates to:
  /// **'Localisation...'**
  String get locationHint;

  /// No description provided for @categories.
  ///
  /// In fr, this message translates to:
  /// **'Catégories'**
  String get categories;

  /// No description provided for @seeAll.
  ///
  /// In fr, this message translates to:
  /// **'Voir tout'**
  String get seeAll;

  /// No description provided for @nearbyProviders.
  ///
  /// In fr, this message translates to:
  /// **'Prestataires proches'**
  String get nearbyProviders;

  /// No description provided for @sortBy.
  ///
  /// In fr, this message translates to:
  /// **'Trier par'**
  String get sortBy;

  /// No description provided for @specialOffer.
  ///
  /// In fr, this message translates to:
  /// **'OFFRE SPÉCIALE'**
  String get specialOffer;

  /// No description provided for @promoDiscount.
  ///
  /// In fr, this message translates to:
  /// **'20% de réduction\nsur votre 1er Ménage'**
  String get promoDiscount;

  /// No description provided for @bookNow.
  ///
  /// In fr, this message translates to:
  /// **'Réserver maintenant'**
  String get bookNow;

  /// No description provided for @viewProfile.
  ///
  /// In fr, this message translates to:
  /// **'Voir profil'**
  String get viewProfile;

  /// No description provided for @reviewsCount.
  ///
  /// In fr, this message translates to:
  /// **'{count} avis'**
  String reviewsCount(int count);

  /// No description provided for @distanceKm.
  ///
  /// In fr, this message translates to:
  /// **'{distance} km'**
  String distanceKm(String distance);

  /// No description provided for @categoryPlumbing.
  ///
  /// In fr, this message translates to:
  /// **'Plomberie'**
  String get categoryPlumbing;

  /// No description provided for @categoryElectricity.
  ///
  /// In fr, this message translates to:
  /// **'Électricité'**
  String get categoryElectricity;

  /// No description provided for @categoryCleaning.
  ///
  /// In fr, this message translates to:
  /// **'Ménage'**
  String get categoryCleaning;

  /// No description provided for @categoryPainting.
  ///
  /// In fr, this message translates to:
  /// **'Peinture'**
  String get categoryPainting;

  /// No description provided for @categoryHandyman.
  ///
  /// In fr, this message translates to:
  /// **'Bricolage'**
  String get categoryHandyman;

  /// No description provided for @categoryGardening.
  ///
  /// In fr, this message translates to:
  /// **'Jardinage'**
  String get categoryGardening;

  /// No description provided for @categoryAC.
  ///
  /// In fr, this message translates to:
  /// **'Climatisation'**
  String get categoryAC;

  /// No description provided for @categoryCarpentry.
  ///
  /// In fr, this message translates to:
  /// **'Menuiserie'**
  String get categoryCarpentry;

  /// No description provided for @categoryLocksmith.
  ///
  /// In fr, this message translates to:
  /// **'Serrurerie'**
  String get categoryLocksmith;

  /// No description provided for @categoryMoving.
  ///
  /// In fr, this message translates to:
  /// **'Déménagement'**
  String get categoryMoving;

  /// No description provided for @categoryRepair.
  ///
  /// In fr, this message translates to:
  /// **'Réparation'**
  String get categoryRepair;

  /// No description provided for @categoryOther.
  ///
  /// In fr, this message translates to:
  /// **'Autres'**
  String get categoryOther;

  /// No description provided for @allCategories.
  ///
  /// In fr, this message translates to:
  /// **'Toutes les catégories'**
  String get allCategories;

  /// No description provided for @sortProviders.
  ///
  /// In fr, this message translates to:
  /// **'Trier les prestataires'**
  String get sortProviders;

  /// No description provided for @sortBestRated.
  ///
  /// In fr, this message translates to:
  /// **'Mieux notés'**
  String get sortBestRated;

  /// No description provided for @sortPriceLowToHigh.
  ///
  /// In fr, this message translates to:
  /// **'Prix croissant'**
  String get sortPriceLowToHigh;

  /// No description provided for @sortPriceHighToLow.
  ///
  /// In fr, this message translates to:
  /// **'Prix décroissant'**
  String get sortPriceHighToLow;

  /// No description provided for @sortNearest.
  ///
  /// In fr, this message translates to:
  /// **'Distance la plus proche'**
  String get sortNearest;

  /// No description provided for @sortAvailableNow.
  ///
  /// In fr, this message translates to:
  /// **'Disponibles maintenant'**
  String get sortAvailableNow;

  /// No description provided for @reset.
  ///
  /// In fr, this message translates to:
  /// **'Réinitialiser'**
  String get reset;

  /// No description provided for @apply.
  ///
  /// In fr, this message translates to:
  /// **'Appliquer'**
  String get apply;

  /// No description provided for @searchService.
  ///
  /// In fr, this message translates to:
  /// **'Rechercher un service...'**
  String get searchService;

  /// No description provided for @discoverSwipe.
  ///
  /// In fr, this message translates to:
  /// **'Découvrir en swipe'**
  String get discoverSwipe;

  /// No description provided for @listView.
  ///
  /// In fr, this message translates to:
  /// **'Liste'**
  String get listView;

  /// No description provided for @mapView.
  ///
  /// In fr, this message translates to:
  /// **'Carte'**
  String get mapView;

  /// No description provided for @providersFoundNearby.
  ///
  /// In fr, this message translates to:
  /// **'{count} PRESTATAIRES TROUVÉS PRÈS DE VOUS'**
  String providersFoundNearby(int count);

  /// No description provided for @busy.
  ///
  /// In fr, this message translates to:
  /// **'OCCUPÉ'**
  String get busy;

  /// No description provided for @noProviderFound.
  ///
  /// In fr, this message translates to:
  /// **'Aucun prestataire trouvé'**
  String get noProviderFound;

  /// No description provided for @filters.
  ///
  /// In fr, this message translates to:
  /// **'Filtres'**
  String get filters;

  /// No description provided for @resetAll.
  ///
  /// In fr, this message translates to:
  /// **'Tout réinitialiser'**
  String get resetAll;

  /// No description provided for @priceRange.
  ///
  /// In fr, this message translates to:
  /// **'Fourchette de prix (MAD)'**
  String get priceRange;

  /// No description provided for @priceRangeValue.
  ///
  /// In fr, this message translates to:
  /// **'{min} - {max} MAD'**
  String priceRangeValue(int min, int max);

  /// No description provided for @rating.
  ///
  /// In fr, this message translates to:
  /// **'Note'**
  String get rating;

  /// No description provided for @ratingAll.
  ///
  /// In fr, this message translates to:
  /// **'Toutes'**
  String get ratingAll;

  /// No description provided for @distance.
  ///
  /// In fr, this message translates to:
  /// **'Distance'**
  String get distance;

  /// No description provided for @distanceRadius.
  ///
  /// In fr, this message translates to:
  /// **'Dans un rayon de {km}km'**
  String distanceRadius(int km);

  /// No description provided for @availableNow.
  ///
  /// In fr, this message translates to:
  /// **'Disponible maintenant'**
  String get availableNow;

  /// No description provided for @availableNowDescription.
  ///
  /// In fr, this message translates to:
  /// **'Afficher seulement les prestataires prêts à travailler'**
  String get availableNowDescription;

  /// No description provided for @applyFilters.
  ///
  /// In fr, this message translates to:
  /// **'Appliquer les filtres'**
  String get applyFilters;

  /// No description provided for @noMoreProviders.
  ///
  /// In fr, this message translates to:
  /// **'Plus de prestataires'**
  String get noMoreProviders;

  /// No description provided for @discoverTitle.
  ///
  /// In fr, this message translates to:
  /// **'Découvrir'**
  String get discoverTitle;

  /// No description provided for @availableChip.
  ///
  /// In fr, this message translates to:
  /// **'Disponibles'**
  String get availableChip;

  /// No description provided for @noMatchCriteria.
  ///
  /// In fr, this message translates to:
  /// **'Aucun prestataire ne correspond à vos critères'**
  String get noMatchCriteria;

  /// No description provided for @resetFiltersBtn.
  ///
  /// In fr, this message translates to:
  /// **'Réinitialiser les filtres'**
  String get resetFiltersBtn;

  /// No description provided for @backToSearch.
  ///
  /// In fr, this message translates to:
  /// **'Retour à la recherche'**
  String get backToSearch;

  /// No description provided for @addedToFavorites.
  ///
  /// In fr, this message translates to:
  /// **'{name} ajouté aux favoris'**
  String addedToFavorites(String name);

  /// No description provided for @availableNowBadge.
  ///
  /// In fr, this message translates to:
  /// **'Disponible'**
  String get availableNowBadge;

  /// No description provided for @topRatedBadge.
  ///
  /// In fr, this message translates to:
  /// **'Top noté'**
  String get topRatedBadge;

  /// No description provided for @viewProfileBtn.
  ///
  /// In fr, this message translates to:
  /// **'Voir profil'**
  String get viewProfileBtn;

  /// No description provided for @errorGettingLocation.
  ///
  /// In fr, this message translates to:
  /// **'Impossible d\'obtenir votre position'**
  String get errorGettingLocation;

  /// No description provided for @errorLoadingProviders.
  ///
  /// In fr, this message translates to:
  /// **'Erreur lors du chargement des prestataires'**
  String get errorLoadingProviders;

  /// No description provided for @locationPermissionRequired.
  ///
  /// In fr, this message translates to:
  /// **'Permission de localisation requise'**
  String get locationPermissionRequired;

  /// No description provided for @locationPermissionDesc.
  ///
  /// In fr, this message translates to:
  /// **'Nous avons besoin de votre localisation pour trouver les prestataires près de vous'**
  String get locationPermissionDesc;

  /// No description provided for @allowLocation.
  ///
  /// In fr, this message translates to:
  /// **'Autoriser la localisation'**
  String get allowLocation;

  /// No description provided for @gpsDisabled.
  ///
  /// In fr, this message translates to:
  /// **'GPS désactivé'**
  String get gpsDisabled;

  /// No description provided for @gpsDisabledDesc.
  ///
  /// In fr, this message translates to:
  /// **'Veuillez activer votre GPS pour utiliser cette fonctionnalité'**
  String get gpsDisabledDesc;

  /// No description provided for @enableLocation.
  ///
  /// In fr, this message translates to:
  /// **'Activer la localisation'**
  String get enableLocation;

  /// No description provided for @errorTitle.
  ///
  /// In fr, this message translates to:
  /// **'Erreur'**
  String get errorTitle;

  /// No description provided for @errorOccurred.
  ///
  /// In fr, this message translates to:
  /// **'Une erreur est survenue'**
  String get errorOccurred;

  /// No description provided for @retry.
  ///
  /// In fr, this message translates to:
  /// **'Réessayer'**
  String get retry;

  /// No description provided for @noProvidersInYourArea.
  ///
  /// In fr, this message translates to:
  /// **'Il n\'y a pas de prestataires disponibles dans votre zone'**
  String get noProvidersInYourArea;

  /// No description provided for @showList.
  ///
  /// In fr, this message translates to:
  /// **'Afficher la liste'**
  String get showList;

  /// No description provided for @noProviderInThisArea.
  ///
  /// In fr, this message translates to:
  /// **'Aucun prestataire dans cette zone'**
  String get noProviderInThisArea;

  /// No description provided for @serviceProvider.
  ///
  /// In fr, this message translates to:
  /// **'Prestataire de services'**
  String get serviceProvider;

  /// No description provided for @yourReliablePartner.
  ///
  /// In fr, this message translates to:
  /// **'Votre partenaire de service de confiance'**
  String get yourReliablePartner;

  /// No description provided for @continueWith.
  ///
  /// In fr, this message translates to:
  /// **'Continuer avec'**
  String get continueWith;

  /// No description provided for @loginWithEmail.
  ///
  /// In fr, this message translates to:
  /// **'Se connecter avec un e-mail'**
  String get loginWithEmail;

  /// No description provided for @signUp.
  ///
  /// In fr, this message translates to:
  /// **'S\'inscrire'**
  String get signUp;

  /// No description provided for @or.
  ///
  /// In fr, this message translates to:
  /// **'ou'**
  String get or;

  /// No description provided for @termsLabel.
  ///
  /// In fr, this message translates to:
  /// **'Conditions'**
  String get termsLabel;

  /// No description provided for @privacyLabel.
  ///
  /// In fr, this message translates to:
  /// **'Confidentialité'**
  String get privacyLabel;

  /// No description provided for @welcomeBack.
  ///
  /// In fr, this message translates to:
  /// **'Prestataire de services'**
  String get welcomeBack;

  /// No description provided for @welcomeSubtitle.
  ///
  /// In fr, this message translates to:
  /// **'Bienvenue dans le meilleur système de prestataires !'**
  String get welcomeSubtitle;

  /// No description provided for @emailAddress.
  ///
  /// In fr, this message translates to:
  /// **'Adresse e-mail'**
  String get emailAddress;

  /// No description provided for @password.
  ///
  /// In fr, this message translates to:
  /// **'Mot de passe'**
  String get password;

  /// No description provided for @rememberMe.
  ///
  /// In fr, this message translates to:
  /// **'Se souvenir de moi'**
  String get rememberMe;

  /// No description provided for @forgotPasswordLink.
  ///
  /// In fr, this message translates to:
  /// **'Mot de passe oublié ?'**
  String get forgotPasswordLink;

  /// No description provided for @login.
  ///
  /// In fr, this message translates to:
  /// **'Se connecter'**
  String get login;

  /// No description provided for @orContinueWith.
  ///
  /// In fr, this message translates to:
  /// **'ou continuer avec'**
  String get orContinueWith;

  /// No description provided for @loginFailed.
  ///
  /// In fr, this message translates to:
  /// **'Échec de connexion. Vérifiez vos identifiants.'**
  String get loginFailed;

  /// No description provided for @noAccount.
  ///
  /// In fr, this message translates to:
  /// **'Vous n\'avez pas de compte?'**
  String get noAccount;

  /// No description provided for @createAccount.
  ///
  /// In fr, this message translates to:
  /// **'Créer un compte'**
  String get createAccount;

  /// No description provided for @joinUs.
  ///
  /// In fr, this message translates to:
  /// **'Rejoignez-nous !'**
  String get joinUs;

  /// No description provided for @createAccountSubtitle.
  ///
  /// In fr, this message translates to:
  /// **'Créez un compte pour commencer'**
  String get createAccountSubtitle;

  /// No description provided for @client.
  ///
  /// In fr, this message translates to:
  /// **'Client'**
  String get client;

  /// No description provided for @prestataire.
  ///
  /// In fr, this message translates to:
  /// **'Prestataire'**
  String get prestataire;

  /// No description provided for @serviceCategory.
  ///
  /// In fr, this message translates to:
  /// **'Catégorie de Service'**
  String get serviceCategory;

  /// No description provided for @yearsOfExperience.
  ///
  /// In fr, this message translates to:
  /// **'Années d\'expérience'**
  String get yearsOfExperience;

  /// No description provided for @city.
  ///
  /// In fr, this message translates to:
  /// **'Ville'**
  String get city;

  /// No description provided for @description.
  ///
  /// In fr, this message translates to:
  /// **'Description'**
  String get description;

  /// No description provided for @uploadIdDocument.
  ///
  /// In fr, this message translates to:
  /// **'Télécharger la pièce d\'identité'**
  String get uploadIdDocument;

  /// No description provided for @iAgreeToThe.
  ///
  /// In fr, this message translates to:
  /// **'J\'accepte les'**
  String get iAgreeToThe;

  /// No description provided for @termsOfService.
  ///
  /// In fr, this message translates to:
  /// **'Conditions d\'utilisation'**
  String get termsOfService;

  /// No description provided for @privacyPolicy.
  ///
  /// In fr, this message translates to:
  /// **'Politique de confidentialité'**
  String get privacyPolicy;

  /// No description provided for @register.
  ///
  /// In fr, this message translates to:
  /// **'S\'INSCRIRE'**
  String get register;

  /// No description provided for @alreadyHaveAccount.
  ///
  /// In fr, this message translates to:
  /// **'Vous avez déjà un compte?'**
  String get alreadyHaveAccount;

  /// No description provided for @fullName.
  ///
  /// In fr, this message translates to:
  /// **'Nom complet'**
  String get fullName;

  /// No description provided for @email.
  ///
  /// In fr, this message translates to:
  /// **'E-mail'**
  String get email;

  /// No description provided for @phone.
  ///
  /// In fr, this message translates to:
  /// **'Téléphone'**
  String get phone;

  /// No description provided for @confirmPassword.
  ///
  /// In fr, this message translates to:
  /// **'Confirmer le mot de passe'**
  String get confirmPassword;

  /// No description provided for @forgotPassword.
  ///
  /// In fr, this message translates to:
  /// **'Mot de passe oublié'**
  String get forgotPassword;

  /// No description provided for @resetPassword.
  ///
  /// In fr, this message translates to:
  /// **'Réinitialiser le mot de passe'**
  String get resetPassword;

  /// No description provided for @enterEmailToReset.
  ///
  /// In fr, this message translates to:
  /// **'Entrez votre e-mail pour recevoir un lien'**
  String get enterEmailToReset;

  /// No description provided for @sendResetLink.
  ///
  /// In fr, this message translates to:
  /// **'ENVOYER LE LIEN'**
  String get sendResetLink;

  /// No description provided for @resetLinkSent.
  ///
  /// In fr, this message translates to:
  /// **'Lien de réinitialisation envoyé !'**
  String get resetLinkSent;

  /// No description provided for @scheduling.
  ///
  /// In fr, this message translates to:
  /// **'Planification'**
  String get scheduling;

  /// No description provided for @errorMissingData.
  ///
  /// In fr, this message translates to:
  /// **'Erreur: Données manquantes'**
  String get errorMissingData;

  /// No description provided for @bookingProgress.
  ///
  /// In fr, this message translates to:
  /// **'PROGRESSION DE LA RÉSERVATION'**
  String get bookingProgress;

  /// No description provided for @stepOf.
  ///
  /// In fr, this message translates to:
  /// **'Étape {current} sur {total}'**
  String stepOf(int current, int total);

  /// No description provided for @chooseDate.
  ///
  /// In fr, this message translates to:
  /// **'Choisir une date'**
  String get chooseDate;

  /// No description provided for @availableSlots.
  ///
  /// In fr, this message translates to:
  /// **'Créneaux disponibles'**
  String get availableSlots;

  /// No description provided for @morning.
  ///
  /// In fr, this message translates to:
  /// **'Matin'**
  String get morning;

  /// No description provided for @afternoon.
  ///
  /// In fr, this message translates to:
  /// **'Après-midi'**
  String get afternoon;

  /// No description provided for @confirmAddress.
  ///
  /// In fr, this message translates to:
  /// **'Confirmer l\'adresse'**
  String get confirmAddress;

  /// No description provided for @useRegisteredAddress.
  ///
  /// In fr, this message translates to:
  /// **'Utiliser mon adresse enregistrée'**
  String get useRegisteredAddress;

  /// No description provided for @noteForProvider.
  ///
  /// In fr, this message translates to:
  /// **'Note pour le prestataire'**
  String get noteForProvider;

  /// No description provided for @noteHint.
  ///
  /// In fr, this message translates to:
  /// **'Ex: Code d\'entrée 1234, interphone B, 3ème porte à gauche...'**
  String get noteHint;

  /// No description provided for @continueButton.
  ///
  /// In fr, this message translates to:
  /// **'Continuer'**
  String get continueButton;

  /// No description provided for @summary.
  ///
  /// In fr, this message translates to:
  /// **'Récapitulatif'**
  String get summary;

  /// No description provided for @bookingDetails.
  ///
  /// In fr, this message translates to:
  /// **'Détails de la réservation'**
  String get bookingDetails;

  /// No description provided for @date.
  ///
  /// In fr, this message translates to:
  /// **'Date'**
  String get date;

  /// No description provided for @time.
  ///
  /// In fr, this message translates to:
  /// **'Heure'**
  String get time;

  /// No description provided for @address.
  ///
  /// In fr, this message translates to:
  /// **'Adresse'**
  String get address;

  /// No description provided for @note.
  ///
  /// In fr, this message translates to:
  /// **'Note'**
  String get note;

  /// No description provided for @notDefined.
  ///
  /// In fr, this message translates to:
  /// **'Non définie'**
  String get notDefined;

  /// No description provided for @selectedService.
  ///
  /// In fr, this message translates to:
  /// **'Service sélectionné'**
  String get selectedService;

  /// No description provided for @leakRepair.
  ///
  /// In fr, this message translates to:
  /// **'Réparation de fuite'**
  String get leakRepair;

  /// No description provided for @continueToPayment.
  ///
  /// In fr, this message translates to:
  /// **'Continuer vers le paiement'**
  String get continueToPayment;

  /// No description provided for @payment.
  ///
  /// In fr, this message translates to:
  /// **'Paiement'**
  String get payment;

  /// No description provided for @step4Payment.
  ///
  /// In fr, this message translates to:
  /// **'ÉTAPE 4: PAIEMENT'**
  String get step4Payment;

  /// No description provided for @stepCount.
  ///
  /// In fr, this message translates to:
  /// **'{current} sur {total}'**
  String stepCount(int current, int total);

  /// No description provided for @confirmed.
  ///
  /// In fr, this message translates to:
  /// **'Confirmé'**
  String get confirmed;

  /// No description provided for @priceDetails.
  ///
  /// In fr, this message translates to:
  /// **'Détails du prix'**
  String get priceDetails;

  /// No description provided for @service.
  ///
  /// In fr, this message translates to:
  /// **'Service'**
  String get service;

  /// No description provided for @platformFee.
  ///
  /// In fr, this message translates to:
  /// **'Frais de plateforme'**
  String get platformFee;

  /// No description provided for @platformFeeHelp.
  ///
  /// In fr, this message translates to:
  /// **'Frais de sécurité et support client'**
  String get platformFeeHelp;

  /// No description provided for @serviceInsurance.
  ///
  /// In fr, this message translates to:
  /// **'Assurance service'**
  String get serviceInsurance;

  /// No description provided for @insuranceCoverage.
  ///
  /// In fr, this message translates to:
  /// **'Couverture jusqu\'à 10,000 MAD'**
  String get insuranceCoverage;

  /// No description provided for @discountLabel.
  ///
  /// In fr, this message translates to:
  /// **'Réduction ({code})'**
  String discountLabel(String code);

  /// No description provided for @totalToPay.
  ///
  /// In fr, this message translates to:
  /// **'Total à payer'**
  String get totalToPay;

  /// No description provided for @preAuthOnly.
  ///
  /// In fr, this message translates to:
  /// **'Préautorisation uniquement'**
  String get preAuthOnly;

  /// No description provided for @promoCode.
  ///
  /// In fr, this message translates to:
  /// **'Code promo'**
  String get promoCode;

  /// No description provided for @promoCodeHint.
  ///
  /// In fr, this message translates to:
  /// **'Entrez votre code (ex: RILY20)'**
  String get promoCodeHint;

  /// No description provided for @promoCodeApplied.
  ///
  /// In fr, this message translates to:
  /// **'Code \"{code}\" appliqué (-{amount} MAD)'**
  String promoCodeApplied(String code, int amount);

  /// No description provided for @invalidPromoCode.
  ///
  /// In fr, this message translates to:
  /// **'Code promo invalide'**
  String get invalidPromoCode;

  /// No description provided for @paymentMethod.
  ///
  /// In fr, this message translates to:
  /// **'Moyen de paiement'**
  String get paymentMethod;

  /// No description provided for @addCard.
  ///
  /// In fr, this message translates to:
  /// **'Ajouter une carte'**
  String get addCard;

  /// No description provided for @addCardSubtitle.
  ///
  /// In fr, this message translates to:
  /// **'Pour une préautorisation sécurisée'**
  String get addCardSubtitle;

  /// No description provided for @add.
  ///
  /// In fr, this message translates to:
  /// **'Ajouter'**
  String get add;

  /// No description provided for @yourCards.
  ///
  /// In fr, this message translates to:
  /// **'Vos cartes'**
  String get yourCards;

  /// No description provided for @defaultCard.
  ///
  /// In fr, this message translates to:
  /// **'Défaut'**
  String get defaultCard;

  /// No description provided for @expires.
  ///
  /// In fr, this message translates to:
  /// **'Expire {date}'**
  String expires(String date);

  /// No description provided for @seeMore.
  ///
  /// In fr, this message translates to:
  /// **'Voir toutes les cartes ({count}+)'**
  String seeMore(int count);

  /// No description provided for @seeLess.
  ///
  /// In fr, this message translates to:
  /// **'Voir moins'**
  String get seeLess;

  /// No description provided for @orPayCash.
  ///
  /// In fr, this message translates to:
  /// **'Ou payer en espèces'**
  String get orPayCash;

  /// No description provided for @payOnSite.
  ///
  /// In fr, this message translates to:
  /// **'Paiement sur place'**
  String get payOnSite;

  /// No description provided for @payOnSiteSubtitle.
  ///
  /// In fr, this message translates to:
  /// **'Payez en espèces ou carte au prestataire'**
  String get payOnSiteSubtitle;

  /// No description provided for @preAuthInfo.
  ///
  /// In fr, this message translates to:
  /// **'Préautorisation: le montant sera bloqué sur votre carte mais débité uniquement après la completion du service.'**
  String get preAuthInfo;

  /// No description provided for @securePaymentSSL.
  ///
  /// In fr, this message translates to:
  /// **'Paiement sécurisé par cryptage SSL 256-bit'**
  String get securePaymentSSL;

  /// No description provided for @buyerProtection.
  ///
  /// In fr, this message translates to:
  /// **'Protection acheteur jusqu\'à 10,000 MAD'**
  String get buyerProtection;

  /// No description provided for @preAuthDone.
  ///
  /// In fr, this message translates to:
  /// **'Préautorisation effectuée !'**
  String get preAuthDone;

  /// No description provided for @preAuthDescription.
  ///
  /// In fr, this message translates to:
  /// **'Le montant a été bloqué sur votre carte. Il ne sera débité qu\'après la completion du service.'**
  String get preAuthDescription;

  /// No description provided for @confirmation.
  ///
  /// In fr, this message translates to:
  /// **'Confirmation'**
  String get confirmation;

  /// No description provided for @bookingConfirmed.
  ///
  /// In fr, this message translates to:
  /// **'Réservation confirmée!'**
  String get bookingConfirmed;

  /// No description provided for @bookingConfirmedMessage.
  ///
  /// In fr, this message translates to:
  /// **'Votre demande a été acceptée. Le bricoleur vous attend à l\'heure prévue.'**
  String get bookingConfirmedMessage;

  /// No description provided for @serviceDetails.
  ///
  /// In fr, this message translates to:
  /// **'DÉTAILS DE LA PRESTATION'**
  String get serviceDetails;

  /// No description provided for @contactProvider.
  ///
  /// In fr, this message translates to:
  /// **'Contacter le prestataire'**
  String get contactProvider;

  /// No description provided for @viewMyBookings.
  ///
  /// In fr, this message translates to:
  /// **'Voir mes réservations'**
  String get viewMyBookings;

  /// No description provided for @backToHome.
  ///
  /// In fr, this message translates to:
  /// **'Retour à l\'accueil'**
  String get backToHome;

  /// No description provided for @myReservations.
  ///
  /// In fr, this message translates to:
  /// **'Mes Réservations'**
  String get myReservations;

  /// No description provided for @noUpcomingReservation.
  ///
  /// In fr, this message translates to:
  /// **'Aucune réservation à venir'**
  String get noUpcomingReservation;

  /// No description provided for @noOngoingReservation.
  ///
  /// In fr, this message translates to:
  /// **'Aucune réservation en cours'**
  String get noOngoingReservation;

  /// No description provided for @noCompletedReservation.
  ///
  /// In fr, this message translates to:
  /// **'Aucune réservation terminée'**
  String get noCompletedReservation;

  /// No description provided for @noCancelledReservation.
  ///
  /// In fr, this message translates to:
  /// **'Aucune réservation annulée'**
  String get noCancelledReservation;

  /// No description provided for @exploreProviders.
  ///
  /// In fr, this message translates to:
  /// **'Explorer des prestataires'**
  String get exploreProviders;

  /// No description provided for @errorLabel.
  ///
  /// In fr, this message translates to:
  /// **'Erreur: {message}'**
  String errorLabel(String message);

  /// No description provided for @reservationTracking.
  ///
  /// In fr, this message translates to:
  /// **'Suivi de la réservation'**
  String get reservationTracking;

  /// No description provided for @cancelReservation.
  ///
  /// In fr, this message translates to:
  /// **'Annuler la réservation'**
  String get cancelReservation;

  /// No description provided for @cancelReservationQuestion.
  ///
  /// In fr, this message translates to:
  /// **'Annuler la réservation ?'**
  String get cancelReservationQuestion;

  /// No description provided for @reservationCancelled.
  ///
  /// In fr, this message translates to:
  /// **'Réservation annulée'**
  String get reservationCancelled;

  /// No description provided for @cancelWarningText.
  ///
  /// In fr, this message translates to:
  /// **'Vous pouvez annuler cette réservation. Cette action est irréversible.'**
  String get cancelWarningText;

  /// No description provided for @discuss.
  ///
  /// In fr, this message translates to:
  /// **'Discuter'**
  String get discuss;

  /// No description provided for @chatWith.
  ///
  /// In fr, this message translates to:
  /// **'Discuter avec {providerName}'**
  String chatWith(String providerName);

  /// No description provided for @statusConfirmed.
  ///
  /// In fr, this message translates to:
  /// **'Confirmé'**
  String get statusConfirmed;

  /// No description provided for @statusEnRoute.
  ///
  /// In fr, this message translates to:
  /// **'En route'**
  String get statusEnRoute;

  /// No description provided for @statusInProgress.
  ///
  /// In fr, this message translates to:
  /// **'En cours'**
  String get statusInProgress;

  /// No description provided for @statusCompleted.
  ///
  /// In fr, this message translates to:
  /// **'TERMINÉE'**
  String get statusCompleted;

  /// No description provided for @statusCancelled.
  ///
  /// In fr, this message translates to:
  /// **'ANNULÉE'**
  String get statusCancelled;

  /// No description provided for @statusNotStarted.
  ///
  /// In fr, this message translates to:
  /// **'Non démarré'**
  String get statusNotStarted;

  /// No description provided for @validatedAt.
  ///
  /// In fr, this message translates to:
  /// **'Validé à {time}'**
  String validatedAt(String time);

  /// No description provided for @providerArriving.
  ///
  /// In fr, this message translates to:
  /// **'Le prestataire arrive'**
  String get providerArriving;

  /// No description provided for @arrivedAt.
  ///
  /// In fr, this message translates to:
  /// **'Arrivé à {time}'**
  String arrivedAt(String time);

  /// No description provided for @interventionInProgress.
  ///
  /// In fr, this message translates to:
  /// **'Intervention en cours'**
  String get interventionInProgress;

  /// No description provided for @completedAt.
  ///
  /// In fr, this message translates to:
  /// **'Terminé à {time}'**
  String completedAt(String time);

  /// No description provided for @serviceComplete.
  ///
  /// In fr, this message translates to:
  /// **'Prestation complète'**
  String get serviceComplete;

  /// No description provided for @bookingConfirmedHeader.
  ///
  /// In fr, this message translates to:
  /// **'Réservation confirmée'**
  String get bookingConfirmedHeader;

  /// No description provided for @providerStartsSoon.
  ///
  /// In fr, this message translates to:
  /// **'Votre prestataire va bientôt commencer.'**
  String get providerStartsSoon;

  /// No description provided for @providerEnRouteHeader.
  ///
  /// In fr, this message translates to:
  /// **'Le prestataire est en route'**
  String get providerEnRouteHeader;

  /// No description provided for @providerLeftAppointment.
  ///
  /// In fr, this message translates to:
  /// **'{providerName} a quitté son précédent rendez-vous.'**
  String providerLeftAppointment(String providerName);

  /// No description provided for @interventionInProgressHeader.
  ///
  /// In fr, this message translates to:
  /// **'Intervention en cours'**
  String get interventionInProgressHeader;

  /// No description provided for @providerWorkingNow.
  ///
  /// In fr, this message translates to:
  /// **'Le prestataire travaille actuellement chez vous.'**
  String get providerWorkingNow;

  /// No description provided for @serviceCompletedHeader.
  ///
  /// In fr, this message translates to:
  /// **'Prestation terminée'**
  String get serviceCompletedHeader;

  /// No description provided for @thanksLeaveReview.
  ///
  /// In fr, this message translates to:
  /// **'Merci ! Vous pouvez laisser un avis.'**
  String get thanksLeaveReview;

  /// No description provided for @bookingCancelledHeader.
  ///
  /// In fr, this message translates to:
  /// **'Réservation annulée'**
  String get bookingCancelledHeader;

  /// No description provided for @bookingNoLongerActive.
  ///
  /// In fr, this message translates to:
  /// **'Cette réservation n\'est plus active.'**
  String get bookingNoLongerActive;

  /// No description provided for @estimatedArrival.
  ///
  /// In fr, this message translates to:
  /// **'ARRIVÉE PRÉVUE'**
  String get estimatedArrival;

  /// No description provided for @minPlaceholder.
  ///
  /// In fr, this message translates to:
  /// **'min'**
  String get minPlaceholder;

  /// No description provided for @avisText.
  ///
  /// In fr, this message translates to:
  /// **'{count} avis'**
  String avisText(String count);

  /// No description provided for @back.
  ///
  /// In fr, this message translates to:
  /// **'Retour'**
  String get back;

  /// No description provided for @cancel.
  ///
  /// In fr, this message translates to:
  /// **'Annuler'**
  String get cancel;

  /// No description provided for @chatDisabled.
  ///
  /// In fr, this message translates to:
  /// **'Chat désactivé'**
  String get chatDisabled;

  /// No description provided for @leaveReview.
  ///
  /// In fr, this message translates to:
  /// **'Laisser un avis'**
  String get leaveReview;

  /// No description provided for @callComingSoon.
  ///
  /// In fr, this message translates to:
  /// **'Appel (bientôt)'**
  String get callComingSoon;

  /// No description provided for @contactSupport.
  ///
  /// In fr, this message translates to:
  /// **'Contacter le support'**
  String get contactSupport;

  /// No description provided for @comingSoon.
  ///
  /// In fr, this message translates to:
  /// **'Fonction bientôt disponible'**
  String get comingSoon;

  /// No description provided for @chatOnlyAfterBooking.
  ///
  /// In fr, this message translates to:
  /// **'Chat disponible uniquement après réservation confirmée'**
  String get chatOnlyAfterBooking;

  /// No description provided for @returnToReservations.
  ///
  /// In fr, this message translates to:
  /// **'Retour à mes réservations'**
  String get returnToReservations;

  /// No description provided for @howWasService.
  ///
  /// In fr, this message translates to:
  /// **'Comment s\'est passée votre prestation ?'**
  String get howWasService;

  /// No description provided for @rateExperience.
  ///
  /// In fr, this message translates to:
  /// **'Notez votre expérience avec {name}'**
  String rateExperience(String name);

  /// No description provided for @whatDoYouThink.
  ///
  /// In fr, this message translates to:
  /// **'Que pensez-vous du service ?'**
  String get whatDoYouThink;

  /// No description provided for @yourCommentOptional.
  ///
  /// In fr, this message translates to:
  /// **'Votre commentaire (optionnel)'**
  String get yourCommentOptional;

  /// No description provided for @describeExperience.
  ///
  /// In fr, this message translates to:
  /// **'Décrivez votre expérience...'**
  String get describeExperience;

  /// No description provided for @submitReview.
  ///
  /// In fr, this message translates to:
  /// **'Envoyer mon avis'**
  String get submitReview;

  /// No description provided for @pleaseSelectRating.
  ///
  /// In fr, this message translates to:
  /// **'Veuillez sélectionner une note'**
  String get pleaseSelectRating;

  /// No description provided for @thankYouReview.
  ///
  /// In fr, this message translates to:
  /// **'Merci pour votre avis !'**
  String get thankYouReview;

  /// No description provided for @tagExcellent.
  ///
  /// In fr, this message translates to:
  /// **'Excellent service'**
  String get tagExcellent;

  /// No description provided for @tagPunctual.
  ///
  /// In fr, this message translates to:
  /// **'Ponctuel'**
  String get tagPunctual;

  /// No description provided for @tagNeatWork.
  ///
  /// In fr, this message translates to:
  /// **'Travail soigné'**
  String get tagNeatWork;

  /// No description provided for @tagProfessional.
  ///
  /// In fr, this message translates to:
  /// **'Professionnel'**
  String get tagProfessional;

  /// No description provided for @tagRecommended.
  ///
  /// In fr, this message translates to:
  /// **'À recommander'**
  String get tagRecommended;

  /// No description provided for @profile.
  ///
  /// In fr, this message translates to:
  /// **'Profil'**
  String get profile;

  /// No description provided for @myActivity.
  ///
  /// In fr, this message translates to:
  /// **'Mon Activité'**
  String get myActivity;

  /// No description provided for @myReservationsMenu.
  ///
  /// In fr, this message translates to:
  /// **'Mes réservations'**
  String get myReservationsMenu;

  /// No description provided for @paymentMethods.
  ///
  /// In fr, this message translates to:
  /// **'Modes de paiement'**
  String get paymentMethods;

  /// No description provided for @favorites.
  ///
  /// In fr, this message translates to:
  /// **'Favoris'**
  String get favorites;

  /// No description provided for @language.
  ///
  /// In fr, this message translates to:
  /// **'Langue'**
  String get language;

  /// No description provided for @helpCenter.
  ///
  /// In fr, this message translates to:
  /// **'Centre d\'aide'**
  String get helpCenter;

  /// No description provided for @about.
  ///
  /// In fr, this message translates to:
  /// **'À propos'**
  String get about;

  /// No description provided for @logout.
  ///
  /// In fr, this message translates to:
  /// **'Déconnexion'**
  String get logout;

  /// No description provided for @editProfile.
  ///
  /// In fr, this message translates to:
  /// **'Modifier le profil'**
  String get editProfile;

  /// No description provided for @toBeImplemented.
  ///
  /// In fr, this message translates to:
  /// **'(To be implemented)'**
  String get toBeImplemented;

  /// No description provided for @languageChangedTo.
  ///
  /// In fr, this message translates to:
  /// **'Langue changée : {lang}'**
  String languageChangedTo(String lang);

  /// No description provided for @chooseLanguage.
  ///
  /// In fr, this message translates to:
  /// **'Choisir la langue'**
  String get chooseLanguage;

  /// No description provided for @french.
  ///
  /// In fr, this message translates to:
  /// **'Français'**
  String get french;

  /// No description provided for @english.
  ///
  /// In fr, this message translates to:
  /// **'English'**
  String get english;

  /// No description provided for @arabic.
  ///
  /// In fr, this message translates to:
  /// **'العربية'**
  String get arabic;

  /// No description provided for @tabUpcoming.
  ///
  /// In fr, this message translates to:
  /// **'À venir'**
  String get tabUpcoming;

  /// No description provided for @tabOngoing.
  ///
  /// In fr, this message translates to:
  /// **'En cours'**
  String get tabOngoing;

  /// No description provided for @tabCompleted.
  ///
  /// In fr, this message translates to:
  /// **'Terminées'**
  String get tabCompleted;

  /// No description provided for @tabCancelled.
  ///
  /// In fr, this message translates to:
  /// **'Annulées'**
  String get tabCancelled;

  /// No description provided for @statusUpcoming.
  ///
  /// In fr, this message translates to:
  /// **'À VENIR'**
  String get statusUpcoming;

  /// No description provided for @statusOngoing.
  ///
  /// In fr, this message translates to:
  /// **'EN COURS'**
  String get statusOngoing;

  /// No description provided for @labelArrival.
  ///
  /// In fr, this message translates to:
  /// **'Arrivée'**
  String get labelArrival;

  /// No description provided for @btnLeaveReview.
  ///
  /// In fr, this message translates to:
  /// **'Laisser un avis'**
  String get btnLeaveReview;

  /// No description provided for @btnInvoice.
  ///
  /// In fr, this message translates to:
  /// **'Facture'**
  String get btnInvoice;

  /// No description provided for @btnViewDetails.
  ///
  /// In fr, this message translates to:
  /// **'Voir détails'**
  String get btnViewDetails;

  /// No description provided for @msgNewMessage.
  ///
  /// In fr, this message translates to:
  /// **'Nouveau message'**
  String get msgNewMessage;

  /// No description provided for @msgFindProviderToStart.
  ///
  /// In fr, this message translates to:
  /// **'Trouvez un prestataire pour commencer une conversation'**
  String get msgFindProviderToStart;

  /// No description provided for @msgMessagesTitle.
  ///
  /// In fr, this message translates to:
  /// **'Messages'**
  String get msgMessagesTitle;

  /// No description provided for @msgOptionsSoon.
  ///
  /// In fr, this message translates to:
  /// **'Options (bientôt)'**
  String get msgOptionsSoon;

  /// No description provided for @msgSearchConversation.
  ///
  /// In fr, this message translates to:
  /// **'Rechercher une conversation...'**
  String get msgSearchConversation;

  /// No description provided for @msgNoConversations.
  ///
  /// In fr, this message translates to:
  /// **'Aucune conversation pour le moment'**
  String get msgNoConversations;

  /// No description provided for @msgConversationsAppearHere.
  ///
  /// In fr, this message translates to:
  /// **'Vos conversations avec les prestataires apparaîtront ici après une réservation ou un premier contact.'**
  String get msgConversationsAppearHere;

  /// No description provided for @msgNoResults.
  ///
  /// In fr, this message translates to:
  /// **'Aucun résultat'**
  String get msgNoResults;

  /// No description provided for @msgTryAnotherSearchTerm.
  ///
  /// In fr, this message translates to:
  /// **'Essayez avec un autre terme de recherche'**
  String get msgTryAnotherSearchTerm;

  /// No description provided for @msgResetSearch.
  ///
  /// In fr, this message translates to:
  /// **'Réinitialiser la recherche'**
  String get msgResetSearch;

  /// No description provided for @memberSinceDate.
  ///
  /// In fr, this message translates to:
  /// **'Membre depuis {date}'**
  String memberSinceDate(String date);

  /// No description provided for @supportAndInfo.
  ///
  /// In fr, this message translates to:
  /// **'Support & Info'**
  String get supportAndInfo;

  /// No description provided for @aboutProvider.
  ///
  /// In fr, this message translates to:
  /// **'À propos'**
  String get aboutProvider;

  /// No description provided for @customerReviews.
  ///
  /// In fr, this message translates to:
  /// **'Avis clients'**
  String get customerReviews;

  /// No description provided for @showAllReviews.
  ///
  /// In fr, this message translates to:
  /// **'Afficher les {count} avis'**
  String showAllReviews(int count);

  /// No description provided for @readMore.
  ///
  /// In fr, this message translates to:
  /// **'Voir plus'**
  String get readMore;

  /// No description provided for @readLess.
  ///
  /// In fr, this message translates to:
  /// **'Voir moins'**
  String get readLess;

  /// No description provided for @statusLabel.
  ///
  /// In fr, this message translates to:
  /// **'STATUT'**
  String get statusLabel;

  /// No description provided for @certifiedStatus.
  ///
  /// In fr, this message translates to:
  /// **'Certifié'**
  String get certifiedStatus;

  /// No description provided for @missionsLabel.
  ///
  /// In fr, this message translates to:
  /// **'MISSIONS'**
  String get missionsLabel;

  /// No description provided for @responseLabel.
  ///
  /// In fr, this message translates to:
  /// **'RÉPONSE'**
  String get responseLabel;

  /// No description provided for @book.
  ///
  /// In fr, this message translates to:
  /// **'Réserver'**
  String get book;

  /// No description provided for @stepXofY.
  ///
  /// In fr, this message translates to:
  /// **'Étape {step} sur {total}'**
  String stepXofY(int step, int total);

  /// No description provided for @btnContinue.
  ///
  /// In fr, this message translates to:
  /// **'Continuer'**
  String get btnContinue;

  /// No description provided for @securePreAuth.
  ///
  /// In fr, this message translates to:
  /// **'Pour une préautorisation sécurisée'**
  String get securePreAuth;

  /// No description provided for @orPayInCash.
  ///
  /// In fr, this message translates to:
  /// **'Ou payer en espèces'**
  String get orPayInCash;

  /// No description provided for @payInCashOrCardToProvider.
  ///
  /// In fr, this message translates to:
  /// **'Payez en espèces ou carte au prestataire'**
  String get payInCashOrCardToProvider;

  /// No description provided for @preAuthorizeAmount.
  ///
  /// In fr, this message translates to:
  /// **'Préautoriser {amount}'**
  String preAuthorizeAmount(int amount);

  /// No description provided for @plumberExpert.
  ///
  /// In fr, this message translates to:
  /// **'Plombier Expert'**
  String get plumberExpert;

  /// No description provided for @yearsExp.
  ///
  /// In fr, this message translates to:
  /// **'{years} ans d\'exp.'**
  String yearsExp(int years);

  /// No description provided for @emailHint.
  ///
  /// In fr, this message translates to:
  /// **'johndoe@gmail.com'**
  String get emailHint;

  /// No description provided for @passwordHint.
  ///
  /// In fr, this message translates to:
  /// **'••••••••••'**
  String get passwordHint;

  /// No description provided for @nameHint.
  ///
  /// In fr, this message translates to:
  /// **'NOM PRÉNOM'**
  String get nameHint;

  /// No description provided for @phoneHint.
  ///
  /// In fr, this message translates to:
  /// **'Entrez votre numéro de téléphone'**
  String get phoneHint;

  /// No description provided for @confirmPasswordHint.
  ///
  /// In fr, this message translates to:
  /// **'Confirmez votre mot de passe'**
  String get confirmPasswordHint;

  /// No description provided for @experienceHint.
  ///
  /// In fr, this message translates to:
  /// **'Entrez vos années d\'expérience'**
  String get experienceHint;

  /// No description provided for @cityHint.
  ///
  /// In fr, this message translates to:
  /// **'Entrez votre ville'**
  String get cityHint;

  /// No description provided for @descriptionHint.
  ///
  /// In fr, this message translates to:
  /// **'Parlez-nous de vos services'**
  String get descriptionHint;

  /// No description provided for @idUploadComingSoon.
  ///
  /// In fr, this message translates to:
  /// **'Téléchargement d\'ID - Bientôt disponible'**
  String get idUploadComingSoon;

  /// No description provided for @agreeToTermsRequired.
  ///
  /// In fr, this message translates to:
  /// **'Veuillez accepter les conditions et politiques'**
  String get agreeToTermsRequired;

  /// No description provided for @errorNameRequired.
  ///
  /// In fr, this message translates to:
  /// **'Veuillez entrer votre nom'**
  String get errorNameRequired;

  /// No description provided for @errorEmailRequired.
  ///
  /// In fr, this message translates to:
  /// **'Veuillez entrer votre e-mail'**
  String get errorEmailRequired;

  /// No description provided for @errorPhoneRequired.
  ///
  /// In fr, this message translates to:
  /// **'Veuillez entrer votre téléphone'**
  String get errorPhoneRequired;

  /// No description provided for @errorPasswordRequired.
  ///
  /// In fr, this message translates to:
  /// **'Veuillez entrer votre mot de passe'**
  String get errorPasswordRequired;

  /// No description provided for @errorPasswordLength.
  ///
  /// In fr, this message translates to:
  /// **'Le mot de passe doit contenir au moins 6 caractères'**
  String get errorPasswordLength;

  /// No description provided for @errorConfirmPasswordRequired.
  ///
  /// In fr, this message translates to:
  /// **'Veuillez confirmer votre mot de passe'**
  String get errorConfirmPasswordRequired;

  /// No description provided for @errorPasswordsNotMatch.
  ///
  /// In fr, this message translates to:
  /// **'Les mots de passe ne correspondent pas'**
  String get errorPasswordsNotMatch;

  /// No description provided for @errorCategoryRequired.
  ///
  /// In fr, this message translates to:
  /// **'Veuillez sélectionner une catégorie'**
  String get errorCategoryRequired;

  /// No description provided for @errorExperienceRequired.
  ///
  /// In fr, this message translates to:
  /// **'Veuillez entrer votre expérience'**
  String get errorExperienceRequired;

  /// No description provided for @errorCityRequired.
  ///
  /// In fr, this message translates to:
  /// **'Veuillez entrer votre ville'**
  String get errorCityRequired;

  /// No description provided for @errorDescriptionRequired.
  ///
  /// In fr, this message translates to:
  /// **'Veuillez entrer une description'**
  String get errorDescriptionRequired;

  /// No description provided for @notificationsTitle.
  ///
  /// In fr, this message translates to:
  /// **'Notifications'**
  String get notificationsTitle;

  /// No description provided for @markAllAsRead.
  ///
  /// In fr, this message translates to:
  /// **'Tout marquer comme lu'**
  String get markAllAsRead;

  /// No description provided for @deleteAll.
  ///
  /// In fr, this message translates to:
  /// **'Supprimer tout'**
  String get deleteAll;

  /// No description provided for @noNotificationsMsg.
  ///
  /// In fr, this message translates to:
  /// **'Aucune notification'**
  String get noNotificationsMsg;

  /// No description provided for @noNotificationsDesc.
  ///
  /// In fr, this message translates to:
  /// **'Vous serez informé ici des mises à jour importantes.'**
  String get noNotificationsDesc;

  /// No description provided for @deleteAllTitle.
  ///
  /// In fr, this message translates to:
  /// **'Supprimer toutes les notifications'**
  String get deleteAllTitle;

  /// No description provided for @deleteAllDesc.
  ///
  /// In fr, this message translates to:
  /// **'Êtes-vous sûr de vouloir supprimer toutes les notifications ?'**
  String get deleteAllDesc;

  /// No description provided for @selectedCount.
  ///
  /// In fr, this message translates to:
  /// **'{count} sélectionné(s)'**
  String selectedCount(int count);

  /// No description provided for @deleteAction.
  ///
  /// In fr, this message translates to:
  /// **'Supprimer'**
  String get deleteAction;

  /// No description provided for @invoiceTitle.
  ///
  /// In fr, this message translates to:
  /// **'Facture'**
  String get invoiceTitle;

  /// No description provided for @shareComingSoon.
  ///
  /// In fr, this message translates to:
  /// **'Partager bientôt disponible'**
  String get shareComingSoon;

  /// No description provided for @downloadComingSoon.
  ///
  /// In fr, this message translates to:
  /// **'Téléchargement bientôt disponible'**
  String get downloadComingSoon;

  /// No description provided for @paidStatus.
  ///
  /// In fr, this message translates to:
  /// **'Payée'**
  String get paidStatus;

  /// No description provided for @serviceDetailsTitle.
  ///
  /// In fr, this message translates to:
  /// **'Détails de la prestation'**
  String get serviceDetailsTitle;

  /// No description provided for @providerLabel.
  ///
  /// In fr, this message translates to:
  /// **'Prestataire'**
  String get providerLabel;

  /// No description provided for @dateLabel.
  ///
  /// In fr, this message translates to:
  /// **'Date'**
  String get dateLabel;

  /// No description provided for @timeLabel.
  ///
  /// In fr, this message translates to:
  /// **'Heure'**
  String get timeLabel;

  /// No description provided for @paymentDetailsTitle.
  ///
  /// In fr, this message translates to:
  /// **'Détails du paiement'**
  String get paymentDetailsTitle;

  /// No description provided for @serviceFeeLabel.
  ///
  /// In fr, this message translates to:
  /// **'Frais de service'**
  String get serviceFeeLabel;

  /// No description provided for @taxLabel.
  ///
  /// In fr, this message translates to:
  /// **'TVA (20%)'**
  String get taxLabel;

  /// No description provided for @totalTotalLabel.
  ///
  /// In fr, this message translates to:
  /// **'Total'**
  String get totalTotalLabel;

  /// No description provided for @paymentMethodLabel.
  ///
  /// In fr, this message translates to:
  /// **'Méthode de paiement'**
  String get paymentMethodLabel;

  /// No description provided for @creditCardLabel.
  ///
  /// In fr, this message translates to:
  /// **'Carte bancaire •••• 4242'**
  String get creditCardLabel;

  /// No description provided for @invoiceIssuedOn.
  ///
  /// In fr, this message translates to:
  /// **'Facture émise le {date}'**
  String invoiceIssuedOn(String date);

  /// No description provided for @downloadInvoiceBtn.
  ///
  /// In fr, this message translates to:
  /// **'Télécharger la facture'**
  String get downloadInvoiceBtn;

  /// No description provided for @invoiceNumber.
  ///
  /// In fr, this message translates to:
  /// **'Facture #{number}'**
  String invoiceNumber(String number);

  /// No description provided for @onlinePaymentTitle.
  ///
  /// In fr, this message translates to:
  /// **'Paiement en ligne'**
  String get onlinePaymentTitle;

  /// No description provided for @addCmiCardLabel.
  ///
  /// In fr, this message translates to:
  /// **'Ajouter une carte (CMI)'**
  String get addCmiCardLabel;

  /// No description provided for @cmiCardDescription.
  ///
  /// In fr, this message translates to:
  /// **'Visa, Mastercard via CMI'**
  String get cmiCardDescription;

  /// No description provided for @paymentMethodsTitleLabel.
  ///
  /// In fr, this message translates to:
  /// **'Modes de paiement'**
  String get paymentMethodsTitleLabel;

  /// No description provided for @expiresAt.
  ///
  /// In fr, this message translates to:
  /// **'Expire {date}'**
  String expiresAt(String date);

  /// No description provided for @expiresLabel.
  ///
  /// In fr, this message translates to:
  /// **'Expire {date}'**
  String expiresLabel(String date);

  /// No description provided for @expiresShortLabel.
  ///
  /// In fr, this message translates to:
  /// **'EXPIRE'**
  String get expiresShortLabel;

  /// No description provided for @expiryDateLabel.
  ///
  /// In fr, this message translates to:
  /// **'Expiration (MM/AA)'**
  String get expiryDateLabel;

  /// No description provided for @defaultCardChip.
  ///
  /// In fr, this message translates to:
  /// **'Par défaut'**
  String get defaultCardChip;

  /// No description provided for @defaultLabel.
  ///
  /// In fr, this message translates to:
  /// **'Par défaut'**
  String get defaultLabel;

  /// No description provided for @authRequiredForCard.
  ///
  /// In fr, this message translates to:
  /// **'Veuillez vous authentifier pour voir les détails de la carte'**
  String get authRequiredForCard;

  /// No description provided for @editCardInfo.
  ///
  /// In fr, this message translates to:
  /// **'Modifier les informations'**
  String get editCardInfo;

  /// No description provided for @setAsDefaultCard.
  ///
  /// In fr, this message translates to:
  /// **'Définir par défaut'**
  String get setAsDefaultCard;

  /// No description provided for @deleteCardLabel.
  ///
  /// In fr, this message translates to:
  /// **'Supprimer la carte'**
  String get deleteCardLabel;

  /// No description provided for @howItWorksLabel.
  ///
  /// In fr, this message translates to:
  /// **'Comment fonctionnent les paiements ?'**
  String get howItWorksLabel;

  /// No description provided for @learnMoreButton.
  ///
  /// In fr, this message translates to:
  /// **'Découvrez comment nous protégeons vos transactions'**
  String get learnMoreButton;

  /// No description provided for @emptyStateAlert.
  ///
  /// In fr, this message translates to:
  /// **'Ajoutez une carte ou activez le paiement sur place pour pouvoir effectuer des réservations.'**
  String get emptyStateAlert;

  /// No description provided for @addCardTitle.
  ///
  /// In fr, this message translates to:
  /// **'Ajouter une carte'**
  String get addCardTitle;

  /// No description provided for @cmiSubtitle.
  ///
  /// In fr, this message translates to:
  /// **'CMI - Centre Monétique Interbancaire'**
  String get cmiSubtitle;

  /// No description provided for @nameOnCardLabel.
  ///
  /// In fr, this message translates to:
  /// **'Nom sur la carte'**
  String get nameOnCardLabel;

  /// No description provided for @cardNumberLabel.
  ///
  /// In fr, this message translates to:
  /// **'Numéro de carte'**
  String get cardNumberLabel;

  /// No description provided for @cvvLabel.
  ///
  /// In fr, this message translates to:
  /// **'CVV'**
  String get cvvLabel;

  /// No description provided for @setAsDefaultLabel.
  ///
  /// In fr, this message translates to:
  /// **'Définir comme carte par défaut'**
  String get setAsDefaultLabel;

  /// No description provided for @setAsDefaultDescription.
  ///
  /// In fr, this message translates to:
  /// **'Cette carte sera utilisée par défaut pour les paiements'**
  String get setAsDefaultDescription;

  /// No description provided for @saveCardButton.
  ///
  /// In fr, this message translates to:
  /// **'Enregistrer la carte'**
  String get saveCardButton;

  /// No description provided for @invalidCardNumber.
  ///
  /// In fr, this message translates to:
  /// **'Numéro de carte invalide'**
  String get invalidCardNumber;

  /// No description provided for @nameRequired.
  ///
  /// In fr, this message translates to:
  /// **'Nom requis'**
  String get nameRequired;

  /// No description provided for @expiryRequired.
  ///
  /// In fr, this message translates to:
  /// **'Date d\'expiration requise'**
  String get expiryRequired;

  /// No description provided for @invalidExpiry.
  ///
  /// In fr, this message translates to:
  /// **'Expiration invalide'**
  String get invalidExpiry;

  /// No description provided for @invalidCvv.
  ///
  /// In fr, this message translates to:
  /// **'CVV invalide'**
  String get invalidCvv;

  /// No description provided for @deleteCardConfirmTitle.
  ///
  /// In fr, this message translates to:
  /// **'Supprimer la carte ?'**
  String get deleteCardConfirmTitle;

  /// No description provided for @deleteCardConfirmContent.
  ///
  /// In fr, this message translates to:
  /// **'Voulez-vous vraiment supprimer {cardLabel} ?'**
  String deleteCardConfirmContent(String cardLabel);

  /// No description provided for @cardCannotBeDeleted.
  ///
  /// In fr, this message translates to:
  /// **'Impossible de supprimer cette carte'**
  String get cardCannotBeDeleted;

  /// No description provided for @cardDeletedSuccess.
  ///
  /// In fr, this message translates to:
  /// **'Carte supprimée'**
  String get cardDeletedSuccess;

  /// No description provided for @cardDeleteError.
  ///
  /// In fr, this message translates to:
  /// **'Erreur lors de la suppression'**
  String get cardDeleteError;

  /// No description provided for @cardSetDefaultSuccess.
  ///
  /// In fr, this message translates to:
  /// **'Carte définie par défaut'**
  String get cardSetDefaultSuccess;

  /// No description provided for @editCardTitle.
  ///
  /// In fr, this message translates to:
  /// **'Modifier la carte'**
  String get editCardTitle;

  /// No description provided for @editCardWarning.
  ///
  /// In fr, this message translates to:
  /// **'Note : Vous pouvez uniquement modifier le libellé et la date d\'expiration.'**
  String get editCardWarning;

  /// No description provided for @saveChanges.
  ///
  /// In fr, this message translates to:
  /// **'Enregistrer les modifications'**
  String get saveChanges;

  /// No description provided for @paymentInfoTitle.
  ///
  /// In fr, this message translates to:
  /// **'Informations paiement'**
  String get paymentInfoTitle;

  /// No description provided for @securePayment.
  ///
  /// In fr, this message translates to:
  /// **'Paiement sécurisé'**
  String get securePayment;

  /// No description provided for @moneyProtected.
  ///
  /// In fr, this message translates to:
  /// **'Votre argent est protégé'**
  String get moneyProtected;

  /// No description provided for @cmiPreauthDesc.
  ///
  /// In fr, this message translates to:
  /// **'RiLyBricoule utilise le système de préautorisation CMI pour garantir que vous ne payez que les services effectivement réalisés.'**
  String get cmiPreauthDesc;

  /// No description provided for @cmiPreauth.
  ///
  /// In fr, this message translates to:
  /// **'Préautorisation CMI'**
  String get cmiPreauth;

  /// No description provided for @cmiPreauthDetail1.
  ///
  /// In fr, this message translates to:
  /// **'Le montant est BLOQUÉ sur votre carte bancaire'**
  String get cmiPreauthDetail1;

  /// No description provided for @cmiPreauthDetail2.
  ///
  /// In fr, this message translates to:
  /// **'Aucun débit n\'est effectué immédiatement'**
  String get cmiPreauthDetail2;

  /// No description provided for @cmiPreauthDetail3.
  ///
  /// In fr, this message translates to:
  /// **'Le débit final se fait APRÈS service terminé'**
  String get cmiPreauthDetail3;

  /// No description provided for @cmiPreauthDetail4.
  ///
  /// In fr, this message translates to:
  /// **'Si annulation, le blocage est levé sous 48h'**
  String get cmiPreauthDetail4;

  /// No description provided for @cashPayment.
  ///
  /// In fr, this message translates to:
  /// **'Paiement en espèces'**
  String get cashPayment;

  /// No description provided for @cashPaymentDetail1.
  ///
  /// In fr, this message translates to:
  /// **'Aucune transaction en ligne'**
  String get cashPaymentDetail1;

  /// No description provided for @cashPaymentDetail2.
  ///
  /// In fr, this message translates to:
  /// **'Réservation marquée \'À régler sur place\''**
  String get cashPaymentDetail2;

  /// No description provided for @cashPaymentDetail3.
  ///
  /// In fr, this message translates to:
  /// **'Payez directement le prestataire'**
  String get cashPaymentDetail3;

  /// No description provided for @cashPaymentDetail4.
  ///
  /// In fr, this message translates to:
  /// **'Idéal pour les petits travaux'**
  String get cashPaymentDetail4;

  /// No description provided for @cancellationPolicy.
  ///
  /// In fr, this message translates to:
  /// **'Politique d\'annulation'**
  String get cancellationPolicy;

  /// No description provided for @cancellationDetail1.
  ///
  /// In fr, this message translates to:
  /// **'Maximum {maxCancels} annulations/mois autorisées'**
  String cancellationDetail1(int maxCancels);

  /// No description provided for @cancellationDetail2.
  ///
  /// In fr, this message translates to:
  /// **'Au-delà: pénalité de visibilité'**
  String get cancellationDetail2;

  /// No description provided for @cancellationDetail3.
  ///
  /// In fr, this message translates to:
  /// **'Répétition: suspension temporaire possible'**
  String get cancellationDetail3;

  /// No description provided for @cancellationDetail4.
  ///
  /// In fr, this message translates to:
  /// **'Objectif: garantir la fiabilité du service'**
  String get cancellationDetail4;

  /// No description provided for @fullCmiIntegration.
  ///
  /// In fr, this message translates to:
  /// **'Intégration CMI complète'**
  String get fullCmiIntegration;

  /// No description provided for @fullCmiIntegrationDesc.
  ///
  /// In fr, this message translates to:
  /// **'Documentation technique CMI disponible en {date}. L\'intégration complète avec authentification 3D Secure et tokenization sera déployée à cette date.'**
  String fullCmiIntegrationDesc(String date);

  /// No description provided for @fullCmiIntegrationDetail1.
  ///
  /// In fr, this message translates to:
  /// **'Authentification 3D Secure obligatoire'**
  String get fullCmiIntegrationDetail1;

  /// No description provided for @fullCmiIntegrationDetail2.
  ///
  /// In fr, this message translates to:
  /// **'Tokenization des cartes (jamais stockées en clair)'**
  String get fullCmiIntegrationDetail2;

  /// No description provided for @fullCmiIntegrationDetail3.
  ///
  /// In fr, this message translates to:
  /// **'Redirection sécurisée vers CMI'**
  String get fullCmiIntegrationDetail3;

  /// No description provided for @fullCmiIntegrationDetail4.
  ///
  /// In fr, this message translates to:
  /// **'Conforme aux normes PCI DSS'**
  String get fullCmiIntegrationDetail4;

  /// No description provided for @maxSecurity.
  ///
  /// In fr, this message translates to:
  /// **'Sécurité maximale'**
  String get maxSecurity;

  /// No description provided for @encryptedData.
  ///
  /// In fr, this message translates to:
  /// **'Données chiffrées'**
  String get encryptedData;

  /// No description provided for @encryptedDataDesc.
  ///
  /// In fr, this message translates to:
  /// **'Toutes les communications sont chiffrées SSL 256-bit'**
  String get encryptedDataDesc;

  /// No description provided for @tokenization.
  ///
  /// In fr, this message translates to:
  /// **'Tokenization'**
  String get tokenization;

  /// No description provided for @tokenizationDesc.
  ///
  /// In fr, this message translates to:
  /// **'Les numéros de carte ne sont jamais stockés en clair'**
  String get tokenizationDesc;

  /// No description provided for @pciDss.
  ///
  /// In fr, this message translates to:
  /// **'Certification PCI DSS'**
  String get pciDss;

  /// No description provided for @pciDssDesc.
  ///
  /// In fr, this message translates to:
  /// **'Conforme aux normes de sécurité internationales'**
  String get pciDssDesc;

  /// No description provided for @cmiCentralBank.
  ///
  /// In fr, this message translates to:
  /// **'CMI - Banque centrale'**
  String get cmiCentralBank;

  /// No description provided for @cmiCentralBankDesc.
  ///
  /// In fr, this message translates to:
  /// **'Intermédiaire bancaire agréé par Bank Al-Maghrib'**
  String get cmiCentralBankDesc;

  /// No description provided for @paymentSupportNote.
  ///
  /// In fr, this message translates to:
  /// **'Pour toute question concernant les paiements, contactez notre support client disponible 7j/7 de 8h à 20h.'**
  String get paymentSupportNote;

  /// No description provided for @cardLabelInput.
  ///
  /// In fr, this message translates to:
  /// **'Libellé'**
  String get cardLabelInput;

  /// No description provided for @cardLabelHint.
  ///
  /// In fr, this message translates to:
  /// **'Ex: Ma carte personnelle'**
  String get cardLabelHint;

  /// No description provided for @cardExpiryInput.
  ///
  /// In fr, this message translates to:
  /// **'Expiration (MM/AA)'**
  String get cardExpiryInput;

  /// No description provided for @cardExpiryHint.
  ///
  /// In fr, this message translates to:
  /// **'MM/AA'**
  String get cardExpiryHint;

  /// No description provided for @saveButton.
  ///
  /// In fr, this message translates to:
  /// **'Enregistrer'**
  String get saveButton;

  /// No description provided for @closeButton.
  ///
  /// In fr, this message translates to:
  /// **'Fermer'**
  String get closeButton;

  /// No description provided for @optionsButton.
  ///
  /// In fr, this message translates to:
  /// **'Options'**
  String get optionsButton;

  /// No description provided for @cardUpdatedSuccess.
  ///
  /// In fr, this message translates to:
  /// **'Carte mise à jour'**
  String get cardUpdatedSuccess;

  /// No description provided for @futurePaypalLabel.
  ///
  /// In fr, this message translates to:
  /// **'PayPal'**
  String get futurePaypalLabel;

  /// No description provided for @futurePaypalDesc.
  ///
  /// In fr, this message translates to:
  /// **'Paiement international'**
  String get futurePaypalDesc;

  /// No description provided for @futureStripeLabel.
  ///
  /// In fr, this message translates to:
  /// **'Stripe'**
  String get futureStripeLabel;

  /// No description provided for @futureStripeDesc.
  ///
  /// In fr, this message translates to:
  /// **'Cartes internationales'**
  String get futureStripeDesc;

  /// No description provided for @futureWalletLabel.
  ///
  /// In fr, this message translates to:
  /// **'Portefeuille électronique'**
  String get futureWalletLabel;

  /// No description provided for @futureWalletDesc.
  ///
  /// In fr, this message translates to:
  /// **'Paiement mobile wallet'**
  String get futureWalletDesc;

  /// No description provided for @comingSoonBadge.
  ///
  /// In fr, this message translates to:
  /// **'Bientôt'**
  String get comingSoonBadge;

  /// No description provided for @onSitePaymentTitle.
  ///
  /// In fr, this message translates to:
  /// **'Paiement sur place'**
  String get onSitePaymentTitle;

  /// No description provided for @cashPaymentLabel.
  ///
  /// In fr, this message translates to:
  /// **'Paiement en espèces'**
  String get cashPaymentLabel;

  /// No description provided for @cashPaymentDesc.
  ///
  /// In fr, this message translates to:
  /// **'Réglez directement sur place'**
  String get cashPaymentDesc;

  /// No description provided for @cashPaymentInfo.
  ///
  /// In fr, this message translates to:
  /// **'La réservation sera marquée \"À régler sur place\". Aucune transaction en ligne ne sera effectuée.'**
  String get cashPaymentInfo;

  /// No description provided for @howItWorksTitle.
  ///
  /// In fr, this message translates to:
  /// **'Comment ça marche ?'**
  String get howItWorksTitle;

  /// No description provided for @authCmiTitle.
  ///
  /// In fr, this message translates to:
  /// **'CMI - Préautorisation'**
  String get authCmiTitle;

  /// No description provided for @providerCancelTitle.
  ///
  /// In fr, this message translates to:
  /// **'Annulation prestataire'**
  String get providerCancelTitle;

  /// No description provided for @cmiIntegrationTitle.
  ///
  /// In fr, this message translates to:
  /// **'Intégration CMI complète'**
  String get cmiIntegrationTitle;

  /// No description provided for @cmiIntegrationDesc.
  ///
  /// In fr, this message translates to:
  /// **'Documentation CMI disponible en {date}. L\'intégration complète avec authentification 3D Secure sera disponible à cette date.'**
  String cmiIntegrationDesc(String date);

  /// No description provided for @learnMoreBtn.
  ///
  /// In fr, this message translates to:
  /// **'En savoir plus'**
  String get learnMoreBtn;

  /// No description provided for @emptyPaymentMethodsAlert.
  ///
  /// In fr, this message translates to:
  /// **'Ajoutez une carte ou activez le paiement sur place pour pouvoir effectuer des réservations.'**
  String get emptyPaymentMethodsAlert;

  /// No description provided for @myServices.
  ///
  /// In fr, this message translates to:
  /// **'Mes Services'**
  String get myServices;

  /// No description provided for @servicesOfProvider.
  ///
  /// In fr, this message translates to:
  /// **'Services de {name}'**
  String servicesOfProvider(String name);

  /// No description provided for @onlineStatus.
  ///
  /// In fr, this message translates to:
  /// **'En ligne'**
  String get onlineStatus;

  /// No description provided for @offlineStatus.
  ///
  /// In fr, this message translates to:
  /// **'Hors ligne'**
  String get offlineStatus;

  /// No description provided for @writeMessageHint.
  ///
  /// In fr, this message translates to:
  /// **'Écrire un message…'**
  String get writeMessageHint;

  /// No description provided for @recordingInProgress.
  ///
  /// In fr, this message translates to:
  /// **'Enregistrement en cours...'**
  String get recordingInProgress;

  /// No description provided for @today.
  ///
  /// In fr, this message translates to:
  /// **'Aujourd\'hui'**
  String get today;

  /// No description provided for @yesterday.
  ///
  /// In fr, this message translates to:
  /// **'Hier'**
  String get yesterday;

  /// No description provided for @copiedMessage.
  ///
  /// In fr, this message translates to:
  /// **'Message copié'**
  String get copiedMessage;

  /// No description provided for @copyText.
  ///
  /// In fr, this message translates to:
  /// **'Copier'**
  String get copyText;

  /// No description provided for @deleteMessage.
  ///
  /// In fr, this message translates to:
  /// **'Supprimer'**
  String get deleteMessage;

  /// No description provided for @reportMessage.
  ///
  /// In fr, this message translates to:
  /// **'Signaler'**
  String get reportMessage;

  /// No description provided for @makeCall.
  ///
  /// In fr, this message translates to:
  /// **'Passer un appel'**
  String get makeCall;

  /// No description provided for @sendImage.
  ///
  /// In fr, this message translates to:
  /// **'Envoyer une image'**
  String get sendImage;

  /// No description provided for @shareLocationOption.
  ///
  /// In fr, this message translates to:
  /// **'Partager ma position'**
  String get shareLocationOption;

  /// No description provided for @sendDocument.
  ///
  /// In fr, this message translates to:
  /// **'Envoyer PDF / Document'**
  String get sendDocument;

  /// No description provided for @voiceMessageSent.
  ///
  /// In fr, this message translates to:
  /// **'Message vocal envoyé ({duration}s)'**
  String voiceMessageSent(int duration);

  /// No description provided for @noMessages.
  ///
  /// In fr, this message translates to:
  /// **'Aucun message'**
  String get noMessages;

  /// No description provided for @dispatchTitle.
  ///
  /// In fr, this message translates to:
  /// **'Demande rapide'**
  String get dispatchTitle;

  /// No description provided for @dispatchSubtitle.
  ///
  /// In fr, this message translates to:
  /// **'Recevez un prestataire rapidement sans chercher'**
  String get dispatchSubtitle;

  /// No description provided for @dispatchChooseCategory.
  ///
  /// In fr, this message translates to:
  /// **'Choisissez un service'**
  String get dispatchChooseCategory;

  /// No description provided for @dispatchFormTitle.
  ///
  /// In fr, this message translates to:
  /// **'Détails de la demande'**
  String get dispatchFormTitle;

  /// No description provided for @dispatchAddress.
  ///
  /// In fr, this message translates to:
  /// **'Adresse'**
  String get dispatchAddress;

  /// No description provided for @dispatchAddressHint.
  ///
  /// In fr, this message translates to:
  /// **'Ex: 123 Rue Mohammed V, Casablanca'**
  String get dispatchAddressHint;

  /// No description provided for @dispatchAddressRequired.
  ///
  /// In fr, this message translates to:
  /// **'L\'adresse est obligatoire'**
  String get dispatchAddressRequired;

  /// No description provided for @dispatchPhone.
  ///
  /// In fr, this message translates to:
  /// **'Téléphone'**
  String get dispatchPhone;

  /// No description provided for @dispatchPhoneRequired.
  ///
  /// In fr, this message translates to:
  /// **'Le téléphone est obligatoire'**
  String get dispatchPhoneRequired;

  /// No description provided for @dispatchPhoneInvalid.
  ///
  /// In fr, this message translates to:
  /// **'Numéro de téléphone invalide'**
  String get dispatchPhoneInvalid;

  /// No description provided for @dispatchNote.
  ///
  /// In fr, this message translates to:
  /// **'Note'**
  String get dispatchNote;

  /// No description provided for @dispatchNoteHint.
  ///
  /// In fr, this message translates to:
  /// **'Instructions ou détails supplémentaires (optionnel)'**
  String get dispatchNoteHint;

  /// No description provided for @dispatchUrgency.
  ///
  /// In fr, this message translates to:
  /// **'Urgence'**
  String get dispatchUrgency;

  /// No description provided for @dispatchASAP.
  ///
  /// In fr, this message translates to:
  /// **'Dès que possible'**
  String get dispatchASAP;

  /// No description provided for @dispatchSchedule.
  ///
  /// In fr, this message translates to:
  /// **'Planifier'**
  String get dispatchSchedule;

  /// No description provided for @dispatchSendRequest.
  ///
  /// In fr, this message translates to:
  /// **'Envoyer la demande'**
  String get dispatchSendRequest;

  /// No description provided for @dispatchSelectedService.
  ///
  /// In fr, this message translates to:
  /// **'Service sélectionné'**
  String get dispatchSelectedService;

  /// No description provided for @dispatchChange.
  ///
  /// In fr, this message translates to:
  /// **'Changer'**
  String get dispatchChange;

  /// No description provided for @dispatchStepCategory.
  ///
  /// In fr, this message translates to:
  /// **'Service'**
  String get dispatchStepCategory;

  /// No description provided for @dispatchStepDetails.
  ///
  /// In fr, this message translates to:
  /// **'Détails'**
  String get dispatchStepDetails;

  /// No description provided for @dispatchStepSearch.
  ///
  /// In fr, this message translates to:
  /// **'Recherche'**
  String get dispatchStepSearch;

  /// No description provided for @dispatchSearchingTitle.
  ///
  /// In fr, this message translates to:
  /// **'Recherche en cours'**
  String get dispatchSearchingTitle;

  /// No description provided for @dispatchSearching.
  ///
  /// In fr, this message translates to:
  /// **'Recherche de prestataires…'**
  String get dispatchSearching;

  /// No description provided for @dispatchSearchingCategory.
  ///
  /// In fr, this message translates to:
  /// **'Demande envoyée aux prestataires de {category}'**
  String dispatchSearchingCategory(String category);

  /// No description provided for @dispatchCancelButton.
  ///
  /// In fr, this message translates to:
  /// **'Annuler la recherche'**
  String get dispatchCancelButton;

  /// No description provided for @dispatchCancelTitle.
  ///
  /// In fr, this message translates to:
  /// **'Annuler la demande ?'**
  String get dispatchCancelTitle;

  /// No description provided for @dispatchCancelMessage.
  ///
  /// In fr, this message translates to:
  /// **'Voulez-vous vraiment annuler votre demande de dispatch ?'**
  String get dispatchCancelMessage;

  /// No description provided for @dispatchNo.
  ///
  /// In fr, this message translates to:
  /// **'Non'**
  String get dispatchNo;

  /// No description provided for @dispatchYesCancel.
  ///
  /// In fr, this message translates to:
  /// **'Oui, annuler'**
  String get dispatchYesCancel;

  /// No description provided for @dispatchExpiredTitle.
  ///
  /// In fr, this message translates to:
  /// **'Aucun prestataire disponible'**
  String get dispatchExpiredTitle;

  /// No description provided for @dispatchExpiredMessage.
  ///
  /// In fr, this message translates to:
  /// **'Aucun prestataire n\'a répondu dans le délai imparti. Vous pouvez relancer la recherche ou choisir manuellement.'**
  String get dispatchExpiredMessage;

  /// No description provided for @dispatchRelaunch.
  ///
  /// In fr, this message translates to:
  /// **'Relancer la recherche'**
  String get dispatchRelaunch;

  /// No description provided for @dispatchChooseManually.
  ///
  /// In fr, this message translates to:
  /// **'Choisir manuellement'**
  String get dispatchChooseManually;

  /// No description provided for @dispatchMatchTitle.
  ///
  /// In fr, this message translates to:
  /// **'Prestataire trouvé'**
  String get dispatchMatchTitle;

  /// No description provided for @dispatchMatchFound.
  ///
  /// In fr, this message translates to:
  /// **'Un prestataire a accepté !'**
  String get dispatchMatchFound;

  /// No description provided for @dispatchMatchSubtitle.
  ///
  /// In fr, this message translates to:
  /// **'Voici le prestataire qui a accepté votre demande'**
  String get dispatchMatchSubtitle;

  /// No description provided for @dispatchContinueWithProvider.
  ///
  /// In fr, this message translates to:
  /// **'Continuer avec ce prestataire'**
  String get dispatchContinueWithProvider;

  /// No description provided for @dispatchReviews.
  ///
  /// In fr, this message translates to:
  /// **'avis'**
  String get dispatchReviews;

  /// No description provided for @dispatchDistance.
  ///
  /// In fr, this message translates to:
  /// **'Distance'**
  String get dispatchDistance;

  /// No description provided for @dispatchPriceFrom.
  ///
  /// In fr, this message translates to:
  /// **'À partir de'**
  String get dispatchPriceFrom;

  /// No description provided for @dispatchRequestDetails.
  ///
  /// In fr, this message translates to:
  /// **'Détails de la demande'**
  String get dispatchRequestDetails;

  /// No description provided for @dispatchService.
  ///
  /// In fr, this message translates to:
  /// **'Service'**
  String get dispatchService;

  /// No description provided for @dispatchSearchButton.
  ///
  /// In fr, this message translates to:
  /// **'Demande rapide (Dispatch)'**
  String get dispatchSearchButton;

  /// No description provided for @dispatchSearchSubtext.
  ///
  /// In fr, this message translates to:
  /// **'Recevez un prestataire rapidement'**
  String get dispatchSearchSubtext;

  /// No description provided for @swipeFilterButton.
  ///
  /// In fr, this message translates to:
  /// **'Filtrer'**
  String get swipeFilterButton;

  /// No description provided for @swipeFilterTitle.
  ///
  /// In fr, this message translates to:
  /// **'Filtrer par swipe'**
  String get swipeFilterTitle;

  /// No description provided for @swipeFilterHint.
  ///
  /// In fr, this message translates to:
  /// **'Glissez pour garder ou masquer les prestataires'**
  String get swipeFilterHint;

  /// No description provided for @swipeFilterDone.
  ///
  /// In fr, this message translates to:
  /// **'Terminer'**
  String get swipeFilterDone;

  /// No description provided for @swipeFilterReset.
  ///
  /// In fr, this message translates to:
  /// **'Reset'**
  String get swipeFilterReset;

  /// No description provided for @swipeFilterDoneMessage.
  ///
  /// In fr, this message translates to:
  /// **'Filtrage terminé !'**
  String get swipeFilterDoneMessage;

  /// No description provided for @swipeFilterKept.
  ///
  /// In fr, this message translates to:
  /// **'prestataires gardés'**
  String get swipeFilterKept;

  /// No description provided for @swipeFilterActive.
  ///
  /// In fr, this message translates to:
  /// **'prestataires filtrés'**
  String get swipeFilterActive;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar', 'en', 'fr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
    case 'fr':
      return AppLocalizationsFr();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
