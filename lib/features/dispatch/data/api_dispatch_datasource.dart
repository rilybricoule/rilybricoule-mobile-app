import '../domain/dispatch_repository.dart';
import '../domain/models/dispatch_request.dart';
import '../domain/models/provider_offer.dart';

/// API datasource for dispatch operations.
/// Placeholder for backend integration (Spring Boot + WebSocket/FCM).
///
/// Backend endpoints to implement:
/// - POST   /api/dispatch/requests           → Create dispatch request
/// - WS     /api/dispatch/requests/{id}/events → Real-time events stream
/// - POST   /api/dispatch/requests/{id}/cancel → Cancel request
/// - POST   /api/dispatch/requests/{id}/accept → Provider accepts (provider side)
/// - POST   /api/dispatch/requests/{id}/confirm → Client confirms provider
/// - POST   /api/dispatch/requests/{id}/paid   → Mark as paid
/// - GET    /api/dispatch/categories          → Get dispatch categories
///
/// WebSocket events:
/// - PROVIDER_ACCEPTED { providerId, providerSnapshot }
/// - REQUEST_EXPIRED
/// - REQUEST_CANCELLED
///
/// FCM notifications:
/// - dispatch_new_request → sent to eligible providers
/// - dispatch_provider_accepted → sent to client
/// - dispatch_request_expired → sent to client
class ApiDispatchDatasource implements DispatchRepository {
  // TODO: Inject ApiClient for HTTP calls
  // TODO: Inject WebSocket client for real-time events

  @override
  Future<DispatchRequest> createRequest(DispatchRequest request) {
    // TODO: POST /api/dispatch/requests with request.toJson()
    throw UnimplementedError('Backend dispatch not yet implemented');
  }

  @override
  Stream<DispatchRequest> watchRequest(String requestId) {
    // TODO: Connect to WS /api/dispatch/requests/{id}/events
    throw UnimplementedError('Backend dispatch not yet implemented');
  }

  @override
  Future<void> cancelRequest(String requestId) {
    // TODO: POST /api/dispatch/requests/{id}/cancel
    throw UnimplementedError('Backend dispatch not yet implemented');
  }

  @override
  Future<ProviderOffer?> waitForFirstAcceptance(
    String requestId, {
    Set<String> blockedProviderIds = const {},
  }) {
    // TODO: Listen to WS events for PROVIDER_ACCEPTED
    throw UnimplementedError('Backend dispatch not yet implemented');
  }

  @override
  Future<void> confirmProvider(String requestId, String providerId) {
    // TODO: POST /api/dispatch/requests/{id}/confirm
    throw UnimplementedError('Backend dispatch not yet implemented');
  }

  @override
  Future<void> markPaid(String requestId) {
    // TODO: POST /api/dispatch/requests/{id}/paid
    throw UnimplementedError('Backend dispatch not yet implemented');
  }

  @override
  List<Map<String, dynamic>> getCategories(String langCode) {
    // TODO: GET /api/dispatch/categories?lang={langCode}
    throw UnimplementedError('Backend dispatch not yet implemented');
  }
}
