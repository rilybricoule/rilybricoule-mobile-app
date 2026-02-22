enum NotificationType {
  bookingConfirmed,
  message,
  promotion,
  cancelled,
  system,
  referral,
  reminder,
}

class AppNotification {
  final String id;
  final String title;
  final String message;
  final NotificationType type;
  final DateTime createdAt;
  bool isRead;

  AppNotification({
    required this.id,
    required this.title,
    required this.message,
    required this.type,
    required this.createdAt,
    this.isRead = false,
  });
}