import 'dart:async';

import 'package:smart_xdrip/application/floating_surface/floating_surface_action.dart';
import 'package:smart_xdrip/application/floating_surface/floating_surface_service.dart';

import '../../data/sqlite/sqlite_floating_glance_settings_repository.dart';
import '../../domain/floating/floating_glance_preset_source.dart';
import '../../domain/floating/floating_glance_size_preset.dart';
import '../glance_snapshot_service.dart';
import 'glance_floating_surface_contributor.dart';
import 'floating_glance_service.dart';

class FloatingGlanceOverlayActionHandler {
  final FloatingSurfaceService surfaceService;
  final SqliteFloatingGlanceSettingsRepository settingsRepository;
  final GlanceSnapshotService snapshotService;
  final FloatingGlanceService floatingService;

  StreamSubscription<FloatingSurfaceAction>? _subscription;

  FloatingGlanceOverlayActionHandler({
    required this.surfaceService,
    required this.settingsRepository,
    required this.snapshotService,
    required this.floatingService,
  });

  void start() {
    _subscription ??= surfaceService.actions.listen(handle);
  }

  Future<void> stop() async {
    await _subscription?.cancel();
    _subscription = null;
  }

  Future<void> handle(FloatingSurfaceAction action) async {
    if (action.segmentId != GlanceFloatingSurfaceContributor.segmentId) return;
    if (action.action != 'set_size_preset') return;
    final preset = FloatingGlanceSizePreset.fromCode(action.value);
    final settings = await settingsRepository.get();
    final next = settings.copyWith(
      sizePreset: preset,
      presetSource: FloatingGlancePresetSource.user,
    );
    await settingsRepository.save(next);
    final snapshot = await snapshotService.current();
    await floatingService.show(snapshot);
  }
}
