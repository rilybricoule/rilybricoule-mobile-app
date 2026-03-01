import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';

class PrestataireMockData {
  static const String providerName = 'Yassine El Amrani';
  static const String providerCategory = 'Plumbing & Repair';
  static const double rating = 4.8;
  static const int totalBookings = 127;
  static const String totalRevenue = '15,240';

  static const List<Map<String, dynamic>> services = [
    {
      'id': 's1',
      'name': 'Leak Repair',
      'price': '150 MAD',
      'category': 'Plumbing',
      'description': 'Typical leak repair for faucets, pipes, and toilets.',
    },
    {
      'id': 's2',
      'name': 'Electrical Maintenance',
      'price': '200 MAD',
      'category': 'Electricity',
      'description': 'General electrical maintenance and troubleshooting.',
    },
  ];

  static const List<Map<String, dynamic>> recentBookings = [
    {
      'id': 'b1',
      'clientName': 'Sarah Benjelloun',
      'service': 'Plumbing - Repair',
      'date': 'Today • 14:00',
      'statusLabel': 'Pending',
      'statusColor': AppColors.warning,
    },
    {
      'id': 'b2',
      'clientName': 'Omar Mansouri',
      'service': 'Electricity',
      'date': 'Tomorrow • 10:30',
      'statusLabel': 'Confirmed',
      'statusColor': AppColors.success,
    },
  ];

  static const List<Map<String, dynamic>> conversations = [
    {
      'id': 'c1',
      'clientName': 'Sarah Benjelloun',
      'lastMessage': 'Thank you for your help!',
      'timeLabel': '2 min',
      'unreadCount': 2,
    },
    {
      'id': 'c2',
      'clientName': 'Omar Mansouri',
      'lastMessage': 'Can you come earlier?',
      'timeLabel': '1 h',
      'unreadCount': 0,
    },
  ];

  static final Map<String, List<Map<String, dynamic>>> messagesByConversation = {
    'conv_1': [
      {
        'id': 'msg_1',
        'senderId': 'client_1',
        'senderName': 'Sarah Benjelloun',
        'content': 'Bonjour! J\'ai réservé pour demain à 14h.',
        'timestamp': DateTime.now().subtract(Duration(hours: 2)).toIso8601String(),
        'isFromProvider': false,
      },
      {
        'id': 'msg_2',
        'senderId': 'provider_1',
        'senderName': 'Yassine El Amrani',
        'content': 'Bonjour Sarah! Oui, c\'est bien confirmé. À demain!',
        'timestamp': DateTime.now().subtract(Duration(hours: 2, minutes: 2)).toIso8601String(),
        'isFromProvider': true,
      },
      {
        'id': 'msg_3',
        'senderId': 'client_1',
        'senderName': 'Sarah Benjelloun',
        'content': 'Pouvez-vous arriver 30 minutes plus tôt?',
        'timestamp': DateTime.now().subtract(Duration(hours: 1)).toIso8601String(),
        'isFromProvider': false,
      },
      {
        'id': 'msg_4',
        'senderId': 'provider_1',
        'senderName': 'Yassine El Amrani',
        'content': 'Malheureusement non, j\'ai un rendez-vous avant. Mais je serai ponctuel à 14h!',
        'timestamp': DateTime.now().subtract(Duration(hours: 1, minutes: 5)).toIso8601String(),
        'isFromProvider': true,
      },
      {
        'id': 'msg_5',
        'senderId': 'client_1',
        'senderName': 'Sarah Benjelloun',
        'content': 'Merci, à demain! 👍',
        'timestamp': DateTime.now().subtract(Duration(minutes: 30)).toIso8601String(),
        'isFromProvider': false,
      },
    ],
    'conv_2': [
      {
        'id': 'msg_6',
        'senderId': 'client_2',
        'senderName': 'Omar Mansouri',
        'content': 'Bonjour, la réparation est terminée?',
        'timestamp': DateTime.now().subtract(Duration(days: 1, hours: 2)).toIso8601String(),
        'isFromProvider': false,
      },
      {
        'id': 'msg_7',
        'senderId': 'provider_1',
        'senderName': 'Yassine El Amrani',
        'content': 'Oui, tout est réparé. Merci!',
        'timestamp': DateTime.now().subtract(Duration(days: 1, hours: 1)).toIso8601String(),
        'isFromProvider': true,
      },
      {
        'id': 'msg_8',
        'senderId': 'client_2',
        'senderName': 'Omar Mansouri',
        'content': 'Parfait, merci!',
        'timestamp': DateTime.now().subtract(Duration(days: 1)).toIso8601String(),
        'isFromProvider': false,
      },
    ],
    'conv_3': [
      {
        'id': 'msg_9',
        'senderId': 'client_3',
        'senderName': 'Ahmed El Mamouni',
        'content': 'Bonjour, j\'ai une fuite urgente.',
        'timestamp': DateTime.now().subtract(Duration(days: 3, hours: 5)).toIso8601String(),
        'isFromProvider': false,
      },
      {
        'id': 'msg_10',
        'senderId': 'provider_1',
        'senderName': 'Yassine El Amrani',
        'content': 'Je peux venir aujourd\'hui à 15h?',
        'timestamp': DateTime.now().subtract(Duration(days: 3, hours: 4)).toIso8601String(),
        'isFromProvider': true,
      },
      {
        'id': 'msg_11',
        'senderId': 'client_3',
        'senderName': 'Ahmed El Mamouni',
        'content': 'D\'accord.',
        'timestamp': DateTime.now().subtract(Duration(days: 3, hours: 3)).toIso8601String(),
        'isFromProvider': false,
      },
    ],
  };


}
