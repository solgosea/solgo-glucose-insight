import 'package:flutter_test/flutter_test.dart';
import 'package:smart_xdrip/application/analysis/analysis_refresh_result.dart';
import 'package:smart_xdrip/application/analysis/analysis_session_capability_service.dart';
import 'package:smart_xdrip/application/analysis/analysis_session_store.dart';
import 'package:smart_xdrip/application/subject/active_subject_defaults.dart';
import 'package:smart_xdrip/domain/analysis/analysis_snapshot.dart';
import 'package:smart_xdrip/domain/entities/app_settings.dart';
import 'package:smart_xdrip/domain/entities/glucose_event.dart';
import 'package:smart_xdrip/domain/entities/glucose_reading.dart';
import 'package:smart_xdrip/domain/subject/analysis_subject.dart';
import 'package:smart_xdrip/domain/subject/analysis_subject_origin.dart';

void main() {
  tearDown(_resetStore);

  test('self subject source availability follows app settings', () {
    final store = AnalysisSessionStore.instance;
    store.updateSettings(const AppSettings());
    store.setActiveSubject(ActiveSubjectDefaults.self);

    final summary =
        AnalysisSessionCapabilityService(store: AnalysisSessionStore.instance)
            .summarize();

    expect(summary.activeSubject.isSelf, isTrue);
    expect(summary.hasConfiguredSource, isFalse);
    expect(summary.hasGlucoseData, isFalse);
  });

  test('remote subject with canonical snapshot is treated as sourced data', () {
    final store = AnalysisSessionStore.instance;
    const subject = AnalysisSubject(
      id: 'remote:child-a',
      displayName: 'Child A',
      sourceLabel: 'Remote Nightscout',
      origin: AnalysisSubjectOrigin('remote'),
    );
    final now = DateTime(2026, 6, 6, 8);
    store.update(
      AnalysisRefreshResult(
        snapshot: AnalysisSnapshot(
          generatedAt: now,
          windowStart: now.subtract(const Duration(hours: 1)),
          windowEnd: now,
          readings: [
            GlucoseReading(timestamp: now, value: 6.4),
          ],
          dailySummaries: const [],
          periodSummaries: const [],
          events: [
            GlucoseEvent(
              type: GlucoseEventType.stableWindow,
              time: now,
              value: 6.4,
            ),
          ],
        ),
        insights: const [],
      ),
      settings: const AppSettings(),
      subject: subject,
    );

    final summary =
        AnalysisSessionCapabilityService(store: AnalysisSessionStore.instance)
            .summarize();

    expect(summary.activeSubject.id, subject.id);
    expect(summary.hasConfiguredSource, isTrue);
    expect(summary.hasGlucoseData, isTrue);
    expect(summary.hasGlucoseEvents, isTrue);
  });
}

void _resetStore() {
  final store = AnalysisSessionStore.instance;
  store.clear();
  store.updateSettings(const AppSettings());
  store.setActiveSubject(ActiveSubjectDefaults.self);
}
