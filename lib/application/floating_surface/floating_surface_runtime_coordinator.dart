import 'floating_surface_service.dart';

class FloatingSurfaceRuntimeCoordinator {
  final FloatingSurfaceService service;

  const FloatingSurfaceRuntimeCoordinator({required this.service});

  Future<void> refresh() => service.refresh();

  Future<void> stop() => service.stop();
}
