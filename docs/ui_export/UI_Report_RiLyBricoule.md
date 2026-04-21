# UI Report — RiLyBricoule Mobile App v1.0
> Generated: 2026-03-18 | Platform: Flutter (Android + iOS)
> Languages: FR 🇫🇷 | EN 🇬🇧 | AR 🇲🇦 (RTL)

---

# TABLE OF CONTENTS
1. [AUTH](#1-auth)
2. [CLIENT — Home](#2-client--home)
3. [CLIENT — Search](#3-client--search)
4. [CLIENT — Provider Profile & Booking](#4-client--provider-profile--booking)
5. [CLIENT — Reservations](#5-client--reservations)
6. [CLIENT — Chat](#6-client--chat)
7. [CLIENT — Notifications](#7-client--notifications)
8. [CLIENT — Profile & Settings](#8-client--profile--settings)
9. [PROVIDER (Prestataire)](#9-provider-prestataire)
10. [Admin API Reference Notes](#10-admin-api-reference-notes)

---

# 1. AUTH

## 001 — Splash Screen
- **Route**: `/` (`SplashView`)
- **Screenshot**: `screenshots/001_splash.png`

### Description fonctionnelle
Écran de démarrage de l'application avec logo animé (fade-in) et loader circulaire. Vérifie automatiquement l'état d'authentification Firebase et redirige vers Welcome (non connecté), Home client ou Provider main selon le rôle.

### Données affichées
- Logo app (`assets/images/provider.png`)
- CircularProgressIndicator

### Actions utilisateur
- Aucune (écran automatique)

### API Needs
| Endpoint | Description |
|----------|-------------|
| Firebase Auth `currentUser` | Vérification session locale |
| `GET /auth/me` | (Futur) Validation token backend |

### États / Edge cases
- **Loading**: Spinner pendant 1.5s
- **Auth OK**: Redirect `/home` (client) ou `/provider-main` (prestataire)
- **Auth KO**: Redirect `/welcome`
- **Offline**: Comportement dépendant de Firebase cache

### Dépendances externes
- Firebase Auth, Firebase Core

---

## 002 — Welcome Screen
- **Route**: `/welcome` (`WelcomeView`)
- **Screenshot**: `screenshots/002_welcome.png`

### Description fonctionnelle
Écran de bienvenue avec illustration, texte d'accroche et deux CTA principaux: connexion et inscription. Point d'entrée pour les utilisateurs non connectés.

### Données affichées
- Illustration / Logo
- Texte de bienvenue localisé
- Boutons "Se connecter" et "S'inscrire"

### Actions utilisateur
- **Se connecter** → `/login`
- **S'inscrire** → `/register`

### API Needs
Aucune

### États / Edge cases
- État unique (statique)

### Dépendances externes
- Aucune

---

## 003 — Login Screen
- **Route**: `/login` (`LoginView`)
- **Screenshot**: `screenshots/003_login.png`

### Description fonctionnelle
Formulaire de connexion avec email et mot de passe. Supporte Firebase Auth. Inclut lien "mot de passe oublié" et options de connexion sociale.

### Données affichées
- Champs: email, mot de passe
- Toggle visibilité mot de passe
- Lien "Mot de passe oublié"
- Boutons OAuth (Google, Facebook, Apple)

### Actions utilisateur
- Saisir email + mot de passe → Connexion
- **Mot de passe oublié** → `/forgot_password`
- **Connexion Google/Facebook/Apple** → OAuth flow
- **S'inscrire** → `/register`

### API Needs
| Endpoint | Description |
|----------|-------------|
| `POST /auth/login` | `{ email, password, deviceToken }` |
| `POST /auth/login/social` | `{ provider: "google", idToken }` |

### États / Edge cases
- **Loading**: Spinner sur bouton
- **Error**: Email invalide, mauvais mot de passe, compte inexistant (SnackBar)
- **Offline**: Message d'erreur réseau

### Dépendances externes
- Firebase Auth, Google Sign-In, Facebook SDK

---

## 004 — Register Screen
- **Route**: `/register` (`RegisterView`)
- **Screenshot**: `screenshots/004_register.png`

### Description fonctionnelle
Formulaire d'inscription avec toggle Client/Prestataire. Champs: nom complet, email, téléphone, mot de passe, confirmation. Validation côté client.

### Données affichées
- Toggle rôle (Client / Prestataire)
- Champs: fullName, email, phone, password, confirmPassword
- Conditions d'utilisation (checkbox)

### Actions utilisateur
- Choisir rôle
- Remplir formulaire → Inscription
- **Déjà un compte** → `/login`

### API Needs
| Endpoint | Description |
|----------|-------------|
| `POST /auth/register` | `{ email, password, fullName, phone, role, deviceToken }` |

### États / Edge cases
- **Loading**: Spinner
- **Error**: Email déjà utilisé (409), validation fields (422)
- **Success**: Redirect `/home` ou `/provider-main`

### Dépendances externes
- Firebase Auth

---

## 005 — Forgot Password
- **Route**: `/forgot_password` (`ForgotPasswordView`)
- **Screenshot**: `screenshots/005_forgot_password.png`

### Description fonctionnelle
Écran de réinitialisation de mot de passe. L'utilisateur entre son email et reçoit un lien de reset.

### Données affichées
- Champ email
- Bouton "Envoyer le lien"

### Actions utilisateur
- Saisir email → Envoi lien reset
- **Retour** → `/login`

### API Needs
| Endpoint | Description |
|----------|-------------|
| `POST /auth/forgot-password` | `{ email }` |

### États / Edge cases
- **Success**: Message de confirmation
- **Error**: Email non trouvé (404)

### Dépendances externes
- Firebase Auth (sendPasswordResetEmail)

---

# 2. CLIENT — HOME

## 006 — Home Screen
- **Route**: `/home` (tab 0 de `ClientMainView`)
- **Screenshot**: `screenshots/006_home.png`

### Description fonctionnelle
Page principale du client. Affiche: header avec avatar + nom + localisation, barre de recherche, catégories de services (horizontale), bannière promo, et liste de prestataires à proximité avec tri.

### Données affichées
- **Header**: Avatar utilisateur, "Bonjour, {nom} 👋", localisation GPS, badge notifications
- **Search bar**: Placeholder "Rechercher un service..."
- **Catégories**: Plomberie, Électricité, Ménage, Peinture, Bricolage (icônes + couleurs)
- **Promo banner**: Offre promotionnelle
- **Prestataires proches**: Cards avec nom, service, photo, note (★), nb avis, distance, prix, badge vérifié, statut disponibilité

### Actions utilisateur
- **Tap avatar** → Onglet Profile (tab 4)
- **Tap notification bell** → Push `NotificationsView`
- **Tap Search bar** → Switch to Search tab (tab 1)
- **Tap filtre (icône tune)** → Search tab + open filters
- **Tap catégorie** → Search tab filtrée
- **"Voir tout" catégories** → Push `AllCategoriesScreen`
- **"Trier par"** → `SortBottomSheet`
- **Tap provider card** → Push `/provider-profile`

### API Needs
| Endpoint | Description |
|----------|-------------|
| `GET /users/me` | Profil (nom, avatar) |
| `GET /categories` | Liste catégories |
| `GET /providers/nearby` | `?lat=X&lng=Y&limit=10` |
| `GET /notifications` (count) | Badge non-lu |

### États / Edge cases
- **Loading**: Skeleton loaders
- **Empty providers**: "Aucun prestataire à proximité"
- **Location denied**: Fallback "Maroc"
- **Offline**: Données cachées

### Dépendances externes
- Google Maps (Geocoding), Location Services, Firebase Auth, FCM

---

## 020 — All Categories
- **Route**: Push from Home
- **Screenshot**: `screenshots/020_all_categories.png`

### Description fonctionnelle
Grille complète de toutes les catégories de services (12 catégories). Tap retourne le categoryId sélectionné vers la recherche.

### Données affichées
- Grid de catégories: Plomberie, Électricité, Ménage, Peinture, Bricolage, Jardinage, Climatisation, Menuiserie, Serrurerie, Déménagement, Réparation, Autre

### Actions utilisateur
- **Tap catégorie** → Pop avec categoryId → Search filtrée

### API Needs
| Endpoint | Description |
|----------|-------------|
| `GET /categories` | Toutes les catégories |

---

## 021 — Sort Bottom Sheet
- **Route**: Modal from Home
- **Screenshot**: `screenshots/021_sort_bottom_sheet.png`

### Description fonctionnelle
Bottom sheet de tri des prestataires: Distance, Note, Prix, Popularité.

### Actions utilisateur
- Sélectionner critère → Apply → Fermer

---

# 3. CLIENT — SEARCH

## 007 — Search List View
- **Route**: `/home` (tab 1, mode liste)
- **Screenshot**: `screenshots/007_search_list.png`

### Description fonctionnelle
Recherche textuelle et filtrée de prestataires. Mode liste avec cards. Barre de recherche auto-complete, toggle Liste/Carte, chips catégorie active, bouton "Découvrir en swipe", compteur résultats.

### Données affichées
- Search bar avec query
- Toggle List/Map view
- Category chip (si filtre actif)
- "Discover Swipe" banner
- Results count: "X PRESTATAIRES TROUVÉS À PROXIMITÉ"
- Provider cards: nom, service, photo, note, distance, prix, badge vérifié
- Prestataires occupés grisés avec overlay "OCCUPÉ"

### Actions utilisateur
- **Saisir texte** → Recherche instantanée
- **Tap filter icon** → `FilterBottomSheet`
- **Toggle Map** → Switch to map mode
- **Tap Discover Swipe** → `/discover-swipe`
- **Tap provider** → `/provider-profile`
- **Clear category chip** → Reset filtre

### API Needs
| Endpoint | Description |
|----------|-------------|
| `GET /providers` | `?q=&categoryId=&lat=&lng=&radius=&minRating=&minPrice=&maxPrice=&availableNow=&sortBy=` |

### États / Edge cases
- **Loading**: CircularProgressIndicator
- **Empty**: Icône search_off + "Aucun prestataire trouvé"
- **Busy provider**: Opacity 0.5 + overlay "OCCUPÉ"

### Dépendances externes
- Location Services

---

## 008 — Search Map View
- **Route**: `/home` (tab 1, mode carte)
- **Screenshot**: `screenshots/008_search_map.png`

### Description fonctionnelle
Vue carte Google Maps avec marqueurs de prix pour chaque prestataire. Preview card en bas au tap sur un marqueur.

### Données affichées
- Google Map avec marqueurs custom (prix)
- Preview card: nom, service, note, distance, prix
- Search bar en overlay

### Actions utilisateur
- **Tap marqueur** → Preview card
- **Tap preview card** → `/provider-profile`
- **Toggle Liste** → mode liste
- **Tap filtre** → `FilterBottomSheet`

### API Needs
| Endpoint | Description |
|----------|-------------|
| `GET /providers/nearby` | `?lat=&lng=&radius=` (avec coordonnées) |

### Dépendances externes
- **Google Maps SDK**, Location Services

---

## 009 — Filters Bottom Sheet
- **Route**: Modal from Search
- **Screenshot**: `screenshots/009_filters.png`

### Description fonctionnelle
Bottom sheet de filtres avancés: fourchette de prix (RangeSlider 0-2000 MAD), note minimum (chips All/4.0+/4.5+), rayon (Slider 1-50 km), disponibilité immédiate (Switch).

### Données affichées
- **Prix**: RangeSlider 0-2000 MAD
- **Note**: Choice chips (Tous, 4.0+, 4.5+)
- **Distance**: Slider 1-50 km
- **Disponible maintenant**: Switch
- Boutons "Réinitialiser" et "Appliquer"

### Actions utilisateur
- Ajuster sliders/chips → "Appliquer les filtres"
- "Tout réinitialiser" → Reset defaults

---

## 041 — Discover Swipe
- **Route**: `/discover-swipe`
- **Screenshot**: `screenshots/041_discover_swipe.png`

### Description fonctionnelle
Mode Tinder-like pour découvrir les prestataires. Cards empilées que l'on swipe right (intéressé) ou left (passer).

### Actions utilisateur
- **Swipe right** → Like
- **Swipe left** → Pass
- **Tap card** → Détails prestataire

### API Needs
| Endpoint | Description |
|----------|-------------|
| `GET /providers` | Avec mêmes filtres que la recherche |

---

# 4. CLIENT — PROVIDER PROFILE & BOOKING

## 022 — Provider Profile
- **Route**: `/provider-profile` (`ProviderProfileScreen`)
- **Screenshot**: `screenshots/022_provider_profile.png`

### Description fonctionnelle
Profil complet du prestataire: photo, bio, stats, galerie, services proposés, avis clients. CTA principal "Réserver".

### Données affichées
- **Header**: Photo, nom, badge vérifié, bio
- **Stats**: Note, nb avis, nb missions, ancienneté
- **Galerie**: Photos de travaux
- **Services**: Nom, durée, prix
- **Avis**: Note, commentaire, date, auteur

### Actions utilisateur
- **Tap service** → Sélection pour réservation
- **"Voir tout" services** → `AllServicesScreen`
- **"Voir tout" avis** → `AllReviewsScreen`
- **"Réserver"** → `/booking-date-time` avec providerId + serviceId

### API Needs
| Endpoint | Description |
|----------|-------------|
| `GET /providers/:id` | Profil complet |
| `GET /providers/:id/services` | Services disponibles |
| `GET /providers/:id/reviews` | Avis clients |
| `POST /providers/:id/favorite` | Ajouter favoris |

### Dépendances externes
- Image cache/loading

---

## 023 — All Services
- **Screenshot**: `screenshots/023_all_services.png`
- Affiche la liste complète des services du prestataire.

## 024 — All Reviews
- **Screenshot**: `screenshots/024_all_reviews.png`
- Affiche tous les avis clients avec pagination.

---

## 025 — Booking Step 2: Date/Time + Address
- **Route**: `/booking-date-time` (`BookingDateTimeScreen`)
- **Screenshot**: `screenshots/025_booking_date_time.png`

### Description fonctionnelle
Étape 2 du booking: sélection date (calendrier custom), créneau horaire (matin/après-midi), confirmation adresse avec carte Google Maps, note pour le prestataire.

### Données affichées
- **Progress bar**: "PROGRESSION RÉSERVATION • Étape 2 sur 5"
- **Calendrier** custom (mois courant + suivant)
- **Créneaux matin**: 08:30, 09:00, 10:30
- **Créneaux après-midi**: 14:00, 15:30, 17:00
- **Adresse**: Adresse enregistrée + détails + checkbox "Utiliser mon adresse"
- **Carte**: MapPreview (LatLng Casablanca)
- **Note**: TextField multi-ligne

### Actions utilisateur
- **Sélectionner date** → Calendar tap
- **Sélectionner créneau** → Time slot button
- **Modifier adresse** → `EditAddressDialog`
- **Continuer** → `/booking-summary`

### API Needs
| Endpoint | Description |
|----------|-------------|
| `GET /providers/:id/availability` | `?date=YYYY-MM-DD` → créneaux libres |
| `GET /users/me` | Adresse par défaut |

### Dépendances externes
- **Google Maps SDK** (MapPreview), Geocoding

---

## 026 — Booking Step 3: Summary
- **Route**: `/booking-summary` (`BookingSummaryView`)
- **Screenshot**: `screenshots/026_booking_summary.png`

### Description fonctionnelle
Récapitulatif de la réservation avant paiement: infos prestataire, détails booking (date, heure, adresse, note), service sélectionné avec prix, carte.

### Données affichées
- **Progress**: Step 3/5
- **Provider card**: Avatar, nom, spécialité, note, badge vérifié
- **Détails**: Date, heure, adresse, détails adresse, note
- **Service**: Nom, durée estimée, prix (250 MAD)
- **Carte**: MapPreview

### Actions utilisateur
- **Continuer vers paiement** → `/booking-payment`
- **Retour** → Pop

### API Needs
Données passées via arguments de navigation (aucun appel API supplémentaire)

### Dépendances externes
- **Google Maps SDK**

---

## 027 — Booking Step 4: Payment & Checkout
- **Route**: `/booking-payment` (`BookingPaymentView`)
- **Screenshot**: `screenshots/027_booking_payment.png`

### Description fonctionnelle
Écran de paiement premium: résumé service, décomposition prix (service + frais plateforme + assurance - code promo), saisie code promo, sélection moyen de paiement (cartes enregistrées ou espèces), infos sécurité. Système de pré-autorisation (l'argent n'est débité qu'après prestation).

### Données affichées
- **Progress**: Step 4/5
- **Service summary**: Nom, prestataire, date, badge "Confirmé"
- **Détails prix**: Service (250 MAD), Frais plateforme (25 MAD), Assurance (10 MAD), Réduction, **Total: 285 MAD**
- **Mention**: "Pré-autorisation uniquement"
- **Code promo**: Input + bouton "Appliquer"
- **Moyens de paiement**: Cartes Visa/Mastercard/CMI enregistrées, checkbox sélection, badge "Défaut"
- **Payer en espèces**: Option alternative
- **Sécurité**: "Paiement sécurisé SSL", "Protection acheteur"

### Actions utilisateur
- **Saisir code promo** → Valider / Retirer
- **Sélectionner carte** → Checkbox
- **Ajouter carte** → Push `AddPaymentMethodScreen`
- **Payer en espèces** → Toggle
- **Confirmer paiement** → Dialog succès → `/booking-status`

### API Needs
| Endpoint | Description |
|----------|-------------|
| `GET /payments/methods` | Cartes enregistrées |
| `POST /payments/promo/validate` | `{ code }` |
| `POST /payments/pre-authorize` | Pré-autorisation |
| `POST /bookings` | Création booking final |

### États / Edge cases
- **Loading**: Spinner sur bouton
- **No card**: CTA "Ajouter une carte"
- **Invalid promo**: SnackBar erreur rouge
- **Promo applied**: Badge vert avec remise
- **Payment error**: Message d'erreur en bas
- **Success dialog**: Check vert + "Pré-autorisation effectuée"

### Dépendances externes
- Payment gateway (CMI)

---

## 028 — Booking Step 5: Confirmation
- **Route**: `/booking-status` (`BookingStatusView`)
- **Screenshot**: `screenshots/028_booking_status.png`

### Description fonctionnelle
Écran de confirmation post-booking: icône check animée, message de succès, récapitulatif prestataire/date/heure/adresse, carte Google Maps, 3 CTA.

### Données affichées
- **Icône succès**: Cercle vert + check
- **"Réservation confirmée !"** + message
- **Détails**: Prestataire (nom, catégorie), date, heure, adresse
- **Carte**: Google Maps avec marqueur

### Actions utilisateur
- **Contacter le prestataire** → Push `/chat/:providerId`
- **Voir mes réservations** → ClientMainView tab 2
- **Retour à l'accueil** → ClientMainView tab 0
- **Close (X)** → ClientMainView

### API Needs
| Endpoint | Description |
|----------|-------------|
| `GET /bookings/:id` | Détails confirmation |
| `POST /chat/conversations` | Créer conversation avec provider |

### Dépendances externes
- **Google Maps SDK**, Chat Service

---

# 5. CLIENT — RESERVATIONS

## 010-014 — Reservations Tabs
- **Route**: `/home` (tab 2) (`ReservationsView`)
- **Screenshots**: `screenshots/010_reservations_upcoming.png`, `011_ongoing.png`, `012_completed.png`, `013_cancelled.png`, `014_empty.png`

### Description fonctionnelle
Liste des réservations du client avec 4 onglets: À venir, En cours, Terminées, Annulées. Chaque réservation affichée en card avec statut coloré. Pull-to-refresh.

### Données affichées (par card)
- Prestataire: nom, avatar
- Service: nom
- Date et heure
- Statut: badge couleur (upcoming=bleu, ongoing=orange, completed=vert, cancelled=rouge)
- Actions contextuelles

### Actions utilisateur
- **Tap card** → Push `/reservation-details`
- **"Laisser un avis"** → Push `/leave-review` (si completed + canReview)
- **"Voir facture"** → Push `/invoice` (si completed)
- **Pull-to-refresh** → Recharger
- **Tab switch** → Filtrer par statut
- **Empty state** → "Explorer les prestataires"

### API Needs
| Endpoint | Description |
|----------|-------------|
| `GET /bookings` | `?status=upcoming&page=1` |

### États / Edge cases
- **Loading**: CircularProgressIndicator
- **Error**: Message texte
- **Empty**: Icône calendrier + message localisé par statut + CTA

---

## 029 — Reservation Details / Timeline
- **Route**: `/reservation-details` (`ReservationDetailsView`)
- **Screenshot**: `screenshots/029_reservation_details.png`

### Description fonctionnelle
Détails complets d'une réservation avec timeline de suivi: statut actuel, prestataire, service, date/heure, adresse, ETA, carte, actions (annuler, contacter, facture).

### Données affichées
- **Timeline**: Étapes avec icônes et timestamps (Créée → Confirmée → En route → En cours → Terminée)
- **ETA badge**: "Arrivée dans ~X min"
- **Provider card**: Nom, photo, catégorie, note
- **Détails**: Service, date, heure, adresse, prix
- **Carte**: Google Maps

### Actions utilisateur
- **Annuler** → Dialog confirmation → API cancel
- **Contacter** → Chat thread
- **Laisser un avis** → `/leave-review`
- **Voir facture** → `/invoice`

### API Needs
| Endpoint | Description |
|----------|-------------|
| `GET /bookings/:id` | Détails + timeline |
| `PUT /bookings/:id/cancel` | Annulation |
| `GET /bookings/:id/tracking` | Statut temps réel (WebSocket possible) |

### Dépendances externes
- **Google Maps SDK**

---

## 030 — Leave Review (Rate Provider)
- **Route**: `/leave-review` (`RateProviderView`)
- **Screenshot**: `screenshots/030_leave_review.png`

### Description fonctionnelle
Formulaire d'évaluation: note étoiles (1-5), commentaire, envoi.

### Actions utilisateur
- Sélectionner note (étoiles)
- Saisir commentaire
- Envoyer → API

### API Needs
| Endpoint | Description |
|----------|-------------|
| `POST /bookings/:id/review` | `{ rating, comment }` |

---

## 031 — Invoice
- **Route**: `/invoice` (`InvoiceView`)
- **Screenshot**: `screenshots/031_invoice.png`

### Description fonctionnelle
Facture détaillée post-prestation: n° facture, prestataire, service, décomposition prix, statut paiement, option téléchargement PDF.

### API Needs
| Endpoint | Description |
|----------|-------------|
| `GET /bookings/:id/invoice` | Facture PDF/JSON |

---

# 6. CLIENT — CHAT

## 015 — Conversation List
- **Route**: `/home` (tab 3) (`ConversationListScreen`)
- **Screenshot**: `screenshots/015_conversation_list.png`

### Description fonctionnelle
Liste des conversations avec prestataires. Header "Messages", barre de recherche toggle, FAB "nouveau message". Chaque conversation affiche: avatar, nom, dernier message, timestamp, badge non-lu.

### Données affichées
- Titre "Messages"
- Search bar (toggle icon)
- Conversations: avatar, nom prestataire, dernier message (preview), heure, badge unread count
- Statut en ligne (point vert)

### Actions utilisateur
- **Tap conversation** → Push `/chat/:id`
- **Search icon** → Toggle search bar
- **Recherche** → Filtre conversations
- **FAB (+)** → Bottom sheet "Nouveau message" → Explorer prestataires
- **Pull-to-refresh** → Recharger

### API Needs
| Endpoint | Description |
|----------|-------------|
| `GET /chat/conversations` | Liste avec derniers messages |

### États / Edge cases
- **Loading**: Spinner
- **Empty**: Icône chat + "Pas encore de conversations"
- **No search results**: Icône search_off + "Aucun résultat"
- **Error**: Message texte

---

## 016 — Conversation List Empty
- **Screenshot**: `screenshots/016_conversation_list_empty.png`
- Grand icône bulle chat, texte "Pas encore de conversations", description.

---

## 032 — Chat Thread
- **Route**: `/chat/:conversationId` (`ChatThreadScreen`)
- **Screenshot**: `screenshots/032_chat_thread.png`

### Description fonctionnelle
Fil de discussion en temps réel: messages text, images, localisation. Header avec nom + statut en ligne. Input avec boutons attachement.

### Données affichées
- **Header**: Nom prestataire, statut "En ligne" / "Dernière connexion...", avatar
- **Messages**: Bulles (text, image, location map), timestamps, statut (envoyé/lu)
- **Input bar**: TextField, bouton envoi, attachement (photo, caméra, localisation)

### Actions utilisateur
- **Saisir message** → Envoi text
- **Bouton photo** → Galerie/caméra
- **Bouton localisation** → Envoi position GPS
- **Tap image** → Zoom
- **Appel** → (À venir)

### API Needs
| Endpoint | Description |
|----------|-------------|
| `GET /chat/conversations/:id/messages` | `?page=1&limit=50` |
| `POST /chat/conversations/:id/messages` | `{ type, content, imageUrl, location }` |
| `PUT /chat/conversations/:id/read` | Marquer lu |
| WebSocket `wss://` | `new_message`, `typing`, `read_receipt`, `online_status` |

### Dépendances externes
- WebSocket, Image Picker, Google Maps (pour partage location), Firebase Storage (upload images)

---

# 7. CLIENT — NOTIFICATIONS

## 018 — Notifications List
- **Route**: Push from Home (`NotificationsView`)
- **Screenshot**: `screenshots/018_notifications_list.png`

### Description fonctionnelle
Liste de notifications: booking confirmé, message, promotion, annulation, système, referral, rappel. Chaque notification avec icône-couleur thématique, titre, message, timestamp relative. Actions: swipe-to-delete, menu (tout marquer lu, tout supprimer).

### Données affichées
- Notification cards: icône colorée par type, titre, message (2 lignes max), "Il y a Xm/h/j", badge non-lu (point bleu)
- Menu: "Tout marquer comme lu", "Tout supprimer"

### Actions utilisateur
- **Tap notification** → Marquer comme lu
- **Long press** → Dialog détails
- **Swipe left** → Supprimer
- **Menu "Tout marquer"** → Bulk read
- **Menu "Tout supprimer"** → Dialog confirmation → Bulk delete

### API Needs
| Endpoint | Description |
|----------|-------------|
| `GET /notifications` | Liste avec pagination |
| `PUT /notifications/:id/read` | Marquer lu |
| `PUT /notifications/read-all` | Tout marquer lu |
| `DELETE /notifications/:id` | Supprimer |
| `DELETE /notifications` | Tout supprimer |

### États / Edge cases
- **Loading**: Spinner
- **Empty**: Icône notifications_off + "Pas de notifications" + CTA retour
- **Unread highlight**: Background bleu clair + bordure

### Dépendances externes
- FCM (Firebase Cloud Messaging)

---

## 019 — Notifications Empty
- **Screenshot**: `screenshots/019_notifications_empty.png`
- Icône `notifications_off`, message localisé, CTA "Retour à l'accueil"

---

# 8. CLIENT — PROFILE & SETTINGS

## 017 — Profile Screen
- **Route**: `/home` (tab 4) (`ProfileScreen`)
- **Screenshot**: `screenshots/017_profile.png`

### Description fonctionnelle
Profil utilisateur avec header (avatar éditable, nom, ancienneté), sections: Mon activité (réservations, paiements, favoris), Langue, Support & Info (aide, à propos), bouton déconnexion.

### Données affichées
- **Header**: Avatar (avec bouton edit), nom, "Membre depuis Jan 2024"
- **Mon activité**: Mes réservations, Moyens de paiement, Favoris
- **Langue**: Sélection langue
- **Support**: Centre d'aide, À propos
- **Déconnexion**: Bouton rouge

### Actions utilisateur
- **Edit profile** → `/edit-profile`
- **Tap avatar** → `/edit-profile`
- **Mes réservations** → Tab 2
- **Moyens de paiement** → `/payment-methods`
- **Favoris** → `/favorites`
- **Langue** → `LanguageBottomSheet`
- **Centre d'aide** → `/help`
- **À propos** → `/about`
- **Déconnexion** → Dialog confirmation → Sign out → `/welcome`

### API Needs
| Endpoint | Description |
|----------|-------------|
| `GET /users/me` | Profil complet |

---

## 033 — Edit Profile
- **Route**: `/edit-profile` (`EditProfileView`)
- **Screenshot**: `screenshots/033_edit_profile.png`

### Description fonctionnelle
Formulaire d'édition du profil: avatar (changement photo), nom, email (lecture seule), téléphone, adresse.

### API Needs
| Endpoint | Description |
|----------|-------------|
| `GET /users/me` | Charger profil actuel |
| `PUT /users/me` | Sauvegarder modifications |
| `PUT /users/me/avatar` | Upload nouveau avatar (multipart) |

### Dépendances externes
- Image Picker, Firebase Storage

---

## 034 — Payment Methods
- **Route**: `/payment-methods` (`PaymentMethodsScreen`)
- **Screenshot**: `screenshots/034_payment_methods.png`

### Description fonctionnelle
Liste des cartes enregistrées. Sélection carte par défaut, ajout, suppression.

### API Needs
| Endpoint | Description |
|----------|-------------|
| `GET /payments/methods` | Liste cartes |
| `DELETE /payments/methods/:id` | Supprimer |
| `PUT /payments/methods/:id/default` | Carte par défaut |

---

## 035 — Add Payment Method
- **Route**: `/add-payment-method` (`AddPaymentMethodScreen`)
- **Screenshot**: `screenshots/035_add_payment_method.png`

### Description fonctionnelle
Formulaire d'ajout de carte: numéro, date expiration, CVV, nom du titulaire. Tokenisation CMI.

### API Needs
| Endpoint | Description |
|----------|-------------|
| `POST /payments/methods` | `{ cardToken, brand, last4, expiryMonth, expiryYear }` |

### Dépendances externes
- CMI Payment SDK

---

## 036 — Payment Policy Info
- **Route**: `/payment-policy-info`
- **Screenshot**: `screenshots/036_payment_policy_info.png`
- Information sur la politique de paiement et pré-autorisation.

## 037 — Favorites
- **Route**: `/favorites`
- **Screenshot**: `screenshots/037_favorites.png`
- Liste des prestataires favoris (placeholder "À implémenter").

### API Needs
| Endpoint | Description |
|----------|-------------|
| `GET /providers/favorites` | Liste favoris |

## 038 — Language Bottom Sheet
- **Screenshot**: `screenshots/038_language.png`
- Sélection: Français, English, العربية. Applique la langue immédiatement.

## 039 — Help Center
- **Route**: `/help`
- **Screenshot**: `screenshots/039_help.png`
- Placeholder "À implémenter"

## 040 — About
- **Route**: `/about`
- **Screenshot**: `screenshots/040_about.png`
- Placeholder "À implémenter"

---

# 9. PROVIDER (Prestataire)

## 042 — Provider Dashboard
- **Route**: `/provider-main` (tab 0) (`ProviderDashboardView`)
- **Screenshot**: `screenshots/042_provider_dashboard.png`

### Description fonctionnelle
Tableau de bord du prestataire: toggle online/offline, stats grid (4 cards: total bookings, total revenue, pending requests, average rating), recent bookings, upcoming missions.

### Données affichées
- **Header**: Avatar, toggle "En ligne / Hors ligne", badge notifications
- **Stats grid** (2x2):
  - Total bookings: 127 (+12%)
  - Total revenue: MAD 15,240 (+8%)
  - Pending requests: 8
  - Average rating: 4.8
- **Recent bookings**: Client name, service, date, status (Pending/Confirmed)
- **Upcoming missions today**: Client, service, heure, adresse, badge URGENT

### Actions utilisateur
- **Toggle online** → PUT `/provider/online-status`
- **Tap Notifications** → `ProviderNotificationsView`
- **Tap Revenue** → `ProviderEarningsView`
- **Tap Rating** → `ProviderReviewsView`
- **Tap Booking** → Mission details
- **Drawer icon** → `ProviderDrawer`

### API Needs
| Endpoint | Description |
|----------|-------------|
| `GET /provider/dashboard` | Stats + recent + upcoming |
| `PUT /provider/online-status` | `{ isOnline }` |

---

## 043 — Provider Services
- **Route**: `/provider-main` (tab 1) (`ProviderServicesView`)
- **Screenshot**: `screenshots/043_provider_services.png`

### Description fonctionnelle
Gestion des services proposés: CRUD services avec nom, catégorie, prix, durée.

### API Needs
| Endpoint | Description |
|----------|-------------|
| `GET /provider/services` | Mes services |
| `POST /provider/services` | Ajouter |
| `PUT /provider/services/:id` | Modifier |
| `DELETE /provider/services/:id` | Supprimer |

---

## 044 — Provider Bookings
- **Route**: `/provider-main` (tab 2) (`ProviderBookingsView`)
- **Screenshot**: `screenshots/044_provider_bookings.png`

### Description fonctionnelle
Réservations reçues par le prestataire. Actions: accepter, refuser, démarrer, terminer.

### API Needs
| Endpoint | Description |
|----------|-------------|
| `GET /provider/bookings` | `?status=pending|confirmed|in_progress|completed` |
| `PUT /provider/bookings/:id/accept` | Accepter |
| `PUT /provider/bookings/:id/reject` | Refuser |
| `PUT /provider/bookings/:id/start` | Démarrer intervention |
| `PUT /provider/bookings/:id/complete` | Terminer |

---

## 045 — Provider Planning
- **Route**: `/provider-main` (tab 3) (`ProviderPlanningView`)
- **Screenshot**: `screenshots/045_provider_planning.png`

### Description fonctionnelle
Calendrier du prestataire avec créneaux de disponibilité et missions planifiées.

### API Needs
| Endpoint | Description |
|----------|-------------|
| `GET /provider/planning` | `?month=&year=` |
| `PUT /provider/availability` | Modifier créneaux |

---

## 046 — Provider Chat List
- **Route**: `/provider-main` (tab 4) (`ProviderChatListView`)
- **Screenshot**: `screenshots/046_provider_chat_list.png`

### Description fonctionnelle
Conversations du prestataire avec ses clients.

### API Needs
Identique au chat client.

---

## 047-055 — Autres écrans Provider
| # | Screen | Screenshot | Description |
|---|--------|-----------|-------------|
| 047 | Provider Chat Thread | `047_provider_chat_thread.png` | Fil de discussion avec client |
| 048 | Provider Notifications | `048_provider_notifications.png` | Notifications prestataire |
| 049 | Provider Earnings | `049_provider_earnings.png` | Revenus détaillés |
| 050 | Provider Reviews | `050_provider_reviews.png` | Avis reçus |
| 051 | Provider Profile | `051_provider_profile_self.png` | Mon profil prestataire |
| 052 | Provider Edit Profile | `052_provider_edit_profile.png` | Éditer profil |
| 053 | Provider Settings | `053_provider_settings.png` | Paramètres |
| 054 | Provider Mission Details | `054_provider_mission_details.png` | Détails d'une mission |
| 055 | Provider Drawer | `055_provider_drawer.png` | Menu latéral |

---

# 10. Admin API Reference Notes

> Les endpoints suivants proviennent de la **Documentation API Interface Admin — RiLyBricoule v1.0 (Mars 2026)**. Ils sont réservés à l'admin back-office. Cependant, les données qu'ils manipulent sont nécessaires côté mobile via des **endpoints mobile équivalents**.

| Admin Endpoint (ref doc) | Mobile Equivalent | Usage |
|--------------------------|-------------------|-------|
| `GET /api/admin/categories` (p.14) | `GET /api/mobile/categories` | Liste catégories (lecture seule) |
| `POST/PUT/DELETE /api/admin/categories` | ❌ Non nécessaire mobile | CRUD admin only |
| `GET /api/admin/reservations` (p.19-20) | `GET /api/mobile/bookings` | Réservations du user connecté |
| Filtres: status, payment_status, payment_method, date_from/to | `?status=upcoming` | Filtres simplifiés |
| `GET /api/admin/transactions` (p.22-23) | `GET /api/mobile/payments/history` | Historique paiements du user |
| `POST /api/admin/notifications/send` (p.28-29) | ❌ Non nécessaire mobile | Push admin → FCM recevoir |
| `GET /api/admin/tickets` (p.30-32) | `GET /api/mobile/support/tickets` | Mes tickets support |
| `Auth: Bearer token` (p.1) | `Authorization: Bearer <JWT>` | Identique pour mobile + admin |

### Notes importantes
1. **Admin ≠ Mobile**: Les endpoints admin (`/api/admin/*`) ne doivent PAS être exposés au mobile. Le mobile utilise ses propres endpoints (`/api/mobile/*`) avec des permissions restreintes.
2. **Paiement CMI**: L'intégration CMI pour la tokenisation des cartes est en attente. Le mobile utilise actuellement des mocks.
3. **WebSocket**: Nécessaire pour le chat temps réel et le tracking de réservation (statut en direct).
4. **i18n**: Toutes les réponses API doivent supporter les champs localisés (`{ "fr": "...", "en": "...", "ar": "..." }`) pour les catégories et contenus marketing.
5. **FCM**: Le token device doit être enregistré au login et mis à jour en cas de refresh.

---

> **Fichier généré automatiquement le 2026-03-18 par l'outil UI Export RiLyBricoule.**
> **Total: 55 écrans documentés | 70+ endpoints API mobile spécifiés**
