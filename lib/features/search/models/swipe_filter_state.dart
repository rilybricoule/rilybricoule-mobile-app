import 'provider_location.dart';

/// Tracks which providers the user has liked/disliked via swipe filtering on the map.
class SwipeFilterState {
  final bool isEnabled;
  final bool isSessionActive;
  final Set<String> likedProviderIds;
  final Set<String> dislikedProviderIds;
  final int currentIndex;

  const SwipeFilterState({
    this.isEnabled = false,
    this.isSessionActive = false,
    this.likedProviderIds = const {},
    this.dislikedProviderIds = const {},
    this.currentIndex = 0,
  });

  /// Whether a swipe filter is actively applied (liked set is non-empty).
  bool get isFilterApplied => isEnabled && likedProviderIds.isNotEmpty;

  int get totalSwiped => likedProviderIds.length + dislikedProviderIds.length;

  SwipeFilterState copyWith({
    bool? isEnabled,
    bool? isSessionActive,
    Set<String>? likedProviderIds,
    Set<String>? dislikedProviderIds,
    int? currentIndex,
  }) {
    return SwipeFilterState(
      isEnabled: isEnabled ?? this.isEnabled,
      isSessionActive: isSessionActive ?? this.isSessionActive,
      likedProviderIds: likedProviderIds ?? this.likedProviderIds,
      dislikedProviderIds: dislikedProviderIds ?? this.dislikedProviderIds,
      currentIndex: currentIndex ?? this.currentIndex,
    );
  }

  /// Filters providers based on swipe state.
  /// - If swipe is disabled → returns all providers
  /// - If session is active → returns all except disliked (neutral + liked)
  /// - If session ended (filter applied) → returns only liked
  List<ProviderLocation> applyFilter(List<ProviderLocation> providers) {
    if (!isEnabled) return providers;

    if (isSessionActive) {
      // During session: hide disliked, show liked + neutral
      return providers
          .where((p) => !dislikedProviderIds.contains(p.id))
          .toList();
    }

    // After session: show only liked
    if (likedProviderIds.isNotEmpty) {
      return providers
          .where((p) => likedProviderIds.contains(p.id))
          .toList();
    }

    return providers;
  }

  /// Reset all swipe data.
  SwipeFilterState reset() {
    return const SwipeFilterState();
  }
}
