import '../model/notification_model.dart';

abstract class NotificationRepository {
  Future<List<AppNotification>> getNotifications();
  Future<void> markAllAsRead();
  Future<void> markAsRead(String id);
  Future<void> deleteNotification(String id);
  Future<void> deleteAllNotifications();
}