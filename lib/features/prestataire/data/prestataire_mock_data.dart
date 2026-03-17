import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';

class PrestataireMockData {
  static const String providerName = 'Yassine El Amrani';
  static const String providerCategory = 'Plumbing & Repair';
  static const double rating = 4.8;
  static const int totalBookings = 127;
  static const String totalRevenue = '15,240';

  static List<Map<String, dynamic>> getServices(BuildContext context) {
    final lang = Localizations.localeOf(context).languageCode;
    return [
      {
        'id': 's1',
        'name': lang == 'en' ? 'Leak Repair' : lang == 'ar' ? 'إصلاح تسرب المياه' : 'Réparation fuite',
        'price': '150 MAD/hr',
        'category': lang == 'en' ? 'Plumbing' : lang == 'ar' ? 'سباكة' : 'Plomberie',
        'description': lang == 'en' ? 'Typical leak repair for faucets, pipes, and toilets.' 
                     : lang == 'ar' ? 'إصلاح تسرب المياه في الصنابير والأنابيب والمراحيض.' 
                     : 'Réparation classique de fuite pour robinets, tuyaux et toilettes.',
      },
      {
        'id': 's2',
        'name': lang == 'en' ? 'Electrical Maintenance' : lang == 'ar' ? 'صيانة كهربائية' : 'Maintenance Électrique',
        'price': '200 MAD/hr',
        'category': lang == 'en' ? 'Electricity' : lang == 'ar' ? 'كهرباء' : 'Électricité',
        'description': lang == 'en' ? 'General electrical maintenance and troubleshooting.' 
                     : lang == 'ar' ? 'صيانة وإصلاح أعطال كهربائية عامة.' 
                     : 'Maintenance et dépannage électrique général.',
      },
    ];
  }

  static List<Map<String, dynamic>> getRecentBookings(BuildContext context) {
    final lang = Localizations.localeOf(context).languageCode;
    return [
      {
        'id': 'b1',
        'clientName': lang == 'ar' ? 'سارة بنجلون' : 'Sarah Benjelloun',
        'service': lang == 'en' ? 'Plumbing - Repair' : lang == 'ar' ? 'سباكة - إصلاح' : 'Plomberie - Réparation',
        'date': lang == 'en' ? 'Today • 14:00' : lang == 'ar' ? 'اليوم • 14:00' : 'Aujourd\'hui • 14:00',
        'statusLabel': lang == 'en' ? 'Pending' : lang == 'ar' ? 'قيد الانتظار' : 'En attente',
        'statusColor': AppColors.warning,
      },
      {
        'id': 'b2',
        'clientName': lang == 'ar' ? 'عمر المنصوري' : 'Omar Mansouri',
        'service': lang == 'en' ? 'Electricity' : lang == 'ar' ? 'كهرباء' : 'Électricité',
        'date': lang == 'en' ? 'Tomorrow • 10:30' : lang == 'ar' ? 'غداً • 10:30' : 'Demain • 10:30',
        'statusLabel': lang == 'en' ? 'Confirmed' : lang == 'ar' ? 'مؤكد' : 'Confirmé',
        'statusColor': AppColors.success,
      },
    ];
  }

  static List<Map<String, dynamic>> getConversations(BuildContext context) {
    final lang = Localizations.localeOf(context).languageCode;
    return [
      {
        'id': 'c1',
        'clientName': lang == 'ar' ? 'سارة بنجلون' : 'Sarah Benjelloun',
        'lastMessage': lang == 'en' ? 'Thank you for your help!' : lang == 'ar' ? 'شكراً لمساعدتك!' : 'Merci pour votre aide !',
        'timeLabel': lang == 'en' ? '2 min' : lang == 'ar' ? 'دقيقتان' : '2 min',
        'unreadCount': 2,
      },
      {
        'id': 'c2',
        'clientName': lang == 'ar' ? 'عمر المنصوري' : 'Omar Mansouri',
        'lastMessage': lang == 'en' ? 'Can you come earlier?' : lang == 'ar' ? 'هل يمكنك المجيء مبكراً؟' : 'Pouvez-vous venir plus tôt ?',
        'timeLabel': lang == 'en' ? '1 h' : lang == 'ar' ? 'ساعة' : '1 h',
        'unreadCount': 0,
      },
    ];
  }

  static  Map<String, List<Map<String, dynamic>>> getMessagesByConversation(BuildContext context) {
    final lang = Localizations.localeOf(context).languageCode;
    return {
    'conv_1': [
      {
        'id': 'msg_1',
        'senderId': 'client_1',
        'senderName': lang == 'ar' ? 'سارة بنجلون' : 'Sarah Benjelloun',
        'content': lang == 'en' ? 'Hello! I booked for tomorrow at 14:00.' 
                 : lang == 'ar' ? 'مرحباً! لقد حجزت لغد الساعة 14:00.' 
                 : 'Bonjour! J\'ai réservé pour demain à 14h.',
        'timestamp': DateTime.now().subtract(Duration(hours: 2)).toIso8601String(),
        'isFromProvider': false,
      },
      {
        'id': 'msg_2',
        'senderId': 'provider_1',
        'senderName': lang == 'ar' ? 'ياسين العمراني' : 'Yassine El Amrani',
        'content': lang == 'en' ? 'Hello Sarah! Yes, it is confirmed. See you tomorrow!' 
                 : lang == 'ar' ? 'مرحباً سارة! نعم، تم تأكيده. أراك غداً!' 
                 : 'Bonjour Sarah! Oui, c\'est bien confirmé. À demain!',
        'timestamp': DateTime.now().subtract(Duration(hours: 2, minutes: 2)).toIso8601String(),
        'isFromProvider': true,
      },
      {
        'id': 'msg_3',
        'senderId': 'client_1',
        'senderName': lang == 'ar' ? 'سارة بنجلون' : 'Sarah Benjelloun',
        'content': lang == 'en' ? 'Can you arrive 30 minutes earlier?' 
                 : lang == 'ar' ? 'هل يمكنك الوصول قبل 30 دقيقة؟' 
                 : 'Pouvez-vous arriver 30 minutes plus tôt?',
        'timestamp': DateTime.now().subtract(Duration(hours: 1)).toIso8601String(),
        'isFromProvider': false,
      },
      {
        'id': 'msg_4',
        'senderId': 'provider_1',
        'senderName': lang == 'ar' ? 'ياسين العمراني' : 'Yassine El Amrani',
        'content': lang == 'en' ? 'Unfortunately no, I have an appointment before. But I will be punctual at 14:00!' 
                 : lang == 'ar' ? 'للأسف لا، لدي موعد قبل ذلك. لكني سأكون دقيقاً في موعدي الساعة 14:00!' 
                 : 'Malheureusement non, j\'ai un rendez-vous avant. Mais je serai ponctuel à 14h!',
        'timestamp': DateTime.now().subtract(Duration(hours: 1, minutes: 5)).toIso8601String(),
        'isFromProvider': true,
      },
      {
        'id': 'msg_5',
        'senderId': 'client_1',
        'senderName': lang == 'ar' ? 'سارة بنجلون' : 'Sarah Benjelloun',
        'content': lang == 'en' ? 'Thank you, see you tomorrow! 👍' 
                 : lang == 'ar' ? 'شكراً، أراك غداً! 👍' 
                 : 'Merci, à demain! 👍',
        'timestamp': DateTime.now().subtract(Duration(minutes: 30)).toIso8601String(),
        'isFromProvider': false,
      },
    ],
    'conv_2': [
      {
        'id': 'msg_6',
        'senderId': 'client_2',
        'senderName': lang == 'ar' ? 'عمر المنصوري' : 'Omar Mansouri',
        'content': lang == 'en' ? 'Hello, is the repair finished?' 
                 : lang == 'ar' ? 'مرحباً، هل انتهى الإصلاح؟' 
                 : 'Bonjour, la réparation est terminée?',
        'timestamp': DateTime.now().subtract(Duration(days: 1, hours: 2)).toIso8601String(),
        'isFromProvider': false,
      },
      {
        'id': 'msg_7',
        'senderId': 'provider_1',
        'senderName': lang == 'ar' ? 'ياسين العمراني' : 'Yassine El Amrani',
        'content': lang == 'en' ? 'Yes, everything is repaired. Thank you!' 
                 : lang == 'ar' ? 'نعم، تم إصلاح كل شيء. شكراً لك!' 
                 : 'Oui, tout est réparé. Merci!',
        'timestamp': DateTime.now().subtract(Duration(days: 1, hours: 1)).toIso8601String(),
        'isFromProvider': true,
      },
      {
        'id': 'msg_8',
        'senderId': 'client_2',
        'senderName': lang == 'ar' ? 'عمر المنصوري' : 'Omar Mansouri',
        'content': lang == 'en' ? 'Perfect, thanks!' 
                 : lang == 'ar' ? 'ممتاز، شكراً!' 
                 : 'Parfait, merci!',
        'timestamp': DateTime.now().subtract(Duration(days: 1)).toIso8601String(),
        'isFromProvider': false,
      },
    ],
    'conv_3': [
      {
        'id': 'msg_9',
        'senderId': 'client_3',
        'senderName': lang == 'ar' ? 'أحمد الماموني' : 'Ahmed El Mamouni',
        'content': lang == 'en' ? 'Hello, I have an urgent leak.' 
                 : lang == 'ar' ? 'مرحباً، لدي تسرب مياه طارئ.' 
                 : 'Bonjour, j\'ai une fuite urgente.',
        'timestamp': DateTime.now().subtract(Duration(days: 3, hours: 5)).toIso8601String(),
        'isFromProvider': false,
      },
      {
        'id': 'msg_10',
        'senderId': 'provider_1',
        'senderName': lang == 'ar' ? 'ياسين العمراني' : 'Yassine El Amrani',
        'content': lang == 'en' ? 'Can I come today at 15:00?' 
                 : lang == 'ar' ? 'هل يمكنني الحضور اليوم الساعة 15:00؟' 
                 : 'Je peux venir aujourd\'hui à 15h?',
        'timestamp': DateTime.now().subtract(Duration(days: 3, hours: 4)).toIso8601String(),
        'isFromProvider': true,
      },
      {
        'id': 'msg_11',
        'senderId': 'client_3',
        'senderName': lang == 'ar' ? 'أحمد الماموني' : 'Ahmed El Mamouni',
        'content': lang == 'en' ? 'Okay.' 
                 : lang == 'ar' ? 'حسناً.' 
                 : 'D\'accord.',
        'timestamp': DateTime.now().subtract(Duration(days: 3, hours: 3)).toIso8601String(),
        'isFromProvider': false,
      },
    ],
  };
  }
}
