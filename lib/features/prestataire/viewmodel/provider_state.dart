import 'package:flutter/material.dart';

class ProviderState extends ChangeNotifier {
  bool _isOnline = true;
  int _notificationCount = 2;

  bool get isOnline => _isOnline;
  int get notificationCount => _notificationCount;

  void toggleOnline() {
    _isOnline = !_isOnline;
    notifyListeners();
  }

  void markNotificationsRead() {
    _notificationCount = 0;
    notifyListeners();
  }
}