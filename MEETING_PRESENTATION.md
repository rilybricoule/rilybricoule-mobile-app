# 📊 PRÉSENTATION RÉUNION - Backend Auth Integration

## 🎯 OBJECTIF

Intégrer l'authentification backend (Spring Boot) avec l'app Flutter mobile.

---

## 📋 A) CODE FLUTTER (PRÊT)

### 1. Endpoints Attendus

**Fichier:** `lib/data/datasources/backend_auth_datasource.dart`

```dart
// POST /api/auth/firebase
Future<Map<String, dynamic>> authenticateWithFirebase(String firebaseIdToken)

// GET /api/auth/me
Future<BackendUser> getMe()

// POST /api/auth/refresh
Future<AuthTokens> refreshToken(String refreshToken)

// POST /api/auth/logout
Future<void> logout()
```

### 2. Modèles

**AuthTokens** (`lib/data/models/auth_tokens.dart`):
```dart
class AuthTokens {
  final String accessToken;
  final String refreshToken;
  final int expiresIn;
  final DateTime issuedAt;
}
```

**BackendUser** (`lib/data/models/backend_user.dart`):
```dart
class BackendUser {
  final String id;
  final String email;
  final String fullName;
  final UserRole role;  // ← SOURCE DE VÉRITÉ
  final String? phone;
  final String? photoUrl;
  final bool isVerified;
  final DateTime createdAt;
  final DateTime updatedAt;
}
```

### 3. Format Headers

**ApiClient** (`lib/services/api/api_client.dart`):
```dart
// Automatiquement ajouté à chaque requête:
headers['Authorization'] = 'Bearer ${tokens.accessToken}'
```

---

## 📝 B) BACKEND INTEGRATION CHECKLIST

**Document:** `BACKEND_INTEGRATION_CHECKLIST.md`

### Endpoints Requis:

#### 1. POST /api/auth/firebase
```json
Request: { "idToken": "..." }
Response: {
  "accessToken": "...",
  "refreshToken": "...",
  "expiresIn": 3600,
  "user": { "id": "...", "role": "client", ... }
}
```

#### 2. GET /api/auth/me
```json
Headers: Authorization: Bearer <token>
Response: { "id": "...", "role": "client", ... }
```

#### 3. POST /api/auth/refresh
```json
Request: { "refreshToken": "..." }
Response: { "accessToken": "...", "refreshToken": "...", "expiresIn": 3600 }
```

### Codes d'Erreur:
- **400**: Bad Request (Firebase token invalide)
- **401**: Unauthorized (JWT invalide/expiré)
- **403**: Forbidden (Permissions insuffisantes)
- **422**: Unprocessable Entity (Validation échouée)
- **500**: Internal Server Error

### Refresh Token Behavior:
- **Automatique**: 5min avant expiration
- **Sur 401**: Retry automatique après refresh
- **Si échec**: Logout + redirect login

---

## ✅ C) VÉRIFICATION RÔLE BACKEND

**Document:** `ROLE_VERIFICATION.md`

### Confirmation:

✅ **Le rôle vient à 100% du backend (pas de Firestore)**

### Flow:
```
1. Login Google
2. Firebase ID Token → Backend
3. Backend response: { user: { role: "client" } }
4. BackendUser.fromJson(response['user'])
5. AppUser.role = BackendUser.role
6. Navigation selon AppUser.role
```

### Code Proof:
```dart
// hybrid_auth_repository.dart ligne 283
AppUser _convertBackendUserToAppUser(BackendUser backendUser) {
  return AppUser(
    uid: backendUser.id,
    role: backendUser.role,  // ← RÔLE DU BACKEND
    ...
  );
}
```

### Pas de Firestore en mode backend:
```dart
if (AppConfig.USE_BACKEND_AUTH) {
  await _loadBackendUser();  // ← GET /auth/me
} else {
  _currentUser = await _firebaseDataSource.getUserProfile(uid);  // ← Firestore
}
```

---

## 🔄 FLOW COMPLET

```
┌─────────────┐
│   User      │
│  Login      │
└──────┬──────┘
       │
       ▼
┌─────────────┐
│  Firebase   │
│    Auth     │
└──────┬──────┘
       │ Firebase ID Token
       ▼
┌─────────────┐
│   Flutter   │
│     App     │
└──────┬──────┘
       │ POST /auth/firebase
       ▼
┌─────────────┐
│   Backend   │
│ Spring Boot │
└──────┬──────┘
       │ Vérifie Firebase Token
       │ Crée/récupère User
       │ Génère JWT
       ▼
┌─────────────┐
│   Response  │
│ JWT + User  │
└──────┬──────┘
       │
       ▼
┌─────────────┐
│   Flutter   │
│ Sauvegarde  │
│   Tokens    │
└──────┬──────┘
       │
       ▼
┌─────────────┐
│  Navigate   │
│  par Role   │
└─────────────┘
```

---

## 🚀 ACTIVATION

### Étape 1: Backend (À faire)
```java
// 1. Firebase Admin SDK
FirebaseApp.initializeApp(options);

// 2. POST /auth/firebase
@PostMapping("/auth/firebase")
public AuthResponse authenticateWithFirebase(@RequestBody FirebaseAuthRequest request) {
    FirebaseToken token = FirebaseAuth.getInstance().verifyIdToken(request.getIdToken());
    User user = userService.findOrCreateByFirebaseUid(token.getUid());
    String accessToken = jwtService.generateAccessToken(user);
    String refreshToken = jwtService.generateRefreshToken(user);
    return new AuthResponse(accessToken, refreshToken, 3600, user);
}

// 3. JWT Filter
@Component
public class JwtAuthenticationFilter extends OncePerRequestFilter {
    // Intercepter requêtes, valider JWT, set authentication
}
```

### Étape 2: Flutter (5 minutes)
```dart
// main.dart
ApiClient().initialize();

final authRepository = HybridAuthRepository(
  firebaseDataSource: FirebaseAuthDataSource(),
  backendDataSource: BackendAuthDataSource(),
);
```

### Étape 3: Configuration
```dart
// app_config.dart
static const String BACKEND_BASE_URL = 'https://your-backend.com/api';
static const bool USE_BACKEND_AUTH = true;
```

---

## 📦 LIVRABLES BACKEND

### Requis:
- [ ] POST /auth/firebase implémenté
- [ ] GET /auth/me implémenté
- [ ] POST /auth/refresh implémenté
- [ ] JWT Service (generate, validate, refresh)
- [ ] JWT Filter (interceptor)
- [ ] Firebase Admin SDK configuré
- [ ] Codes d'erreur standardisés
- [ ] CORS configuré
- [ ] HTTPS activé (production)

### Nice to have:
- [ ] POST /auth/logout
- [ ] Postman collection
- [ ] Documentation Swagger
- [ ] Tests unitaires

---

## ⏱️ TIMELINE

| Phase | Durée | Responsable |
|-------|-------|-------------|
| Backend endpoints | 2-3 jours | Backend team |
| JWT Service | 1 jour | Backend team |
| Tests backend | 1 jour | Backend team |
| Configuration Flutter | 5 minutes | Mobile team |
| Tests intégration | 1 jour | Les 2 teams |
| **TOTAL** | **4-5 jours** | |

---

## 🎯 PROCHAINES ÉTAPES

### Immédiat:
1. Backend team: Commencer implémentation
2. Mobile team: Installer dépendances (`flutter pub get`)
3. Partager Postman collection (exemples Firebase ID Token)

### Cette semaine:
1. Backend: POST /auth/firebase + GET /auth/me
2. Backend: JWT Service
3. Tests avec Postman

### Semaine prochaine:
1. Backend: POST /auth/refresh + JWT Filter
2. Mobile: Configuration + activation
3. Tests intégration end-to-end

---

## 📞 CONTACTS

**Mobile Team**: [Ton nom/email]
**Backend Team**: [Nom/email]

**Documents:**
- `BACKEND_INTEGRATION_CHECKLIST.md` - Checklist complète
- `ROLE_VERIFICATION.md` - Vérification rôle backend
- `BACKEND_AUTH_ARCHITECTURE.md` - Architecture détaillée

---

## ❓ QUESTIONS?

1. URL du backend de dev?
2. Firebase Admin SDK déjà configuré?
3. JWT library utilisée?
4. Durée des tokens (access/refresh)?
5. Format des erreurs standardisé?
