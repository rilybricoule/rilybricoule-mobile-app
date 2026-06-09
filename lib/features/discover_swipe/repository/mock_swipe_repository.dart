import 'swipe_repository.dart';

class MockSwipeRepository implements SwipeRepository {
  final Set<String> _likedProviders = {};
  final Set<String> _skippedProviders = {};
  final List<String> _history = [];

  Set<String> get likedProviders => Set.unmodifiable(_likedProviders);
  Set<String> get skippedProviders => Set.unmodifiable(_skippedProviders);

  bool isSkipped(String providerId) => _skippedProviders.contains(providerId);

  @override
  Future<void> likeProvider(String providerId) async {
    await Future.delayed(const Duration(milliseconds: 100));
    _likedProviders.add(providerId);
    _history.add('like:$providerId');
    // TODO: POST /api/favorites/{providerId}
  }

  @override
  Future<void> skipProvider(String providerId) async {
    await Future.delayed(const Duration(milliseconds: 100));
    _skippedProviders.add(providerId);
    _history.add('skip:$providerId');
    // TODO: POST /api/providers/{providerId}/skip
  }

  @override
  Future<void> undoLastDecision() async {
    if (_history.isEmpty) return;
    
    final last = _history.removeLast();
    final parts = last.split(':');
    final action = parts[0];
    final providerId = parts[1];

    if (action == 'like') {
      _likedProviders.remove(providerId);
    } else if (action == 'skip') {
      _skippedProviders.remove(providerId);
    }
  }

  void clearSession() {
    _likedProviders.clear();
    _skippedProviders.clear();
    _history.clear();
  }
}
