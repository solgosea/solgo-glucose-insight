import '../glucose_sync_target_lease_registry.dart';

class GlucoseSyncTargetLimiter {
  final GlucoseSyncTargetLeaseRegistry leases;

  const GlucoseSyncTargetLimiter({
    required this.leases,
  });

  Future<T?> run<T>(
    String targetId,
    Future<T> Function() action,
  ) async {
    if (!leases.acquire(targetId)) return null;
    try {
      return await action();
    } finally {
      leases.release(targetId);
    }
  }
}
