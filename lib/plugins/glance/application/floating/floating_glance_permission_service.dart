import 'package:smart_xdrip/application/floating_surface/floating_surface_permission_service.dart';
import 'package:smart_xdrip/data/platform/floating_surface/floating_surface_platform_bridge.dart';

class FloatingGlancePermissionService {
  final FloatingSurfacePermissionService permissionService;
  final FloatingSurfacePlatformBridge bridge;

  const FloatingGlancePermissionService({
    required this.permissionService,
    required this.bridge,
  });

  bool get isSupported => bridge.isSupported;

  Future<bool> hasPermission() => permissionService.hasPermission();

  Future<void> requestPermission() => permissionService.requestPermission();
}
