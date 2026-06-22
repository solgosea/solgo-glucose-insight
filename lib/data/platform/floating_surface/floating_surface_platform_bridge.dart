import '../../../application/floating_surface/floating_surface_action.dart';
import '../../../application/floating_surface/floating_surface_payload.dart';

abstract interface class FloatingSurfacePlatformBridge {
  bool get isSupported;

  Stream<FloatingSurfaceAction> get actions;

  Future<bool> hasOverlayPermission();

  Future<void> requestOverlayPermission();

  Future<void> update(FloatingSurfacePayload payload);

  Future<void> stop();
}
