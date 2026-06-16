import '../../../domain/floating/floating_glance_settings.dart';
import '../../../domain/glance_snapshot.dart';

abstract interface class FloatingGlancePlatformBridge {
  bool get isSupported;

  Future<bool> hasOverlayPermission();

  Future<void> requestOverlayPermission();

  Future<void> start({
    required FloatingGlanceSettings settings,
    required GlanceSnapshot snapshot,
  });

  Future<void> update({
    required FloatingGlanceSettings settings,
    required GlanceSnapshot snapshot,
  });

  Future<void> stop();
}
