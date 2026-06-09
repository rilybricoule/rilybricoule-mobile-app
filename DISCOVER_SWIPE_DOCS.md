# Discover Swipe Feature - Documentation

## 📱 OVERVIEW

Mode découverte Tinder-like pour RiLyBricoule permettant aux utilisateurs de swiper les prestataires de manière ludique et engageante.

---

## ✅ FEATURES IMPLEMENTED

### 1. INTEGRATION DANS SEARCH
- ✅ Bouton CTA "Découvrir en swipe" visible uniquement si résultats > 0
- ✅ Design premium avec gradient et shadow
- ✅ Navigation avec SearchContextBundle (tous les filtres transmis)
- ✅ Position: sous search bar, au-dessus des toggles List/Map

### 2. SWIPE MECHANICS (Tinder-like)
- ✅ **Swipe Right** → LIKE (ajout aux favoris)
- ✅ **Swipe Left** → SKIP (masqué pour la session)
- ✅ **Swipe Up** → VIEW PROFILE (navigation vers profil)
- ✅ Haptic feedback sur chaque swipe
- ✅ 3 cartes visibles (stack avec scale + offset)
- ✅ Animations fluides (rotation + scale)

### 3. UI/UX PREMIUM
- ✅ AppBar avec back, titre "Découvrir", bouton reset
- ✅ Context chips (query, catégorie, distance, rating, disponibilité)
- ✅ Cartes prestataires premium:
  - Image cover avec gradient
  - Avatar + online dot si disponible
  - Verified badge
  - Rating + reviews + distance
  - Prix
  - Tags: "Disponible", "Top noté"
  - Bouton "Voir profil"
- ✅ Action buttons (Tinder-style):
  - ❌ Skip (rouge)
  - ℹ️ Info (bleu)
  - ❤️ Like (primary color)
- ✅ Empty state premium avec reset + retour

### 4. LOGIQUE MÉTIER
- ✅ **Source unique**: ProviderRankingEngine
- ✅ Même filtrage que Search (category, rating, distance, availability, price)
- ✅ Tri "Best Match" (score composite)
- ✅ Respect équité (activeJobsCount)
- ✅ Providers skippés exclus de la session
- ✅ Snackbar feedback sur like

### 5. BACKEND READY
- ✅ SwipeRepository interface
- ✅ MockSwipeRepository avec session storage
- ✅ TODO clairs pour API:
  - POST /api/favorites/{providerId}
  - POST /api/providers/{providerId}/skip
  - GET /api/favorites (liste)

---

## 📂 FILES CREATED

```
lib/features/discover_swipe/
├── view/
│   └── discover_swipe_view.dart          # Main swipe screen
├── viewmodel/
│   └── discover_swipe_viewmodel.dart     # State management + ranking engine
├── widgets/
│   ├── provider_swipe_card.dart          # Premium provider card
│   ├── swipe_action_buttons.dart         # Tinder-style buttons
│   └── swipe_overlay_label.dart          # LIKE/NOPE labels (unused but ready)
├── models/
│   ├── search_context_bundle.dart        # Search state transfer
│   └── swipe_decision.dart               # Enum for decisions
└── repository/
    ├── swipe_repository.dart             # Interface
    └── mock_swipe_repository.dart        # Mock implementation
```

### FILES MODIFIED
```
lib/features/search/view/search_view.dart
  + Import SearchContextBundle
  + _navigateToSwipe() method
  + CTA button in header

lib/core/routes/app_routes.dart
  + discoverSwipe route

lib/main.dart
  + Import DiscoverSwipeView + ViewModel + Repository
  + Provider registration
  + Route mapping
```

---

## 🎯 USAGE

### From Search Screen
```dart
// User clicks "Découvrir en swipe" button
// SearchView creates bundle with current filters
final bundle = SearchContextBundle(
  query: viewModel.currentQuery,
  categoryId: viewModel.categoryId,
  minRating: viewModel.minRating,
  maxDistanceKm: viewModel.maxDistance,
  availableNow: viewModel.availableNow,
  minPrice: viewModel.minPrice,
  maxPrice: viewModel.maxPrice,
);

Navigator.pushNamed(context, '/discover-swipe', arguments: bundle);
```

### Swipe Actions
```dart
// Right swipe → Like
viewModel.likeProvider(providerId);
// Shows snackbar: "Provider ajouté aux favoris"

// Left swipe → Skip
viewModel.skipProvider(providerId);
// Provider removed from current session

// Up swipe → View Profile
Navigator.pushNamed(context, '/provider-profile', arguments: providerId);
```

### Programmatic Swipe (via buttons)
```dart
SwipeActionButtons(
  onSkip: () => _swiperController.swipeLeft(),
  onLike: () => _swiperController.swipeRight(),
  onInfo: () => _viewProfile(currentProvider.id),
)
```

---

## 🔧 CONFIGURATION

### Swipe Thresholds (appinio_swiper)
```dart
swipeOptions: const SwipeOptions(
  horizontalSwipeThreshold: 0.3,  // 30% horizontal drag
  verticalSwipeThreshold: 0.6,    // 60% vertical drag
),
```

### Card Stack
```dart
backgroundCardCount: 2,           // 3 cards visible total
backgroundCardScale: 0.9,         // Next card 90% size
backgroundCardOffset: Offset(0, 10), // 10px down
```

---

## 🧪 TESTING

### Manual Test Scenarios

#### 1. Navigation from Search
- [ ] Search for "plombier"
- [ ] Apply filters (rating 4.5+, distance 10km)
- [ ] Click "Découvrir en swipe"
- [ ] Verify context chips show filters
- [ ] Verify providers match search results

#### 2. Swipe Mechanics
- [ ] Swipe right → snackbar "ajouté aux favoris"
- [ ] Swipe left → card disappears
- [ ] Swipe up → navigates to profile
- [ ] Verify haptic feedback on swipe

#### 3. Action Buttons
- [ ] Click ❌ → same as swipe left
- [ ] Click ❤️ → same as swipe right
- [ ] Click ℹ️ → opens current provider profile

#### 4. Empty State
- [ ] Swipe all cards
- [ ] Verify empty state shows
- [ ] Click "Réinitialiser" → reloads without filters
- [ ] Click "Retour" → goes back to search

#### 5. Session Persistence
- [ ] Skip provider A
- [ ] Go back to search
- [ ] Return to swipe
- [ ] Verify provider A not in stack

---

## 🚀 BACKEND INTEGRATION

### Endpoints Required

#### 1. Like Provider (Add to Favorites)
```http
POST /api/favorites/{providerId}
Authorization: Bearer {token}

Response 200:
{
  "success": true,
  "message": "Provider added to favorites"
}
```

#### 2. Skip Provider (Analytics)
```http
POST /api/providers/{providerId}/skip
Authorization: Bearer {token}

Request Body:
{
  "sessionId": "uuid",
  "timestamp": "2024-01-15T10:30:00Z"
}

Response 200:
{
  "success": true
}
```

#### 3. Get Favorites (Optional)
```http
GET /api/favorites
Authorization: Bearer {token}

Response 200:
{
  "favorites": [
    {
      "providerId": "1",
      "addedAt": "2024-01-15T10:30:00Z"
    }
  ]
}
```

### Implementation Steps
1. Replace MockSwipeRepository with ApiSwipeRepository
2. Inject Dio client
3. Add error handling (network, 401, 500)
4. Add retry logic for failed requests
5. Sync local favorites with backend on app start

---

## 📊 ANALYTICS EVENTS (TODO)

```dart
// Track swipe events
analytics.logEvent(
  name: 'provider_swiped',
  parameters: {
    'provider_id': providerId,
    'direction': 'right', // left, right, up
    'category': categoryId,
    'session_id': sessionId,
  },
);

// Track profile views from swipe
analytics.logEvent(
  name: 'profile_viewed_from_swipe',
  parameters: {
    'provider_id': providerId,
    'source': 'swipe_up', // or 'info_button'
  },
);
```

---

## 🎨 DESIGN TOKENS

### Colors
```dart
Primary: AppColors.mainAppPrimary
Like: AppColors.mainAppPrimary (green-ish)
Skip: Colors.red
Info: Colors.blue
Available: Colors.green
Verified: Colors.blue
```

### Spacing
```dart
Card padding: 24px
Button spacing: 24px
Chip spacing: 8px
Card border radius: 24px
Button border radius: 12px
```

### Typography
```dart
Provider name: 28px, bold
Service: 16px, regular
Rating: 16px, w600
Price: 18px, bold
Chips: 12px, w600
```

---

## ⚡ PERFORMANCE

### Optimizations
- ✅ Consumer selective (only rebuild swipe area)
- ✅ Const constructors where possible
- ✅ List.unmodifiable for exposed lists
- ✅ Lazy loading (cards built on demand)
- ✅ Image caching (Flutter default)

### Memory
- Cards removed from stack after swipe (not kept in memory)
- Session storage cleared on app restart
- Max 3 cards rendered at once

---

## 🐛 KNOWN LIMITATIONS

1. **No Undo**: Once swiped, cannot undo (can be added with undoLastDecision)
2. **Session Only**: Skipped providers reset on app restart
3. **No Offline**: Requires network for initial load
4. **No Filters in Swipe**: Must go back to search to change filters

---

## 🔮 FUTURE ENHANCEMENTS

1. **Undo Button**: Allow undo last swipe
2. **Super Like**: Swipe up for priority match
3. **Boost**: Pay to appear first in others' swipe
4. **Match Notification**: If provider also likes user
5. **Swipe Stats**: Show "X providers liked today"
6. **Filters in Swipe**: Bottom sheet to adjust filters without leaving
7. **Infinite Scroll**: Load more providers when stack empty
8. **Animations**: More elaborate card animations (bounce, spring)

---

## ✅ CHECKLIST

- [x] SearchContextBundle model
- [x] SwipeRepository interface
- [x] MockSwipeRepository implementation
- [x] DiscoverSwipeViewModel with ranking engine
- [x] ProviderSwipeCard premium UI
- [x] SwipeActionButtons Tinder-style
- [x] DiscoverSwipeView main screen
- [x] Integration in SearchView (CTA button)
- [x] Route registration
- [x] Provider registration
- [x] Haptic feedback
- [x] Empty state
- [x] Context chips
- [x] Snackbar feedback
- [x] Navigation to profile
- [x] Session skip filtering
- [x] Documentation

---

## 📞 SUPPORT

For questions or issues:
- Check RANKING_ENGINE_DOCS.md for ranking logic
- Check RANKING_AUDIT_FINAL.md for architecture
- Review appinio_swiper docs: https://pub.dev/packages/appinio_swiper
