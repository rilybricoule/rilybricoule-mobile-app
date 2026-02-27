enum TrackingStatus {
  confirmed,
  enRoute,
  inProgress,
  completed,
  cancelled;

  String get label {
    switch (this) {
      case TrackingStatus.confirmed:
        return 'Confirmé';
      case TrackingStatus.enRoute:
        return 'En route';
      case TrackingStatus.inProgress:
        return 'En cours';
      case TrackingStatus.completed:
        return 'Terminé';
      case TrackingStatus.cancelled:
        return 'Annulé';
    }
  }
}
