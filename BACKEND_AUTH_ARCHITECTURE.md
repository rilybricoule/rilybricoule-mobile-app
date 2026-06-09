# Architecture d'Authentification - RilyBricoule

## 📋 FLOW FINAL (Firebase → Backend → JWT)

```
1. Flutter → Firebase Auth (Google/Facebook/Apple/Email)
2. Firebase → Firebase ID Token
3. Flutter → Backend POST /auth/firebase { idToken }
4. Backend → Vérifie token via Firebase Admin SDK
5. Backend → Crée/récupère user en base
6. Backend → Renvoie JWT (accessToken + refreshToken)
7. Flutter → Utilise JWT pour toutes les APIs métier
```

## 🏗️ ARCHITECTURE ACTUELLE

### Mode Hybride (USE_BACKEND_AUTH flag)

**Mode Firebase-only (USE_BACKEND_AUTH = false)** - ACTUEL
- Firebase Auth pour login
- Firestore pour profils utilisateurs
- Rôle stocké dans Firestore
- Pas de JWT backend

**Mode Backend JWT (USE_BACKEND_AUTH = true)** - PRÊT
- Firebase Auth pour login
- Backend Spring Boot pour vérification
- JWT pour toutes les APIs
- Rôle vient du backend

## 📁 STRUCTURE DES FICHIERS

```
lib/
├── core/
│   └── config/
│       └── app_config.dart              # Flag USE_BACKEND_AUTH
├── data/
│   ├── datasources/
│   │   ├── firebase_auth_datasource.dart    # Firebase sign-in
│   │   └── backend_auth_datasource.dart     # HTTP calls backend
│   ├── models/
│   │   ├── app_user.dart                    # Modèle app (existant)
│   │   ├── auth_tokens.dart                 # JWT tokens
│   │   └── backend_user.dart                # Profil backend
│   └── repositories/
│       ├── firebase_auth_repository.dart    # Firebase-only (existant)
│       └── hybrid_auth_repository.dart      # Hybride (nouveau)
├── domain/
│   └── repositories/
│       └── auth_repository.dart             # Interface
├── services/
│   ├── api/
│   │   └── api_client.dart                  # Dio + interceptors
│   └── storage/
│       └── token_storage.dart               # SecureStorage JWT
└── features/
    └── auth/
        └── viewmodel/
            └── auth_viewmodel.dart          # Inchangé
```

## 🔐 ENDPOINTS BACKEND (TODO)

### POST /auth/firebase
**Request:**
```json
{
  "idToken": "<FIREBASE_ID_TOKEN>"
}
```

**Response:**
```json
{
  "accessToken": "eyJhbGc...",
  "refreshToken": "eyJhbGc...",
  "expiresIn": 3600,
  "user": {
    "id": "uuid",
    "email": "user@example.com",
    "fullName": "John Doe",
    "role": "client",
    "phone": "+212...",
    "photoUrl": "https://...",
    "isVerified": true,
    "createdAt": "2024-01-01T00:00:00Z",
    "updatedAt": "2024-01-01T00:00:00Z"
  }
}
```

### GET /auth/me
**Headers:**
```
Authorization: Bearer <accessToken>
```

**Response:**
```json
{
  "id": "uuid",
  "email": "user@example.com",
  "fullName": "John Doe",
  "role": "client",
  ...
}
```

### POST /auth/refresh
**Request:**
```json
{
  "refreshToken": "eyJhbGc..."
}
```

**Response:**
```json
{
  "accessToken": "eyJhbGc...",
  "refreshToken": "eyJhbGc...",
  "expiresIn": 3600
}
```

### POST /auth/logout
**Headers:**
```
Authorization: Bearer <accessToken>
```

## 🚀 ACTIVATION DU MODE BACKEND

### Étape 1: Installer les dépendances
```bash
flutter pub get
```

### Étape 2: Configurer l'URL backend
Dans `lib/core/config/app_config.dart`:
```dart
static const String BACKEND_BASE_URL = 'https://your-backend.com/api';
```

### Étape 3: Activer le mode backend
Dans `lib/core/config/app_config.dart`:
```dart
static const bool USE_BACKEND_AUTH = true;
```

### Étape 4: Mettre à jour main.dart
Remplacer `FirebaseAuthRepository` par `HybridAuthRepository`:
```dart
final authRepository = HybridAuthRepository(
  firebaseDataSource: FirebaseAuthDataSource(),
  backendDataSource: BackendAuthDataSource(),
);
```

## 🔄 REFRESH TOKEN AUTOMATIQUE

L'`ApiClient` gère automatiquement le refresh:
1. Intercepte les erreurs 401
2. Appelle POST /auth/refresh
3. Sauvegarde le nouveau token
4. Retry la requête originale

## 🔒 SÉCURITÉ

- **Tokens JWT**: Stockés dans `flutter_secure_storage` (Keychain iOS / Keystore Android)
- **Firebase ID Token**: Utilisé uniquement pour `/auth/firebase`
- **Access Token**: Ajouté automatiquement à toutes les requêtes API
- **Refresh Token**: Utilisé uniquement pour `/auth/refresh`

## 📝 LOGOUT COMPLET

```dart
await authViewModel.logout();
```

Effectue:
1. `FirebaseAuth.signOut()`
2. `POST /auth/logout` (backend)
3. `TokenStorage.clearAll()` (supprime JWT)
4. Reset state
5. Navigate to login

## ⚠️ IMPORTANT

- Le **rôle** doit venir du backend, pas de Firebase/Firestore
- Firebase = Identity Provider uniquement
- Backend = Source de vérité métier
- Tous les repos métier doivent utiliser `ApiClient` avec JWT

## 🧪 TESTS

Mode Firebase-only (actuel):
```dart
AppConfig.USE_BACKEND_AUTH = false
```

Mode Backend JWT (quand prêt):
```dart
AppConfig.USE_BACKEND_AUTH = true
```
