import 'package:flutter/foundation.dart';
import 'package:dio/dio.dart';
import '../../services/api/api_client.dart';
import '../../core/config/app_config.dart';
import '../../domain/entities/payment_method_entity.dart';
import '../../domain/entities/payment_policy.dart';
import '../../domain/entities/add_payment_method_request.dart';
import 'payment_datasource.dart';

/// Implementation API du PaymentDataSource
/// 
/// Appelle le backend REST pour les opérations de paiement.
/// Les cartes sont stockées côté serveur et liées au compte utilisateur,
/// donc elles persistent après réinstallation de l'app.
/// 
/// Endpoints API:
/// - GET /api/v1/payments/methods - Liste des méthodes
/// - POST /api/v1/payments/methods - Ajouter une carte
/// - DELETE /api/v1/payments/methods/{id} - Supprimer une carte
/// - PATCH /api/v1/payments/methods/{id}/default - Définir par défaut
/// - GET /api/v1/payments/policy - Politique de paiement
/// - POST /api/v1/payments/cash-preference - Préférence cash
/// - POST /api/v1/payments/cmi/preauth-intent - Créer session CMI
/// 
/// Flow d'ajout de carte CMI:
/// 1. POST /payments/cmi/preauth-intent -> retourne sessionId + redirectUrl
/// 2. Ouvrir WebView/redirect vers CMI (3D Secure)
/// 3. CMI redirige vers callback avec cardToken
/// 4. Backend sauvegarde la carte tokenisée liée au user
class ApiPaymentDataSource implements PaymentDataSource {
  final ApiClient _apiClient;

  ApiPaymentDataSource({ApiClient? apiClient})
      : _apiClient = apiClient ?? ApiClient();

  String get _baseUrl => AppConfig.BACKEND_BASE_URL;

  @override
  String? get currentUserId {
    // L'user ID est extrait du JWT côté backend
    // On ne l'a pas directement ici pour des raisons de sécurité
    return null;
  }

  @override
  bool get isAuthenticated => true; // Le token JWT est géré par ApiClient

  @override
  bool get isCashEnabled {
    // Sera récupéré depuis le backend dans getMyPaymentMethods
    return true;
  }

  @override
  Future<List<PaymentMethod>> getMyPaymentMethods() async {
    try {
      final response = await _apiClient.dio.get(
        '$_baseUrl/payments/methods',
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        final methods = data.map((e) => PaymentMethod.fromMap(e)).toList();
        
        debugPrint('ApiPaymentDataSource: ${methods.length} méthodes récupérées');
        return methods;
      } else {
        throw Exception('Erreur lors du chargement des méthodes: ${response.statusCode}');
      }
    } on DioException catch (e) {
      debugPrint('ApiPaymentDataSource: Erreur getMyPaymentMethods - $e');
      throw _handleDioError(e, 'Impossible de charger vos méthodes de paiement');
    }
  }

  @override
  Future<PaymentMethod> addPaymentMethod(AddPaymentMethodRequest request) async {
    try {
      // Flow CMI 3D Secure
      if (request.type == PaymentMethodType.cmiCard) {
        return await _addCmiCard(request);
      } else if (request.type == PaymentMethodType.cash) {
        // Le cash est une préférence, pas une méthode enregistrée
        await setCashEnabled(true);
        return PaymentMethod.cash(
          id: 'cash_${DateTime.now().millisecondsSinceEpoch}',
          isDefault: request.setAsDefault,
        );
      } else {
        throw Exception('Type de paiement non supporté: ${request.type}');
      }
    } on DioException catch (e) {
      debugPrint('ApiPaymentDataSource: Erreur addPaymentMethod - $e');
      throw _handleDioError(e, 'Impossible d\'ajouter la méthode de paiement');
    }
  }

  /// Ajouter une carte via CMI avec 3D Secure
  Future<PaymentMethod> _addCmiCard(AddPaymentMethodRequest request) async {
    // 1. Créer une intention de préautorisation CMI
    final intentResponse = await _apiClient.dio.post(
      '$_baseUrl/payments/cmi/preauth-intent',
      data: {
        'cardNumber': request.cardNumber,
        'expMonth': request.expMonth,
        'expYear': request.expYear,
        'cvv': request.cvv,
        'cardHolderName': request.cardHolderName,
        'setAsDefault': request.setAsDefault,
      },
    );

    if (intentResponse.statusCode != 200) {
      throw Exception('Échec de la création de la session CMI');
    }

    final intentData = intentResponse.data;
    final sessionId = intentData['sessionId'];
    final paymentMethodId = intentData['paymentMethodId'];

    // 2. Retourner une méthode temporaire avec l'URL de redirection
    // L'UI devra ouvrir une WebView et gérer le callback
    // Après succès CMI, le backend aura déjà sauvegardé la carte
    
    debugPrint('ApiPaymentDataSource: Session CMI créée - $sessionId');
    
    return PaymentMethod.cmiCard(
      id: paymentMethodId,
      last4: request.cardNumber!.substring(request.cardNumber!.length - 4),
      expMonth: request.expMonth!,
      expYear: request.expYear!,
      brand: request.detectCardBrand(),
      cardHolderName: request.cardHolderName,
      isDefault: request.setAsDefault,
      createdAt: DateTime.now(),
    );
  }

  @override
  Future<void> deletePaymentMethod(String id) async {
    try {
      final response = await _apiClient.dio.delete(
        '$_baseUrl/payments/methods/$id',
      );

      if (response.statusCode != 204 && response.statusCode != 200) {
        throw Exception('Erreur lors de la suppression: ${response.statusCode}');
      }

      debugPrint('ApiPaymentDataSource: Méthode supprimée - $id');
    } on DioException catch (e) {
      debugPrint('ApiPaymentDataSource: Erreur deletePaymentMethod - $e');
      throw _handleDioError(e, 'Impossible de supprimer la méthode de paiement');
    }
  }

  @override
  Future<void> setDefaultMethod(String id) async {
    try {
      final response = await _apiClient.dio.patch(
        '$_baseUrl/payments/methods/$id/default',
      );

      if (response.statusCode != 200) {
        throw Exception('Erreur lors de la mise à jour: ${response.statusCode}');
      }

      debugPrint('ApiPaymentDataSource: Méthode par défaut définie - $id');
    } on DioException catch (e) {
      debugPrint('ApiPaymentDataSource: Erreur setDefaultMethod - $e');
      throw _handleDioError(e, 'Impossible de définir la méthode par défaut');
    }
  }

  @override
  Future<PaymentPolicy> getPaymentPolicy() async {
    try {
      final response = await _apiClient.dio.get(
        '$_baseUrl/payments/policy',
      );

      if (response.statusCode == 200) {
        return PaymentPolicy.fromMap(response.data);
      } else {
        // Fallback sur la politique par défaut
        return PaymentPolicy.defaultPolicy();
      }
    } on DioException catch (e) {
      debugPrint('ApiPaymentDataSource: Erreur getPaymentPolicy - $e');
      // Fallback silencieux sur la politique par défaut
      return PaymentPolicy.defaultPolicy();
    }
  }

  @override
  Future<void> setCashEnabled(bool enabled) async {
    try {
      final response = await _apiClient.dio.post(
        '$_baseUrl/payments/cash-preference',
        data: {'enabled': enabled},
      );

      if (response.statusCode != 200) {
        throw Exception('Erreur lors de la mise à jour: ${response.statusCode}');
      }

      debugPrint('ApiPaymentDataSource: Cash ${enabled ? 'activé' : 'désactivé'}');
    } on DioException catch (e) {
      debugPrint('ApiPaymentDataSource: Erreur setCashEnabled - $e');
      throw _handleDioError(e, 'Impossible de mettre à jour la préférence');
    }
  }

  /// Traiter le callback après authentification 3D Secure CMI
  /// 
  /// Appelé après que l'utilisateur a complété le 3D Secure sur la WebView CMI
  Future<PaymentMethod> processCmiCallback({
    required String sessionId,
    required String status,
    String? cardToken,
    String? errorMessage,
  }) async {
    try {
      final response = await _apiClient.dio.post(
        '$_baseUrl/payments/cmi/callback',
        data: {
          'sessionId': sessionId,
          'status': status,
          'cardToken': cardToken,
          'errorMessage': errorMessage,
        },
      );

      if (response.statusCode == 200 && response.data != null) {
        final paymentMethod = PaymentMethod.fromMap(response.data);
        debugPrint('ApiPaymentDataSource: Carte sauvegardée avec succès');
        return paymentMethod;
      } else {
        throw Exception(errorMessage ?? 'Échec de l\'authentification 3D Secure');
      }
    } on DioException catch (e) {
      debugPrint('ApiPaymentDataSource: Erreur processCmiCallback - $e');
      throw _handleDioError(e, 'Erreur lors de la validation du paiement');
    }
  }

  /// Effectuer un paiement pour une réservation
  /// 
  /// Retourne le paiement créé avec son statut
  Future<Map<String, dynamic>> createBookingPayment({
    required String bookingId,
    required String paymentMethodId,
    required double amount,
    String? promoCode,
  }) async {
    try {
      final response = await _apiClient.dio.post(
        '$_baseUrl/payments/booking',
        data: {
          'bookingId': bookingId,
          'paymentMethodId': paymentMethodId,
          'amount': amount,
          'currency': 'MAD',
          'promoCode': promoCode,
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        debugPrint('ApiPaymentDataSource: Paiement créé pour booking $bookingId');
        return response.data;
      } else {
        throw Exception('Erreur lors du paiement: ${response.statusCode}');
      }
    } on DioException catch (e) {
      debugPrint('ApiPaymentDataSource: Erreur createBookingPayment - $e');
      throw _handleDioError(e, 'Impossible de traiter le paiement');
    }
  }

  /// Vérifier le statut d'un paiement
  Future<Map<String, dynamic>> getPaymentStatus(String paymentId) async {
    try {
      final response = await _apiClient.dio.get(
        '$_baseUrl/payments/$paymentId/status',
      );

      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw Exception('Impossible de récupérer le statut du paiement');
      }
    } on DioException catch (e) {
      debugPrint('ApiPaymentDataSource: Erreur getPaymentStatus - $e');
      throw _handleDioError(e, 'Erreur lors de la vérification du paiement');
    }
  }

  /// Gestion centralisée des erreurs Dio
  Exception _handleDioError(DioException e, String defaultMessage) {
    if (e.response != null) {
      final statusCode = e.response?.statusCode;
      final data = e.response?.data;
      
      if (data != null && data is Map && data['message'] != null) {
        return Exception(data['message']);
      }
      
      switch (statusCode) {
        case 401:
          return Exception('Session expirée. Veuillez vous reconnecter.');
        case 403:
          return Exception('Accès non autorisé.');
        case 404:
          return Exception('Ressource non trouvée.');
        case 422:
          return Exception('Données invalides. Vérifiez les informations saisies.');
        case 500:
        case 502:
        case 503:
          return Exception('Erreur serveur. Veuillez réessayer plus tard.');
        default:
          return Exception(defaultMessage);
      }
    } else if (e.type == DioExceptionType.connectionTimeout ||
               e.type == DioExceptionType.receiveTimeout) {
      return Exception('Délai d\'attente dépassé. Vérifiez votre connexion.');
    } else if (e.type == DioExceptionType.connectionError) {
      return Exception('Pas de connexion internet. Vérifiez votre réseau.');
    }
    
    return Exception(defaultMessage);
  }
}
