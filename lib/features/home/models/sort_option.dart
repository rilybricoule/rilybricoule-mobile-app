enum SortOption {
  bestRated,
  priceLowToHigh,
  priceHighToLow,
  nearest,
  availableNow,
}

extension SortOptionExtension on SortOption {
  String get displayName {
    switch (this) {
      case SortOption.bestRated:
        return 'Mieux notés';
      case SortOption.priceLowToHigh:
        return 'Prix croissant';
      case SortOption.priceHighToLow:
        return 'Prix décroissant';
      case SortOption.nearest:
        return 'Distance la plus proche';
      case SortOption.availableNow:
        return 'Disponibles maintenant';
    }
  }

  String get icon {
    switch (this) {
      case SortOption.bestRated:
        return '⭐';
      case SortOption.priceLowToHigh:
        return '💰';
      case SortOption.priceHighToLow:
        return '💰';
      case SortOption.nearest:
        return '📍';
      case SortOption.availableNow:
        return '🔥';
    }
  }
}