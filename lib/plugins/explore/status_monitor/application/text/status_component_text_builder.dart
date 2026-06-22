import '../../domain/analysis/status_rule_result.dart';
import '../../domain/scoring/status_component_score.dart';
import '../../domain/status_metric.dart';
import '../engines/cgm_sensor/cgm_sensor_metric_ids.dart';
import '../engines/nightscout/nightscout_metric_ids.dart';
import '../engines/xdrip/xdrip_metric_ids.dart';
import 'status_text_renderer.dart';

class StatusComponentTextBuilder {
  final StatusTextRenderer renderer;

  const StatusComponentTextBuilder({
    this.renderer = const StatusTextRenderer(),
  });

  String takeaway(String key, StatusComponentScore score) {
    return renderer.render(key, {'scoreLabel': score.label}).body;
  }

  String cgmSummary(
    List<StatusRuleResult> results,
    StatusComponentScore score,
  ) {
    final metrics = _metrics(results);
    return renderer.render('status.cgm.hero.summary.v1', {
      ..._scoreFacts(score),
      'cv': _metric(metrics, CgmSensorMetricIds.cv24h).valueLabel,
      'jumps': _metric(metrics, CgmSensorMetricIds.suddenChanges24h).valueLabel,
      'flat': _metric(metrics, CgmSensorMetricIds.flatLinePeriods).valueLabel,
    }).body;
  }

  String xdripSummary(
    List<StatusRuleResult> results,
    StatusComponentScore score,
  ) {
    final metrics = _metrics(results);
    return renderer.render('status.xdrip.hero.summary.v1', {
      ..._scoreFacts(score),
      'freshness': _metric(metrics, XdripMetricIds.freshness).valueLabel,
      'completeness':
          _metric(metrics, XdripMetricIds.completeness24h).valueLabel,
      'battery': _metric(metrics, XdripMetricIds.uploaderBattery).valueLabel,
    }).body;
  }

  String nightscoutSummary(
    List<StatusRuleResult> results,
    StatusComponentScore score,
  ) {
    final metrics = _metrics(results);
    return renderer.render('status.nightscout.hero.summary.v1', {
      ..._scoreFacts(score),
      'reachable':
          _metric(metrics, NightscoutMetricIds.apiReachable).valueLabel,
      'responseTime':
          _metric(metrics, NightscoutMetricIds.responseTime).valueLabel,
      'deviceStatus':
          _metric(metrics, NightscoutMetricIds.deviceStatus).valueLabel,
    }).body;
  }

  Map<String, Object?> _scoreFacts(StatusComponentScore score) => {
        'availableSignals': score.availableSignals,
        'totalSignals': score.totalSignals,
      };

  List<StatusMetric> _metrics(List<StatusRuleResult> results) {
    return results.map((result) => result.metric).toList(growable: false);
  }

  StatusMetric _metric(List<StatusMetric> metrics, String id) {
    return metrics.firstWhere((metric) => metric.id == id);
  }
}
