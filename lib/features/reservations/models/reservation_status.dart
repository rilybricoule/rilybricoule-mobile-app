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
}
