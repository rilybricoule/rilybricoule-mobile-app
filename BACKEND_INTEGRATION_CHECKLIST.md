# 🔌 CHECKLIST INTÉGRATION BACKEND - RILYBRICOULE

> **Document de référence pour l'intégration backend Spring Boot**
> 
> Date: Mars 2026  
> Statut: ✅ PRÊT pour intégration backend

---

## 🎯 ARCHITECTURE PRÊTE

### ✅ Flux d'Authentification (Firebase → Backend → JWT)

```
┌─────────────────────────────────────────────────────────────────┐
│  FLUX COMPLET D'AUTHENTIFICATION                                │
├─────────────────────────────────────────────────────────────────┤
│                                                                  │
│  1. Utilisateur → Login (Google/Facebook/Apple/Email)          │
│           ↓                                                      │
│  2. Flutter → Firebase Auth                                    │
│           ↓                                                      │
│  3. Firebase → Firebase ID Token                               │
│           ↓                                                      │
│  4. Flutter → POST /auth/firebase { idToken }                 │
│           ↓                                                      │
│  5. Backend → Firebase Admin SDK (vérifie token)               │
│           ↓                                                      │
│  6. Backend → Crée/Récupère user en base de données            │
│           ↓                                                      │
│  7. Backend → Retourne JWT (accessToken + refreshToken)         │
│           ↓                                                      │
│  8. Flutter → Stocke JWT en SecureStorage                      │
│           ↓                                                      │
│  9. Flutter → Utilise JWT pour TOUTES les APIs métier         │
│                                                                  │
└─────────────────────────────────────────────────────────────────┘
```

---

## 📋 ENDPOINTS BACKEND À IMPLÉMENTER

### 🔐 AUTHENTIFICATION

| Méthode | Endpoint | Description | Request | Response |
|---------|----------|-------------|-----------|----------|
| POST | `/auth/firebase` | Authentifier via Firebase ID Token | `{ "idToken": "string" }` | `{ accessToken, refreshToken, expiresIn, user }` |
| GET | `/auth/me` | Profil utilisateur connecté | Headers: `Authorization: Bearer {token}` | `{ id, email, fullName, role, ... }` |
| POST | `/auth/refresh` | Rafraîchir le token JWT | `{ "refreshToken": "string" }` | `{ accessToken, refreshToken, expiresIn }` |
| POST | `/auth/logout` | Déconnexion (optionnel) | Headers: `Authorization: Bearer {token}` | `204 No Content` |

### 👤 PROFIL UTILISATEUR

| Méthode | Endpoint | Description | Request | Response |
|---------|----------|-------------|-----------|----------|
| GET | `/users/me` | Récupérer profil | Headers: `Authorization: Bearer {token}` | `{ UserProfile }` |
| PUT | `/users/me` | Mettre à jour profil | `{ fullName, phone, photoUrl, ... }` | `{ UserProfile }` |
| POST | `/users/me/avatar` | Upload avatar | `multipart/form-data` | `{ photoUrl }` |
| DELETE | `/users/me` | Supprimer compte | Headers: `Authorization: Bearer {token}` | `204 No Content` |

### 💳 PAIEMENT (CMI Integration)

| Méthode | Endpoint | Description | Request | Response |
|---------|----------|-------------|-----------|----------|
| GET | `/payments/methods` | Liste des cartes | Headers: `Authorization: Bearer {token}` | `[ { id, last4, brand, expMonth, expYear, ... } ]` |
| POST | `/payments/methods` | Ajouter carte via CMI | `{ cardNumber, expMonth, expYear, cvv, ... }` | `{ sessionId, redirectUrl, paymentMethodId }` |
| DELETE | `/payments/methods/{id}` | Supprimer carte | Headers: `Authorization: Bearer {token}` | `204 No Content` |
| PATCH | `/payments/methods/{id}/default` | Définir par défaut | Headers: `Authorization: Bearer {token}` | `{ PaymentMethod }` |
| POST | `/payments/cmi/preauth-intent` | Créer session CMI 3D Secure | `{ amount, currency, returnUrl }` | `{ sessionId, redirectUrl }` |
| POST | `/payments/cmi/callback` | Callback CMI | `{ sessionId, status, cardToken }` | `{ PaymentMethod }` |
| POST | `/payments/booking` | Paiement réservation | `{ bookingId, paymentMethodId, amount, ... }` | `{ paymentId, status }` |
| GET | `/payments/{id}/status` | Statut paiement | Headers: `Authorization: Bearer {token}` | `{ status, amount, ... }` |
| POST | `/payments/cash-preference` | Préférence cash | `{ enabled: boolean }` | `200 OK` |
| GET | `/payments/policy` | Politique de paiement | - | `{ Policy }` |

---

## 🔧 CONFIGURATION FLUTTER

### Fichier: `lib/core/config/app_config.dart`

```dart
/// Configuration globale de l'application
class AppConfig {
  /// 🔄 Switch Auth: Firebase-only vs Backend JWT
  /// - false: Mode Firebase (actuel, sans backend)
  /// - true:  Mode Backend JWT (avec votre Spring Boot)
  static const bool USE_BACKEND_AUTH = false;  // ← PASSER À TRUE
  
  /// 🔄 Switch Profil: Firebase vs Backend API
  /// - false: Firestore pour profils
  /// - true:  API Backend pour profils
  static const bool USE_BACKEND_PROFILE = false;  // ← PASSER À TRUE
  
  /// 🔄 Switch Paiement: Mock vs Backend API
  /// - false: Mode Mock (données en mémoire)
  /// - true:  API Backend (cartes persistées)
  static const bool USE_BACKEND_PAYMENT = true;  // ← DÉJÀ TRUE
  
  /// 🌐 URL de votre backend Spring Boot
  /// TODO: Remplacer par votre URL de production
  static const String BACKEND_BASE_URL = 'http://localhost:8080/api';
  // Exemple production: 'https://api.rilybricoule.com/api'
  
  /// ⏱️ Timeout des requêtes HTTP (secondes)
  static const int HTTP_TIMEOUT = 30;
  
  /// 🔄 Buffer refresh token (5 minutes avant expiration)
  static const int TOKEN_REFRESH_BUFFER = 300;
}
```

### Activation Backend (3 étapes)

1. **Backend Auth** - Après que `/auth/firebase` soit prêt:
   ```dart
   static const bool USE_BACKEND_AUTH = true;
   ```

2. **Backend Profile** - Après que `/users/me` soit prêt:
   ```dart
   static const bool USE_BACKEND_PROFILE = true;
   ```

3. **Backend URL** - Configurez votre URL:
   ```dart
   static const String BACKEND_BASE_URL = 'https://votre-api.com/api';
   ```

---

## 🏗️ ARCHITECTURE INTERNE

### Couche Data - DataSources

```
lib/data/datasources/
├── backend_auth_datasource.dart      ✅ PRÊT - POST /auth/*
├── api_profile_datasource.dart       ✅ PRÊT - GET/PUT /users/me
├── api_payment_datasource.dart       ✅ PRÊT - Tous les endpoints paiement
├── firebase_auth_datasource.dart     ✅ EXISTANT - Fallback Firebase
└── firebase_profile_datasource.dart  ✅ EXISTANT - Fallback Firebase
```

### Couche Data - Repositories

```
lib/data/repositories/
├── hybrid_auth_repository.dart       ✅ PRÊT - Combine Firebase + Backend
├── payment_repository_impl.dart      ✅ PRÊT - Implémentation PaymentRepository
└── profile_repository_impl.dart      ✅ PRÊT - Implémentation ProfileRepository
```

### Couche Domain - Interfaces

```
lib/domain/repositories/
├── auth_repository.dart              ✅ INTERFACE - Unchanged
├── payment_repository.dart           ✅ INTERFACE - CRUD cartes
└── profile_repository.dart           ✅ INTERFACE - CRUD profil
```

### Services

```
lib/services/
├── api/
│   └── api_client.dart               ✅ PRÊT - Dio + JWT Interceptors
└── storage/
    └── token_storage.dart            ✅ PRÊT - SecureStorage JWT
```

---

## 📱 MAIN.DART - INJECTION DE DÉPENDANCES

```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  
  // ✅ Initialisé: API Client avec intercepteurs JWT
  ApiClient().initialize();
  
  // ... autres services
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // 🔐 Auth: Firebase-only OU Hybrid Backend (selon config)
    final authRepository = AppConfig.USE_BACKEND_AUTH
        ? HybridAuthRepository(...)      // ← AVEC backend
        : FirebaseAuthRepository(...); // ← SANS backend
    
    // 👤 Profile: Firebase OU API Backend
    final profileRepository = ProfileService.createRepository();
    
    // 💳 Payment: Mock OU API Backend (déjà configuré pour backend)
    final paymentRepository = PaymentService.createRepository();
    
    return MultiProvider(
      providers: [
        Provider<AuthRepository>.value(value: authRepository),
        Provider<ProfileRepository>.value(value: profileRepository),
        Provider<PaymentRepository>.value(value: paymentRepository),
        // ... autres providers
      ],
      child: MaterialApp(...),
    );
  }
}
```

---

## 🔐 SÉCURITÉ JWT - DÉJÀ IMPLÉMENTÉE

### ApiClient avec Intercepteurs

```dart
class ApiClient {
  void initialize() {
    _dio = Dio(BaseOptions(baseUrl: AppConfig.BACKEND_BASE_URL));
    
    _dio.interceptors.add(InterceptorsWrapper(
      // 1. Ajoute JWT à chaque requête (sauf /auth/*)
      onRequest: (options, handler) async {
        if (!options.path.contains('/auth/')) {
          final tokens = await TokenStorage().getTokens();
          options.headers['Authorization'] = 'Bearer ${tokens.accessToken}';
        }
        return handler.next(options);
      },
      
      // 2. Auto-refresh si 401
      onError: (error, handler) async {
        if (error.response?.statusCode == 401) {
          final refreshed = await _refreshToken();
          if (refreshed) {
            // Retry avec nouveau token
            final tokens = await TokenStorage().getTokens();
            error.requestOptions.headers['Authorization'] = 
                'Bearer ${tokens.accessToken}';
            final response = await _dio.fetch(error.requestOptions);
            return handler.resolve(response);
          }
        }
        return handler.next(error);
      },
    ));
  }
}
```

---

## ✅ CHECKLIST BACKEND TEAM

### Phase 1: Authentification (Priorité Haute)
- [ ] Endpoint `POST /auth/firebase` - Valider Firebase ID Token
- [ ] Endpoint `GET /auth/me` - Retourner profil utilisateur
- [ ] Endpoint `POST /auth/refresh` - Rafraîchir JWT
- [ ] Implémenter Firebase Admin SDK côté backend
- [ ] Générer JWT (access + refresh tokens)
- [ ] Stocker utilisateurs en base de données

### Phase 2: Profil Utilisateur (Priorité Haute)
- [ ] Endpoint `GET /users/me` - Récupérer profil
- [ ] Endpoint `PUT /users/me` - Mettre à jour profil
- [ ] Endpoint `POST /users/me/avatar` - Upload photo (multipart)
- [ ] Endpoint `DELETE /users/me` - Suppression compte RGPD

### Phase 3: Paiement CMI (Priorité Moyenne)
- [ ] Intégration CMI (Centre Monétique Interbancaire)
- [ ] Endpoint `POST /payments/cmi/preauth-intent` - Session 3D Secure
- [ ] Endpoint `POST /payments/cmi/callback` - Callback CMI
- [ ] Endpoint `GET /payments/methods` - Liste cartes sauvegardées
- [ ] Endpoint `DELETE /payments/methods/{id}` - Supprimer carte
- [ ] Endpoint `POST /payments/booking` - Paiement réservation
- [ ] Tokenization cartes (ne pas stocker les numéros complets)

### Phase 4: Notifications & Real-time (Priorité Basse)
- [ ] WebSocket ou SSE pour notifications temps réel
- [ ] Endpoint pour enregistrer FCM token
- [ ] Endpoint pour notifications push

---

## 🧪 TESTS POST-INTÉGRATION

### Test 1: Flow Auth Complet
```dart
// 1. Login avec Google
// 2. Vérifier que Flutter appelle POST /auth/firebase
// 3. Vérifier que JWT est stocké
// 4. Vérifier que /auth/me retourne le profil
// 5. Vérifier refresh automatique quand token expire
```

### Test 2: Persistance Cartes
```dart
// 1. Ajouter une carte via CMI
// 2. Vérifier que la carte persiste après réinstall app
// 3. Vérifier que la carte est liée au compte utilisateur
// 4. Vérifier que d'autres appareils voient la même carte
```

### Test 3: Paiement Réservation
```dart
// 1. Créer une réservation
// 2. Paiement avec préautorisation
// 3. Vérifier que le montant est bloqué mais pas débité
// 4. Confirmer service terminé
// 5. Vérifier capture du paiement
```

---

## 🚨 ROLLBACK PLAN

Si problèmes en production:

1. **Retour Firebase-only** (Auth):
   ```dart
   // app_config.dart
   static const bool USE_BACKEND_AUTH = false;
   ```

2. **Retour Firestore** (Profile):
   ```dart
   // app_config.dart
   static const bool USE_BACKEND_PROFILE = false;
   ```

3. **Retour Mock** (Payment - temporaire):
   ```dart
   // app_config.dart
   static const bool USE_BACKEND_PAYMENT = false;
   ```

---

## 📞 CONTACT & SUPPORT

### Fichiers critiques à ne pas modifier sans discussion:
- `lib/services/api/api_client.dart` - Configuration Dio
- `lib/core/config/app_config.dart` - Feature flags
- `lib/services/storage/token_storage.dart` - Stockage JWT

### Questions fréquentes:
**Q: Comment ajouter un nouvel endpoint backend?**  
A: Créer/modifier le DataSource dans `lib/data/datasources/`

**Q: Comment gérer les erreurs réseau?**  
A: Déjà géré dans `ApiClient` avec retry automatique

**Q: Comment tester sans backend?**  
A: Mettre tous les flags à `false` dans `app_config.dart`

---

**✅ PROJET PRÊT POUR INTÉGRATION BACKEND**  
**🎯 Dernière mise à jour: Mars 2026**
