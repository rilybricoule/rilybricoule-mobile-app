enum BookingStatusStep {
  accepted,
  scheduled,
  onTheWay,
  arrived,
  completed;

  String get label {
    switch (this) {
      case BookingStatusStep.accepted:
        return 'Accepté';
      case BookingStatusStep.scheduled:
        return 'Planifié';
      case BookingStatusStep.onTheWay:
        return 'En route';
      case BookingStatusStep.arrived:
        return 'Arrivé';
      case BookingStatusStep.completed:
        return 'Terminé';
    }
  }
}
