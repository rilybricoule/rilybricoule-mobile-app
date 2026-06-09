import 'models/dispatch_request.dart';
import 'models/provider_offer.dart';

/// Abstract repository for dispatch operations.
/// Mock implementation now, backend (Spring Boot + WebSocket/FCM) later.
abstract class DispatchRepository {
  /// Create and broadcast a new dispatch request.
  Future<DispatchRequest> createRequest(DispatchRequest request);

  /// Watch a dispatch request for status changes (real-time stream).
  Stream<DispatchRequest> watchRequest(String requestId);

  /// Cancel a pending dispatch request.
  Future<void> cancelRequest(String requestId);

  /// Wait for the first provider to accept (first-accept-wins).
  /// Returns null if timeout/expired.
  Future<ProviderOffer?> waitForFirstAcceptance(
    String requestId, {
    Set<String> blockedProviderIds,
  });

  /// Client confirms the matched provider (lock final).
  Future<void> confirmProvider(String requestId, String providerId);

  /// Mark a dispatch request as paid.
  Future<void> markPaid(String requestId);

  /// Get available categories for dispatch.
  List<Map<String, dynamic>> getCategories(String langCode);
}
