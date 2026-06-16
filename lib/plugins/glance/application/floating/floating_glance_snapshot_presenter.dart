import '../../domain/floating/floating_glance_settings.dart';
import '../../domain/glance_snapshot.dart';

class FloatingGlanceSnapshotPresenter {
  const FloatingGlanceSnapshotPresenter();

  bool shouldShow({
    required FloatingGlanceSettings settings,
    required bool hasPermission,
  }) {
    return settings.enabled && hasPermission && !settings.dismissedForSession;
  }

  bool shouldRequestPermission(FloatingGlanceSettings settings) {
    return settings.enabled;
  }

  bool hasVisibleData(GlanceSnapshot snapshot) {
    return snapshot.hasReading && !snapshot.freshness.isStale;
  }
}
