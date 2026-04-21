# API Needs — Mobile RiLyBricoule
> Version: 1.0 | Generated: 2026-03-18
> Base URL: `https://api.rilybricoule.ma/api/mobile`
> Auth: `Authorization: Bearer <JWT>`

---

## 1. AUTH

| Method | Endpoint | Description |
|--------|----------|-------------|
| POST | `/auth/register` | Inscription client ou prestataire |
| POST | `/auth/login` | Connexion (email + password) |
| POST | `/auth/login/social` | OAuth Google / Facebook / Apple |
| POST | `/auth/forgot-password` | Envoi lien reset |
| POST | `/auth/reset-password` | Reset avec token |
| POST | `/auth/refresh-token` | Refresh JWT |
| POST | `/auth/logout` | Révocation token |
| GET  | `/auth/me` | Profil connecté + rôle |

### Register — Request
```json
{
  "email": "user@mail.com",
  "password": "********",
  "fullName": "Yassine El Amrani",
  "phone": "+212600000000",
  "role": "client|provider",
  "deviceToken": "fcm_token"
}
```

### Login — Response
```json
{
  "accessToken": "eyJ...",
  "refreshToken": "eyJ...",
  "expiresIn": 3600,
  "user": {
    "id": "u_123",
    "email": "user@mail.com",
    "fullName": "Yassine El Amrani",
    "role": "client",
    "avatarUrl": "https://...",
    "phone": "+212600000000",
    "createdAt": "2024-01-15T10:00:00Z"
  }
}
```

Error codes: `400` (validation), `401` (bad credentials), `409` (email exists), `422`, `500`

---

## 2. USERS / PROFILE

| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/users/me` | Mon profil complet |
| PUT | `/users/me` | Mise à jour profil (nom, téléphone, adresse) |
| PUT | `/users/me/avatar` | Upload photo de profil (multipart) |
| DELETE | `/users/me` | Suppression de compte |
| GET | `/users/me/stats` | Statistiques client (nb réservations, dépenses) |

### PUT /users/me — Request
```json
{
  "fullName": "Yassine El Amrani",
  "phone": "+212611111111",
  "address": "69, av. Abdelkrim Al Khattabi, Océan",
  "addressDetails": "Apt 4B, 2ème étage",
  "city": "Casablanca",
  "latitude": 33.5731,
  "longitude": -7.5898
}
```

Error codes: `401`, `403`, `404`, `422`, `500`

---

## 3. CATEGORIES

| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/categories` | Liste des catégories (id, name, icon, color) |
| GET | `/categories/:id/subcategories` | Sous-catégories |

> **Note Admin API**: L'Admin utilise `POST/PUT/DELETE /api/admin/categories` pour le CRUD. Le mobile n'a besoin que du GET.

### GET /categories — Response
```json
{
  "data": [
    {
      "id": "1",
      "name": { "fr": "Plomberie", "en": "Plumbing", "ar": "السباكة" },
      "icon": "plumbing",
      "backgroundColor": "#E8EAF6",
      "iconColor": "#3F51B5",
      "subcategories": [
        { "id": "1a", "name": { "fr": "Réparation fuite", "en": "Leak Repair", "ar": "إصلاح التسرب" } }
      ]
    }
  ]
}
```

Error codes: `401`, `500`

---

## 4. PROVIDERS (Search & Discovery)

| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/providers` | Recherche prestataires (query, catégorie, localisation) |
| GET | `/providers/:id` | Profil complet prestataire |
| GET | `/providers/:id/services` | Services proposés |
| GET | `/providers/:id/reviews` | Avis clients |
| GET | `/providers/:id/availability` | Créneaux disponibles par date |
| GET | `/providers/nearby` | Prestataires à proximité (carte) |
| POST | `/providers/:id/favorite` | Ajouter aux favoris |
| DELETE | `/providers/:id/favorite` | Retirer des favoris |
| GET | `/providers/favorites` | Mes prestataires favoris |

### GET /providers — Query params
```
?q=plombier
&categoryId=1
&lat=33.5731&lng=-7.5898
&radius=10          (km)
&minRating=4.0
&minPrice=0&maxPrice=2000
&availableNow=true
&sortBy=distance|rating|price
&page=1&limit=20
```

### GET /providers/:id — Response
```json
{
  "id": "p_456",
  "fullName": "Ahmed El Mansouri",
  "avatarUrl": "https://...",
  "coverImageUrl": "https://...",
  "bio": "Plombier expert, 8 ans d'expérience",
  "rating": 4.9,
  "reviewCount": 150,
  "isVerified": true,
  "isAvailable": true,
  "distance": 2.3,
  "location": { "lat": 33.58, "lng": -7.60 },
  "services": [...],
  "categories": ["1"],
  "gallery": ["https://..."],
  "completedJobs": 127,
  "memberSince": "2022-06-01"
}
```

Error codes: `401`, `404`, `500`

---

## 5. BOOKINGS (Réservations)

| Method | Endpoint | Description |
|--------|----------|-------------|
| POST | `/bookings` | Créer une réservation |
| GET | `/bookings` | Mes réservations (client) |
| GET | `/bookings/:id` | Détails réservation + timeline |
| PUT | `/bookings/:id/cancel` | Annuler |
| POST | `/bookings/:id/review` | Laisser un avis |
| GET | `/bookings/:id/invoice` | Télécharger facture |
| GET | `/bookings/:id/tracking` | Statut en temps réel |

### GET /bookings — Query params
```
?status=upcoming|ongoing|completed|cancelled
&page=1&limit=20
```

### POST /bookings — Request
```json
{
  "providerId": "p_456",
  "serviceId": "svc_789",
  "scheduledDate": "2026-01-15",
  "scheduledTime": "10:30",
  "address": "69, av. Abdelkrim Al Khattabi, Océan",
  "addressDetails": "Apt 4B, 2ème étage",
  "latitude": 33.5731,
  "longitude": -7.5898,
  "note": "Fuite sous évier cuisine",
  "paymentMethodId": "pm_abc",
  "promoCode": "RILY10"
}
```

### GET /bookings/:id — Response
```json
{
  "id": "b_001",
  "status": "confirmed",
  "provider": { "id": "p_456", "name": "Ahmed El Mansouri", "avatarUrl": "..." },
  "service": { "id": "svc_789", "name": "Réparation fuite", "price": 250, "duration": "45-60 min" },
  "scheduledDate": "2026-01-15",
  "scheduledTime": "10:30",
  "address": "69, av. Abdelkrim Al Khattabi",
  "addressDetails": "Apt 4B",
  "location": { "lat": 33.5731, "lng": -7.5898 },
  "note": "Fuite sous évier",
  "pricing": {
    "servicePrice": 250,
    "platformFee": 25,
    "insurance": 10,
    "discount": 0,
    "total": 285
  },
  "paymentMethod": "visa_4242",
  "paymentStatus": "pre_authorized",
  "timeline": [
    { "step": "created", "label": "Réservation créée", "at": "2026-01-14T15:00:00Z", "completed": true },
    { "step": "confirmed", "label": "Confirmée", "at": "2026-01-14T15:05:00Z", "completed": true },
    { "step": "provider_en_route", "label": "Prestataire en route", "at": null, "completed": false },
    { "step": "in_progress", "label": "Intervention en cours", "at": null, "completed": false },
    { "step": "completed", "label": "Terminée", "at": null, "completed": false }
  ],
  "canReview": false,
  "canCancel": true,
  "createdAt": "2026-01-14T15:00:00Z"
}
```

> **Note Admin API**: L'Admin utilise `GET /api/admin/reservations` avec filtres (status, payment_status, payment_method, date_from/to, search). Le mobile utilise un endpoint simplifié.

Error codes: `401`, `403`, `404`, `409` (conflit horaire), `422`, `500`

---

## 6. PAYMENTS

| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/payments/methods` | Mes moyens de paiement |
| POST | `/payments/methods` | Ajouter carte (CMI tokenization) |
| DELETE | `/payments/methods/:id` | Supprimer carte |
| PUT | `/payments/methods/:id/default` | Carte par défaut |
| POST | `/payments/pre-authorize` | Pré-autorisation avant booking |
| POST | `/payments/capture/:bookingId` | Capture après prestation |
| POST | `/payments/promo/validate` | Valider un code promo |

### POST /payments/methods — Request
```json
{
  "type": "card",
  "cardToken": "tok_cmi_xxx",
  "brand": "visa|mastercard|cmi",
  "last4": "4242",
  "expiryMonth": 12,
  "expiryYear": 2028,
  "isDefault": true
}
```

### POST /payments/promo/validate — Request / Response
```json
// Request
{ "code": "RILY10" }
// Response
{
  "valid": true,
  "discountType": "percentage",
  "discountValue": 10,
  "maxDiscount": 50,
  "expiresAt": "2026-03-31"
}
```

> **Note Admin API**: L'Admin consulte `GET /api/admin/transactions` pour le suivi des transactions côté back-office.

Error codes: `401`, `402` (paiement refusé), `404`, `422`, `500`

---

## 7. CHAT (WebSocket + REST)

| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/chat/conversations` | Liste conversations |
| POST | `/chat/conversations` | Créer / obtenir conversation avec un prestataire |
| GET | `/chat/conversations/:id/messages` | Historique messages |
| POST | `/chat/conversations/:id/messages` | Envoyer message (text, image, location) |
| PUT | `/chat/conversations/:id/read` | Marquer comme lu |

### WebSocket: `wss://api.rilybricoule.ma/ws/chat`
Events:
- `new_message` → réception en temps réel
- `typing` → indicateur de saisie
- `read_receipt` → accusé de lecture
- `online_status` → statut en ligne

### POST /chat/conversations/:id/messages — Request
```json
{
  "type": "text|image|location",
  "content": "Bonjour, je confirme le RDV",
  "imageUrl": "https://...",
  "location": { "lat": 33.5731, "lng": -7.5898, "label": "Mon adresse" }
}
```

Error codes: `401`, `403`, `404`, `500`

---

## 8. NOTIFICATIONS

| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/notifications` | Mes notifications |
| PUT | `/notifications/:id/read` | Marquer comme lue |
| PUT | `/notifications/read-all` | Tout marquer comme lu |
| DELETE | `/notifications/:id` | Supprimer notification |
| DELETE | `/notifications` | Supprimer toutes |
| POST | `/notifications/device-token` | Enregistrer FCM token |

### GET /notifications — Response
```json
{
  "data": [
    {
      "id": "n_001",
      "type": "booking_confirmed|message|promotion|cancelled|system|referral|reminder",
      "title": "Réservation confirmée",
      "message": "Votre réservation #001 a été confirmée",
      "isRead": false,
      "data": { "bookingId": "b_001" },
      "createdAt": "2026-03-18T10:00:00Z"
    }
  ],
  "unreadCount": 3
}
```

> **Note Admin API**: L'Admin envoie des notifications marketing via `POST /api/admin/notifications/send` (push / email / SMS). Le mobile ne fait que recevoir.

Error codes: `401`, `500`

---

## 9. SUPPORT & TICKETS

| Method | Endpoint | Description |
|--------|----------|-------------|
| POST | `/support/tickets` | Créer un ticket |
| GET | `/support/tickets` | Mes tickets |
| GET | `/support/tickets/:id` | Détails ticket |
| POST | `/support/tickets/:id/messages` | Répondre au ticket |
| GET | `/support/faq` | FAQ |

### POST /support/tickets — Request
```json
{
  "subject": "Problème avec ma réservation",
  "category": "booking|payment|provider|account|other",
  "bookingId": "b_001",
  "message": "Description du problème...",
  "attachments": ["https://..."]
}
```

> **Note Admin API**: L'Admin gère les litiges via `GET/PUT /api/admin/tickets` avec statuts open/in_progress/resolved/closed.

Error codes: `401`, `404`, `422`, `500`

---

## 10. PROVIDER-SIDE (Prestataire)

| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/provider/dashboard` | Stats du tableau de bord |
| GET | `/provider/bookings` | Réservations du prestataire |
| PUT | `/provider/bookings/:id/accept` | Accepter |
| PUT | `/provider/bookings/:id/reject` | Refuser |
| PUT | `/provider/bookings/:id/start` | Début intervention |
| PUT | `/provider/bookings/:id/complete` | Fin intervention |
| GET | `/provider/services` | Mes services |
| POST | `/provider/services` | Ajouter service |
| PUT | `/provider/services/:id` | Modifier service |
| DELETE | `/provider/services/:id` | Supprimer service |
| GET | `/provider/planning` | Mon planning (calendrier) |
| PUT | `/provider/availability` | Mettre à jour disponibilités |
| GET | `/provider/earnings` | Mes revenus |
| GET | `/provider/reviews` | Avis reçus |
| PUT | `/provider/profile` | Modifier profil prestataire |
| PUT | `/provider/online-status` | Toggle en ligne / hors ligne |

### GET /provider/dashboard — Response
```json
{
  "totalBookings": 127,
  "totalRevenue": 15240,
  "pendingRequests": 8,
  "averageRating": 4.8,
  "recentBookings": [...],
  "upcomingMissions": [...]
}
```

Error codes: `401`, `403`, `500`

---

## Summary: Endpoint Count by Feature

| Feature | Endpoints |
|---------|-----------|
| Auth | 8 |
| Users/Profile | 5 |
| Categories | 2 |
| Providers/Search | 9 |
| Bookings | 7 |
| Payments | 7 |
| Chat | 5 + WebSocket |
| Notifications | 6 |
| Support | 5 |
| Provider-side | 16 |
| **Total** | **70+** |
