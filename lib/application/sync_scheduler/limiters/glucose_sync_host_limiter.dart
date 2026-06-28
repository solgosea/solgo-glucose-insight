import 'package:pool/pool.dart';

import '../../../domain/sync_target/glucose_sync_target.dart';
import 'glucose_sync_host_key.dart';

class GlucoseSyncHostLimiter {
  final int perHostConcurrency;
  final Map<GlucoseSyncHostKey, Pool> _pools = <GlucoseSyncHostKey, Pool>{};

  GlucoseSyncHostLimiter({
    this.perHostConcurrency = 1,
  });

  Future<T> run<T>(
    GlucoseSyncTarget target,
    Future<T> Function() action,
  ) {
    final key = GlucoseSyncHostKey.fromTarget(target);
    final pool = _pools.putIfAbsent(
      key,
      () => Pool(perHostConcurrency < 1 ? 1 : perHostConcurrency),
    );
    return pool.withResource(action);
  }

  Future<void> close() async {
    await Future.wait(_pools.values.map((pool) => pool.close()));
    _pools.clear();
  }
}
