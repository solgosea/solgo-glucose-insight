import '../../../domain/status_level.dart';
import '../../../domain/status_metric.dart';
import '../../../application/text/status_signal_text_builder.dart';
import '../models/nightscout_signal_kind.dart';
import '../models/nightscout_signal_view_model.dart';

class NightscoutSignalMapper {
  final StatusSignalTextBuilder textBuilder;

  const NightscoutSignalMapper({
    this.textBuilder = const StatusSignalTextBuilder(),
  });

  List<NightscoutSignalViewModel> map(List<StatusMetric> metrics) {
    return [
      _reachability(_metric(metrics, 'api_reachable')),
      _responseTime(_metric(metrics, 'response_time')),
      _deviceStatus(_metric(metrics, 'device_status')),
    ];
  }

  NightscoutSignalViewModel _reachability(StatusMetric metric) {
    return NightscoutSignalViewModel(
      kind: NightscoutSignalKind.reachability,
      title: NightscoutSignalKind.reachability.title,
      valueLabel: metric.valueLabel,
      detailLabel: textBuilder.nightscoutReachabilityDetail(metric),
      sourceLabel: textBuilder.nightscoutReachabilitySource(),
      level: metric.level,
      available: metric.available,
      progress: metric.level == StatusLevel.healthy
          ? 1
          : metric.level == StatusLevel.watch
              ? .62
              : 0,
    );
  }

  NightscoutSignalViewModel _responseTime(StatusMetric metric) {
    return NightscoutSignalViewModel(
      kind: NightscoutSignalKind.responseTime,
      title: NightscoutSignalKind.responseTime.title,
      valueLabel: metric.valueLabel,
      detailLabel: textBuilder.nightscoutResponseDetail(metric),
      sourceLabel: textBuilder.nightscoutResponseSource(),
      level: metric.level,
      available: metric.available,
      progress: 1 - _durationProgress(metric.valueLabel),
    );
  }

  NightscoutSignalViewModel _deviceStatus(StatusMetric metric) {
    return NightscoutSignalViewModel(
      kind: NightscoutSignalKind.deviceStatus,
      title: NightscoutSignalKind.deviceStatus.title,
      valueLabel: metric.valueLabel,
      detailLabel: textBuilder.nightscoutDeviceStatusDetail(metric),
      sourceLabel: textBuilder.nightscoutDeviceStatusSource(),
      level: metric.level,
      available: metric.available,
      progress: metric.available ? 1 : 0,
    );
  }

  StatusMetric _metric(List<StatusMetric> metrics, String id) {
    return metrics.firstWhere((metric) => metric.id == id);
  }

  double _durationProgress(String value) {
    final seconds = RegExp(r'([\d.]+)s').firstMatch(value);
    if (seconds != null) {
      return (double.parse(seconds.group(1)!) / 3).clamp(0, 1).toDouble();
    }
    final millis = RegExp(r'([\d.]+)ms').firstMatch(value);
    if (millis != null) {
      return (double.parse(millis.group(1)!) / 3000).clamp(0, 1).toDouble();
    }
    return 1;
  }
}
