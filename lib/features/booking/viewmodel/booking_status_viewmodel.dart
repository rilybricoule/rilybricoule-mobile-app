import 'package:flutter/foundation.dart';
import '../models/booking_status_step.dart';

class BookingStatusViewModel extends ChangeNotifier {
  BookingStatusStep _currentStep = BookingStatusStep.scheduled;

  BookingStatusStep get currentStep => _currentStep;

  // Mock data - will be replaced with API data
  final String bookingId = 'BK-2024-001';
  final String providerId = '1';
  final String providerName = 'Ahmed El Mansouri';
  final String providerCategory = 'Plombier Expert';
  final String serviceName = 'Réparation de fuite';
  final String dateLabel = 'Lundi 25 Octobre, 2023';
  final String timeLabel = '14:30 - 16:30';
  final String addressLabel = '69, avenue Abdelkrim Al Khattabi, Océan';
  final double totalPrice = 350.0;

  void updateStatus(BookingStatusStep newStep) {
    _currentStep = newStep;
    notifyListeners();
  }

  // Simulate status progression (for demo purposes)
  void simulateProgress() {
    final steps = BookingStatusStep.values;
    final currentIndex = steps.indexOf(_currentStep);
    if (currentIndex < steps.length - 1) {
      _currentStep = steps[currentIndex + 1];
      notifyListeners();
    }
  }
}
