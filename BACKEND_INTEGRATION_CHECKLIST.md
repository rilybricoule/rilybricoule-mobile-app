# 📋 BACKEND INTEGRATION CHECKLIST

## 🔐 ENDPOINTS REQUIS

### 1️⃣ POST /api/auth/firebase
**Vérifier Firebase ID Token et retourner JWT**

**Request:**
```http
POST /api/auth/firebase
Content-Type: application/json

{
  "idToken": "eyJhbGciOiJSUzI1NiIsImtpZCI6IjFkYzBmMTc..."
}
```

**Response Success (200):**
```json
{
  "accessToken": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "refreshToken": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "expiresIn": 3600,
  "user": {
    "id": "550e8400-e29b-41d4-a716-446655440000",
    "email": "user@example.com",
    "fullName": "John Doe",
    "role": "client",
    "phone": "+212612345678",
    "photoUrl": "https://example.com/photo.jpg",
    "isVerified": true,
    "createdAt": "2024-01-01T00:00:00Z",
    "updatedAt": "2024-01-01T00:00:00Z"
  }
}
```

**Response Error (400):**
```json
{
  "error": "Bad Request",
  "message": "Invalid Firebase ID Token",
  "statusCode": 400
}
```

**Response Error (401):**
```json
{
  "error": "Unauthorized",
  "message": "Firebase token expired",
  "statusCode": 401
}
```

---

### 2️⃣ GET /api/auth/me
**Récupérer le profil utilisateur connecté**

**Request:**
```http
GET /api/auth/me
Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
```

**Response Success (200):**
```json
{
  "id": "550e8400-e29b-41d4-a716-446655440000",
  "email": "user@example.com",
  "fullName": "John Doe",
  "role": "client",
  "phone": "+212612345678",
  "photoUrl": "https://example.com/photo.jpg",
  "isVerified": true,
  "createdAt": "2024-01-01T00:00:00Z",
  "updatedAt": "2024-01-01T00:00:00Z"
}
```

**Response Error (401):**
```json
{
  "error": "Unauthorized",
  "message": "Invalid or expired token",
  "statusCode": 401
}
```

---

### 3️⃣ POST /api/auth/refresh
**Rafraîchir l'access token**

**Request:**
```http
POST /api/auth/refresh
Content-Type: application/json

{
  "refreshToken": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."
}
```

**Response Success (200):**
```json
{
  "accessToken": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "refreshToken": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "expiresIn": 3600
}
```

**Response Error (401):**
```json
{
  "error": "Unauthorized",
  "message": "Invalid or expired refresh token",
  "statusCode": 401
}
```

---

### 4️⃣ POST /api/auth/logout (Optionnel)
**Invalider le refresh token**

**Request:**
```http
POST /api/auth/logout
Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
```

**Response Success (200):**
```json
{
  "message": "Logged out successfully"
}
```

---

## 🔑 FORMAT HEADERS

### Authorization Header
```
Authorization: Bearer <ACCESS_TOKEN>
```

**Exemple:**
```
Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiI1NTBlODQwMC1lMjliLTQxZDQtYTcxNi00NDY2NTU0NDAwMDAiLCJlbWFpbCI6InVzZXJAZXhhbXBsZS5jb20iLCJyb2xlIjoiY2xpZW50IiwiaWF0IjoxNzA5MjEwNDAwLCJleHAiOjE3MDkyMTQwMDB9.abc123xyz
```

### Content-Type Header
```
Content-Type: application/json
```

---

## ⚠️ CODES D'ERREUR

### 400 - Bad Request
**Quand:** Données invalides (Firebase ID Token malformé, champs manquants)
```json
{
  "error": "Bad Request",
  "message": "Invalid Firebase ID Token",
  "statusCode": 400
}
```

### 401 - Unauthorized
**Quand:** Token JWT invalide, expiré, ou manquant
```json
{
  "error": "Unauthorized",
  "message": "Invalid or expired token",
  "statusCode": 401
}
```

### 403 - Forbidden
**Quand:** Token valide mais permissions insuffisantes
```json
{
  "error": "Forbidden",
  "message": "Insufficient permissions",
  "statusCode": 403
}
```

### 422 - Unprocessable Entity
**Quand:** Validation échouée (email déjà utilisé, format invalide)
```json
{
  "error": "Unprocessable Entity",
  "message": "Email already exists",
  "statusCode": 422
}
```

### 500 - Internal Server Error
**Quand:** Erreur serveur
```json
{
  "error": "Internal Server Error",
  "message": "An unexpected error occurred",
  "statusCode": 500
}
```

---

## 🔄 REFRESH TOKEN BEHAVIOR

### Quand refresh?
- **Automatique**: 5 minutes avant expiration de l'access token
- **Sur 401**: Si une requête retourne 401, l'app tente un refresh automatique

### Flow de refresh:
```
1. App détecte token expiré (ou reçoit 401)
2. App appelle POST /auth/refresh avec refreshToken
3. Backend valide refreshToken
4. Backend génère nouveau accessToken + refreshToken
5. App sauvegarde nouveaux tokens
6. App retry la requête originale avec nouveau token
```

### Si refresh échoue:
```
1. App supprime tous les tokens
2. App déconnecte l'utilisateur
3. App redirige vers écran de login
```

---

## 🎯 RÔLES UTILISATEUR

### Valeurs possibles:
- `"client"` - Utilisateur qui réserve des services
- `"prestataire"` - Prestataire de services

### ⚠️ IMPORTANT:
Le **rôle DOIT venir du backend**, pas de Firebase/Firestore.
L'app route l'utilisateur selon `user.role` dans la response backend.

---

## 🧪 TESTS REQUIS

### Test 1: Login Google
```
1. User login avec Google dans l'app
2. App récupère Firebase ID Token
3. App envoie POST /auth/firebase { idToken }
4. Backend vérifie et retourne JWT + user
5. Vérifier que user.role = "client" ou "prestataire"
```

### Test 2: Refresh Token
```
1. Attendre expiration du token (ou forcer)
2. App appelle POST /auth/refresh
3. Backend retourne nouveaux tokens
4. App peut continuer à utiliser les APIs
```

### Test 3: Token Invalide
```
1. Envoyer requête avec token invalide
2. Backend retourne 401
3. App tente refresh
4. Si refresh échoue, app déconnecte user
```

---

## 📝 MODÈLE USER

```typescript
interface User {
  id: string;              // UUID
  email: string;           // Unique
  fullName: string;
  role: "client" | "prestataire";
  phone?: string;          // Nullable
  photoUrl?: string;       // Nullable
  isVerified: boolean;
  createdAt: string;       // ISO 8601
  updatedAt: string;       // ISO 8601
}
```

---

## 🔐 JWT REQUIREMENTS

### Access Token
- **Durée**: 3600 secondes (1 heure)
- **Contenu**: userId, email, role
- **Algorithme**: HS256 ou RS256

### Refresh Token
- **Durée**: 604800 secondes (7 jours)
- **Stockage**: Base de données (pour invalidation)
- **Usage**: Uniquement pour /auth/refresh

---

## 📦 POSTMAN COLLECTION

**À fournir par l'équipe backend:**
1. Collection Postman avec tous les endpoints
2. Exemples de Firebase ID Token de test
3. Variables d'environnement (base_url, tokens)

---

## ✅ CHECKLIST FINALE

- [ ] POST /auth/firebase implémenté
- [ ] GET /auth/me implémenté
- [ ] POST /auth/refresh implémenté
- [ ] POST /auth/logout implémenté (optionnel)
- [ ] Firebase Admin SDK configuré
- [ ] JWT génération/validation fonctionnel
- [ ] Codes d'erreur standardisés (400/401/403/422/500)
- [ ] CORS configuré pour mobile
- [ ] HTTPS activé (production)
- [ ] Tests unitaires écrits
- [ ] Postman collection fournie
- [ ] Documentation Swagger disponible
- [ ] URL de base communiquée

---

**Contact Flutter Team**: [Ton nom/email]
**Deadline**: [À définir]
