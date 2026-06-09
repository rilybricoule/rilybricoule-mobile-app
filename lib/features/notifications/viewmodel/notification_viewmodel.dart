import 'package:flutter/material.dart';
import '../domain/notification_repository.dart';
import '../model/notification_model.dart';

class NotificationViewModel extends ChangeNotifier {
  final NotificationRepository _repository;
  bool _disposed = false;

  NotificationViewModel(this._repository);

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }

  @override
  void notifyListeners() {
    if (!_disposed) {
      super.notifyListeners();
    }
  }

  List<AppNotification> _notifications = [];
  List<AppNotification> get notifications => _notifications;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _hasError = false;
  bool get hasError => _hasError;

  Future<void> loadNotifications([BuildContext? context]) async {
    _isLoading = true;
    _hasError = false;
    notifyListeners();

    try {
      String? langCode;
      if (context != null) {
        langCode = Localizations.localeOf(context).languageCode;
      }
      _notifications = await _repository.getNotifications(langCode);
    } catch (e) {
      _hasError = true;
      _notifications = [];
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> markAllAsRead() async {
    try {
      await _repository.markAllAsRead();
      for (var notification in _notifications) {
        notification.isRead = true;
      }
      notifyListeners();
    } catch (e) {
      _hasError = true;
      notifyListeners();
    }
  }

  Future<void> markAsRead(String id) async {
    try {
      await _repository.markAsRead(id);
      final notification = _notifications.firstWhere((n) => n.id == id);
      notification.isRead = true;
      notifyListeners();
    } catch (e) {
      _hasError = true;
      notifyListeners();
    }
  }

  Future<void> deleteNotification(String id) async {
    try {
      await _repository.deleteNotification(id);
      _notifications.removeWhere((n) => n.id == id);
      notifyListeners();
    } catch (e) {
      _hasError = true;
      notifyListeners();
    }
  }

  Future<void> deleteAllNotifications() async {
    try {
      await _repository.deleteAllNotifications();
      _notifications.clear();
      notifyListeners();
    } catch (e) {
      _hasError = true;
      notifyListeners();
    }
  }
}