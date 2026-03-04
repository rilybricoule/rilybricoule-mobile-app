import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../data/models/auth_tokens.dart';

/// Service de stockage sécurisé des tokens JWT
/// Utilise flutter_secure_storage (Keychain iOS / Keystore Android)
class TokenStorage {
  static final TokenStorage _instance = TokenStorage._internal();
  factory TokenStorage() => _instance;
  TokenStorage._internal();

  final _storage = const FlutterSecureStorage();

  static const String _keyTokens = 'auth_tokens';
  static const String _keyUserId = 'user_id';

  /// Sauvegarder les tokens
  Future<void> saveTokens(AuthTokens tokens) async {
    await _storage.write(
      key: _keyTokens,
      value: jsonEncode(tokens.toJson()),
    );
  }

  /// Récupérer les tokens
  Future<AuthTokens?> getTokens() async {
    final tokensJson = await _storage.read(key: _keyTokens);
    if (tokensJson == null) return null;
    
    try {
      final map = jsonDecode(tokensJson) as Map<String, dynamic>;
      return AuthTokens.fromJson(map);
    } catch (e) {
      return null;
    }
  }

  /// Sauvegarder l'ID utilisateur
  Future<void> saveUserId(String userId) async {
    await _storage.write(key: _keyUserId, value: userId);
  }

  /// Récupérer l'ID utilisateur
  Future<String?> getUserId() async {
    return await _storage.read(key: _keyUserId);
  }

  /// Supprimer tous les tokens (logout)
  Future<void> clearAll() async {
    await _storage.delete(key: _keyTokens);
    await _storage.delete(key: _keyUserId);
  }

  /// Vérifier si des tokens existent
  Future<bool> hasTokens() async {
    final tokens = await getTokens();
    return tokens != null;
  }

  /// Vérifier si les tokens sont valides (non expirés)
  Future<bool> hasValidTokens() async {
    final tokens = await getTokens();
    if (tokens == null) return false;
    return !tokens.isExpired;
  }
}
