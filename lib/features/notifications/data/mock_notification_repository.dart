import '../domain/notification_repository.dart';
import '../model/notification_model.dart';

class MockNotificationRepository implements NotificationRepository {
  final List<AppNotification> _notifications = [
    AppNotification(
      id: '1',
      title: 'Réservation confirmée',
      message: 'Votre réservation avec Yassine El Amrani est confirmée.',
      type: NotificationType.bookingConfirmed,
      createdAt: DateTime.now().subtract(const Duration(minutes: 2)),
      isRead: false,
    ),
    AppNotification(
      id: '2',
      title: 'Nouveau message',
      message: 'Yassine El Amrani : "Bonjour, je suis en route vers votre domicile..."',
      type: NotificationType.message,
      createdAt: DateTime.now().subtract(const Duration(minutes: 5)),
      isRead: false,
    ),
    AppNotification(
      id: '3',
      title: 'Promotion',
      message: 'Profitez de nos tarifs d\'été sur la plomberie et le jardinage.',
      type: NotificationType.promotion,
      createdAt: DateTime.now().subtract(const Duration(hours: 2)),
      isRead: true,
    ),
    AppNotification(
      id: '4',
      title: 'Réservation annulée',
      message: 'L\'intervention prévue à 14h a été annulée par le prestataire.',
      type: NotificationType.cancelled,
      createdAt: DateTime.now().subtract(const Duration(hours: 5)),
      isRead: true,
    ),
    AppNotification(
      id: '5',
      title: 'Offre spéciale -20%',
      message: 'C\'est votre jour de chance ! -20% sur votre prochaine commande avec le...',
      type: NotificationType.promotion,
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
      isRead: true,
    ),
    AppNotification(
      id: '6',
      title: 'Mise à jour du profil',
      message: 'Votre adresse a été mise à jour avec succès dans votre espace client.',
      type: NotificationType.system,
      createdAt: DateTime.now().subtract(const Duration(days: 2)),
      isRead: true,
    ),
    AppNotification(
      id: '7',
      title: 'Parrainage réussi',
      message: 'Félicitations ! Votre ami a rejoint RilyBricoule. Vous avez gagné 10€ de...',
      type: NotificationType.referral,
      createdAt: DateTime.now().subtract(const Duration(days: 7)),
      isRead: true,
    ),
    AppNotification(
      id: '8',
      title: 'Rappel d\'intervention',
      message: 'N\'oubliez pas votre rendez-vous de demain à 09h00 pour la pose de...',
      type: NotificationType.reminder,
      createdAt: DateTime.now().subtract(const Duration(days: 7)),
      isRead: true,
    ),
  ];

  @override
  Future<List<AppNotification>> getNotifications() async {
    await Future.delayed(const Duration(milliseconds: 800));
    return List.from(_notifications);
  }

  @override
  Future<void> markAllAsRead() async {
    await Future.delayed(const Duration(milliseconds: 300));
    for (var notification in _notifications) {
      notification.isRead = true;
    }
  }

  @override
  Future<void> markAsRead(String id) async {
    await Future.delayed(const Duration(milliseconds: 200));
    final notification = _notifications.firstWhere((n) => n.id == id);
    notification.isRead = true;
  }

  @override
  Future<void> deleteNotification(String id) async {
    await Future.delayed(const Duration(milliseconds: 300));
    _notifications.removeWhere((n) => n.id == id);
  }

  @override
  Future<void> deleteAllNotifications() async {
    await Future.delayed(const Duration(milliseconds: 400));
    _notifications.clear();
  }
}