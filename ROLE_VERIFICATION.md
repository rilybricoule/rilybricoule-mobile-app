# ✅ VÉRIFICATION: RÔLE VIENT DU BACKEND

## 🎯 CONFIRMATION

### ✅ Mode Backend (USE_BACKEND_AUTH = true)

**Le rôle vient UNIQUEMENT du backend, PAS de Firestore.**

### Code Proof:

#### 1. Login Google (ligne 95-97)
```dart
// 5. Récupérer le profil backend
_backendUser = BackendUser.fromJson(backendResponse['user']);
await _tokenStorage.saveUserId(_backendUser!.id);

// 6. Convertir en AppUser
_currentUser = _convertBackendUserToAppUser(_backendUser!);
```

#### 2. Conversion BackendUser → AppUser (ligne 283-295)
```dart
AppUser _convertBackendUserToAppUser(BackendUser backendUser) {
  return AppUser(
    uid: backendUser.id,
    role: backendUser.role,  // ← RÔLE VIENT DU BACKEND
    fullName: backendUser.fullName,
    email: backendUser.email,
    phone: backendUser.phone,
    photoUrl: backendUser.photoUrl,
    createdAt: backendUser.createdAt,
    updatedAt: backendUser.updatedAt,
    isVerified: backendUser.isVerified,
    clientProfile: backendUser.role == UserRole.client ? ClientProfile() : null,
    providerProfile: backendUser.role == UserRole.prestataire ? ProviderProfile() : null,
  );
}
```

#### 3. BackendUser.fromJson (backend_user.dart ligne 32-34)
```dart
factory BackendUser.fromJson(Map<String, dynamic> json) {
  return BackendUser(
    id: json['id'] as String,
    email: json['email'] as String,
    fullName: json['fullName'] as String,
    role: _parseRole(json['role'] as String),  // ← PARSE LE RÔLE DU JSON BACKEND
    phone: json['phone'] as String?,
    photoUrl: json['photoUrl'] as String?,
    isVerified: json['isVerified'] as bool? ?? false,
    createdAt: DateTime.parse(json['createdAt'] as String),
    updatedAt: DateTime.parse(json['updatedAt'] as String),
    metadata: json['metadata'] as Map<String, dynamic>?,
  );
}
```

#### 4. Parse Role (backend_user.dart ligne 56-65)
```dart
static UserRole _parseRole(String roleStr) {
  switch (roleStr.toLowerCase()) {
    case 'client':
      return UserRole.client;
    case 'prestataire':
    case 'provider':
      return UserRole.prestataire;
    default:
      return UserRole.client;
  }
}
```

---

## 🔄 FLOW COMPLET

```
1. User login Google
   ↓
2. Firebase Auth → Firebase ID Token
   ↓
3. POST /auth/firebase { idToken }
   ↓
4. Backend response:
   {
     "accessToken": "...",
     "refreshToken": "...",
     "user": {
       "id": "...",
       "role": "client"  ← BACKEND DÉCIDE LE RÔLE
     }
   }
   ↓
5. BackendUser.fromJson(response['user'])
   ↓
6. _convertBackendUserToAppUser(backendUser)
   ↓
7. AppUser.role = backendUser.role  ← RÔLE DU BACKEND
   ↓
8. Navigation selon AppUser.role
```

---

## ❌ CE QUI N'EST PAS UTILISÉ (Mode Backend)

### Firestore
- ❌ Pas de lecture de Firestore pour le rôle
- ❌ Pas de `getUserProfile(uid)` en mode backend
- ❌ Firestore utilisé UNIQUEMENT en mode Firebase-only

### Code Proof (ligne 38-46):
```dart
if (AppConfig.USE_BACKEND_AUTH) {
  // Mode backend: charger depuis backend
  await _loadBackendUser();  // ← Appelle GET /auth/me
} else {
  // Mode Firebase: charger depuis Firestore
  _currentUser = await _firebaseDataSource.getUserProfile(firebaseUser.uid);
}
```

---

## 🎯 NAVIGATION PAR RÔLE

### Dans login_view.dart / register_view.dart:
```dart
if (user.role == UserRole.client) {
  Navigator.pushReplacementNamed(context, AppRoutes.home);
} else if (user.role == UserRole.prestataire) {
  Navigator.pushReplacementNamed(context, AppRoutes.providerMain);
}
```

**Le `user.role` vient de `AppUser` qui vient de `BackendUser` qui vient du backend.**

---

## ✅ RÉSUMÉ

| Aspect | Mode Firebase-only | Mode Backend |
|--------|-------------------|--------------|
| Source du rôle | Firestore | Backend API |
| Endpoint | N/A | POST /auth/firebase |
| Modèle | AppUser (Firestore) | BackendUser → AppUser |
| Décision | Client (Firestore) | Backend (source de vérité) |
| Changement rôle | Modifier Firestore | Modifier backend DB |

---

## 🔐 SÉCURITÉ

### ✅ Avantages du rôle backend:
1. **Source de vérité**: Backend contrôle les permissions
2. **Sécurisé**: Client ne peut pas modifier son rôle
3. **Centralisé**: Un seul endroit pour gérer les rôles
4. **Auditable**: Logs backend pour changements de rôle
5. **Scalable**: Facile d'ajouter de nouveaux rôles

### ❌ Problème du rôle Firestore:
1. Client peut modifier Firestore (si rules mal configurées)
2. Pas de validation côté serveur
3. Difficile à auditer
4. Pas de source de vérité unique

---

## 🧪 TEST DE VÉRIFICATION

### Pour confirmer que le rôle vient du backend:

1. **Activer mode backend:**
   ```dart
   // app_config.dart
   static const bool USE_BACKEND_AUTH = true;
   ```

2. **Login avec Google**

3. **Vérifier les logs:**
   ```
   BackendAuthDataSource: Sending Firebase ID Token to backend...
   BackendAuthDataSource: Backend auth successful
   HybridAuthRepository: Backend user role: client
   ```

4. **Vérifier la navigation:**
   - Si role = "client" → ClientMainView
   - Si role = "prestataire" → ProviderMainView

5. **Modifier le rôle dans le backend DB**

6. **Logout + Login**

7. **Vérifier que le nouveau rôle est appliqué**

---

## ✅ CONCLUSION

**Le rôle vient à 100% du backend quand USE_BACKEND_AUTH = true.**

- ✅ Pas de lecture Firestore
- ✅ BackendUser.role utilisé
- ✅ Navigation basée sur backend role
- ✅ Sécurisé et centralisé
