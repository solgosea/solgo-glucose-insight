import 'package:flutter_test/flutter_test.dart';
import 'package:smart_xdrip/application/analysis/analysis_facade.dart';
import 'package:smart_xdrip/application/analysis/analysis_refresh_result.dart';
import 'package:smart_xdrip/application/analysis/analysis_session_store.dart';
import 'package:smart_xdrip/domain/analysis/analysis_snapshot.dart';
import 'package:smart_xdrip/domain/analysis/daily_glucose_summary.dart';
import 'package:smart_xdrip/domain/data_source/data_source_action.dart';
import 'package:smart_xdrip/domain/data_source/data_source_connection_snapshot.dart';
import 'package:smart_xdrip/domain/data_source/data_source_connection_status.dart';
import 'package:smart_xdrip/domain/data_source/data_source_kind.dart';
import 'package:smart_xdrip/domain/data_source/data_source_sync_strategy_action.dart';
import 'package:smart_xdrip/domain/entities/app_settings.dart';
import 'package:smart_xdrip/domain/entities/source_sync_state.dart';
import 'package:smart_xdrip/domain/sync_status/sync_schedule_mode.dart';
import 'package:smart_xdrip/domain/sync_status/sync_schedule_snapshot.dart';
import 'package:smart_xdrip/domain/sync_status/sync_status_level.dart';
import 'package:smart_xdrip/domain/sync_status/sync_status_snapshot.dart';
import 'package:smart_xdrip/plugins/profile/mappers/profile_view_model_mapper.dart';

void main() {
  group('ProfileViewModelMapper', () {
    tearDown(() => AnalysisSessionStore.instance.clear());

    test('formats profile summary glucose metrics with selected unit', () {
      final now = DateTime(2026, 6, 4, 12);
      AnalysisSessionStore.instance.update(
        AnalysisRefreshResult(
          snapshot: AnalysisSnapshot(
            generatedAt: now,
            windowStart: now.subtract(const Duration(days: 5)),
            windowEnd: now,
            readings: const [],
            dailySummaries: [
              for (var i = 0; i < 5; i++)
                DailyGlucoseSummary(
                  day: DateTime(2026, 6, 4).subtract(Duration(days: i)),
                  readingCount: 288,
                  tir: 78.0 + i,
                  tar: 18.0,
                  tbr: 4.0,
                  mean: 6.0 + i * 0.1,
                  cv: 28.0 + i,
                  minValue: 3.8,
                  maxValue: 9.8 + i * 0.2,
                  firstReadingValue: 5.4 + i * 0.1,
                ),
            ],
            periodSummaries: const [],
            events: const [],
          ),
          insights: const [],
        ),
        settings: const AppSettings(unit: GlucoseUnit.mgDl),
      );

      final viewModel = const ProfileViewModelMapper().map(
        facade: AnalysisFacade.current(),
        settings: const AppSettings(unit: GlucoseUnit.mgDl),
        syncStatus: _syncStatus(),
        dataSourceSnapshots: const [],
      );
      final average = viewModel.stats.singleWhere(
        (stat) => stat.label == 'Avg 14d',
      );

      expect(average.value, isNot(contains('mg/dL')));
      expect(average.unit, 'mg/dL');
      expect(viewModel.header.primaryBadge, 'Waiting for data');
    });

    test('maps target range into four profile rows', () {
      final now = DateTime(2026, 6, 4, 12);
      const settings = AppSettings(
        unit: GlucoseUnit.mmolL,
        lowThreshold: 3.9,
        highThreshold: 10.0,
        veryHighThreshold: 13.9,
      );
      AnalysisSessionStore.instance.update(
        AnalysisRefreshResult(
          snapshot: AnalysisSnapshot(
            generatedAt: now,
            windowStart: now.subtract(const Duration(days: 1)),
            windowEnd: now,
            readings: const [],
            dailySummaries: const [],
            periodSummaries: const [],
            events: const [],
          ),
          insights: const [],
        ),
        settings: settings,
      );

      final viewModel = const ProfileViewModelMapper().map(
        facade: AnalysisFacade.current(),
        settings: settings,
        syncStatus: _syncStatus(),
        dataSourceSnapshots: const [],
      );

      expect(viewModel.targetRanges.map((row) => row.label), [
        'Target range',
        'Low threshold',
        'High threshold',
        'Very high threshold',
      ]);
      expect(viewModel.targetRanges.first.valueLabel, '3.9-10.0 mmol/L');
    });

    test('active datasource uses shared sync status instead of meta text', () {
      final now = DateTime.now();
      AnalysisSessionStore.instance.update(
        AnalysisRefreshResult(
          snapshot: AnalysisSnapshot(
            generatedAt: now,
            windowStart: now.subtract(const Duration(hours: 1)),
            windowEnd: now,
            readings: const [],
            dailySummaries: const [],
            periodSummaries: const [],
            events: const [],
          ),
          insights: const [],
        ),
        settings: const AppSettings(
          nightscoutBaseUrl: 'http://localhost:1337',
          nightscoutSyncEnabled: true,
        ),
      );

      final viewModel = const ProfileViewModelMapper().map(
        facade: AnalysisFacade.current(),
        settings: const AppSettings(
          nightscoutBaseUrl: 'http://localhost:1337',
          nightscoutSyncEnabled: true,
        ),
        syncStatus: _syncStatus(now: now),
        dataSourceSnapshots: [
          DataSourceConnectionSnapshot(
            kind: DataSourceKind.nightscout,
            status: DataSourceConnectionStatus.syncing,
            action: DataSourceConnectionAction.sync,
            strategyAction: DataSourceSyncStrategyAction.disable,
            title: 'Nightscout API',
            subtitle: 'Sync enabled',
            trailing: 'Sync',
            strategyTrailing: 'Disable',
            active: true,
            detected: true,
            configured: true,
            strategyEnabled: true,
            supported: true,
            syncState: SourceSyncState(
              sourceKey: 'nightscout',
              lastSuccessAt: now.subtract(const Duration(minutes: 3)),
              lastAttemptAt: now.subtract(const Duration(minutes: 3)),
              updatedAt: now,
            ),
          ),
        ],
      );

      final source = viewModel.dataSources.single;
      expect(source.meta, isNull);
      expect(source.syncStatus, isNotNull);
      expect(source.syncStatus!.label, contains('3 min ago'));
      expect(source.syncStatus!.countdownLabel, contains('Est. next'));
    });
  });
}

SyncStatusSnapshot _syncStatus({DateTime? now}) {
  final base = now ?? DateTime(2026, 6, 4, 12);
  return SyncStatusSnapshot(
    sourceLabel: 'Nightscout API',
    level: SyncStatusLevel.fresh,
    active: true,
    lastSuccessAt: base.subtract(const Duration(minutes: 3)),
    lastAttemptAt: base.subtract(const Duration(minutes: 3)),
    schedule: SyncScheduleSnapshot(
      reportedAt: base,
      mode: SyncScheduleMode.background,
      nextSyncAt: base.add(const Duration(minutes: 2)),
      nextInterval: const Duration(minutes: 2),
      estimated: true,
    ),
  );
}
