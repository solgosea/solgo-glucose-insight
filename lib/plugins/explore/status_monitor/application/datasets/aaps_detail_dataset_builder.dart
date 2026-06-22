import '../../domain/aaps/aaps_detail_data.dart';
import '../../domain/aaps/aaps_evidence_matrix_row.dart';
import '../../domain/aaps/aaps_health_score_breakdown.dart';
import '../../domain/aaps/aaps_loop_timeline_bucket.dart';
import '../../domain/analysis/status_analysis_context.dart';
import '../../domain/detail/status_signal_summary.dart';
import '../../domain/status_level.dart';
import '../../domain/status_metric.dart';
import '../engines/aaps/aaps_metric_ids.dart';
import 'status_dataset_builder.dart';

class AapsDetailDatasetBuilder implements StatusDatasetBuilder<AapsDetailData> {
  const AapsDetailDatasetBuilder();

  @override
  AapsDetailData build({
    required StatusAnalysisContext context,
    required List<StatusMetric> metrics,
  }) {
    return buildWithBreakdown(
      context: context,
      metrics: metrics,
    );
  }

  AapsDetailData buildWithBreakdown({
    required StatusAnalysisContext context,
    required List<StatusMetric> metrics,
    AapsHealthScoreBreakdown? scoreBreakdown,
  }) {
    final byId = {for (final metric in metrics) metric.id: metric};
    final evidence = context.evidence.aapsEvidence;
    return AapsDetailData(
      signals: _signals(byId),
      timeline: _timeline(context),
      evidenceMatrix: _matrix(context),
      loopContext: _card(
        label: 'Loop context',
        metric: byId[AapsMetricIds.loopContext],
        fallbackValue: evidence.latestLoop?.label ?? 'Unknown',
        fallbackBody:
            evidence.latestLoop?.note ?? 'OpenAPS context is not visible.',
      ),
      pumpContext: _card(
        label: 'Pump context',
        metric: byId[AapsMetricIds.pumpContext],
        fallbackValue: evidence.latestPump?.statusLabel ?? 'Unknown',
        fallbackBody: evidence.latestPump?.note ??
            'Pump context is not visible in Nightscout.',
      ),
      iobContext: _card(
        label: 'IOB context',
        metric: byId[AapsMetricIds.iobCobContext],
        fallbackValue: evidence.latestIobCob?.iobLabel ?? 'Unknown',
        fallbackBody:
            evidence.latestIobCob?.note ?? 'IOB context is not visible.',
      ),
      cobContext: _card(
        label: 'COB context',
        metric: byId[AapsMetricIds.iobCobContext],
        fallbackValue: evidence.latestIobCob?.cobLabel ?? 'Unknown',
        fallbackBody:
            evidence.latestIobCob?.note ?? 'COB context is not visible.',
      ),
      profileContext: _card(
        label: 'Profile / temp target',
        metric: byId[AapsMetricIds.profileContext],
        fallbackValue: evidence.latestProfile?.label ?? 'Unknown',
        fallbackBody: evidence.latestProfile?.note ??
            'Profile or temp target context is not visible.',
      ),
      latestContextLabel: _latestLabel(context),
      scoreBreakdown: scoreBreakdown,
    );
  }

  List<StatusSignalSummary> _signals(Map<String, StatusMetric> byId) {
    final ids = [
      AapsMetricIds.nightscoutDependency,
      AapsMetricIds.syncFreshness,
      AapsMetricIds.loopContext,
      AapsMetricIds.pumpContext,
      AapsMetricIds.iobCobContext,
      AapsMetricIds.profileContext,
    ];
    final labels = {
      AapsMetricIds.nightscoutDependency: 'Nightscout',
      AapsMetricIds.syncFreshness: 'AAPS sync',
      AapsMetricIds.loopContext: 'Loop context',
      AapsMetricIds.pumpContext: 'Pump',
      AapsMetricIds.iobCobContext: 'IOB/COB',
      AapsMetricIds.profileContext: 'Profile',
    };
    return ids.map((id) {
      final metric = byId[id];
      return StatusSignalSummary(
        id: id,
        label: labels[id]!,
        valueLabel: metric?.valueLabel ?? 'Unknown',
        level: metric?.level ?? StatusLevel.unknown,
        note: metric?.note ?? metric?.unavailableReason,
      );
    }).toList(growable: false);
  }

  List<AapsEvidenceMatrixRow> _matrix(StatusAnalysisContext context) {
    final evidence = context.evidence.aapsEvidence;
    return [
      AapsEvidenceMatrixRow(
        title: 'Nightscout API',
        copy: evidence.nightscoutReachable
            ? 'Reachable. Device status endpoint returned evidence.'
            : evidence.configured
                ? 'Nightscout is configured but current evidence is unavailable.'
                : 'No Nightscout target is configured.',
        badge: evidence.nightscoutReachable ? 'Healthy' : 'Unknown',
        level: evidence.nightscoutReachable
            ? StatusLevel.healthy
            : StatusLevel.unknown,
      ),
      AapsEvidenceMatrixRow(
        title: 'openaps context',
        copy: evidence.latestLoop?.note ??
            'No OpenAPS loop context is visible in sampled device status.',
        badge: evidence.latestLoop?.label ?? 'Unknown',
        level: evidence.latestLoop?.visible == true
            ? evidence.latestLoop!.partial
                ? StatusLevel.watch
                : StatusLevel.healthy
            : StatusLevel.unknown,
      ),
      AapsEvidenceMatrixRow(
        title: 'pump context',
        copy: evidence.latestPump?.note ??
            'Pump context is not visible in sampled device status.',
        badge: evidence.latestPump?.visible == true
            ? evidence.latestPump!.partial
                ? 'Partial'
                : 'Visible'
            : 'Unknown',
        level: evidence.latestPump?.visible == true
            ? evidence.latestPump!.partial
                ? StatusLevel.watch
                : StatusLevel.healthy
            : StatusLevel.unknown,
      ),
      AapsEvidenceMatrixRow(
        title: 'profile context',
        copy: evidence.latestProfile?.note ??
            'No recent profile or temp target context in the sampled response.',
        badge: evidence.latestProfile?.label ?? 'Unknown',
        level: evidence.latestProfile?.visible == true
            ? StatusLevel.healthy
            : StatusLevel.unknown,
      ),
    ];
  }

  List<AapsLoopTimelineBucket> _timeline(StatusAnalysisContext context) {
    final samples = context.evidence.aapsEvidence.deviceStatusSamples;
    final now = context.now;
    return List.generate(36, (index) {
      final start = now.subtract(Duration(minutes: (35 - index) * 5));
      final end = start.add(const Duration(minutes: 5));
      final sample = samples.where((candidate) {
        final at = candidate.observedAt;
        return at != null && !at.isBefore(start) && at.isBefore(end);
      }).firstOrNull;
      final level = sample == null
          ? StatusLevel.unknown
          : sample.hasLoopContext
              ? sample.hasPumpContext || sample.hasIobContext
                  ? StatusLevel.healthy
                  : StatusLevel.watch
              : StatusLevel.unknown;
      return AapsLoopTimelineBucket(
        at: start,
        level: level,
        label: sample == null
            ? 'Missing'
            : level == StatusLevel.healthy
                ? 'Fresh'
                : 'Partial',
      );
    });
  }

  AapsContextCardData _card({
    required String label,
    required StatusMetric? metric,
    required String fallbackValue,
    required String fallbackBody,
  }) {
    final level = metric?.level ?? StatusLevel.unknown;
    return AapsContextCardData(
      label: label,
      value: metric?.valueLabel ?? fallbackValue,
      body: metric?.note ?? metric?.unavailableReason ?? fallbackBody,
      fraction: _fraction(level),
      level: level,
    );
  }

  String _latestLabel(StatusAnalysisContext context) {
    final latest = context.evidence.aapsEvidence.latestContextAt;
    if (latest == null) return 'No AAPS context';
    final age = context.now.difference(latest);
    if (age.inSeconds < 45) return '0s';
    if (age.inMinutes < 60) return '${age.inMinutes}m';
    if (age.inHours < 24) return '${age.inHours}h';
    return '${age.inDays}d';
  }

  double _fraction(StatusLevel level) {
    return switch (level) {
      StatusLevel.healthy => .86,
      StatusLevel.watch => .62,
      StatusLevel.issue => .34,
      StatusLevel.unknown => .12,
    };
  }
}
