import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';

/// Service d'initialisation Firebase
/// Gère l'initialisation de tous les services Firebase
class FirebaseService {
  static Future<void> initialize() async {
    try {
      // Initialiser Firebase
      await Firebase.initializeApp(
        // TODO: Ajouter les options Firebase depuis firebase_options.dart
        // options: DefaultFirebaseOptions.currentPlatform,
      );

      // Configurer Crashlytics
      if (!kDebugMode) {
        FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
        
        PlatformDispatcher.instance.onError = (error, stack) {
          FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
          return true;
        };
      }

      debugPrint('✅ Firebase initialized successfully');
    } catch (e) {
      debugPrint('❌ Firebase initialization failed: $e');
      rethrow;
    }
  }

  /// Définir l'utilisateur actuel pour Crashlytics
  static Future<void> setUserIdentifier(String uid, String? role) async {
    if (!kDebugMode) {
      await FirebaseCrashlytics.instance.setUserIdentifier(uid);
      if (role != null) {
        await FirebaseCrashlytics.instance.setCustomKey('user_role', role);
      }
    }
  }

  /// Logger une erreur non-fatale
  static Future<void> logError(dynamic error, StackTrace? stackTrace, {String? reason}) async {
    if (!kDebugMode) {
      await FirebaseCrashlytics.instance.recordError(
        error,
        stackTrace,
        reason: reason,
        fatal: false,
      );
    }
    debugPrint('Error logged: $error');
  }

  /// Ajouter un breadcrumb
  static Future<void> log(String message) async {
    if (!kDebugMode) {
      await FirebaseCrashlytics.instance.log(message);
    }
    debugPrint('Breadcrumb: $message');
  }
}
