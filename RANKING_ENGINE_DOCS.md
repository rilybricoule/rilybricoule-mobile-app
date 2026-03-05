# Provider Ranking Engine - Documentation

## 📋 RÉSUMÉ DE L'IMPLÉMENTATION

### ✅ PROBLÈMES RÉSOLUS

1. **Tri dispersé** → Centralisé dans `ProviderRankingEngine`
2. **Pas de scoring composite** → Score multi-critères (rating + distance + équité + disponibilité)
3. **Pas d'équité** → `activeJobsCount` ajouté avec pénalité pour prestataires surchargés
4. **Pas de subCategoryId** → Ajouté aux modèles (prêt pour backend)
5. **Map vs List incohérent** → Même engine utilisé partout

---

## 🏗️ ARCHITECTURE

### Fichiers créés
```
lib/core/
├── models/
│   ├── provider_filter.dart          # Critères de filtrage
│   ├── provider_sort_mode.dart       # Modes de tri
│   └── user_search_context.dart      # Contexte utilisateur (lat/lng, query)
└── services/
    └── provider_ranking_engine.dart  # Engine centralisé

test/core/services/
└── provider_ranking_engine_test.dart # Tests unitaires
```

### Fichiers modifiés
```
lib/features/home/
├── models/provider_model.dart        # + categoryId, subCategoryId, activeJobsCount, lastAssignedAt
├── providers/home_provider.dart      # Utilise ranking engine
└── view/home_view.dart               # Mock data avec activeJobsCount

lib/features/search/
├── models/provider_location.dart     # + categoryId, activeJobsCount
├── repository/providers_repository.dart # Mock data avec activeJobsCount
├── data/mock_search_repository.dart  # Mock data avec activeJobsCount
└── viewmodel/search_viewmodel.dart   # Utilise ranking engine
```

---

## 🎯 LOGIQUE DE RANKING

### 1. FILTRAGE (Hard Filters)
```dart
- categoryId: obligatoire si fourni
- subCategoryId: si fourni (futur)
- minRating: >= minRating
- maxDistanceKm: <= maxDistance
- availableNow: isAvailableNow == true
- minPrice / maxPrice: fourchette de prix
- query: recherche dans name + service
```

### 2. SCORING COMPOSITE (Best Match)
```dart
Score = 0.40 * ratingScore +
        0.30 * distanceScore +
        0.20 * fairnessScore +
        0.10 * availabilityScore

Où:
- ratingScore = rating / 5.0
- distanceScore = clamp(1 - (distanceKm / 50), 0, 1)
- fairnessScore = clamp(1 - (activeJobsCount / 10), 0, 1)
- availabilityScore = isAvailableNow ? 1.0 : 0.0
```

### 3. PÉNALITÉ ÉQUITÉ
```dart
if (activeJobsCount > 5) {
  score *= 0.7  // Pénalité 30%
}
```

### 4. TIE-BREAKER
Si scores proches (diff < 0.05):
1. Moins de `activeJobsCount` gagne
2. Si égal: `lastAssignedAt` le plus ancien gagne

---

## 📊 MODES DE TRI

| Mode | Description |
|------|-------------|
| `bestMatch` | Score composite (défaut) |
| `nearest` | Distance croissante |
| `bestRated` | Rating décroissant |
| `priceLowToHigh` | Prix croissant |
| `priceHighToLow` | Prix décroissant |
| `availableFirst` | Disponibles d'abord + distance |

---

## 🔧 UTILISATION

### Home Screen
```dart
final homeProvider = HomeProvider();
homeProvider.setProviders(mockProviders);
// Applique automatiquement bestMatch ranking
```

### Search Screen
```dart
final searchViewModel = SearchViewModel(repository);
await searchViewModel.search('plombier');
// Applique filtres + bestMatch ranking
```

### Avec filtres personnalisés
```dart
final engine = ProviderRankingEngine();
final ranked = engine.filterAndRank(
  providers: allProviders,
  context: UserSearchContext(
    latitude: 33.5731,
    longitude: -7.5898,
    query: 'plombier',
  ),
  filter: ProviderFilter(
    categoryId: '1',
    minRating: 4.5,
    maxDistanceKm: 10.0,
    availableNow: true,
  ),
  sortMode: ProviderSortMode.bestMatch,
);
```

---

## 🧪 TESTS UNITAIRES

### Couverture
- ✅ Filtrage par categoryId
- ✅ Filtrage par minRating
- ✅ Filtrage par maxDistanceKm
- ✅ Filtrage par availableNow
- ✅ Pénalité activeJobsCount élevé
- ✅ Tie-breaker sur activeJobsCount
- ✅ Tri par nearest
- ✅ Tri par bestRated
- ✅ Tri par priceLowToHigh

### Exécution
```bash
flutter test test/core/services/provider_ranking_engine_test.dart
```

---

## 🔮 BACKEND READY

### Modèles prêts
```dart
class ProviderModel {
  final String categoryId;        // ✅ Backend
  final String? subCategoryId;    // ✅ Backend (futur)
  final int activeJobsCount;      // ✅ Backend
  final DateTime? lastAssignedAt; // ✅ Backend (optionnel)
  final bool isAvailableNow;      // ✅ Backend
}
```

### API Backend attendue
```json
GET /providers?lat=33.5731&lng=-7.5898&categoryId=1

Response:
{
  "providers": [
    {
      "id": "1",
      "name": "Ahmed",
      "categoryId": "1",
      "subCategoryId": "1a",
      "rating": 4.9,
      "distanceKm": 1.2,
      "priceValue": 150.0,
      "isAvailableNow": true,
      "activeJobsCount": 2,
      "lastAssignedAt": "2024-01-15T10:30:00Z"
    }
  ]
}
```

---

## 📈 EXEMPLES DE RANKING

### Scénario 1: Équité prioritaire
```
Provider A: rating=4.9, distance=1km, activeJobs=8  → Score pénalisé
Provider B: rating=4.7, distance=2km, activeJobs=1  → Score meilleur
Résultat: B avant A
```

### Scénario 2: Disponibilité
```
Provider A: rating=4.9, available=false
Provider B: rating=4.7, available=true
Résultat: B avant A (si availableNow filter)
```

### Scénario 3: Distance
```
Provider A: rating=4.8, distance=0.5km
Provider B: rating=4.9, distance=5km
Résultat: A avant B (distance pèse 30%)
```

---

## ⚙️ CONFIGURATION

### Poids ajustables (dans ProviderRankingEngine)
```dart
static const double _ratingWeight = 0.40;      // 40%
static const double _distanceWeight = 0.30;    // 30%
static const double _fairnessWeight = 0.20;    // 20%
static const double _availabilityWeight = 0.10; // 10%
```

### Seuils
```dart
static const double _maxDistanceRef = 50.0;        // Distance max référence
static const int _fairnessMaxJobs = 10;            // Jobs max pour fairness
static const int _heavyLoadThreshold = 5;          // Seuil pénalité
static const double _heavyLoadPenalty = 0.7;       // Pénalité 30%
```

---

## ✅ CHECKLIST VALIDATION

- [x] Modèles mis à jour (categoryId, activeJobsCount, subCategoryId)
- [x] Engine centralisé créé
- [x] HomeProvider utilise engine
- [x] SearchViewModel utilise engine
- [x] Mock data avec activeJobsCount variés
- [x] Tests unitaires créés
- [x] Équité implémentée (pénalité + tie-breaker)
- [x] Prêt pour backend (modèles + API)
- [x] Documentation complète

---

## 🚀 PROCHAINES ÉTAPES

1. **Backend**: Implémenter endpoints avec activeJobsCount
2. **Distance dynamique**: Calculer avec Haversine côté client si lat/lng fournis
3. **Sous-catégories**: Ajouter UI pour sélection subCategoryId
4. **Analytics**: Logger les scores pour optimiser les poids
5. **A/B Testing**: Tester différents poids de scoring
