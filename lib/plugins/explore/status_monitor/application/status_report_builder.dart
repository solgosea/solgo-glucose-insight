import '../domain/component_health.dart';
import '../domain/evidence/status_evidence_bundle.dart';
import '../domain/status_level.dart';
import '../domain/status_report.dart';
import '../domain/status_timeline_point.dart';
import '../domain/analysis/status_analysis_context.dart';
import 'engines/aaps/aaps_status_engine.dart';
import 'engines/cgm_sensor/cgm_sensor_status_engine.dart';
import 'engines/juggluco/juggluco_status_engine.dart';
import 'engines/nightscout/nightscout_status_engine.dart';
import 'engines/status_component_engine_registry.dart';
import 'engines/watch/watch_status_engine.dart';
import 'engines/xdrip/xdrip_status_engine.dart';

class StatusReportBuilder {
  final CgmSensorStatusEngine cgmEngine;
  final JugglucoStatusEngine jugglucoEngine;
  final XdripStatusEngine xdripEngine;
  final NightscoutStatusEngine nightscoutEngine;
  final AapsStatusEngine aapsEngine;
  final WatchStatusEngine watchEngine;

  const StatusReportBuilder({
    this.cgmEngine = const CgmSensorStatusEngine(),
    this.jugglucoEngine = const JugglucoStatusEngine(),
    this.xdripEngine = const XdripStatusEngine(),
    this.nightscoutEngine = const NightscoutStatusEngine(),
    this.aapsEngine = const AapsStatusEngine(),
    this.watchEngine = const WatchStatusEngine(),
  });

  Future<StatusReport> build({
    required DateTime now,
    required StatusEvidenceBundle evidence,
    required List<StatusTimelinePoint> history,
  }) async {
    final context = StatusAnalysisContext(
      now: now,
      evidence: evidence,
    );
    final components = await StatusComponentEngineRegistry(
      engines: [
        cgmEngine,
        jugglucoEngine,
        xdripEngine,
        nightscoutEngine,
        aapsEngine,
        watchEngine,
      ],
    ).evaluateAll(context);
    return buildFromComponents(
      now: now,
      evidence: evidence,
      history: history,
      components: components,
    );
  }

  StatusReport buildFromComponents({
    required DateTime now,
    required StatusEvidenceBundle evidence,
    required List<StatusTimelinePoint> history,
    required List<ComponentHealth> components,
  }) {
    return StatusReport(
      subjectId: evidence.subjectId,
      sourceTargetId: evidence.primarySourceTargetId,
      sourceKind: evidence.primarySourceKind,
      sourceLabel: evidence.primarySourceLabel,
      generatedAt: now,
      summary: _summary(
        components,
        evidence.primarySourceLabel,
      ),
      components: _withHistory(components, history),
      recentEvents: history,
      capabilities: evidence.capabilities,
      hasConfiguredSource: evidence.hasConfiguredSource,
      emptyReason: evidence.hasConfiguredSource
          ? null
          : 'Connect xDrip+ Local or Nightscout API to view link status.',
    );
  }

  StatusSummary _summary(
    List<ComponentHealth> components,
    String modeLabel,
  ) {
    if (modeLabel == 'No data source' || modeLabel == 'No source') {
      return const StatusSummary(
        level: StatusLevel.unknown,
        headline: 'Status needs a configured data source.',
        body:
            'Connect xDrip+ Local or Nightscout API before reading link status.',
        meta: 'No data source - status is not evaluated yet',
        healthyCount: 0,
        totalCount: 4,
      );
    }
    final available = components
        .where((component) => component.level != StatusLevel.unknown)
        .toList();
    final overall = available.isEmpty
        ? StatusLevel.unknown
        : available
            .map((component) => component.level)
            .reduce((a, b) => a.severity >= b.severity ? a : b);
    final healthy =
        components.where((c) => c.level == StatusLevel.healthy).length;
    final issue = components.where((c) => c.level == StatusLevel.issue).length;
    final watch = components.where((c) => c.level == StatusLevel.watch).length;
    final headline = switch (overall) {
      StatusLevel.healthy => 'Your glucose link is healthy.',
      StatusLevel.watch => 'Your glucose link needs a glance.',
      StatusLevel.issue => 'A status component is outside its healthy range.',
      StatusLevel.unknown => 'Status needs a configured data source.',
    };
    final body = issue > 0
        ? '$issue component is in Issue. Review the facts below before deciding what to do.'
        : watch > 0
            ? '$watch component is in Watch. Readings can still be flowing.'
            : healthy == components.length
                ? 'All visible components are inside their healthy ranges.'
                : 'Some metrics are Unknown because this source does not expose them.';
    return StatusSummary(
      level: overall,
      headline: headline,
      body: body,
      meta: '$modeLabel - refreshes when you open this page',
      healthyCount: healthy,
      totalCount: components.length,
    );
  }

  List<ComponentHealth> _withHistory(
    List<ComponentHealth> components,
    List<StatusTimelinePoint> history,
  ) {
    return components
        .map(
          (component) => ComponentHealth(
            kind: component.kind,
            level: component.level,
            title: component.title,
            role: component.role,
            takeaway: component.takeaway,
            summary: component.summary,
            metrics: component.metrics,
            directions: component.directions,
            history: history
                .where((point) => point.component == component.kind)
                .toList(growable: false),
            score: component.score,
            detailData: component.detailData,
          ),
        )
        .toList(growable: false);
  }
}
