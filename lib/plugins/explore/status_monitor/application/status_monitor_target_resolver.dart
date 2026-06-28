import 'package:smart_xdrip/application/data_source/data_source_connection_service.dart';
import 'package:smart_xdrip/application/sync_target/glucose_sync_target_registry.dart';
import 'package:smart_xdrip/domain/entities/app_settings.dart';
import 'package:smart_xdrip/domain/subject/analysis_subject.dart';
import 'package:smart_xdrip/domain/sync_target/glucose_sync_target.dart';
import 'package:smart_xdrip/domain/sync_target/glucose_sync_target_kind.dart';

import 'status_monitor_target_resolution.dart';

class StatusMonitorTargetResolver {
  final GlucoseSyncTargetRegistry targetRegistry;
  final AppSettings Function() settingsProvider;

  const StatusMonitorTargetResolver({
    required this.targetRegistry,
    required this.settingsProvider,
  });

  Future<StatusMonitorTargetResolution> resolve(AnalysisSubject subject) async {
    if (subject.isSelf) {
      final xdrip = _selfXdripFallback(subject.id);
      if (xdrip != null && xdrip.enabled) return xdrip;
    }

    final enabledTarget = await _enabledTargetForSubject(subject.id);
    if (enabledTarget != null) {
      return _nightscoutResolution(subject.id, enabledTarget);
    }

    if (subject.isSelf) {
      final xdrip = _selfXdripFallback(subject.id);
      if (xdrip != null) return xdrip;
    }

    return StatusMonitorTargetResolution.none(subjectId: subject.id);
  }

  Future<StatusMonitorTargetResolution?> resolveEnabledNightscout(
    AnalysisSubject subject,
  ) async {
    final target = await _enabledTargetForSubject(subject.id);
    if (target == null) return null;
    return _nightscoutResolution(subject.id, target);
  }

  StatusMonitorTargetResolution? resolveSelfXdripLocal(
    AnalysisSubject subject,
  ) {
    return _selfXdripFallback(subject.id);
  }

  Future<GlucoseSyncTarget?> _enabledTargetForSubject(String subjectId) async {
    final targets = await targetRegistry.targetsFor(settingsProvider());
    for (final target in targets) {
      if (target.subjectId != subjectId) continue;
      if (target.kind == GlucoseSyncTargetKind.selfNightscout ||
          target.kind == GlucoseSyncTargetKind.remoteNightscout) {
        return target;
      }
    }
    return null;
  }

  StatusMonitorTargetResolution _nightscoutResolution(
    String subjectId,
    GlucoseSyncTarget target,
  ) {
    return StatusMonitorTargetResolution(
      subjectId: subjectId,
      sourceKind: StatusMonitorTargetSourceKind.nightscout,
      targetId: target.targetId,
      sourceLabel: target.label,
      baseUrl: target.metadata.nightscoutUrl,
      token: target.metadata.accessToken,
      enabled: target.enabled,
      unavailableReason:
          target.enabled ? null : '${target.label} is configured but disabled.',
    );
  }

  StatusMonitorTargetResolution? _selfXdripFallback(String subjectId) {
    final settings = settingsProvider();
    final configuredBaseUrl = settings.xdripBaseUrl?.trim();
    final baseUrl = configuredBaseUrl != null && configuredBaseUrl.isNotEmpty
        ? configuredBaseUrl
        : settings.xdripSyncEnabled
            ? DataSourceConnectionService.defaultXdripUrl
            : null;
    if (baseUrl == null) return null;
    return StatusMonitorTargetResolution(
      subjectId: subjectId,
      sourceKind: StatusMonitorTargetSourceKind.xdripLocal,
      targetId: 'self:xdrip-local',
      sourceLabel: 'xDrip+ Local',
      baseUrl: baseUrl,
      token: settings.xdripApiSecret,
      enabled: true,
    );
  }
}
