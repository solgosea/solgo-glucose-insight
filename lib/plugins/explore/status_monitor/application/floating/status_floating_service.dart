import 'package:smart_xdrip/application/floating_surface/floating_surface_service.dart';

import '../../data/sqlite/sqlite_status_floating_settings_repository.dart';
import '../../domain/floating/status_floating_mode.dart';
import '../../domain/status_report.dart';
import 'status_floating_surface_contributor.dart';

class StatusFloatingService {
  final SqliteStatusFloatingSettingsRepository settingsRepository;
  final FloatingSurfaceService surfaceService;
  final StatusFloatingSurfaceContributor contributor;

  const StatusFloatingService({
    required this.settingsRepository,
    required this.surfaceService,
    this.contributor = const StatusFloatingSurfaceContributor(),
  });

  Future<bool> hasPermission() => surfaceService.hasPermission();

  Future<void> requestPermission() => surfaceService.requestPermission();

  Future<void> setEnabled(bool enabled) async {
    final settings = await settingsRepository.get();
    await settingsRepository.save(
      settings.copyWith(
        mode:
            enabled ? StatusFloatingMode.enabled : StatusFloatingMode.disabled,
        updatedAt: DateTime.now(),
      ),
    );
    if (!enabled) await stop();
  }

  Future<void> update(StatusReport report) async {
    final settings = await settingsRepository.get();
    final hasPermission = await surfaceService.hasPermission();
    if (!settings.enabled || !hasPermission) {
      await stop();
      return;
    }
    await surfaceService.upsertSegment(contributor.build(report));
  }

  Future<void> startIfAvailable(StatusReport report) async {
    await update(report);
  }

  Future<void> stop() {
    return surfaceService.removeSegment(
      StatusFloatingSurfaceContributor.segmentId,
    );
  }
}
