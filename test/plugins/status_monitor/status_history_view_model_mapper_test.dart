import 'package:flutter_test/flutter_test.dart';
import 'package:smart_xdrip/plugins/explore/status_monitor/domain/component_health.dart';
import 'package:smart_xdrip/plugins/explore/status_monitor/domain/history/status_component_history_load_result.dart';
import 'package:smart_xdrip/plugins/explore/status_monitor/domain/history/status_component_history_load_state.dart';
import 'package:smart_xdrip/plugins/explore/status_monitor/domain/history/status_component_history_result.dart';
import 'package:smart_xdrip/plugins/explore/status_monitor/domain/history/status_history_bucket.dart';
import 'package:smart_xdrip/plugins/explore/status_monitor/domain/history/status_history_bucket_reason.dart';
import 'package:smart_xdrip/plugins/explore/status_monitor/domain/status_component_kind.dart';
import 'package:smart_xdrip/plugins/explore/status_monitor/domain/status_level.dart';
import 'package:smart_xdrip/plugins/explore/status_monitor/domain/status_report.dart';
import 'package:smart_xdrip/plugins/explore/status_monitor/domain/status_source_capabilities.dart';
import 'package:smart_xdrip/plugins/explore/status_monitor/presentation/history/mappers/status_history_view_model_mapper.dart';

void main() {
  test('maps component history into daily and hourly status grids', () {
    final now = DateTime.utc(2026, 6, 12, 10, 30);
    final report = StatusReport(
      subjectId: 'self',
      sourceKind: 'nightscout',
      sourceLabel: 'Nightscout',
      generatedAt: now,
      summary: const StatusSummary(
        level: StatusLevel.watch,
        headline: 'watch',
        body: 'body',
        meta: 'meta',
        healthyCount: 1,
        totalCount: 3,
      ),
      components: [
        ComponentHealth(
          kind: StatusComponentKind.xdrip,
          level: StatusLevel.watch,
          title: 'xDrip+',
          role: 'Phone uploader',
          takeaway: 'Watch',
          summary: 'summary',
          metrics: const [],
          history: const [],
        ),
      ],
      recentEvents: const [],
      capabilities: const StatusSourceCapabilities.nightscout(),
      hasConfiguredSource: true,
    );
    final history = StatusComponentHistoryResult(
      component: StatusComponentKind.xdrip,
      currentLevel: StatusLevel.watch,
      coverage: .25,
      dailyBuckets: [
        for (var day = 6; day >= 0; day--)
          _bucket(
            now.subtract(Duration(days: day)),
            StatusLevel.watch,
            reason: StatusHistoryBucketReason.recordedSample,
          ),
      ],
      hourlyBuckets: [
        for (var day = 6; day >= 0; day--)
          [
            for (var hour = 0; hour < 24; hour++)
              _bucket(
                DateTime.utc(2026, 6, 12 - day, hour),
                hour == 8 ? StatusLevel.watch : StatusLevel.unknown,
                reason: hour == 8
                    ? StatusHistoryBucketReason.recordedSample
                    : StatusHistoryBucketReason.noSample,
                score: hour == 8 ? 68 : null,
              ),
          ],
      ],
    );

    final vm = const StatusHistoryViewModelMapper().mapProgressive(
      report: report,
      loads: {
        StatusComponentKind.xdrip: StatusComponentHistoryLoadResult(
          component: report.components.single,
          state: StatusComponentHistoryLoadState.ready,
          result: history,
        ),
      },
      now: now,
    );

    expect(vm.sections, hasLength(1));
    final component = vm.sections.single.history!;
    expect(component.dailyCells, hasLength(7));
    expect(component.hourlyRows, hasLength(7));
    expect(component.hourlyRows.first, hasLength(24));
    expect(component.currentLevel, StatusLevel.watch);
    expect(component.coverage, .25);
    expect(
      component.hourlyRows.last[8].reason,
      StatusHistoryBucketReason.recordedSample,
    );
    expect(component.hourlyRows.last[8].score, 68);
  });
}

StatusHistoryBucket _bucket(
  DateTime at,
  StatusLevel level, {
  required StatusHistoryBucketReason reason,
  int? score,
}) {
  return StatusHistoryBucket(
    component: StatusComponentKind.xdrip,
    start: at,
    end: at.add(const Duration(hours: 1)),
    level: level,
    score: score,
    summary: level.label,
    reason: reason,
  );
}
