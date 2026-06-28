import 'package:flutter/foundation.dart';
import 'package:smart_xdrip/application/polling_runtime/polling_job.dart';
import 'package:smart_xdrip/application/polling_runtime/polling_job_context.dart';
import 'package:smart_xdrip/application/polling_runtime/polling_job_key.dart';
import 'package:smart_xdrip/application/polling_runtime/polling_job_policy.dart';
import 'package:smart_xdrip/application/polling_runtime/polling_job_result.dart';
import 'package:smart_xdrip/domain/polling/polling_mode.dart';

import '../../domain/status_report.dart';
import '../../domain/status_component_kind.dart';
import '../../domain/xdrip/xdrip_detail_data.dart';
import '../../domain/juggluco/juggluco_detail_data.dart';
import '../status_monitor_refresh_coordinator.dart';
import 'status_monitor_polling_policy.dart';
import 'status_monitor_polling_result_mapper.dart';

class StatusMonitorPollingJob implements PollingJob {
  static const jobKey = PollingJobKey('status-monitor.probe');

  final StatusMonitorRefreshCoordinator refreshCoordinator;
  final void Function(StatusReport report) onReport;
  final void Function(Object error) onError;
  final StatusMonitorPollingResultMapper resultMapper;

  @override
  final PollingJobPolicy policy;

  StatusMonitorPollingJob({
    required this.refreshCoordinator,
    required this.onReport,
    required this.onError,
    StatusMonitorPollingPolicy pollingPolicy =
        const StatusMonitorPollingPolicy(),
    this.resultMapper = const StatusMonitorPollingResultMapper(),
  }) : policy = pollingPolicy.build();

  @override
  PollingJobKey get key => jobKey;

  @override
  Future<PollingJobResult> run(PollingJobContext context) async {
    try {
      final report = await refreshCoordinator.refresh();
      _logReport(report);
      onReport(report);
      final lowBatteryMode =
          await refreshCoordinator.lowBatteryMode(report.subjectId);
      return resultMapper.success(
        report,
        nextInterval: lowBatteryMode ? _lowBatteryInterval(context.mode) : null,
      );
    } catch (error) {
      onError(error);
      return resultMapper.failure(error);
    }
  }

  Duration _lowBatteryInterval(PollingMode mode) {
    return switch (mode) {
      PollingMode.foreground => const Duration(minutes: 5),
      PollingMode.background => const Duration(minutes: 15),
    };
  }

  void _logReport(StatusReport report) {
    final xdrip = _detail<XdripDetailData>(report, StatusComponentKind.xdrip);
    final juggluco =
        _detail<JugglucoDetailData>(report, StatusComponentKind.juggluco);
    debugPrint(
      'Status Monitor polling refreshed '
      'xDrip=${xdrip?.broadcastReadiness.payloadLabel ?? '-'} '
      'Juggluco=${juggluco?.latestGlucoseLabel ?? '-'} '
      'generatedAt=${report.generatedAt.toIso8601String()}',
    );
  }

  T? _detail<T>(StatusReport report, StatusComponentKind kind) {
    for (final component in report.components) {
      if (component.kind == kind && component.detailData is T) {
        return component.detailData as T;
      }
    }
    return null;
  }
}
