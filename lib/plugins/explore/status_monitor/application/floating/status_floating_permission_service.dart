import 'package:smart_xdrip/application/floating_surface/floating_surface_permission_service.dart';

class StatusFloatingPermissionService {
  final FloatingSurfacePermissionService permissionService;

  const StatusFloatingPermissionService({required this.permissionService});

  Future<bool> hasPermission() => permissionService.hasPermission();

  Future<void> requestPermission() => permissionService.requestPermission();
}
