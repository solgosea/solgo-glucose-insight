class GlucoseSyncTargetLeaseRegistry {
  final Set<String> _leased = <String>{};

  bool acquire(String targetId) {
    if (_leased.contains(targetId)) return false;
    _leased.add(targetId);
    return true;
  }

  void release(String targetId) {
    _leased.remove(targetId);
  }

  bool isLeased(String targetId) => _leased.contains(targetId);

  Set<String> activeTargetIds() => Set.unmodifiable(_leased);
}
