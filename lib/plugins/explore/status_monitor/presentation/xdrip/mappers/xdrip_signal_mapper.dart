import '../../../domain/status_metric.dart';
import '../../../domain/status_metric_source.dart';
import '../../../application/engines/xdrip/xdrip_metric_ids.dart';
import '../../../application/i18n/status_monitor_l10n_resolver.dart';
import '../../../application/text/status_signal_text_builder.dart';
import '../../../l10n/generated/status_monitor_localizations.dart';
import '../models/xdrip_signal_kind.dart';
import '../models/xdrip_signal_view_model.dart';

class XdripSignalMapper {
  final StatusSignalTextBuilder textBuilder;
  final StatusMonitorLocalizations? l10n;

  const XdripSignalMapper({
    this.textBuilder = const StatusSignalTextBuilder(),
    this.l10n,
  });

  StatusMonitorLocalizations get _strings =>
      l10n ?? StatusMonitorL10nResolver.fallback;

  List<XdripSignalViewModel> map(List<StatusMetric> metrics) {
    return [
      _freshness(
        _metric(
          metrics,
          XdripMetricIds.freshness,
          label: _strings.pageFresh,
          source: StatusMetricSource.entries,
        ),
      ),
      _completeness(
        _metric(
          metrics,
          XdripMetricIds.completeness24h,
          label: _strings.pageCompleteness24h,
          source: StatusMetricSource.entries,
        ),
      ),
      _latency(
        _metric(
          metrics,
          XdripMetricIds.uploadLatency,
          label: _strings.pageUploadLatency,
          source: StatusMetricSource.entries,
        ),
      ),
      _battery(
        _metric(
          metrics,
          XdripMetricIds.uploaderBattery,
          label: _strings.pageUploaderBattery,
          source: StatusMetricSource.deviceStatus,
        ),
      ),
    ];
  }

  XdripSignalViewModel _freshness(StatusMetric metric) {
    return XdripSignalViewModel(
      kind: XdripSignalKind.freshness,
      title: _signalTitle(XdripSignalKind.freshness),
      valueLabel: metric.valueLabel,
      detailLabel: textBuilder.xdripFreshnessDetail(metric),
      sourceLabel: textBuilder.xdripFreshnessSource(),
      level: metric.level,
      available: metric.available,
      progress: 1 - _minutesProgress(metric.valueLabel, maxMinutes: 15),
    );
  }

  XdripSignalViewModel _completeness(StatusMetric metric) {
    return XdripSignalViewModel(
      kind: XdripSignalKind.completeness,
      title: _signalTitle(XdripSignalKind.completeness),
      valueLabel: metric.valueLabel,
      detailLabel: textBuilder.xdripCompletenessDetail(metric),
      sourceLabel: textBuilder.xdripCompletenessSource(),
      level: metric.level,
      available: metric.available,
      progress: _percentProgress(metric.valueLabel),
    );
  }

  XdripSignalViewModel _latency(StatusMetric metric) {
    return XdripSignalViewModel(
      kind: XdripSignalKind.latency,
      title: _signalTitle(XdripSignalKind.latency),
      valueLabel: metric.valueLabel,
      detailLabel: textBuilder.xdripLatencyDetail(metric),
      sourceLabel: textBuilder.xdripLatencySource(),
      level: metric.level,
      available: metric.available,
      progress: 1 - _secondsProgress(metric.valueLabel, maxSeconds: 30),
    );
  }

  XdripSignalViewModel _battery(StatusMetric metric) {
    return XdripSignalViewModel(
      kind: XdripSignalKind.battery,
      title: _signalTitle(XdripSignalKind.battery),
      valueLabel: metric.valueLabel,
      detailLabel: textBuilder.xdripBatteryDetail(metric),
      sourceLabel: textBuilder.xdripBatterySource(),
      level: metric.level,
      available: metric.available,
      progress: _percentProgress(metric.valueLabel),
    );
  }

  StatusMetric _metric(
    List<StatusMetric> metrics,
    String id, {
    required String label,
    required StatusMetricSource source,
  }) {
    for (final metric in metrics) {
      if (metric.id == id) return metric;
    }
    return StatusMetric.unknown(
      id: id,
      label: label,
      source: source,
      reason: _strings.pageXdripSignalMissingReason,
    );
  }

  String _signalTitle(XdripSignalKind kind) {
    return switch (kind) {
      XdripSignalKind.freshness => _strings.pageFresh,
      XdripSignalKind.completeness => _strings.pageCompleteness24h,
      XdripSignalKind.latency => _strings.pageUploadLatency,
      XdripSignalKind.battery => _strings.pageUploaderBattery,
    };
  }

  double _percentProgress(String value) {
    final match = RegExp(r'([\d.]+)%').firstMatch(value);
    if (match == null) return 0;
    return (double.parse(match.group(1)!) / 100).clamp(0, 1).toDouble();
  }

  double _minutesProgress(String value, {required double maxMinutes}) {
    if (value.endsWith('s')) return 0;
    final match = RegExp(r'([\d.]+)m').firstMatch(value);
    if (match == null) return 1;
    return (double.parse(match.group(1)!) / maxMinutes).clamp(0, 1).toDouble();
  }

  double _secondsProgress(String value, {required double maxSeconds}) {
    final seconds = RegExp(r'([\d.]+)s').firstMatch(value);
    if (seconds != null) {
      return (double.parse(seconds.group(1)!) / maxSeconds)
          .clamp(0, 1)
          .toDouble();
    }
    final millis = RegExp(r'([\d.]+)ms').firstMatch(value);
    if (millis != null) {
      return (double.parse(millis.group(1)!) / 1000 / maxSeconds)
          .clamp(0, 1)
          .toDouble();
    }
    return 1;
  }
}
