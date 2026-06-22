import '../../../application/text/status_signal_text_builder.dart';
import '../../../domain/status_metric.dart';
import '../models/cgm_sensor_signal_kind.dart';
import '../models/cgm_sensor_signal_view_model.dart';

class CgmSensorSignalMapper {
  final StatusSignalTextBuilder textBuilder;

  const CgmSensorSignalMapper({
    this.textBuilder = const StatusSignalTextBuilder(),
  });

  List<CgmSensorSignalViewModel> map(List<StatusMetric> metrics) {
    return [
      _session(_metric(metrics, 'sensor_lifetime')),
      _variability(_metric(metrics, 'cgm_cv_24h')),
      _jumps(_metric(metrics, 'sudden_changes_24h')),
      _flatPeriod(_metric(metrics, 'flat_line_periods')),
    ];
  }

  CgmSensorSignalViewModel _session(StatusMetric metric) {
    return CgmSensorSignalViewModel(
      kind: CgmSensorSignalKind.session,
      title: CgmSensorSignalKind.session.title,
      valueLabel: metric.valueLabel,
      detailLabel: textBuilder.cgmSessionDetail(metric),
      sourceLabel: textBuilder.cgmSessionSource(),
      level: metric.level,
      available: metric.available,
      progress: _sessionProgress(metric.valueLabel),
    );
  }

  CgmSensorSignalViewModel _variability(StatusMetric metric) {
    return CgmSensorSignalViewModel(
      kind: CgmSensorSignalKind.variability,
      title: CgmSensorSignalKind.variability.title,
      valueLabel: metric.valueLabel,
      detailLabel: textBuilder.cgmVariabilityDetail(metric),
      sourceLabel: textBuilder.cgmVariabilitySource(),
      level: metric.level,
      available: metric.available,
      progress: _percentProgress(metric.valueLabel, max: 60),
    );
  }

  CgmSensorSignalViewModel _jumps(StatusMetric metric) {
    return CgmSensorSignalViewModel(
      kind: CgmSensorSignalKind.jumps,
      title: CgmSensorSignalKind.jumps.title,
      valueLabel: metric.valueLabel,
      detailLabel: textBuilder.cgmJumpsDetail(metric),
      sourceLabel: textBuilder.cgmJumpsSource(),
      level: metric.level,
      available: metric.available,
      progress: _numberProgress(metric.valueLabel, max: 5),
      eventPositions: _eventPositions(metric),
    );
  }

  CgmSensorSignalViewModel _flatPeriod(StatusMetric metric) {
    return CgmSensorSignalViewModel(
      kind: CgmSensorSignalKind.flatPeriod,
      title: CgmSensorSignalKind.flatPeriod.title,
      valueLabel: metric.valueLabel,
      detailLabel: textBuilder.cgmFlatDetail(metric),
      sourceLabel: textBuilder.cgmFlatSource(),
      level: metric.level,
      available: metric.available,
      progress: _durationProgress(metric.valueLabel, maxMinutes: 60),
    );
  }

  StatusMetric _metric(List<StatusMetric> metrics, String id) {
    return metrics.firstWhere((metric) => metric.id == id);
  }

  double _sessionProgress(String value) {
    if (value == 'Expired') return 1;
    final days = RegExp(r'^(\d+)d$').firstMatch(value);
    if (days != null) {
      return (1 - int.parse(days.group(1)!) / 14).clamp(0, 1).toDouble();
    }
    final hours = RegExp(r'^(\d+)h$').firstMatch(value);
    if (hours != null) {
      return (1 - int.parse(hours.group(1)!) / (14 * 24))
          .clamp(0, 1)
          .toDouble();
    }
    return 0;
  }

  double _percentProgress(String value, {required double max}) {
    final match = RegExp(r'([\d.]+)%').firstMatch(value);
    if (match == null) return 0;
    return (double.parse(match.group(1)!) / max).clamp(0, 1).toDouble();
  }

  double _numberProgress(String value, {required double max}) {
    final parsed = double.tryParse(value);
    if (parsed == null) return 0;
    return (parsed / max).clamp(0, 1).toDouble();
  }

  double _durationProgress(String value, {required double maxMinutes}) {
    final match = RegExp(r'([\d.]+)m').firstMatch(value);
    if (match == null) return 0;
    return (double.parse(match.group(1)!) / maxMinutes).clamp(0, 1).toDouble();
  }

  List<double> _eventPositions(StatusMetric metric) {
    final raw = metric.metadata['eventPositions'];
    if (raw is! List) return const [];
    return raw
        .whereType<num>()
        .map((value) => value.toDouble().clamp(0, 1).toDouble())
        .toList(growable: false);
  }
}
