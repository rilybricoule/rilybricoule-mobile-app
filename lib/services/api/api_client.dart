import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../../core/config/app_config.dart';
import '../../data/models/auth_tokens.dart';
import '../storage/token_storage.dart';

/// Client API avec Dio + intercepteurs pour JWT
class ApiClient {
  static final ApiClient _instance = ApiClient._internal();
  factory ApiClient() => _instance;
  ApiClient._internal();

  late final Dio _dio;
  final _tokenStorage = TokenStorage();

  Dio get dio => _dio;

  void initialize() {
    _dio = Dio(
      BaseOptions(
        baseUrl: AppConfig.BACKEND_BASE_URL,
        connectTimeout: Duration(seconds: AppConfig.HTTP_TIMEOUT),
        receiveTimeout: Duration(seconds: AppConfig.HTTP_TIMEOUT),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    // Intercepteur pour ajouter le token JWT
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          // Ne pas ajouter token pour /auth/firebase et /auth/refresh
          if (options.path.contains('/auth/firebase') ||
              options.path.contains('/auth/refresh')) {
            return handler.next(options);
          }

          // Ajouter le token JWT
          final tokens = await _tokenStorage.getTokens();
          if (tokens != null) {
            options.headers['Authorization'] = 'Bearer ${tokens.accessToken}';
          }

          return handler.next(options);
        },
        onError: (error, handler) async {
          // Si 401, tenter de refresh le token
          if (error.response?.statusCode == 401) {
            try {
              final refreshed = await _refreshToken();
              if (refreshed) {
                // Retry la requête avec le nouveau token
                final options = error.requestOptions;
                final tokens = await _tokenStorage.getTokens();
                options.headers['Authorization'] = 'Bearer ${tokens!.accessToken}';
                
                final response = await _dio.fetch(options);
                return handler.resolve(response);
              }
            } catch (e) {
              debugPrint('ApiClient: Refresh token failed: $e');
            }
          }
          return handler.next(error);
        },
        onResponse: (response, handler) {
          if (kDebugMode) {
            debugPrint('ApiClient: ${response.requestOptions.method} ${response.requestOptions.path}');
            debugPrint('ApiClient: Status ${response.statusCode}');
          }
          return handler.next(response);
        },
      ),
    );

    // Intercepteur de logs en debug
    if (kDebugMode) {
      _dio.interceptors.add(LogInterceptor(
        requestBody: true,
        responseBody: true,
        error: true,
      ));
    }
  }

  /// Refresh le token JWT
  Future<bool> _refreshToken() async {
    try {
      final tokens = await _tokenStorage.getTokens();
      if (tokens == null) return false;

      final response = await _dio.post(
        '/auth/refresh',
        data: {'refreshToken': tokens.refreshToken},
      );

      if (response.statusCode == 200) {
        final newTokens = AuthTokens.fromJson(response.data);
        await _tokenStorage.saveTokens(newTokens);
        return true;
      }
      return false;
    } catch (e) {
      debugPrint('ApiClient: Refresh token error: $e');
      return false;
    }
  }
}
