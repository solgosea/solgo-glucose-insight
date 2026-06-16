import 'package:smart_xdrip/application/floating_surface/floating_surface_service.dart';

import '../../data/sqlite/sqlite_floating_glance_settings_repository.dart';
import '../../domain/glance_snapshot.dart';
import 'floating_glance_snapshot_presenter.dart';
import 'glance_floating_surface_contributor.dart';

class FloatingGlanceService {
  final SqliteFloatingGlanceSettingsRepository settingsRepository;
  final FloatingSurfaceService surfaceService;
  final FloatingGlanceSnapshotPresenter presenter;
  final GlanceFloatingSurfaceContributor contributor;

  const FloatingGlanceService({
    required this.settingsRepository,
    required this.surfaceService,
    this.presenter = const FloatingGlanceSnapshotPresenter(),
    this.contributor = const GlanceFloatingSurfaceContributor(),
  });

  Future<bool> hasPermission() => surfaceService.hasPermission();

  Future<void> requestPermission() => surfaceService.requestPermission();

  Future<void> update(GlanceSnapshot snapshot) async {
    final settings = await settingsRepository.get();
    final hasPermission = await surfaceService.hasPermission();
    if (!presenter.shouldShow(
      settings: settings,
      hasPermission: hasPermission,
    )) {
      await stop();
      return;
    }
    await surfaceService.upsertSegment(contributor.build(snapshot));
  }

  Future<void> startIfAvailable(GlanceSnapshot snapshot) async {
    await update(snapshot);
  }

  Future<void> stop() {
    return surfaceService.removeSegment(
      GlanceFloatingSurfaceContributor.segmentId,
    );
  }
}
