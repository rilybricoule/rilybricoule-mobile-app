# 🔥 Firebase Integration - RilyBricoule

## 📋 Configuration Firebase

### 1. Créer un projet Firebase
1. Aller sur [Firebase Console](https://console.firebase.google.com/)
2. Créer un nouveau projet "RilyBricoule"
3. Activer Google Analytics (optionnel)

### 2. Ajouter les applications

#### Android
```bash
# Dans Firebase Console:
1. Ajouter une app Android
2. Package name: com.rilybricoule.app (ou votre package)
3. Télécharger google-services.json
4. Placer dans: android/app/google-services.json
```

#### iOS
```bash
# Dans Firebase Console:
1. Ajouter une app iOS
2. Bundle ID: com.rilybricoule.app (ou votre bundle)
3. Télécharger GoogleService-Info.plist
4. Placer dans: ios/Runner/GoogleService-Info.plist
```

### 3. Configuration Android

**android/build.gradle:**
```gradle
buildscript {
    dependencies {
        classpath 'com.google.gms:google-services:4.4.0'
    }
}
```

**android/app/build.gradle:**
```gradle
apply plugin: 'com.google.gms.google-services'

android {
    defaultConfig {
        minSdkVersion 21  // Firebase minimum
    }
}
```

### 4. Configuration iOS

**ios/Podfile:**
```ruby
platform :ios, '13.0'  # Firebase minimum
```

Puis:
```bash
cd ios
pod install
```

### 5. Activer les services Firebase

#### Authentication
1. Firebase Console → Authentication → Get Started
2. Activer les providers:
   - ✅ Google
   - ✅ Facebook (nécessite App ID/Secret)
   - ✅ Apple (iOS uniquement)
   - ✅ Email/Password

#### Firestore
1. Firebase Console → Firestore Database → Create Database
2. Mode: **Production** (avec règles de sécurité)
3. Région: europe-west1 (ou proche)

**Règles Firestore (firestore.rules):**
```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Users collection
    match /users/{userId} {
      allow read: if request.auth != null;
      allow write: if request.auth != null && request.auth.uid == userId;
    }
    
    // Notifications
    match /notifications/{userId}/items/{notifId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
  }
}
```

#### Cloud Messaging (FCM)
1. Firebase Console → Cloud Messaging
2. Activer l'API
3. Pour iOS: Ajouter APNs Auth Key

#### Crashlytics
1. Firebase Console → Crashlytics → Get Started
2. Suivre les instructions

#### Remote Config
1. Firebase Console → Remote Config
2. Créer les paramètres:
   - `feature_map_view_enabled` = true
   - `feature_new_checkout_enabled` = false
   - `feature_chat_enabled` = true

### 6. Configuration Social Auth

#### Google Sign-In
**Android:** Automatique avec google-services.json

**iOS (ios/Runner/Info.plist):**
```xml
<key>CFBundleURLTypes</key>
<array>
    <dict>
        <key>CFBundleTypeRole</key>
        <string>Editor</string>
        <key>CFBundleURLSchemes</key>
        <array>
            <string>com.googleusercontent.apps.YOUR_CLIENT_ID</string>
        </array>
    </dict>
</array>
```

#### Facebook Login
1. Créer app sur [Facebook Developers](https://developers.facebook.com/)
2. Obtenir App ID et App Secret
3. Configurer dans Firebase Auth

**Android (android/app/src/main/res/values/strings.xml):**
```xml
<string name="facebook_app_id">YOUR_FACEBOOK_APP_ID</string>
<string name="fb_login_protocol_scheme">fbYOUR_FACEBOOK_APP_ID</string>
```

**iOS (ios/Runner/Info.plist):**
```xml
<key>CFBundleURLTypes</key>
<array>
    <dict>
        <key>CFBundleURLSchemes</key>
        <array>
            <string>fbYOUR_FACEBOOK_APP_ID</string>
        </array>
    </dict>
</array>
<key>FacebookAppID</key>
<string>YOUR_FACEBOOK_APP_ID</string>
<key>FacebookDisplayName</key>
<string>RilyBricoule</string>
```

#### Apple Sign-In
**iOS uniquement - Automatique si configuré dans Xcode:**
1. Xcode → Signing & Capabilities
2. Ajouter "Sign in with Apple"

### 7. Générer firebase_options.dart

```bash
# Installer FlutterFire CLI
dart pub global activate flutterfire_cli

# Générer les options
flutterfire configure
```

Cela crée: `lib/firebase_options.dart`

### 8. Tester FCM

#### Simulateur (Firestore)
```dart
// Créer des notifications de test dans Firestore
FirebaseFirestore.instance
  .collection('notifications')
  .doc(userId)
  .collection('items')
  .add({
    'type': 'chat',
    'title': 'Nouveau message',
    'body': 'Ahmed vous a envoyé un message',
    'conversationId': '123',
    'timestamp': FieldValue.serverTimestamp(),
    'read': false,
  });
```

#### Device réel (FCM)
1. Firebase Console → Cloud Messaging → Send test message
2. Copier le FCM token depuis les logs
3. Envoyer une notification de test

**Format payload:**
```json
{
  "notification": {
    "title": "Test",
    "body": "Message de test"
  },
  "data": {
    "type": "chat",
    "conversationId": "123"
  }
}
```

## 🏗️ Architecture

```
lib/
├── core/
│   └── errors/
│       └── exceptions.dart
├── data/
│   ├── datasources/
│   │   └── firebase_auth_datasource.dart
│   ├── models/
│   │   └── app_user.dart
│   └── repositories/
│       └── firebase_auth_repository.dart
├── domain/
│   └── repositories/
│       └── auth_repository.dart (interface)
└── services/
    ├── firebase/
    │   └── firebase_service.dart
    ├── notifications/
    │   └── fcm_service.dart
    └── remote_config/
        └── remote_config_service.dart
```

## 🔄 Migration vers Backend

Tous les appels Firebase sont encapsulés dans des datasources/repositories.
Pour migrer vers une API:

1. Créer `ApiAuthDataSource` qui implémente les mêmes méthodes
2. Créer `ApiAuthRepository` qui utilise `ApiAuthDataSource`
3. Remplacer l'injection de dépendance dans `main.dart`
4. Le reste de l'app ne change pas!

**Exemple:**
```dart
// Avant (Firebase)
final authRepo = FirebaseAuthRepository(FirebaseAuthDataSource());

// Après (API)
final authRepo = ApiAuthRepository(ApiAuthDataSource(httpClient));
```

## 📱 Utilisation

### Initialisation (main.dart)
```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialiser Firebase
  await FirebaseService.initialize();
  
  // Initialiser Remote Config
  await RemoteConfigService().initialize();
  
  // Initialiser FCM
  await FCMService().initialize();
  
  runApp(MyApp());
}
```

### Auth
```dart
final authRepo = FirebaseAuthRepository(FirebaseAuthDataSource());

// Google Sign-In
final user = await authRepo.signInWithGoogle(UserRole.client);

// Email/Password
final user = await authRepo.signInWithEmailPassword(email, password);
```

### Notifications
```dart
final fcmService = FCMService();

// Écouter les messages
fcmService.onMessage.listen((message) {
  print('New message: ${message.notification?.title}');
});

// Obtenir le token
final token = fcmService.token;
```

### Remote Config
```dart
final config = RemoteConfigService();

if (config.isMapViewEnabled) {
  // Afficher la vue carte
}
```

## 🐛 Debug

### Logs Firebase
```dart
// Activer les logs détaillés
await FirebaseFirestore.instance.settings = Settings(
  persistenceEnabled: true,
  cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED,
);
```

### Tester Crashlytics
```dart
// Forcer un crash (debug uniquement)
FirebaseCrashlytics.instance.crash();
```

## 📚 Documentation

- [Firebase Flutter](https://firebase.google.com/docs/flutter/setup)
- [FlutterFire](https://firebase.flutter.dev/)
- [FCM](https://firebase.google.com/docs/cloud-messaging/flutter/client)
