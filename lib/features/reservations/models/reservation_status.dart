import 'package:flutter/material.dart';
import '../../../l10n/app_localizations.dart';

enum ReservationStatus {
  upcoming,
  ongoing,
  completed,
  cancelled;

  String get label {
    switch (this) {
      case ReservationStatus.upcoming:
        return 'À venir';
      case ReservationStatus.ongoing:
        return 'En cours';
      case ReservationStatus.completed:
        return 'Terminée';
      case ReservationStatus.cancelled:
        return 'Annulée';
    }
  }

  String get tabLabel {
    switch (this) {
      case ReservationStatus.upcoming:
        return 'À venir';
      case ReservationStatus.ongoing:
        return 'En cours';
      case ReservationStatus.completed:
        return 'Terminées';
      case ReservationStatus.cancelled:
        return 'Annulées';
    }
  }
  String getLocalizedLabel(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    switch (this) {
      case ReservationStatus.upcoming:
        return l10n.statusUpcoming;
      case ReservationStatus.ongoing:
        return l10n.statusOngoing;
      case ReservationStatus.completed:
        return l10n.statusCompleted;
      case ReservationStatus.cancelled:
        return l10n.statusCancelled;
    }
  }

  String getLocalizedTabLabel(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    switch (this) {
      case ReservationStatus.upcoming:
        return l10n.tabUpcoming;
      case ReservationStatus.ongoing:
        return l10n.tabOngoing;
      case ReservationStatus.completed:
        return l10n.tabCompleted;
      case ReservationStatus.cancelled:
        return l10n.tabCancelled;
    }
  }
}
