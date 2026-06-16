import 'floating_surface_service.dart';

class FloatingSurfacePermissionService {
  final FloatingSurfaceService service;

  const FloatingSurfacePermissionService({required this.service});

  Future<bool> hasPermission() => service.hasPermission();

  Future<void> requestPermission() => service.requestPermission();
}
