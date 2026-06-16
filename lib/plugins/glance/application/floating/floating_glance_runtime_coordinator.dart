import '../../domain/glance_snapshot.dart';
import 'floating_glance_service.dart';

class FloatingGlanceRuntimeCoordinator {
  final FloatingGlanceService service;

  const FloatingGlanceRuntimeCoordinator({
    required this.service,
  });

  Future<void> refresh(GlanceSnapshot snapshot) {
    return service.update(snapshot);
  }

  Future<void> stop() => service.stop();
}
