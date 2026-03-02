import 'dart:async';
import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/foundation.dart';
import '../../core/errors/exceptions.dart';

/// Handler pour les notifications en background
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  debugPrint('📩 Background message: ${message.messageId}');
}

/// Service Firebase Cloud Messaging
/// Gère les notifications push (foreground, background, terminated)
/// TODO: Remplacer par API /notifications quand backend disponible
class FCMService {
  static final FCMService _instance = FCMService._internal();
  factory FCMService() => _instance;
  FCMService._internal();

  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();

  String? _fcmToken;
  bool _initialized = false;

  final StreamController<RemoteMessage> _messageStreamController =
      StreamController<RemoteMessage>.broadcast();

  /// Stream des messages reçus
  Stream<RemoteMessage> get onMessage => _messageStreamController.stream;

  /// Token FCM actuel
  String? get token => _fcmToken;

  /// Initialiser FCM
  Future<void> initialize() async {
    if (_initialized) return;

    try {
      // Demander permissions
      await _requestPermissions();

      // Initialiser notifications locales
      await _initializeLocalNotifications();

      // Récupérer token
      _fcmToken = await _messaging.getToken();
      debugPrint('📱 FCM Token: $_fcmToken');

      // Écouter refresh token
      _messaging.onTokenRefresh.listen((newToken) {
        _fcmToken = newToken;
        debugPrint('🔄 FCM Token refreshed: $newToken');
        // TODO: Mettre à jour dans Firestore via repository
      });

      // Configurer handlers
      FirebaseMessaging.onMessage.listen(_handleForegroundMessage);
      FirebaseMessaging.onMessageOpenedApp.listen(_handleMessageOpenedApp);
      FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

      // Vérifier si l'app a été ouverte depuis une notification
      final initialMessage = await _messaging.getInitialMessage();
      if (initialMessage != null) {
        _handleMessageOpenedApp(initialMessage);
      }

      _initialized = true;
      debugPrint('✅ FCM initialized');
    } catch (e) {
      debugPrint('❌ FCM initialization failed: $e');
      throw NotificationException('Erreur initialisation FCM: $e');
    }
  }

  /// Demander permissions notifications
  Future<void> _requestPermissions() async {
    if (Platform.isIOS) {
      await _messaging.requestPermission(
        alert: true,
        badge: true,
        sound: true,
        provisional: false,
      );
    }

    if (Platform.isAndroid) {
      await _localNotifications
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.requestNotificationsPermission();
    }
  }

  /// Initialiser notifications locales
  Future<void> _initializeLocalNotifications() async {
    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const settings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _localNotifications.initialize(
      settings,
      onDidReceiveNotificationResponse: _onNotificationTapped,
    );
  }

  /// Handler message en foreground
  void _handleForegroundMessage(RemoteMessage message) {
    debugPrint('📩 Foreground message: ${message.notification?.title}');
    
    _messageStreamController.add(message);

    // Afficher notification locale
    if (message.notification != null) {
      _showLocalNotification(message);
    }
  }

  /// Handler message clicked (app en background)
  void _handleMessageOpenedApp(RemoteMessage message) {
    debugPrint('👆 Message opened: ${message.data}');
    _messageStreamController.add(message);
    _navigateFromNotification(message.data);
  }

  /// Callback notification locale tapped
  void _onNotificationTapped(NotificationResponse response) {
    debugPrint('👆 Local notification tapped: ${response.payload}');
    // Le payload contient les data de la notification
    // TODO: Parser et naviguer
  }

  /// Afficher notification locale (foreground)
  Future<void> _showLocalNotification(RemoteMessage message) async {
    final notification = message.notification;
    if (notification == null) return;

    const androidDetails = AndroidNotificationDetails(
      'rilybricoule_channel',
      'RilyBricoule Notifications',
      channelDescription: 'Notifications de l\'application RilyBricoule',
      importance: Importance.high,
      priority: Priority.high,
      icon: '@mipmap/ic_launcher',
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _localNotifications.show(
      notification.hashCode,
      notification.title,
      notification.body,
      details,
      payload: message.data.toString(),
    );
  }

  /// Navigation depuis notification
  void _navigateFromNotification(Map<String, dynamic> data) {
    final type = data['type'] as String?;
    
    switch (type) {
      case 'chat':
        final conversationId = data['conversationId'] as String?;
        if (conversationId != null) {
          // TODO: Navigator vers ChatThreadScreen
          debugPrint('Navigate to chat: $conversationId');
        }
        break;
      case 'booking':
        final bookingId = data['bookingId'] as String?;
        if (bookingId != null) {
          // TODO: Navigator vers ReservationDetailsView
          debugPrint('Navigate to booking: $bookingId');
        }
        break;
      case 'system':
        // TODO: Navigator vers NotificationsScreen
        debugPrint('Navigate to notifications');
        break;
      default:
        debugPrint('Unknown notification type: $type');
    }
  }

  /// S'abonner à un topic
  Future<void> subscribeToTopic(String topic) async {
    try {
      await _messaging.subscribeToTopic(topic);
      debugPrint('✅ Subscribed to topic: $topic');
    } catch (e) {
      debugPrint('❌ Failed to subscribe to topic: $e');
    }
  }

  /// Se désabonner d'un topic
  Future<void> unsubscribeFromTopic(String topic) async {
    try {
      await _messaging.unsubscribeFromTopic(topic);
      debugPrint('✅ Unsubscribed from topic: $topic');
    } catch (e) {
      debugPrint('❌ Failed to unsubscribe from topic: $e');
    }
  }

  void dispose() {
    _messageStreamController.close();
  }
}
