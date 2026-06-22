import '../../domain/component_health.dart';
import '../../domain/floating/status_floating_component_payload.dart';
import '../../domain/floating/status_floating_payload.dart';
import '../../domain/status_component_kind.dart';
import '../../domain/status_level.dart';
import '../../domain/status_report.dart';
import '../scoring/status_score_label_mapper.dart';

class StatusFloatingPayloadBuilder {
  static const staleAfter = Duration(minutes: 15);

  final StatusScoreLabelMapper scoreLabelMapper;

  const StatusFloatingPayloadBuilder({
    this.scoreLabelMapper = const StatusScoreLabelMapper(),
  });

  StatusFloatingPayload build({
    required StatusReport report,
    DateTime? now,
  }) {
    final effectiveNow = now ?? DateTime.now();
    final age = effectiveNow.difference(report.generatedAt);
    final stale = age > staleAfter;
    final components = [
      _component(report.component(StatusComponentKind.cgmSensor)),
      _component(report.component(StatusComponentKind.xdrip)),
      _component(report.component(StatusComponentKind.nightscout)),
      _component(report.component(StatusComponentKind.aapsLoop)),
    ];
    return StatusFloatingPayload(
      level: report.summary.level,
      headline: _headline(report, stale),
      freshnessLabel: _freshnessLabel(age),
      hasConfiguredSource: report.hasConfiguredSource,
      isStale: stale,
      components: components,
    );
  }

  StatusFloatingComponentPayload _component(ComponentHealth component) {
    final score = component.score?.value;
    final level = scoreLabelMapper.levelFor(score);
    return StatusFloatingComponentPayload(
      label: _shortName(component.kind),
      level: level,
      glyph: glyphFor(level),
      score: score,
      scoreLabel: score == null ? '--' : '$score',
    );
  }

  static String glyphFor(StatusLevel level) {
    return switch (level) {
      StatusLevel.healthy => '\u25CF',
      StatusLevel.watch => '\u25B2',
      StatusLevel.issue => '\u25A0',
      StatusLevel.unknown => '\u25CB',
    };
  }

  String _headline(StatusReport report, bool stale) {
    if (!report.hasConfiguredSource) return 'Status unavailable';
    if (stale) return 'No recent status';
    return report.summary.headline;
  }

  String _shortName(StatusComponentKind kind) {
    return switch (kind) {
      StatusComponentKind.cgmSensor => 'Sensor',
      StatusComponentKind.xdrip => 'xDrip+',
      StatusComponentKind.nightscout => 'Nightscout',
      StatusComponentKind.aapsLoop => 'AAPS',
    };
  }

  String _freshnessLabel(Duration diff) {
    if (diff.inSeconds < 45) return 'now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m';
    if (diff.inHours < 24) return '${diff.inHours}h';
    return '${diff.inDays}d';
  }
}
