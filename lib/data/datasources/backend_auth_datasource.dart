import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../../services/api/api_client.dart';
import '../models/auth_tokens.dart';
import '../models/backend_user.dart';
import '../../core/errors/exceptions.dart';

/// DataSource pour l'authentification backend (Spring Boot)
/// Gère les appels HTTP vers /auth/*
class BackendAuthDataSource {
  final ApiClient _apiClient;

  BackendAuthDataSource({ApiClient? apiClient})
      : _apiClient = apiClient ?? ApiClient();

  /// Envoyer le Firebase ID Token au backend
  /// POST /auth/firebase
  /// Body: { "idToken": "..." }
  /// Response: { "accessToken": "...", "refreshToken": "...", "expiresIn": 3600, "user": {...} }
  Future<Map<String, dynamic>> authenticateWithFirebase(String firebaseIdToken) async {
    try {
      debugPrint('BackendAuthDataSource: Sending Firebase ID Token to backend...');
      
      final response = await _apiClient.dio.post(
        '/auth/firebase',
        data: {'idToken': firebaseIdToken},
      );

      if (response.statusCode == 200) {
        debugPrint('BackendAuthDataSource: Backend auth successful');
        return response.data as Map<String, dynamic>;
      } else {
        throw AuthException('Backend auth failed: ${response.statusCode}');
      }
    } on DioException catch (e) {
      debugPrint('BackendAuthDataSource: DioException: ${e.message}');
      throw AuthException(_handleDioError(e));
    } catch (e) {
      debugPrint('BackendAuthDataSource: Error: $e');
      throw AuthException('Erreur backend: $e');
    }
  }

  /// Récupérer le profil utilisateur depuis le backend
  /// GET /auth/me
  /// Header: Authorization: Bearer <accessToken>
  Future<BackendUser> getMe() async {
    try {
      final response = await _apiClient.dio.get('/auth/me');
      
      if (response.statusCode == 200) {
        return BackendUser.fromJson(response.data as Map<String, dynamic>);
      } else {
        throw AuthException('Failed to get user profile: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw AuthException(_handleDioError(e));
    } catch (e) {
      throw AuthException('Erreur récupération profil: $e');
    }
  }

  /// Refresh le token JWT
  /// POST /auth/refresh
  /// Body: { "refreshToken": "..." }
  Future<AuthTokens> refreshToken(String refreshToken) async {
    try {
      final response = await _apiClient.dio.post(
        '/auth/refresh',
        data: {'refreshToken': refreshToken},
      );

      if (response.statusCode == 200) {
        return AuthTokens.fromJson(response.data as Map<String, dynamic>);
      } else {
        throw AuthException('Token refresh failed: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw AuthException(_handleDioError(e));
    } catch (e) {
      throw AuthException('Erreur refresh token: $e');
    }
  }

  /// Logout (optionnel, peut juste clear les tokens localement)
  /// POST /auth/logout
  Future<void> logout() async {
    try {
      await _apiClient.dio.post('/auth/logout');
    } catch (e) {
      // Ignorer les erreurs de logout
      debugPrint('BackendAuthDataSource: Logout error (ignored): $e');
    }
  }

  String _handleDioError(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return 'Timeout - Vérifiez votre connexion';
      case DioExceptionType.badResponse:
        final statusCode = e.response?.statusCode;
        if (statusCode == 401) return 'Non autorisé';
        if (statusCode == 403) return 'Accès refusé';
        if (statusCode == 404) return 'Endpoint introuvable';
        if (statusCode == 500) return 'Erreur serveur';
        return 'Erreur HTTP $statusCode';
      case DioExceptionType.cancel:
        return 'Requête annulée';
      case DioExceptionType.connectionError:
        return 'Erreur de connexion';
      default:
        return 'Erreur réseau: ${e.message}';
    }
  }
}
