import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/booking_status_step.dart';

class BookingStatusViewModel extends ChangeNotifier {
  BookingStatusStep _currentStep = BookingStatusStep.scheduled;

  BookingStatusStep get currentStep => _currentStep;

  // Mock data - will be replaced with API data
  final String bookingId = 'BK-2024-001';
  final String providerId = '1';

  String providerName(BuildContext context) {
    final lang = Localizations.localeOf(context).languageCode;
    return lang == 'ar' ? 'أحمد المنصوري' : 'Ahmed El Mansouri';
  }

  String providerCategory(BuildContext context) {
    final lang = Localizations.localeOf(context).languageCode;
    return lang == 'ar' ? 'سباك محترف' : lang == 'en' ? 'Expert Plumber' : 'Plombier Expert';
  }
  
  String getServiceName(BuildContext context) {
    final lang = Localizations.localeOf(context).languageCode;
    return lang == 'ar' ? 'إصلاح التسرب' : lang == 'en' ? 'Leak Repair' : 'Réparation de fuite';
  }
  
  String getDateLabel(BuildContext context) {
    final locale = Localizations.localeOf(context).languageCode;
    final date = DateTime(2024, 10, 25);
    return DateFormat.yMMMMEEEEd(locale).format(date);
  }

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
