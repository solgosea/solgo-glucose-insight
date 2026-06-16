import '../../../application/floating_surface/floating_surface_payload.dart';

abstract interface class FloatingSurfacePlatformBridge {
  bool get isSupported;

  Future<bool> hasOverlayPermission();

  Future<void> requestOverlayPermission();

  Future<void> update(FloatingSurfacePayload payload);

  Future<void> stop();
}
