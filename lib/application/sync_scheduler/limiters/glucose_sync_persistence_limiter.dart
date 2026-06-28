import 'package:pool/pool.dart';

class GlucoseSyncPersistenceLimiter {
  final Pool _pool;

  GlucoseSyncPersistenceLimiter({
    int concurrency = 1,
  }) : _pool = Pool(concurrency < 1 ? 1 : concurrency);

  Future<T> run<T>(Future<T> Function() action) {
    return _pool.withResource(action);
  }

  Future<void> close() => _pool.close();
}
