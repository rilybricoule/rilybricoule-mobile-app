import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/foundation.dart';

/// Service Remote Config pour les feature flags
/// Permet d'activer/désactiver des fonctionnalités sans mise à jour de l'app
class RemoteConfigService {
  static final RemoteConfigService _instance = RemoteConfigService._internal();
  factory RemoteConfigService() => _instance;
  RemoteConfigService._internal();

  late FirebaseRemoteConfig _remoteConfig;
  bool _initialized = false;

  /// Initialiser Remote Config avec valeurs par défaut
  Future<void> initialize() async {
    if (_initialized) return;

    try {
      _remoteConfig = FirebaseRemoteConfig.instance;

      // Configuration
      await _remoteConfig.setConfigSettings(
        RemoteConfigSettings(
          fetchTimeout: const Duration(seconds: 10),
          minimumFetchInterval: kDebugMode 
              ? const Duration(minutes: 1) // Dev: 1 min
              : const Duration(hours: 1),  // Prod: 1 heure
        ),
      );

      // Valeurs par défaut
      await _remoteConfig.setDefaults({
        'feature_map_view_enabled': true,
        'feature_new_checkout_enabled': false,
        'feature_chat_enabled': true,
        'feature_apple_pay_enabled': false,
        'min_app_version': '1.0.0',
      });

      // Fetch et activer
      await _remoteConfig.fetchAndActivate();
      _initialized = true;

      debugPrint('✅ Remote Config initialized');
    } catch (e) {
      debugPrint('❌ Remote Config initialization failed: $e');
      // Ne pas bloquer l'app, utiliser les valeurs par défaut
    }
  }

  /// Feature: Vue carte activée
  bool get isMapViewEnabled => _getBool('feature_map_view_enabled');

  /// Feature: Nouveau checkout activé
  bool get isNewCheckoutEnabled => _getBool('feature_new_checkout_enabled');

  /// Feature: Chat activé
  bool get isChatEnabled => _getBool('feature_chat_enabled');

  /// Feature: Apple Pay activé
  bool get isApplePayEnabled => _getBool('feature_apple_pay_enabled');

  /// Version minimale requise
  String get minAppVersion => _getString('min_app_version');

  // Helpers
  bool _getBool(String key) {
    try {
      return _remoteConfig.getBool(key);
    } catch (e) {
      debugPrint('Error getting bool for $key: $e');
      return false;
    }
  }

  String _getString(String key) {
    try {
      return _remoteConfig.getString(key);
    } catch (e) {
      debugPrint('Error getting string for $key: $e');
      return '';
    }
  }

  int _getInt(String key) {
    try {
      return _remoteConfig.getInt(key);
    } catch (e) {
      debugPrint('Error getting int for $key: $e');
      return 0;
    }
  }

  /// Forcer un refresh (pour debug)
  Future<void> refresh() async {
    try {
      await _remoteConfig.fetchAndActivate();
      debugPrint('✅ Remote Config refreshed');
    } catch (e) {
      debugPrint('❌ Remote Config refresh failed: $e');
    }
  }
}
