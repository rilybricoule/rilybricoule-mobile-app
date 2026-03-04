# ✅ CHECKLIST COMPLÈTE - Intégration Backend Auth

## 📦 PHASE 1: INSTALLATION (FAIT ✅)

- [x] Créer `app_config.dart` avec flag USE_BACKEND_AUTH
- [x] Créer modèle `AuthTokens`
- [x] Créer modèle `BackendUser`
- [x] Créer `TokenStorage` (SecureStorage)
- [x] Créer `ApiClient` (Dio + interceptors)
- [x] Créer `BackendAuthDataSource`
- [x] Créer `HybridAuthRepository`
- [x] Ajouter dépendances dans pubspec.yaml
- [x] Créer documentation (BACKEND_AUTH_ARCHITECTURE.md)
- [x] Créer résumé des changements (BACKEND_AUTH_CHANGES.md)
- [x] Créer exemples d'utilisation (BACKEND_AUTH_EXAMPLES.dart)

## 🔧 PHASE 2: CONFIGURATION (À FAIRE)

### 2.1 Installer les dépendances
```bash
cd /path/to/project
flutter pub get
```

### 2.2 Mettre à jour main.dart
```dart
// Ajouter en haut
import 'services/api/api_client.dart';
import 'data/repositories/hybrid_auth_repository.dart';
import 'data/datasources/backend_auth_datasource.dart';

// Dans main()
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  
  // AJOUTER CETTE LIGNE
  ApiClient().initialize();
  
  await FCMService().initialize();
  await RemoteConfigService().initialize();
  
  runApp(const MyApp());
}

// Dans MyApp.build()
// REMPLACER:
final authDataSource = FirebaseAuthDataSource();
final AuthRepository authRepository = FirebaseAuthRepository(authDataSource);

// PAR:
final authDataSource = FirebaseAuthDataSource();
final backendDataSource = BackendAuthDataSource();
final AuthRepository authRepository = HybridAuthRepository(
  firebaseDataSource: authDataSource,
  backendDataSource: backendDataSource,
);
```

### 2.3 Configurer l'URL backend
Dans `lib/core/config/app_config.dart`:
```dart
static const String BACKEND_BASE_URL = 'https://your-backend-url.com/api';
// OU pour dev local:
// static const String BACKEND_BASE_URL = 'http://10.0.2.2:8080/api'; // Android Emulator
// static const String BACKEND_BASE_URL = 'http://localhost:8080/api'; // iOS Simulator
```

## 🧪 PHASE 3: TESTS MODE FIREBASE-ONLY (À FAIRE)

Garder `USE_BACKEND_AUTH = false` et tester:

- [ ] Login email/password fonctionne
- [ ] Register fonctionne
- [ ] Login Google fonctionne
- [ ] Login Facebook fonctionne (si configuré)
- [ ] Login Apple fonctionne (si configuré)
- [ ] Logout fonctionne
- [ ] Navigation selon rôle (client/prestataire)
- [ ] Profil chargé depuis Firestore
- [ ] Pas de régression

## 🚀 PHASE 4: BACKEND SPRING BOOT (À FAIRE)

### 4.1 Dépendances Maven
```xml
<dependency>
    <groupId>com.google.firebase</groupId>
    <artifactId>firebase-admin</artifactId>
    <version>9.2.0</version>
</dependency>
<dependency>
    <groupId>io.jsonwebtoken</groupId>
    <artifactId>jjwt-api</artifactId>
    <version>0.11.5</version>
</dependency>
```

### 4.2 Initialiser Firebase Admin
```java
@Configuration
public class FirebaseConfig {
    @PostConstruct
    public void initialize() throws IOException {
        FileInputStream serviceAccount = new FileInputStream("path/to/serviceAccountKey.json");
        FirebaseOptions options = FirebaseOptions.builder()
            .setCredentials(GoogleCredentials.fromStream(serviceAccount))
            .build();
        FirebaseApp.initializeApp(options);
    }
}
```

### 4.3 Créer les endpoints
- [ ] POST /auth/firebase
- [ ] GET /auth/me
- [ ] POST /auth/refresh
- [ ] POST /auth/logout

### 4.4 JWT Service
- [ ] generateAccessToken(User user)
- [ ] generateRefreshToken(User user)
- [ ] validateToken(String token)
- [ ] extractUserId(String token)

### 4.5 JWT Filter
- [ ] Intercepter toutes les requêtes
- [ ] Extraire et valider le token
- [ ] Set SecurityContext

## 🔄 PHASE 5: ACTIVATION MODE BACKEND (À FAIRE)

### 5.1 Activer le flag
Dans `lib/core/config/app_config.dart`:
```dart
static const bool USE_BACKEND_AUTH = true;
```

### 5.2 Tester le flow complet
- [ ] Login Google → Firebase ID Token récupéré
- [ ] Firebase ID Token envoyé au backend
- [ ] Backend vérifie et renvoie JWT
- [ ] JWT sauvegardé en SecureStorage
- [ ] Profil chargé depuis backend
- [ ] Rôle vient du backend
- [ ] Navigation selon rôle backend

### 5.3 Tester les APIs
- [ ] Créer un BookingRepository avec ApiClient
- [ ] Appeler une API métier
- [ ] Vérifier que JWT est ajouté automatiquement
- [ ] Tester le refresh automatique (forcer expiration)
- [ ] Vérifier le retry après refresh

### 5.4 Tester le logout
- [ ] Logout depuis l'app
- [ ] Vérifier Firebase signOut
- [ ] Vérifier backend /auth/logout appelé
- [ ] Vérifier tokens supprimés de SecureStorage
- [ ] Vérifier navigation vers login

## 📱 PHASE 6: MIGRATION DES REPOSITORIES (À FAIRE)

Remplacer tous les mock repositories par des vrais:

### 6.1 SearchRepository
```dart
class ApiSearchRepository implements SearchRepository {
  final _apiClient = ApiClient();
  
  @override
  Future<List<Provider>> searchProviders(SearchFilters filters) async {
    final response = await _apiClient.dio.get('/providers', queryParameters: filters.toJson());
    return (response.data as List).map((json) => Provider.fromJson(json)).toList();
  }
}
```

### 6.2 BookingRepository
- [ ] createBooking()
- [ ] getMyBookings()
- [ ] getBookingDetails()
- [ ] cancelBooking()
- [ ] updateBookingStatus()

### 6.3 ChatRepository
- [ ] getConversations()
- [ ] getMessages()
- [ ] sendMessage()
- [ ] markAsRead()

### 6.4 NotificationRepository
- [ ] getNotifications()
- [ ] markAsRead()
- [ ] deleteNotification()

### 6.5 ReviewRepository
- [ ] createReview()
- [ ] getProviderReviews()
- [ ] getMyReviews()

## 🔐 PHASE 7: SÉCURITÉ (À FAIRE)

- [ ] Vérifier que Firebase ID Token n'est utilisé QUE pour /auth/firebase
- [ ] Vérifier que toutes les APIs métier utilisent JWT backend
- [ ] Tester le refresh automatique
- [ ] Tester le logout complet
- [ ] Vérifier que les tokens sont en SecureStorage
- [ ] Tester la gestion des erreurs 401/403
- [ ] Ajouter des logs pour debug
- [ ] Tester sur iOS et Android

## 📊 PHASE 8: MONITORING (À FAIRE)

- [ ] Ajouter Firebase Crashlytics pour les erreurs
- [ ] Logger les appels API en debug
- [ ] Monitorer les refresh token failures
- [ ] Ajouter analytics pour les logins
- [ ] Tracker les erreurs d'auth

## 🎯 RÉSULTAT FINAL

### Mode Firebase-only (USE_BACKEND_AUTH = false)
✅ Fonctionne comme avant
✅ Aucune régression
✅ Firestore pour profils
✅ Rôle depuis Firestore

### Mode Backend JWT (USE_BACKEND_AUTH = true)
✅ Firebase → Backend → JWT
✅ Tokens en SecureStorage
✅ Profil depuis backend
✅ Rôle depuis backend
✅ Toutes APIs avec JWT
✅ Refresh automatique
✅ Logout complet

## 📝 NOTES IMPORTANTES

1. **Ne PAS casser l'existant**: Le mode Firebase-only doit continuer à fonctionner
2. **Tester les 2 modes**: Basculer entre false/true et vérifier
3. **Sécurité**: Tokens en SecureStorage, pas en SharedPreferences
4. **Rôle**: Doit venir du backend, pas de Firebase/Firestore
5. **APIs**: Toutes doivent utiliser ApiClient avec JWT
6. **Refresh**: Automatique via interceptor, pas manuel
7. **Logout**: Complet (Firebase + Backend + Storage)

## 🆘 EN CAS DE PROBLÈME

### Backend non disponible
→ Garder `USE_BACKEND_AUTH = false`

### Erreur 401 en boucle
→ Vérifier que le refresh token est valide
→ Vérifier l'endpoint /auth/refresh

### Tokens non sauvegardés
→ Vérifier flutter_secure_storage installé
→ Vérifier permissions iOS/Android

### Rôle incorrect
→ Vérifier que le backend renvoie le bon rôle
→ Vérifier le parsing dans BackendUser.fromJson()

### API calls sans JWT
→ Vérifier que ApiClient est initialisé
→ Vérifier que le repository utilise ApiClient.dio
