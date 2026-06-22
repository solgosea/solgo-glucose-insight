import '../../../domain/floating/status_floating_payload.dart';
import '../../../domain/floating/status_floating_settings.dart';

abstract interface class StatusFloatingPlatformBridge {
  bool get isSupported;

  Future<bool> hasOverlayPermission();

  Future<void> requestOverlayPermission();

  Future<void> start({
    required StatusFloatingSettings settings,
    required StatusFloatingPayload payload,
  });

  Future<void> update({
    required StatusFloatingSettings settings,
    required StatusFloatingPayload payload,
  });

  Future<void> stop();
}
