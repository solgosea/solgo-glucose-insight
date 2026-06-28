import '../sync/glucose_sync_result.dart';

class GlucoseSyncBackoffPolicy {
  const GlucoseSyncBackoffPolicy();

  Duration delayFor(GlucoseSyncResult result) {
    if (result.success) return Duration.zero;
    final error = result.error?.toLowerCase() ?? '';
    if (!result.available || error.contains('timeout')) {
      return const Duration(seconds: 30);
    }
    if (error.contains('auth') ||
        error.contains('401') ||
        error.contains('403')) {
      return const Duration(minutes: 30);
    }
    return const Duration(minutes: 2);
  }
}
