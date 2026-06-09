import 'package:flutter/widgets.dart';
import 'package:rilybricoule_mobile_app/l10n/app_localizations.dart';

enum SortOption {
  bestRated,
  priceLowToHigh,
  priceHighToLow,
  nearest,
  availableNow,
}

extension SortOptionExtension on SortOption {
  String getDisplayName(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    switch (this) {
      case SortOption.bestRated:
        return l10n.sortBestRated;
      case SortOption.priceLowToHigh:
        return l10n.sortPriceLowToHigh;
      case SortOption.priceHighToLow:
        return l10n.sortPriceHighToLow;
      case SortOption.nearest:
        return l10n.sortNearest;
      case SortOption.availableNow:
        return l10n.sortAvailableNow;
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