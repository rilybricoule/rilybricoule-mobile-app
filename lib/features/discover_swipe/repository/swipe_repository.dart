abstract class SwipeRepository {
  Future<void> likeProvider(String providerId);
  Future<void> skipProvider(String providerId);
  Future<void> undoLastDecision();
}
