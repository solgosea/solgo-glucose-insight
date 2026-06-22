import '../../data/platform/floating_surface/floating_surface_platform_bridge.dart';
import 'floating_surface_action.dart';
import 'floating_surface_registry.dart';
import 'floating_surface_segment.dart';

class FloatingSurfaceService {
  final FloatingSurfaceRegistry registry;
  final FloatingSurfacePlatformBridge bridge;
  String? _lastPublishedSignature;
  bool _isStopped = false;

  FloatingSurfaceService({
    required this.registry,
    required this.bridge,
  });

  Future<bool> hasPermission() => bridge.hasOverlayPermission();

  Stream<FloatingSurfaceAction> get actions => bridge.actions;

  Future<void> requestPermission() => bridge.requestOverlayPermission();

  Future<void> upsertSegment(FloatingSurfaceSegment segment) async {
    registry.upsert(segment);
    await _publish();
  }

  Future<void> removeSegment(String id) async {
    registry.remove(id);
    await _publish();
  }

  Future<void> refresh() => _publish();

  Future<void> stop() => _stopIfNeeded();

  Future<void> _publish() async {
    final payload = registry.snapshot();
    if (payload.isEmpty || !await bridge.hasOverlayPermission()) {
      await _stopIfNeeded();
      return;
    }
    final signature = payload.signature;
    if (!_isStopped && _lastPublishedSignature == signature) {
      return;
    }
    await bridge.update(payload);
    _lastPublishedSignature = signature;
    _isStopped = false;
  }

  Future<void> _stopIfNeeded() async {
    if (_isStopped) {
      return;
    }
    _lastPublishedSignature = null;
    _isStopped = true;
    await bridge.stop();
  }
}
